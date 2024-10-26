//
//  ToolView.swift
//  Bili-Swift
//
//  Created by zzh on 2024/7/27.
//

import PhotosUI
import QuickLook
import SwiftUI
import SwiftUtils
import UIKit

struct ToolView: View {
    @State var isLoading = false
    var body: some View {
        VStack {
            List {
//                    NavigationLink("工具", destination: ToolView())
                NavigationLink("下载视频封面", destination: DownloadVideoCoverView())
//                    DownloadVideoCoverView()
            }
            //                .toolbar {
            //                    ToolbarItem(placement: .navigationBarTrailing) {
            //                        NavigationLink(destination: UserView()) {
            //                            // TODO: 这里跳转到个人页面或登录界面
            //                            Image(systemName: "person")
            //                        }
            //                    }
            //                    ToolbarItem(placement: .navigationBarTrailing) {
            //                        NavigationLink(destination: SettingView()) {
            //                            Image(systemName: "gear")
            //                        }
            //                    }
            //                }
            .navigationBarTitle("工具", displayMode: .inline)
        }
    }
}

struct DownloadVideoCoverView: View {
    @State private var isLoading = false
    @State private var isShowAlert = false
    @State private var alertTitle = ""
    @State private var alertText = ""
    @State private var inputBvid = "BV117411r7R1"
    @State private var videoCover = ""
    var body: some View {
        List {
            TextField("", text: $inputBvid)
            ListItemLoadingView(title: "开始下载视频封面", isLoading: $isLoading, loadingColor: Color.blue) {
                if inputBvid.isEmpty {
                    isLoading = false
                    alertTitle = "发生错误"
                    alertText = "请输入BVID"
                    isShowAlert = true
                } else if !inputBvid.uppercased().starts(with: "BV") {
                    isLoading = false
                    alertTitle = "发生错误"
                    alertText = "请输入BV开头的ID"
                    isShowAlert = true
                } else {
                    Task {
                        VideoService().getVideoInfo(inputBvid) { infoResult in
                            print(infoResult)
                            if infoResult.code == 0 && infoResult.data?.pic != nil {
                                videoCover = infoResult.data?.pic.replace(of: "http://", with: "https://") ?? ""
                            } else {}
                            isLoading = false
                        } fail: { err in
                            print(err)
                            isLoading = false
                            alertTitle = "发生错误"
                            alertText = err
                            isShowAlert = true
                        }
                    }
                }
            }
            .alert(alertTitle, isPresented: $isShowAlert) {
                Button("OK", action: {
                    alertTitle = ""
                    alertText = ""
                    isLoading = false
                })
            } message: {
                Text(alertText)
            }
            if videoCover.isNotEmpty {
//                AsyncImage(url: URL(string: videoCover)) { image in
//                    image
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .scaledToFit() // 图片将等比缩放以适应框架
//                        .padding(.horizontal, 20) // 设置水平方向的内间距
//                } placeholder: {
//                    ProgressView()
//                }
                TextField("", text: $videoCover)
                NavigationLink("查看视频封面", destination: PreviewView(type: "image", dataList: [videoCover]))
            }
        }
        .navigationBarTitle("下载视频封面", displayMode: .inline)
    }
}

// #Preview {
//    ToolView()
// }
