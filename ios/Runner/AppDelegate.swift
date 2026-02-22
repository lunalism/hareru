import Flutter
import UIKit
import WidgetKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    let controller = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "app.hareru.ios/widget", binaryMessenger: controller.binaryMessenger)

    channel.setMethodCallHandler { (call, result) in
      switch call.method {
      case "saveWidgetData":
        guard let args = call.arguments as? [String: Any],
              let id = args["id"] as? String,
              let data = args["data"] else {
          result(FlutterError(code: "INVALID_ARGS", message: "Missing id or data", details: nil))
          return
        }
        let defaults = UserDefaults(suiteName: "group.com.lunalism.hareru")
        defaults?.set(data, forKey: id)
        result(nil)

      case "updateWidget":
        if #available(iOS 14.0, *) {
          WidgetCenter.shared.reloadAllTimelines()
        }
        result(nil)

      default:
        result(FlutterMethodNotImplemented)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
