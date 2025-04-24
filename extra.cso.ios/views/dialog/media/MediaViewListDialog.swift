import Foundation
import SwiftUI

struct MediaViewListDialog: FBaseView {
    @Environment(\.dismiss) var dismiss
    @StateObject var dataContext: MediaViewListDialogVM
    @GestureState var dragOffset: CGSize = .zero
    init(_ appState: FAppState, _ items: [MediaViewModel], _ index: Int = 0) {
        _dataContext = StateObject(wrappedValue: MediaViewListDialogVM(appState, items, index))
    }
    var body: some View {
        VStack {
            topContainer
            itemListContainer
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .onAppear {
            dataContext.addEventListener(self)
        }
    }
    
    var topContainer: some View {
        ZStack {
            HStack {
                FAppImage.close
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding(.top, 8)
                    .padding(.trailing, 20)
                    .onTapGesture { dataContext.relayCommand.execute(MediaViewListDialogVM.ClickEvent.CLOSE) }
                Spacer()
            }
            Text(dataContext.originalFilename)
                .frame(maxWidth: .infinity, alignment: .center)
                .lineLimit(1)
                .truncationMode(.tail)
                .padding(.horizontal, 30)
        }
    }
    var itemListContainer: some View {
        TabView(selection: $dataContext.selectedIndex) {
            ForEach(dataContext.items.indices, id:\.self) { index in
                itemContainer(dataContext.items[index])
                    .tag(index)
            }
        }.onChange(of: dataContext.selectedIndex) { old, new in
            dataContext.scale = 1
            dataContext.lastScale = 1
            dataContext.offset = .zero
        }.tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .gesture(DragGesture())
    }
    @ViewBuilder
    func itemContainer(_ item: MediaViewModel) -> some View {
        FImageUtils.asyncImage(item.blobUrl, item.mimeType)
            .scaledToFit()
            .scaleEffect(dataContext.scale)
            .offset(dataContext.offset)
            .animation(.easeInOut, value: dataContext.scale)
            .animation(.easeInOut, value: dataContext.offset)
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        var delta = dataContext.lastScale * value
                        if delta <= 1 {
                            delta = 1
                            dataContext.offset = .zero
                        } else if delta > 5 {
                            delta = 5
                        }
                        dataContext.scale = delta
                    }
                    .onEnded { _ in
                        dataContext.lastScale = dataContext.scale
                    }
                )
            .highPriorityGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if dataContext.scale <= 1 {
                            return
                        }
                        dataContext.offset = CGSize(
                            width: dataContext.lastOffset.width + value.translation.width,
                            height: dataContext.lastOffset.height + value.translation.height)
                    }
                    .onEnded { _ in
                        dataContext.lastOffset = dataContext.offset
                    }
                )
    }
    
    func onEvent(_ data: Any?) async {
        setThisCommand(data)
    }
    
    func setThisCommand(_ data: Any?) {
        guard let eventName = data as? MediaViewListDialogVM.ClickEvent else { return }
        switch eventName {
        case MediaViewListDialogVM.ClickEvent.CLOSE:
            dismiss()
            break
        }
    }
}
