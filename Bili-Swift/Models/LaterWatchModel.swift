//
//  LaterWatchModel.swift
//  Bili-Swift
//
//  Created by zzh on 2024/7/18.
//

import Foundation

struct LaterWatchResult: Codable {
    let code: Int
    let msg: String
    let data: LaterWatchData
}

struct LaterWatchData: Codable {
    let list: [LaterWatchList]
    let count: Int
}

struct LaterWatchList: Codable {
    let title: String
    let aid: Int
    let bvid: String
    let pic: String
    let pubdate: Int
    let ctime: Int
    let desc: Int
    let progress: Int
    let duration: Int
    let add_at: Int
    let owner: LaterWatchOwner
}

struct LaterWatchOwner: Codable {
    let mid: Int
    let name: String
    let face: String
}
