//
//  NotificationManager.swift
//  Notification_Test
//
//  Created by Tasuku Yamamoto on 4/20/22.
//

import UIKit
import UserNotifications

class NotificationManager: NSObject {
    override init(){
        super.init()
        
        requestPermission()
    }
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                print("we have permission to send notifications")
                UNUserNotificationCenter.current().delegate = self
            }else if let err = error {
                print(err)
            }
        }
    }
    
    func fireNotification(){
        let action = UNNotificationAction(identifier: "feedMe", title: "Feed Me", options: [])
        let category = UNNotificationCategory(identifier: "eatingCategory", actions: [action], intentIdentifiers: [], options: [.customDismissAction])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        let noteContent = UNMutableNotificationContent()
        noteContent.title = "Time to eat!"
        noteContent.body = "The wait is over!!"
        noteContent.categoryIdentifier = "eatingCategory"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let requestIdentifier = "testRequest"
        let noteRequuest = UNNotificationRequest(identifier: requestIdentifier, content: noteContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(noteRequuest) { (error) in
            print(String(describing: error))
        }
    }
    
}

extension NotificationManager: UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let message = notification.request.content.title
        NotificationCenter.default.post(name: NSNotification.Name("localNotificationFired"), object: nil, userInfo: ["message": message])
        
        completionHandler(.alert)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "feedMe":
            print("I am eating")
        default:
            break
        }
        
        completionHandler()
    }
}
