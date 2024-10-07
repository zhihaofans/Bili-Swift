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
    @State var dynamicList: [DynamicListItem]=[]
    var body: some View {
        ScrollView {
            if loaded {
                if isError {
                    Text(errorStr).font(.largeTitle)
                } else {
                    LazyVStack {
                        ForEach(dynamicList, id: \.id_str) { item in
                            DynamicItemView(itemData: item)
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
        .navigationTitle("动态")
        .onAppear {
            // TODO: 加载历史数据
            Task {
                DynamicService().getDynamicList { result in
                    DispatchQueue.main.async {
                        if result.data == nil || result.data!.items.isEmpty {
                            isError=true
                            errorStr="空白结果列表"
                        } else {
                            dynamicList=result.data?.items
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

struct DynamicItemView: View {
    var itemData: DynamicListItem
    private let defaultImg="https://i0.hdslb.com/bfs/activity-plat/static/20220518/49ddaeaba3a23f61a6d2695de40d45f0/2nqyzFm9He.jpeg"
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                AsyncImage(url: URL(string: itemData.modules.module_dynamic.major?.getCover() ?? defaultImg)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 150, height: 84)
                VStack {
                    Text(itemData.) // .font()
                    Text("@" + itemData.author_name)
                }
                // .frame(width: geometry.size.width)
            }.frame(maxHeight: .infinity, alignment: .leading) // 设置对齐方式
        }
        .frame(height: 100) // 将 VStack 的固定高度设置为100
        .contentShape(Rectangle()) // 加这行才实现可点击
        .onTapGesture {
            // TODO: onClick

            switch itemData.type {
                // case "archive":

                default:
                    print(itemData.type)
            }
        }
    }
}
