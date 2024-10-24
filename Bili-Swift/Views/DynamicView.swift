//
//  DynamicView.swift
//  Bili-Swift
//
//  Created by zzh on 2024/10/6.
//

import Alamofire
import Foundation
import SwiftUI
import SwiftUtils

struct DynamicView: View {
    @State var isError=false
    @State var loaded=false
    @State var errorStr=""
    @State var dynamicList: [DynamicListItem]=[]
    var body: some View {
        NavigationView {
            ScrollView {
                if loaded {
                    if isError {
                        Text("Error").font(.largeTitle)
                        Text(errorStr)
                    } else {
                        LazyVStack {
                            Section(header: Text("共\(dynamicList.count)个动态").foregroundColor(.blue), footer: Text("下面的内容还不能给你看").foregroundColor(.red)) {
                                ForEach(dynamicList, id: \.id_str) { item in
                                    //                            switch item.type {
                                    //                            case DynamicType().WORD:
                                    //                                DynamicItemTextView(itemData: item)
                                    //                            default:
                                    //                                DynamicItemOldView(itemData: item)
                                    //                            }

                                    DynamicItemImageView(itemData: item)
                                }
                            }
                        }
                    }
                } else {
                    Text("Loading...")
                    ProgressView()
                }
            }
            .navigationBarTitle("动态", displayMode: .inline)
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
}

struct DynamicItemOldView: View {
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

struct DynamicItemImageView: View {
    var itemData: DynamicListItem
    private let defaultImg="https://i0.hdslb.com/bfs/activity-plat/static/20220518/49ddaeaba3a23f61a6d2695de40d45f0/2nqyzFm9He.jpeg"
    private var imageUrl: String?
    private var dynamicText: String
    @State private var hasImage=false
    @State private var showingAlert=false
    @State private var alertTitle=""
    @State private var alertText=""
    private let UDUtil=UserDefaultUtil()
    @AppStorage("open_web_in_app") var openWebInApp: Bool=false
    private let dynamicType=DynamicType()
    private let dynamicService=DynamicService()

    init(itemData: DynamicListItem) {
        self.itemData=itemData
        self.dynamicText=itemData.getTitle()
        @AppStorage("bili_dynamic_image_mode") var isDynamicShowImage=true
        debugPrint(itemData.modules.module_dynamic.major?.type)
        // debugPrint(contentJson)
        if isDynamicShowImage {
            switch itemData.type {
            case dynamicType.DRAW:
                self.hasImage=true
                self.imageUrl=itemData.modules.module_dynamic.major?.draw?.items[0].src
            case dynamicType.VIDEO:
                self.hasImage=true
                self.imageUrl=itemData.modules.module_dynamic.major?.archive?.cover
            case dynamicType.ARTICLE:
                self.hasImage=true
                self.imageUrl=itemData.modules.module_dynamic.major?.article?.covers[0]
            case dynamicType.LIVE_RCMD:
                let contentJson=itemData.modules.module_dynamic.major?.live_rcmd?.content
                if contentJson != nil {
                    let data=try? JSONDecoder().decode(DynamicListItemModuleDynamicMajorLiveRcmdContent.self, from: contentJson!.data(using: .utf8)!)
                    debugPrint(data)
                    if data != nil {
                        self.dynamicText=data!.getTitle() ?? dynamicText
                        self.imageUrl=data!.getCover()
                        self.hasImage=true
                    } else {
                        self.hasImage=false
                    }
                    debugPrint(imageUrl)
                    debugPrint(hasImage)
                }
            default:
                self.hasImage=false
                self.imageUrl=nil
            }
        } else {
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
