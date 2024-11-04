//
//  VideoInfoView.swift
//  Bili-Swift
//
//  Created by zzh on 2024/10/30.
//

import SwiftUI

struct VideoInfoView: View {
    @State private var videoInfo: VideoInfoData?=nil
    @State private var isError=false
    @State private var loaded=false
    @State private var errorStr=""
    @State var bvid: String=""
//    init(_ bvid: String?=nil) {
    ////        print(videoInfo)
//        if bvid != nil && bvid!.isNotEmpty {
//            self.bvid=bvid!
//            self.getVideoInfo()
//        } else {
//            self.errorStr="空白bvid"
//            self.bvid="bvid:nil"
//            self.isError=true
//            self.loaded=true
//        }
//    }

    var body: some View {
        ScrollView {
            if self.loaded {
                if self.isError {
                    Text(self.errorStr).font(.largeTitle)
                } else {
                    VideoInfoItemView(videoInfo: self.videoInfo!)
                }
            } else {
                Text("Loading...")
                ProgressView()
            }
        }
        // TODO: toolbar
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Image(systemName: "trash")
//            }
//        }
        .navigationBarTitle(bvid, displayMode: .inline)
        .onAppear {
            // TODO: 加载热视频信息
            Task {
                if self.bvid.isNotEmpty {
                    self.getVideoInfo()
                } else {
                    self.errorStr="空白bvid"
                    self.isError=true
                    self.loaded=true
                }
            }
        }
    }

    private func getVideoInfo() {
        Task {
            VideoService().getVideoInfo(self.bvid) { infoResult in
                print(infoResult)
                if infoResult.code == 0 && infoResult.data?.pic != nil {
                    self.videoInfo=infoResult.data
                } else {}
                self.loaded=true
            } fail: { err in
                print(err)
                self.errorStr=err
                self.loaded=true
                self.isError=true
            }
        }
    }
}

struct VideoInfoItemView: View {
    @State var videoInfo: VideoInfoData
    @AppStorage("open_web_in_app") private var openWebInApp: Bool=false
    init(videoInfo: VideoInfoData) {
        self.videoInfo=videoInfo
        print(videoInfo)
    }

    var body: some View {
        VStack {
            NavigationLink {
                PreviewView(type: "image", dataList: [videoInfo.pic])
            } label: {
                AsyncImage(url: URL(string: self.checkLink(videoInfo.pic))) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .scaledToFit() // 图片将等比缩放以适应框架
                        .padding(.horizontal, 5) // 设置水平方向的内间距
                } placeholder: {
                    ProgressView()
                }
            }
            HStack {
                AsyncImage(url: URL(string: self.checkLink(videoInfo.owner.face))) { image in
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
                Text(videoInfo.owner.name)
                    .font(.title2)
                Spacer()

            }.frame(maxHeight: .infinity) // 设置对齐方式
            Text(videoInfo.title)
                .lineLimit(2)
                .font(.title3)
            Button(action: {
                let urlStr="https://www.bilibili.com/video/\(videoInfo.bvid)/"
//                if openWebInApp {
                AppService().openAppUrl(urlStr)
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
            }) {
                Text("打开APP")
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            Button(action: {}) {
                Text("添加到稍后再看")
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
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
//    VideoInfoView()
// }
