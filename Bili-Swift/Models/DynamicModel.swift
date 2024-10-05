//
//  DynamicModel.swift
//  Bili-Swift
//
//  Created by zzh on 2024/10/6.
//

import Foundation

struct DynamicListResult: Codable {
    let code: Int
    let message: String
    let data: DynamicListData?
}

struct DynamicListData: Codable {
    let has_more: Bool
    let offset: String
    let update_baseline: String
    let update_num: Int
    let items: [DynamicListItem]
}

struct DynamicListItem: Codable {
    let visible: Bool
    let id_str: String
    let type: String
    let basic: DynamicListItemBasic
    let modules: DynamicListItemModules
}

struct DynamicListItemBasic: Codable {
    let comment_id_str: String
    let comment_type: Int
    // let like_icon:{}
    let rid_str: String
}

struct DynamicListItemModules: Codable {
    let module_author: DynamicListItemBModuleAuthor
    //   let module_dynamic    obj    动态内容信息
    //  let module_more    obj    动态右上角三点菜单
    //  let  module_stat    obj    动态统计数据
//    module_interaction    obj    热度评论
//    module_fold    obj    动态折叠信息
//    module_dispute    obj    争议小黄条
//    module_tag    obj    置顶信息
}

struct DynamicListItemBModuleAuthor: Codable {
    let face: String
    let jump_url: String
    let label: String // 名称前标签：合集、电视剧、番剧
    let mid: String // UP主UID、剧集SeasonId
    let name: String // UP主名称、剧集名称、合集名称
    let pub_action: String // 更新动作描述
    let pub_time: String // 更新时间：x分钟前、x小时前、昨天
    let pub_ts: Int // 更新时间戳    UNIX 秒级时间戳
}
