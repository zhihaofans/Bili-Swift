//
//  BiliWidget.swift
//  BiliWidget
//
//  Created by zzh on 2024/11/2.
//

import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry { SimpleEntry(date: Date(), liver_name: "鸽子王", room_title: "今天也摸了", room_id: "-1", is_live: false)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), liver_name: "鸽子王", room_title: "今天也摸了", room_id: "-1", is_live: false)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
//            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: Date(), liver_name: "鸽子王", room_title: "今天也摸了", room_id: "-1", is_live: false)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let liver_name: String
    let room_title: String
    let room_id: String
    let is_live: Bool
}

struct BiliWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
//            HStack {
//                Text("Time:")
//                Text(entry.date, style: .time)
//            }
            Text(entry.liver_name).font(.largeTitle)
            Text("房间:\(entry.room_id)")
            Text(entry.is_live ? "开播了" : "摸了")
            if entry.is_live {
                Text("「\(entry.room_title)」")
            }
        }
    }
}

struct BiliWidget: Widget {
    let kind: String = "BiliWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(macOS 14.0, iOS 17.0, *) {
                BiliWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                BiliWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("鸽子王播了吗")
        .description("输入直播间编号")
    }
}

#Preview(as: .systemSmall) {
    BiliWidget()
} timeline: {
    SimpleEntry(date: Date(), liver_name: "鸽子王", room_title: "今天也摸了", room_id: "-1", is_live: false)
    SimpleEntry(date: Date(), liver_name: "小鸽子", room_title: "咕咕咕", room_id: "-1", is_live: false)
}
