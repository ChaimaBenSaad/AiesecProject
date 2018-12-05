//
//  NotificationPublisher.swift
//  ChaymaApp
//
//  Created by mac on 05/12/2018.
//  Copyright © 2018 esprit. All rights reserved.
//
import UIKit
import Foundation
import UserNotifications
class NotificationPublisher: NSObject
{
    func sendNotification(tittle: String , subtitle: String , body: String , badge : Int? , delayInterval: Int?)
    {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = tittle
         notificationContent.subtitle = subtitle
         notificationContent.body = body
        var delayTimeTrigger: UNTimeIntervalNotificationTrigger?
        if let delayInterval = delayInterval
         {
            
            delayTimeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(delayInterval), repeats: false)
        }
        
        if let badge = badge
        {
            var currentBadgeCount = UIApplication.shared.applicationIconBadgeNumber
            currentBadgeCount += badge
            notificationContent.badge = NSNumber(integerLiteral: currentBadgeCount)
            
        }
        notificationContent.sound = UNNotificationSound.default()
        
        UNUserNotificationCenter.current().delegate = self
        
        let request = UNNotificationRequest(identifier: "testLocalNotification", content: notificationContent, trigger: delayTimeTrigger)
        UNUserNotificationCenter.current().add(request){error in
        if let error = error {
            print (error.localizedDescription)
        }
        }
        
    }
    
    
    
    
    
}

extension NotificationPublisher :UNUserNotificationCenterDelegate
{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print ("the notification is about to be presented")
        completionHandler([.alert , .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let identifier = response.actionIdentifier
        switch identifier {
        case UNNotificationDismissActionIdentifier:
            print ("the notification was dismissed")
            completionHandler()
        case UNNotificationDefaultActionIdentifier:
            print ("the user opened the app from the notification")
            completionHandler()
        default:
            print ("the default case was called")
             completionHandler()
        }
    }
}
