//
//  CheckinView.swift
//  Bili-Swift
//
//  Created by zzh on 2024/7/18.
//

import SwiftUI

struct CheckinView: View {
    @State var showingAlert = false
    @State var alertText = ""
    @State var testLoading = false
    @State var checkList = []
    @State var mangaLoading = false
    @State var liveLoading = false
    @State var vipPointLoading = false
    var body: some View {
        VStack {
            List {
                Section(header: Text("通用")) {
                    CheckinItemView(title: "漫画签到", isLoading: $mangaLoading) {
                        Task {
                            CheckinService().mangaCheckin { result in
                                DispatchQueue.main.async {
                                    mangaLoading = false
                                    alertText = result.msg
                                    showingAlert = true
                                }
                            } fail: { error in
                                DispatchQueue.main.async {
                                    mangaLoading = false
                                    showingAlert = true
                                    alertText = error
                                }
                            }
                        }
                    }
                    CheckinItemView(title: "直播签到", isLoading: $liveLoading) {
                        Task {
                            LiveService().checkIn { result in
                                DispatchQueue.main.async {
                                    liveLoading = false
                                    alertText = result.message
                                    showingAlert = true
                                }
                            } fail: { error in
                                DispatchQueue.main.async {
                                    liveLoading = false
                                    showingAlert = true
                                    alertText = error
                                }
                            }
                        }
                    }
                }
                Section(header: Text("大会员")) {
                    CheckinItemView(title: "大积分签到", isLoading: $vipPointLoading) {
                        Task {
                            VipService().bipPointCheckin { result in
                                DispatchQueue.main.async {
                                    vipPointLoading = false
                                    alertText = result.message
                                    showingAlert = true
                                }
                            } fail: { error in
                                DispatchQueue.main.async {
                                    vipPointLoading = false
                                    showingAlert = true
                                    alertText = error
                                }
                            }
                        }
                    }
                }
            }
        }
        .alert("结果", isPresented: $showingAlert) {
            Button("OK", action: {
                alertText = ""
            })
        } message: {
            Text(alertText.getString("没有结果就是好结果"))
        }.onAppear {}
        #if os(iOS)
            .navigationBarTitle("签到", displayMode: .inline)
        #else
            .navigationTitle("签到")
        #endif
    }
}

struct CheckinItemView: View {
    var title: String
    @Binding var isLoading: Bool
    var onClick: () -> Void
    var body: some View {
        Button(action: {
            if !isLoading {
                isLoading = true
                onClick()
            }
        }) {
            HStack {
                Text(title)
                // Spacer() // 占据剩余空间，将 ProgressView 推到右侧
                if isLoading {
                    ProgressView()
                }
            }
        }
    }
}

#Preview {
    CheckinView()
}
