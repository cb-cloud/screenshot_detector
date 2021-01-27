import Flutter
import UIKit

public class SwiftScreenshotDetectorPlugin: NSObject, FlutterPlugin {
    
    static var channel: FlutterMethodChannel?
    static var observer: NSObjectProtocol?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(name: "cb-cloud/screenshot_detector", binaryMessenger: registrar.messenger())
        observer = nil
        let instance = SwiftScreenshotDetectorPlugin()
        
        channel = methodChannel
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "initialize":
            removeScreenShotObserverIfNeeded()
            
            SwiftScreenshotDetectorPlugin.observer = NotificationCenter.default.addObserver(forName: UIApplication.userDidTakeScreenshotNotification, object: nil, queue: .main) { notification in
                
                if let channel = SwiftScreenshotDetectorPlugin.channel {
                    channel.invokeMethod("onCallback", arguments: nil)
                }
            }
            result("initialize")
        case "activate":
            result("activate")
            
        case "inactivate":
            result("inactivate")
            
        case "dispose":
            removeScreenShotObserverIfNeeded()
            result("dispose")
            
        default:
            result("")
        }
    }
    
    
    private func removeScreenShotObserverIfNeeded() {
        if (SwiftScreenshotDetectorPlugin.observer != nil) {
            NotificationCenter.default.removeObserver(SwiftScreenshotDetectorPlugin.observer!)
            SwiftScreenshotDetectorPlugin.observer = nil;
        }
    }
    
    deinit {
        removeScreenShotObserverIfNeeded()
    }
}
