//
//  ToolView.swift
//  Bili-Swift
//
//  Created by zzh on 2024/7/27.
//

import PhotosUI
import SwiftUI
import UIKit

struct ToolView: View {
    @State private var isLoading = false
    var body: some View {
        VStack {
            NavigationView {
                List {
//                    NavigationLink("工具", destination: ToolView())
                    CheckinItemView(title: "直播签到", isLoading: $isLoading) {
                        Task {}
                    }
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

// #Preview {
//    ToolView()
// }
