import UIKit
import Flutter


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    var channel = FlutterMethodChannel()
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        channel = FlutterMethodChannel(name: "com.amirsheibani.service_background",
                                      binaryMessenger: controller.binaryMessenger)
    channel.setMethodCallHandler({(call: FlutterMethodCall, result: FlutterResult) -> Void in
          // Note: this method is invoked on the UI thread.
        if(call.method == "startBackgroundService"){
            if let args = call.arguments as? Dictionary<String, Any>,
               let minimumLatency = args["minimumLatency"] as? String,
               let _ = args["deadline"] as? String {
                let m = Int(minimumLatency) ?? 6000
                application.setMinimumBackgroundFetchInterval(TimeInterval(m/1000))
              } else {
                result(FlutterError.init(code: "bad args", message: nil, details: nil))
              }
        }else{
            result(FlutterMethodNotImplemented)
            return
        }
      })
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    override func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        channel.invokeMethod("runMe", arguments: nil)
    }
    
}
