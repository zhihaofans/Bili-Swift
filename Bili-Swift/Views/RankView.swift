//
//  RankView.swift
//  Bili-Swift
//
//  Created by zzh on 2024/10/28.
//

import SwiftUI

struct RankView: View {
    @State var isError=false
    @State var loaded=false
    @State var errorStr=""
    @State var rankList: [RankInfoData]=[]
    var body: some View {
        ScrollView {
            if loaded {
                if isError {
                    Text(errorStr).font(.largeTitle)
                } else {
                    LazyVStack {
                        ForEach(rankList, id: \.bvid) { item in
                            RankItemView(itemData: item)
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
                RankService().getRankList { result in
                    DispatchQueue.main.async {
                        if result.data.list.isEmpty {
                            isError=true
                            errorStr="空白结果列表"
                        } else {
                            rankList=result.data.list
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

struct RankItemView: View {
    @AppStorage("open_web_in_app") private var openWebInApp: Bool=false
    var itemData: RankInfoData
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
            print(itemData)
//            var urlStr=""
//            switch itemData.history.business {
//            case "live":
//                urlStr=itemData.uri
//            case "pgc":
//                urlStr=itemData.uri
//            case "archive":
//                urlStr="https://www.bilibili.com/video/\(String(describing: itemData.history.bvid))"
//            default:
//                urlStr=""
//            }
//            if urlStr.isNotEmpty {
//                if openWebInApp {
//                    AppService().openAppUrl(urlStr)
//                } else {
//                    Task {
//                        DispatchQueue.main.async {
//                            if urlStr.isNotEmpty {
//                                if let url=URL(string: urlStr) {
//                                    DispatchQueue.main.async {
//                                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//            switch itemData.history.getType() {
//                // case "archive":
//
//            default:
//                print(itemData.getCover())
//            }
        }
    }
}

struct RankItemNewView: View {
    var itemData: RankInfoData
    private let defaultImg="https://i0.hdslb.com/bfs/activity-plat/static/20220518/49ddaeaba3a23f61a6d2695de40d45f0/2nqyzFm9He.jpeg"
    private var imageUrl: String?
    private var dynamicText: String
    @State private var hasImage=false
    @State private var showingAlert=false
    @State private var alertTitle=""
    @State private var alertText=""
    @AppStorage("open_web_in_app") private var openWebInApp: Bool=false

    init(itemData: RankInfoData) {
        self.itemData=itemData
        self.dynamicText=itemData.getTitle()
        @AppStorage("bili_dynamic_image_mode") var isDynamicShowImage=true
    }

    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                HStack {
                    AsyncImage(url: URL(string: itemData.pic)) { image in
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
                Text(dynamicText)
                    .lineLimit(2)
                    .padding(.horizontal, 20) // 设置水平方向的内间距
                if imageUrl != nil && imageUrl!.isNotEmpty {
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
        .background(Color(.secondarySystemBackground)) // 设置背景色以便观察效果
//        .frame(height: 150) // 将 VStack 的固定高度设置为100
        .frame(minHeight: 100)
        .contentShape(Rectangle()) // 加这行才实现可点击
        .onTapGesture {
            // TODO: onClick
            print(itemData)
            switch itemData.type {
            case DynamicType().VIDEO:
                let urlStr=self.checkLink(itemData.modules.module_dynamic.major?.archive?.jump_url)
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
            case DynamicType().ARTICLE:
                let urlStr=self.checkLink(itemData.modules.module_dynamic.major?.article?.jump_url)
                if openWebInApp {
                    AppService().openAppUrl(urlStr)
                } else {
                    Task {
                        DispatchQueue.main.async {
                            if urlStr.isNotEmpty {
                                if let url=URL(string: urlStr) {
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }
                            }
                        }
                    }
                }
            case DynamicType().LIVE_RCMD:
//                print(itemData.modules.module_dynamic.major?.live_rcmd)
                alertTitle="@" + itemData.modules.module_author.name + " 开播了"
                alertText=itemData.modules.module_dynamic.major?.live_rcmd?.content ?? "[??]"
                showingAlert=true
            default:
                print(itemData.type)
                alertTitle="@" + itemData.modules.module_author.name
                alertText=itemData.modules.module_dynamic.getTitle() ?? "[没有标题]"
                showingAlert=true
            }
        }
        .alert(alertTitle, isPresented: $showingAlert) {
            TextField("Placeholder", text: $alertText)
            Button("OK", action: {
                showingAlert=false
            })
        } message: {
            Text(alertText)
        }
    }

    private func checkLink(_ url: String?) -> String {
        var urlStr=url ?? ""
        if urlStr.starts(with: "//") {
            urlStr="https:" + urlStr
        }
        if urlStr.starts(with: "http://") {
            urlStr=urlStr.replace(of: "http://", with: "https://")
        }
        return urlStr
    }
}

// #Preview {
//    HotView()
// }
