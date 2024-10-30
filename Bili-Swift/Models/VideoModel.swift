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
    let videos: Int // 稿件分P总数
    let pic: String
    let cover43: String?
    let title: String
    let pubdate: Int // 稿件发布时间
    let ctime: Int // 用户投稿时间
    let desc: String
    let duration: Int // 稿件总时长(所有分P)
    let owner: VideoInfoOwner
    let tname: String? // 分区类型
    let dynamic: String // 视频同步发布的的动态的文字内容
    let no_cache: Bool? // 是否不允许缓存?
    let pages: [VideoInfoPagesItem]? // 视频分P列表
    let short_link_v2: String? // 短链接
}

struct VideoInfoOwner: Codable {
    let mid: Int
    let name: String
    let face: String
}

struct VideoInfoPagesItem: Codable {
    let cid: Int
    let page: Int // 分P序号，从1开始
    let from: String // 视频来源，    vupload：普通上传（B站）、hunan：芒果TV、qq：腾讯
    let part: String // 分P标题
    let duration: Int // 分P持续时间
}
