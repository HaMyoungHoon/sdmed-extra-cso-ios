import Foundation
import UserNotifications
import SwiftUI

class FAppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        guard let index = userInfo[FConstants.NOTIFY_INDEX] as? Int,
              let thisPK = userInfo[FConstants.NOTIFY_PK] as? String else {
            completionHandler()
            return
        }
        let notifyIndex = NotifyIndex.parseIndex(index)
        FStorage.setNotifyIndex(notifyIndex.getViewIndex())
        FStorage.setNotifyPK(thisPK)
        completionHandler()
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
