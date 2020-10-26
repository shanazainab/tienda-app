import UIKit
import Flutter
import GoogleMaps
import flutter_downloader


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      GMSServices.provideAPIKey("AIzaSyDBMARSuk2l-TxaUBlHY3m5RVb7bN2C08c")




    GeneratedPluginRegistrant.register(with: self)

    
    FlutterDownloaderPlugin.setPluginRegistrantCallback { registry in
            if (!registry.hasPlugin("FlutterDownloaderPlugin")) {
               FlutterDownloaderPlugin.register(with: registry.registrar(forPlugin: "FlutterDownloaderPlugin")!)
            }
    }
    
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    
 
}



