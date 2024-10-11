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
                    Text("Error").font(.largeTitle)
                    Text(errorStr)
                } else {
                    LazyVStack {
                        ForEach(dynamicList, id: \.id_str) { item in
//                            switch item.type {
//                            case DynamicType().WORD:
//                                DynamicItemTextView(itemData: item)
//                            case DynamicType().DRAW:
//                                DynamicItemImageView(itemData: item)
//                            default:
//                                DynamicItemView(itemData: item)
//                            }

                            DynamicItemImageView(itemData: item)
                        }
                    }
                }
            } else {
                Text("Loading...")
                ProgressView()
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
                        loaded=true
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
                Spacer()
            }.frame(maxHeight: .infinity, alignment: .leading) // 设置对齐方式
            Spacer()
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
                    Text(itemData.modules.module_author.pub_time)
                }.frame(maxHeight: .infinity) // 设置对齐方式
                Text(itemData.getTitle())
                    .padding(.horizontal, 20) // 设置水平方向的内间距
                Spacer()
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
    private let imageUrl: String?
    @State private var hasImage=false
    init(itemData: DynamicListItem) {
        self.itemData=itemData
        switch itemData.type {
        case DynamicType().DRAW:
            self.hasImage=true
            self.imageUrl=itemData.modules.module_dynamic.major?.draw?.items[0].src
        case DynamicType().VIDEO:
            self.hasImage=true
            self.imageUrl=itemData.modules.module_dynamic.major?.archive?.cover
        default:
            self.hasImage=false
            self.imageUrl=nil
        }
    }

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
                    Text(itemData.modules.module_author.pub_time + " " + itemData.modules.module_author.pub_action)
                        .padding(.trailing, 10) // 在右侧添加 10 点的内间距
                }.frame(maxHeight: .infinity) // 设置对齐方式
                Text(itemData.getTitle())
                    .lineLimit(2)
                    .padding(.horizontal, 20) // 设置水平方向的内间距
                if hasImage {
                    AsyncImage(url: URL(string: (imageUrl ?? defaultImg).replace(of: "http://", with: "https://"))) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .scaledToFit() // 图片将等比缩放以适应框架
                            .padding(.horizontal, 20) // 设置水平方向的内间距
                    } placeholder: {
                        ProgressView()
                    }
//                    .padding(.leading, 20) // 在左侧添加 10 点的内间距
                }
                Spacer()
            }
        }
        .background(Color.secondary) // 设置背景色以便观察效果
//        .frame(height: 150) // 将 VStack 的固定高度设置为100
        .frame(minHeight: 100)
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
