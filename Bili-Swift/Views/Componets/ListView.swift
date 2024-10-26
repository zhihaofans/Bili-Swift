//
//  ListView.swift
//  Bili-Swift
//
//  Created by zzh on 2024/10/27.
//

import SwiftUI

struct ListItemLoadingView: View {
    var title: String
    @Binding var isLoading: Bool
    var loadingColor: Color? = nil
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
                    ProgressView().tint(loadingColor)
                }
            }
        }
    }
}
