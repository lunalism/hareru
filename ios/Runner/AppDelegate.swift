import Flutter
import UIKit
import WidgetKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var deepLinkChannel: FlutterMethodChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    let controller = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "app.hareru.ios/widget", binaryMessenger: controller.binaryMessenger)
    deepLinkChannel = channel

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

    // Handle deep link from widget tap when app is cold-launched
    if let url = launchOptions?[.url] as? URL,
       url.scheme == "hareru" {
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        self.deepLinkChannel?.invokeMethod("onDeepLink", arguments: url.host ?? "home")
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
  ) -> Bool {
    if url.scheme == "hareru" {
      deepLinkChannel?.invokeMethod("onDeepLink", arguments: url.host ?? "home")
      return true
    }
    return super.application(app, open: url, options: options)
  }
}
