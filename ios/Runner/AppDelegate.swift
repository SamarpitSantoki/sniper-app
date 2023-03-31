import UIKit
import Flutter
import workmanager
import shared_preferences

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
 
    
    GeneratedPluginRegistrant.register(with: self)
    
    WorkmanagerPlugin.register(with: self.registrar(forPlugin: "be.tramckrijte.workmanager.WorkmanagerPlugin"))
    
    UNUserNotificationCenter.current().delegate = self

    UIApplication.shared.setMinimumBackgroundFetchInterval(TimeInterval(60*15))

    
    WorkmanagerPlugin.setPluginRegistrantCallback { registry in
        AppDelegate.registerPlugins(with: registry)
         FLTSharedPreferencesPlugin.register(with: registry.registrar(forPlugin: "io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin"))
        
       
           
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    static func registerPlugins(with registry: FlutterPluginRegistry) {
               GeneratedPluginRegistrant.register(with: registry)
          }
       
    override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
         completionHandler(.alert) 
     }
    
}
