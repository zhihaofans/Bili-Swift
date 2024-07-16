//
//  SettingView.swift
//  Bili-Swift
//
//  Created by zzh on 2024/7/16.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        VStack {
            List {
                Section(header: Text("About")) {
                    TextItem(title: "开发者", detail: "zhihaofans")
                    TextItem(title: "Version", detail: "0.0.1")
                }
            }
            Text("这里是设置").font(.largeTitle)
        }
        #if os(iOS)
        .navigationBarTitle("设置", displayMode: .inline)
        #else
        .navigationTitle("设置")
        #endif
    }
}

struct TextItem: View {
    var title: String
    var detail: String

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(detail).foregroundColor(.gray)
        }
    }
}

#Preview {
    SettingView()
}
