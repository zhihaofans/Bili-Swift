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
    var body: some View {
        VStack {
            Button("漫画签到") {
                Task {
                    CheckinService().mangaCheckin { result in
                        DispatchQueue.main.async {
                            alertText = result.msg
                            showingAlert = true
                        }
                    } fail: { error in
                        DispatchQueue.main.async {
                            showingAlert = true
                            alertText = error
                        }
                    }
                }
            }
            .font(/*@START_MENU_TOKEN@*/ .title/*@END_MENU_TOKEN@*/)
            .buttonStyle(BorderedProminentButtonStyle())
            Button("直播签到") {
                Task {
                    CheckinService().liveCheckin { result in
                        DispatchQueue.main.async {
                            alertText = result.message
                            showingAlert = true
                        }
                    } fail: { error in
                        DispatchQueue.main.async {
                            showingAlert = true
                            alertText = error
                        }
                    }
                }
            }
            .font(/*@START_MENU_TOKEN@*/ .title/*@END_MENU_TOKEN@*/)
            .buttonStyle(BorderedProminentButtonStyle())
        }
        .alert("结果", isPresented: $showingAlert) {
            Button("OK", action: {
                alertText = ""
            })
        } message: {
            Text(alertText)
        }
        #if os(iOS)
        .navigationBarTitle("签到", displayMode: .inline)
        #else
        .navigationTitle("签到")
        #endif
    }
}

#Preview {
    CheckinView()
}
