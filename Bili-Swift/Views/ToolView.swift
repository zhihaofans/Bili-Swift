//
//  ToolView.swift
//  Bili-Swift
//
//  Created by zzh on 2024/7/27.
//

import PhotosUI
import SwiftUI
import SwiftUtils
import UIKit

struct ToolView: View {
    var body: some View {
        VStack {
            NavigationView {
                List {
//                    NavigationLink("工具", destination: ToolView())
                    DownloadVideoCoverView()
                }
                .navigationTitle("工具")
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
            }
        }
    }
}

struct DownloadVideoCoverView: View {
    @State private var isLoading = false
    @State private var isShowAlert = false
    @State private var inputBvid = ""
    var body: some View {
        CheckinItemView(title: "下载视频封面", isLoading: $isLoading) {
            isShowAlert = true
//            isLoading = false
        }
        .alert("请输入bvid", isPresented: $isShowAlert) {
            TextField("", text: $inputBvid)
            Button("YES", action: {
                if inputBvid.isNotEmpty {
                    Task {
                        VideoService().getVideoInfo(inputBvid) { infoResult in
                            print(infoResult)
                            isLoading = false
                        } fail: { err in
                            print(err)
                            isLoading = false
                        }
                    }
//                    if hasTag {
//                        // TODO: 重复添加提示
//                        alertTitle = "添加标签失败"
//                        alertMessage = "标签\(newTag)已存在，标签不区分大小写"
//                        isShowInfoAlert = true
//                        newTag = ""
//                    } else {
//                        self.addTag(tag: newTag)
//                        newTag = ""
//                    }

                } else {
                    isLoading = false
                }
            })
            Button("NO", action: {
                isShowAlert = false
                isLoading = false
            })
        }
    }
}

// #Preview {
//    ToolView()
// }
