import Foundation
import SwiftUI
import UniformTypeIdentifiers
import Photos

struct MediaPickerDialog: FBaseView {
    @Environment(\.dismiss) var dismiss
    @StateObject var dataContext: MediaPickerDialogVM
    var onSelect: (([MediaPickerSourceBuffModel]) -> Void)?
    init(_ appState: FAppState, _ onSelect: (([MediaPickerSourceBuffModel]) -> Void)? = nil, _ maxItemCount: Int = 0) {
        _dataContext = StateObject(wrappedValue: MediaPickerDialogVM(appState, maxItemCount))
        self.onSelect = onSelect
    }
    
    var body: some View {
        ZStack {
            VStack {
                topContainer
                lastClickedItemContainer
                listItemContainer
            }
        }.onAppear {
            dataContext.addEventListener(self)
            getList()
        }
    }
    
    var topContainer: some View {
        Group {
            HStack {
                FAppImage.close
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding(.top, 8)
                    .padding(.trailing, 20)
                    .onTapGesture { dataContext.relayCommand.execute(MediaPickerDialogVM.ClickEvent.CLOSE) }
                Spacer()
                if dataContext.maxItemCount > 0 {
                    Text((dataContext.maxItemCount - dataContext.clickItemBuff.count).toString)
                        .foregroundColor(FAppColor.accent)
                    Text(FAppLocalString.mediaAbleClickSuffixDesc)
                        .foregroundColor(FAppColor.foreground)
                }
                Spacer()
                Text(dataContext.clickItemBuff.count.toString)
                    .frame(alignment: .center)
                if dataContext.clickItemBuff.count > 0 {
                    FAppImage.checkCircleFill
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(FAppColor.accent)
                        .onTapGesture { dataContext.relayCommand.execute(MediaPickerDialogVM.ClickEvent.SELECT) }
                } else {
                    FAppImage.checkCircle
                        .resizable()
                        .frame(width: 20, height: 20)
                }
            }
        }
    }
    var lastClickedItemContainer: some View {
        Group {
            if let lastClickItem = dataContext.lastClickItem {
                Image(uiImage: lastClickItem.thumbnail)
                    .resizable()
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
    var listItemContainer: some View {
        Group {
            ScrollView {
                LazyVGrid(columns: [GridItem(), GridItem(), GridItem()], spacing: 5) {
                    ForEach(dataContext.items, id: \.thisPK) { item in
                        itemContainer(item)
                    }
                }
            }
        }
    }
    @ViewBuilder
    func itemContainer(_ item: MediaPickerSourceBuffModel) -> some View {
        Group {
            ZStack(alignment: .topTrailing) {
                Image(uiImage: item.thumbnail)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipped()
                Circle()
                    .fill(item.clickState ? FAppColor.buttonBackground : FAppColor.transparent)
                    .frame(width: 30, height: 30)
                    .overlay {
                        if let num = item.num {
                            Text(num.toString)
                                .foregroundColor(item.clickState ? FAppColor.buttonForeground : FAppColor.foreground)
                        }
                    }
                    .offset(x: -5, y: 5)
            }
            .frame(width: 100, height: 100)
            .onTapGesture {
                item.onClick(MediaPickerSourceBuffModel.ClickEvent.SELECT, MediaPickerSourceBuffModel.self)
            }
        }
    }
    
    
    func onEvent(_ data: Any?) async {
        setThisCommand(data)
        setItemCommand(data)
    }
    
    func setThisCommand(_ data: Any?) {
        guard let eventName = data as? MediaPickerDialogVM.ClickEvent else { return }
        
        switch eventName {
        case MediaPickerDialogVM.ClickEvent.SELECT:
            select()
            break
        case MediaPickerDialogVM.ClickEvent.CLOSE:
            close()
            break
        }
    }
    func setItemCommand(_ data: Any?) {
        guard let array = data as? [Any], array.count > 1,
              let eventName = array[0] as? MediaPickerSourceBuffModel.ClickEvent,
              let dataBuff = array[1] as? MediaPickerSourceBuffModel else { return }
        
        switch eventName {
        case MediaPickerSourceBuffModel.ClickEvent.SELECT:
            itemClick(dataBuff)
            break
        }
    }
    
    func getList() {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized || status == .limited else {
                dataContext.toast(FAppLocalString.permitRequire)
                return
            }
            
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            let imageManager = PHCachingImageManager()
            let targetSize = CGSize(width: 100, height: 100)
            let requestOptions = PHImageRequestOptions()
//            requestOptions.deliveryMode = .fastFormat
            requestOptions.isSynchronous = false
            requestOptions.isNetworkAccessAllowed = false
            var ret: [MediaPickerSourceBuffModel] = []
            assets.enumerateObjects { (asset, _, _) in
                let subtype = asset.mediaSubtypes
                if subtype.contains(.photoLive) || subtype.contains(.photoPanorama) { return }
                let resources = PHAssetResource.assetResources(for: asset)
                guard let resource = resources.first,
                      resource.value(forKey: "locallyAvailable") as? Bool == true else { return }
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: requestOptions) { image, _ in
                    guard let image = image else { return }
                    ret.append(MediaPickerSourceBuffModel().apply {
                        $0.asset = asset
                        $0.thumbnail = image
                        $0.relayCommand = dataContext.relayCommand
                    })
                }
            }
            DispatchQueue.main.async {
                dataContext.items = ret
            }
        }
    }
    func select() {
        if dataContext.clickItemBuff.count <= 0 {
            return
        }
        onSelect?(dataContext.clickItemBuff)
        dismiss()
    }
    func close() {
        dismiss()
    }
    func itemClick(_ item: MediaPickerSourceBuffModel) {
        if let findItem = dataContext.clickItemBuff.first(where: { $0.thisPK == item.thisPK }) {
            if let lastClickItem = dataContext.lastClickItem {
                if lastClickItem.thisPK == findItem.thisPK {
                    item.lastClick = false
                    dataContext.lastClickItem = nil
                    dataContext.removeClickedItem(item)
                } else {
                    dataContext.setLastClickedItem(item)
                    dataContext.lastClickItem = item
                }
            } else {
                dataContext.setLastClickedItem(item)
                dataContext.lastClickItem = item
            }
        } else {
            if dataContext.maxItemCount <= 0 || dataContext.maxItemCount > dataContext.clickItemBuff.count {
                item.lastClick = true
                dataContext.lastClickItem = item
                dataContext.appendClickedItem(item)
            }
        }
    }
}
