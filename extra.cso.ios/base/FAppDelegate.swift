import Foundation
import UserNotifications
import SwiftUI

class FAppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
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
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(UIBackgroundFetchResult.newData)
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        backgroundTask = application.beginBackgroundTask {
            application.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = .invalid
        }
        FDI.mqttBackgroundService.mqttDisconnect()
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        if backgroundTask != .invalid {
            application.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
        Task {
            await FDI.mqttBackgroundService.mqttInit()
        }
    }
}
