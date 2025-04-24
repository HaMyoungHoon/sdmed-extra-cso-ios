import Foundation
import SwiftUI

struct MediaViewDialog: FBaseView {
    @Environment(\.dismiss) var dismiss
    @StateObject var dataContext: MediaViewDialogVM
    init(_ appState: FAppState, _ data: MediaViewModel) {
        _dataContext = StateObject(wrappedValue: MediaViewDialogVM(appState, data))
    }
    
    var body: some View {
        VStack {
            topContainer
            imageContainer
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .onAppear {
            dataContext.addEventListener(self)
        }
        .gesture(
            SimultaneousGesture(
                MagnificationGesture()
                    .onChanged { value in
                        var delta = dataContext.lastScale * value
                        if delta <= 1 {
                            delta = 1
                            dataContext.offset = .zero
                            dataContext.lastOffset = .zero
                        }
                        dataContext.scale = delta
                    }
                    .onEnded { _ in
                        dataContext.lastScale = dataContext.scale
                    },
                DragGesture()
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
        )
    }
    
    var topContainer: some View {
        Group {
            ZStack {
                HStack {
                    FAppImage.close
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.top, 8)
                        .padding(.trailing, 20)
                        .onTapGesture { dataContext.relayCommand.execute(MediaViewDialogVM.ClickEvent.CLOSE) }
                    Spacer()
                }
                Text(dataContext.item.originalFilename)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
    var imageContainer: some View {
        FImageUtils.asyncImage(dataContext.item.blobUrl, dataContext.item.mimeType)
            .scaledToFit()
            .scaleEffect(dataContext.scale)
            .offset(dataContext.offset)
            .animation(.easeInOut, value: dataContext.scale)
            .animation(.easeInOut, value: dataContext.offset)
    }
    
    func onEvent(_ data: Any?) async {
        setThisCommand(data)
    }
    
    func setThisCommand(_ data: Any?) {
        guard let eventName = data as? MediaViewDialogVM.ClickEvent else { return }
        switch eventName {
        case MediaViewDialogVM.ClickEvent.CLOSE:
            dismiss()
            break
        }
    }
}
