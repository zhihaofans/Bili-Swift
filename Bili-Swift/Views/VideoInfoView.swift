//
//  VideoInfoView.swift
//  Bili-Swift
//
//  Created by zzh on 2024/10/30.
//

import SwiftUI

struct VideoInfoView: View {
    @State private var videoInfo: VideoInfoData?
    @State private var isError=false
    @State private var loaded=false
    @State private var errorStr=""
    @State private var bvid: String=""
    init(videoInfo: VideoInfoData?=nil, bvid: String?=nil) {
//        print(videoInfo)
        if videoInfo == nil {
            if bvid != nil && bvid!.isNotEmpty {
                self.getVideoInfo()
            } else {
                self.errorStr="请从正确入口进来"
                self.bvid="空白视频信息(videoInfo=nil)"
                self.isError=true
                self.loaded=true
            }
        } else {
            self.videoInfo=videoInfo
            self.bvid=videoInfo!.bvid
            self.loaded=true
        }
    }

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
        .navigationTitle(self.$bvid)
        .onAppear {
            // TODO: 加载热门榜
            Task {}
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
    init(videoInfo: VideoInfoData) {
        self.videoInfo=videoInfo
        print(videoInfo)
    }

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: self.checkLink(self.videoInfo.pic))) { image in
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
            .padding(.leading, 20)
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
