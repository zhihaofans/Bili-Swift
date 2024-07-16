//
//  LoginView.swift
//  Bili-Swift
//
//  Created by zzh on 2024/7/17.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        #if os(iOS)
        iosView()
        #else
        macLoginView()
        #endif
    }
}

@available(macOS, unavailable)
struct iosLoginView: View {
    var body: some View {
        VStack {
            NavigationView {
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            }
        }.navigationTitle("登入")
    }
}

@available(iOS, unavailable)
struct macLoginView: View {
    var body: some View {
        VStack {
            Text("Hello, Mac!")
        }
    }
}
