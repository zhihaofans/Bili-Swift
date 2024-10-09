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
                            switch item.type {
                            case DynamicType().WORD:
                                DynamicItemTextView(itemData: item)
                            case DynamicType().DRAW:
                                DynamicItemImageView(itemData: item)
                            default:
                                DynamicItemView(itemData: item)
                            }
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
                            dynamicList=result.data!.items
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
                AsyncImage(url: URL(string: itemData.getCover() ?? defaultImg)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 100, height: 50)
                VStack {
                    Text(itemData.getTitle()) // .font()
                    Text("@" + itemData.modules.module_author.name)
                }
                // .frame(width: geometry.size.width)
            }.frame(maxHeight: .infinity, alignment: .leading) // 设置对齐方式
        }
        .background(Color.secondary) // 设置背景色以便观察效果
        .frame(height: 100) // 将 VStack 的固定高度设置为100
        .contentShape(Rectangle()) // 加这行才实现可点击
        .onTapGesture {
            // TODO: onClick
            print(itemData)
//            switch itemData.type {
//                // case "archive":
//
//                default:
//                    print(itemData.type)
//            }
        }
    }
}

struct DynamicItemTextView: View {
    var itemData: DynamicListItem
    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                HStack {
                    AsyncImage(url: URL(string: itemData.modules.module_author.face)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .scaledToFit() // 图片将等比缩放以适应框架
                            .frame(width: 40, height: 40) // 设置视图框架的大小
                            .clipShape(Circle()) // 裁剪成圆形
                            .overlay(Circle().stroke(Color.gray, lineWidth: 4)) // 可选的白色边框
                    } placeholder: {
                        ProgressView()
                    }
                    .padding(.leading, 20) // 在左侧添加 10 点的内间距
//                    .frame(width: 40, height: 40)
                    Text(itemData.modules.module_author.name)
                        .font(.title2)
                    Spacer()
                }.frame(maxHeight: .infinity) // 设置对齐方式
                Text(itemData.getTitle())
                    .padding(.horizontal, 20) // 设置水平方向的内间距
            }
        }
        .background(Color.secondary) // 设置背景色以便观察效果
        .frame(height: 100) // 将 VStack 的固定高度设置为100
        .contentShape(Rectangle()) // 加这行才实现可点击
        .onTapGesture {
            // TODO: onClick
            print(itemData)
//            switch itemData.type {
//                // case "archive":
//
//                default:
//                    print(itemData.type)
//            }
        }
    }
}

struct DynamicItemImageView: View {
    var itemData: DynamicListItem
    private let defaultImg="https://i0.hdslb.com/bfs/activity-plat/static/20220518/49ddaeaba3a23f61a6d2695de40d45f0/2nqyzFm9He.jpeg"
    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                HStack {
                    AsyncImage(url: URL(string: itemData.modules.module_author.face)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .scaledToFit() // 图片将等比缩放以适应框架
                            .frame(width: 40, height: 40) // 设置视图框架的大小
                            .clipShape(Circle()) // 裁剪成圆形
                            .overlay(Circle().stroke(Color.gray, lineWidth: 4)) // 可选的白色边框
                    } placeholder: {
                        ProgressView()
                    }
                    .padding(.leading, 20) // 在左侧添加 10 点的内间距
//                    .frame(width: 40, height: 40)
                    Text(itemData.modules.module_author.name)
                        .font(.title2)
                    Spacer()
                }.frame(maxHeight: .infinity) // 设置对齐方式
                Text(itemData.getTitle())
                    .lineLimit(2)
                    .padding(.horizontal, 20) // 设置水平方向的内间距
                AsyncImage(url: URL(string: itemData.modules.module_dynamic.major?.draw?.items[0].src ?? defaultImg)) { image in
                    image
                        .aspectRatio(contentMode: .fill)
                        .scaledToFit() // 图片将等比缩放以适应框架
                } placeholder: {
                    ProgressView()
                }
                .padding(.leading, 20) // 在左侧添加 10 点的内间距
            }
        }
        .background(Color.secondary) // 设置背景色以便观察效果
        .frame(height: 100) // 将 VStack 的固定高度设置为100
        .contentShape(Rectangle()) // 加这行才实现可点击
        .onTapGesture {
            // TODO: onClick
            print(itemData)
//            switch itemData.type {
//                // case "archive":
//
//                default:
//                    print(itemData.type)
//            }
        }
    }
}
