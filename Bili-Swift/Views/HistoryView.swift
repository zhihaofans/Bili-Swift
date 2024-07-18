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
            }.frame(maxHeight: .infinity, alignment: .leading) // 设置对齐方式
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
