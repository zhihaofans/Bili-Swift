//
//  SearchView.swift
//  Bili-Swift
//
//  Created by zzh on 2024/11/15.
//

import SwiftUI
import SwiftUtils

class SearchType {
    let VIDEO = "video"
}

struct SearchView: View {
    private let searchTypeList = SearchType()
    @State private var searchType = "video"
    @State var playNotificationSounds = false
    @State var sendReadReceipts = false
    @State var searchKey = ""
    var body: some View {
        VStack {
            Form {
                Section(header: Text("搜索")) {
                    TextField("搜索", text: $searchKey)
                    Menu {
                        Button(action: {
                            searchType = searchTypeList.VIDEO
                        }) {
                            Label("视频", systemImage: "play.rectangle.fill")
                        }
                    } label: {
                        SimpleTextItemView(title: "搜索类型", detail: searchType)
                    }
                }
                Button("Button") {}
            }
        }.setNavigationTitle("搜索")
    }
}

struct SimpleTextItemView: View {
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

//
// #Preview {
//    SearchView()
// }
