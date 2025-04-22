import UserNotifications
import ActivityKit

class FNotificationService {
    
    func checkPermission(_ fn: (() -> Void)? = nil) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if let _ = error {
            } else {
                fn?()
            }
        }
    }
    
    func sendNotify(_ title: String, _ content: String = "", _ notifyType: NotifyType = NotifyType.DEFAULT) {
        checkPermission {
            let ret = self.createNotification(title, content, notifyType)
            self.sendNotification(ret)
        }
    }
    func sendNotify(_ notifyIndex: NotifyIndex, _ title: String, _ content: String = "", _ notifyType: NotifyType = NotifyType.DEFAULT, _ isCancel: Bool = false, _ thisPK: String = "") {
        checkPermission {
            let ret = self.createNotification(title, content, notifyType)
            self.sendNotification(ret, notifyIndex, thisPK)
        }
    }
    func makeProgressNotify(_ uuid: String, _ title: String, _ content: String = "", _ progress: Double = 0, _ isCancel: Bool = false) {
        let attr = UploadAttributes(uuid)
        let contentState = UploadAttributes.ContentState(progress, title, content)
        checkPermission {
            self.sendNotification(attr, contentState, isCancel)
        }
    }
    func updateNotification(_ uuid: String, _ title: String = "", _ content: String = "", _ progress: Double = 0, _ isCancel: Bool = false) {
        Task {
            guard let activity = Activity<UploadAttributes>.activities.first(where: { $0.attributes.uuid == uuid }) else {
                return
            }
            if isCancel {
                await activity.end(nil, dismissalPolicy: .immediate)
            } else {
                let contentState = UploadAttributes.ContentState(progress, title, content)
                let content = ActivityContent(state: contentState, staleDate: nil)
                await activity.update(content)
            }
        }
    }

    private func sendNotification(_ notify: UNMutableNotificationContent) {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notify, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    private func sendNotification(_ notify: UNMutableNotificationContent, _ notifyIndex: NotifyIndex, _ thisPK: String = "") {
        notify.userInfo = [
            FConstants.NOTIFY_INDEX: notifyIndex.rawValue,
            FConstants.NOTIFY_PK: thisPK
        ]
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notify, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    private func sendNotification(_ attr: UploadAttributes, _ contentState: UploadAttributes.ContentState, _ isCancel: Bool) {
        let content = ActivityContent(state: contentState, staleDate: nil)
        do {
            _ = try Activity<UploadAttributes>.request(attributes: attr, content: content, pushType: nil)
        } catch {
        }
    }
    
    private func createNotification(_ title: String, _ content: String, _ notifyType: NotifyType = NotifyType.DEFAULT) -> UNMutableNotificationContent {
        let notify = UNMutableNotificationContent()
        notify.title = title
        notify.body = content
        switch notifyType {
        case NotifyType.DEFAULT:
            break
        case NotifyType.WITH_SOUND:
            notify.sound = UNNotificationSound.default
            break
        case NotifyType.WITH_VIBRATE:
//            notify.sound = UNNotificationSound.default
            break
        case NotifyType.WITH_S_V:
            notify.sound = UNNotificationSound.default
            break
        }
        
        return notify
    }
    
    enum NotifyType: Int, CaseIterable {
        case DEFAULT = 1
        case WITH_SOUND = 2
        case WITH_VIBRATE = 3
        case WITH_S_V = 4
    }
}
