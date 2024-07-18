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
        VStack {
            if loaded {
                if isError {
                    LazyVStack {
                        ForEach(historyList, id: \.history.oid) { item in
                            HistoryItemView(itemData: item)
                        }
                    }
                }
            } else {
                Text("Loading...")
            }
        }.onAppear {
            // TODO: 加载历史数据
            HistoryService().getHistory { result in
                if result.data.list.isEmpty {
                    isError=true
                    errorStr="空白结果列表"
                } else {
                    historyList=result.data.list
                    isError=false
                }
            } fail: { err in
                isError=true
                errorStr=err
            }
        }
    }
}

struct HistoryItemView: View {
    var itemData: HistoryItem
    var body: some View {
        VStack {
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
                    Text(itemData.title).font(.largeTitle)
                    Text(itemData.author_name)
                }
                // .frame(width: geometry.size.width)
            }
        }
        .frame(height: 100) // 将 VStack 的固定高度设置为100
        .contentShape(Rectangle()) // 加这行才实现可点击
        .onTapGesture {
            // TODO: onClick

            switch itemData.history.getType() {
                // case "archive":

                default:
                    print(itemData.getCover())
            }
        }
    }
}

#Preview {
    HistoryView()
}
