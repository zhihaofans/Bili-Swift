//
//  VideoModel.swift
//  Bili-Swift
//
//  Created by zzh on 2024/10/22.
//

import Foundation

struct VideoInfoResult: Codable {
    let code: Int
    let message: String
    let data: VideoInfoData?
}

struct VideoInfoData: Codable {
    let bvid: String
    let aid: Int
    let videos: Int
    let title: String
}
