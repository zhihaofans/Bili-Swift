//
//  SearchView.swift
//  Bili-Swift
//
//  Created by zzh on 2024/11/15.
//

import SwiftUI
import SwiftUtils

struct SearchView: View {
    @State var playNotificationSounds=false
    @State var sendReadReceipts=false
    @State var searchKey=""
    var body: some View {
        VStack {
            Form {
                TextField("Placeholder", text: $searchKey)
                Section(header: Text("Notifications")) {
                    Toggle("Play notification sounds", isOn: $playNotificationSounds)
                    TextField("Placeholder", text: $searchKey)
                    Toggle("Send read receipts", isOn: $sendReadReceipts)
                    Button("Button") {
                        
                    }
                }
                Button("Button") {
                    
                }
            }
        }.setNavigationTitle("搜索")
    }
}

#Preview {
    SearchView()
}
