//
//  NotificationService.swift
//  Bili-Swift
//
//  Created by zzh on 2024/8/14.
//

import Foundation
import UserNotifications

class NotificationService {
    func requestNotificationPermission(success: () -> Void, fail: (String) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permission: \(error)")
                fail("Error requesting notification permission: \(error)")
            } else if granted {
                print("Notification permission granted.")
                success()
            } else {
                print("Notification permission denied.")
                fail("Notification permission denied.")
            }
        }
    }

    func createNotificationContent() -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "指定时间提醒"
        content.body = "这是在指定时间发送的通知内容"
        content.sound = .default
        return content
    }

    func scheduleNotification(at dateComponents: DateComponents) {
        let content = createNotificationContent()

        // 设置基于日期的触发器
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        // 创建通知请求
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // 将通知请求添加到通知中心
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled for specified date.")
            }
        }
    }

    func scheduleNotificationForSpecificTime() {
        var dateComponents = DateComponents()
        dateComponents.year = 2024
        dateComponents.month = 8
        dateComponents.day = 15
        dateComponents.hour = 9
        dateComponents.minute = 0

        scheduleNotification(at: dateComponents)
    }
}
