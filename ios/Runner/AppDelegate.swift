import UIKit
import Flutter
import BackgroundTasks

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    var channel = FlutterMethodChannel()
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
        
    registerBackgroundTaks()
//    registerLocalNotification()
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    channel = FlutterMethodChannel(name: "com.amirsheibani.service_background",binaryMessenger: controller.binaryMessenger)
    
    channel.setMethodCallHandler({
        [weak self](call: FlutterMethodCall, result: FlutterResult) -> Void in
        self?.methodCallDispatcher(call: call, result: result,application: application)
      })
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func methodCallDispatcher(call: FlutterMethodCall,result: FlutterResult,application: UIApplication){
        if(call.method == "startBackgroundService"){
            let args = call.arguments as? Dictionary<String, String>
            let minimumLatency = args!["minimumLatency"]! as String
            let m = Int(minimumLatency) ?? 60000
            print("AppDelegate :\(m)")
            cancelAllPandingBGTask()
            scheduleAppRefresh()
            result("setSchedule Interval")
        }else{
            result(FlutterMethodNotImplemented)
            return
        }
    }
    
    override func applicationDidEnterBackground(_ application: UIApplication) {
            cancelAllPandingBGTask()
            scheduleAppRefresh()
    }
    
    private func registerBackgroundTaks() {

        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.amirsheibani.service_background", using: nil) { task in
        //This task is cast with processing request (BGAppRefreshTask)
//        self.scheduleLocalNotification()
        self.handleAppRefreshTask(task: task as! BGAppRefreshTask)
        }
    }
    func cancelAllPandingBGTask() {
        BGTaskScheduler.shared.cancelAllTaskRequests()
    }
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.amirsheibani.service_background")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 2 * 60) // App Refresh after 2 minute.
        //Note :: EarliestBeginDate should not be set to too far into the future.
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }

    func handleAppRefreshTask(task: BGAppRefreshTask) {
        //Todo Work
        /*
         //AppRefresh Process
         */
        task.expirationHandler = {
            //This Block call by System
            //Canle your all tak's & queues
        }
//        scheduleLocalNotification()
        
        print("Call me")
        //
        task.setTaskCompleted(success: true)
    }
}


//MARK:- Notification Helper
extension AppDelegate {
    
    func registerLocalNotification() {
        let notificationCenter = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
    }
    
    func scheduleLocalNotification() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                self.fireNotification()
            }
        }
    }
    
    func fireNotification() {
        // Create Notification Content
        let notificationContent = UNMutableNotificationContent()
        
        // Configure Notification Content
        notificationContent.title = "Bg"
        notificationContent.body = "BG Notifications."
        
        // Add Trigger
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
        
        // Create Notification Request
        let notificationRequest = UNNotificationRequest(identifier: "local_notification", content: notificationContent, trigger: notificationTrigger)
        
        // Add Request to User Notification Center
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
    }
    
}
