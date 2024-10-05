//
//  DynamicView.swift
//  Bili-Swift
//
//  Created by zzh on 2024/10/6.
//

import SwiftUI

struct DynamicView: View {
    @State var isError=false
    @State var loaded=false
    @State var errorStr=""
    @State var dynamicList: [HistoryItem]=[]
    var body: some View {
        ScrollView {
            if loaded {
                if isError {
                    Text(errorStr).font(.largeTitle)
                } else {
                    LazyVStack {
                        ForEach(dynamicList, id: \.history.oid) { item in
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
                            dynamicList=result.data.list
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

#Preview {
    DynamicView()
}
