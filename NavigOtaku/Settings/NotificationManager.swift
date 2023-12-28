//
//  NotificationManager.swift
//  NavigOtaku
//
//  Created by Wentao Jiang on 12/11/23.
//

import Foundation
import SwiftUI

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    func requestAuth() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if !success && error == nil {
                print("Notification not permitted")
            }
        }
    }
    
    func scheduleNotification(title: String, notes: String, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = String(localized: "\(title)")
        content.body = notes
        content.sound = UNNotificationSound.default
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: "SakuraStreaming!: ", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }

    func removeNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
