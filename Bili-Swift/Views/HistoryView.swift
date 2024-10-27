//
//  HistoryView.swift
//  Bili-Swift
//
//  Created by zzh on 2024/7/18.
//

import SwiftUI

struct HistoryView: View {
    @State var isError=false
    @State var loaded=false
    @State var errorStr=""
    @State var historyList: [HistoryItem]=[]
    var body: some View {
        ScrollView {
            if loaded {
                if isError {
                    Text(errorStr).font(.largeTitle)
                } else {
                    LazyVStack {
                        ForEach(historyList, id: \.history.oid) { item in
                            HistoryItemView(itemData: item)
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
        .navigationTitle("历史记录")
        .onAppear {
            // TODO: 加载历史数据
            Task {
                HistoryService().getHistory { result in
                    DispatchQueue.main.async {
                        if result.data.list.isEmpty {
                            isError=true
                            errorStr="空白结果列表"
                        } else {
                            historyList=result.data.list
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

struct HistoryItemView: View {
    @AppStorage("open_web_in_app") private var openWebInApp: Bool=false
    var itemData: HistoryItem
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                AsyncImage(url: URL(string: itemData.getCover())) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 150, height: 84)
                VStack {
                    Text(itemData.title) // .font()
                    Text("@" + itemData.author_name)
                }
                // .frame(width: geometry.size.width)
                Spacer()
            }.frame(maxHeight: .infinity, alignment: .leading) // 设置对齐方式
        }
        .frame(height: 100) // 将 VStack 的固定高度设置为100
        .contentShape(Rectangle()) // 加这行才实现可点击
        .onTapGesture {
            // TODO: onClick
            print(itemData)
            var urlStr=""
            switch itemData.history.business {
            case "live":
                urlStr=itemData.uri
            case "pgc":
                urlStr=itemData.uri
            case "archive":
                urlStr="https://www.bilibili.com/video/\(String(describing: itemData.history.bvid))"
            default:
                urlStr=""
            }
            if urlStr.isNotEmpty {
                if openWebInApp {
                    AppService().openAppUrl(urlStr)
                } else {
                    Task {
                        DispatchQueue.main.async {
                            if urlStr.isNotEmpty {
                                if let url=URL(string: urlStr) {
                                    DispatchQueue.main.async {
                                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            switch itemData.history.getType() {
                // case "archive":

            default:
                print(itemData.getCover())
            }
        }
    }
}

// #Preview {
//    HistoryView()
// }
