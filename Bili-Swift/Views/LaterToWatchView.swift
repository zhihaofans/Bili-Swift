//
//  LaterToWatchView.swift
//  Bili-Swift
//
//  Created by zzh on 2024/8/1.
//

import SwiftUI

struct LaterToWatchView: View {
    @State var isError=false
    @State var loaded=false
    @State var errorStr=""
    @State var later2watchList: [Later2WatchItem]=[]
    var body: some View {
        ScrollView {
            if loaded {
                if isError {
                    Text(errorStr).font(.largeTitle)
                } else {
                    LazyVStack {
                        ForEach(later2watchList, id: \.bvid) { item in
                            Later2WatchItemView(itemData: item)
                        }
                    }
                }
            } else {
                Text("Loading...")
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Image(systemName: "trash")
            }
        }
        .navigationTitle("稍后再看")
        .onAppear {
            // TODO: 加载历史数据
            Task {
                HistoryService().getLaterToWatch { result in
                    DispatchQueue.main.async {
                        if result.data.list.isEmpty {
                            isError=true
                            errorStr="空白结果列表"
                        } else {
                            later2watchList=result.data.list
                            isError=false
                        }
                        loaded=true
                    }
                } fail: { err in
                    DispatchQueue.main.async {
                        isError=true
                        errorStr=err
                    }
                }
            }
        }
    }
}

struct Later2WatchItemView: View {
    var itemData: Later2WatchItem
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                AsyncImage(url: URL(string: itemData.pic.replace(of: "http://", with: "https://"))) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 150, height: 84)
                VStack {
                    Text(itemData.title) // .font()
                    Text("@" + itemData.owner.name)
                }
                // .frame(width: geometry.size.width)
                Spacer()
            }.frame(maxHeight: .infinity, alignment: .leading) // 设置对齐方式
        }
        .frame(height: 100) // 将 VStack 的固定高度设置为100
        .contentShape(Rectangle()) // 加这行才实现可点击
        .onTapGesture {
            // TODO: onClick

//            switch itemData.history.getType() {
//                // case "archive":
//
//                default:
//                    print(itemData.getCover())
//            }
        }
    }
}

// #Preview {
//    LaterToWatchView()
// }
