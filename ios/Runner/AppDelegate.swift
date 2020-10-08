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



    //Platform code for CUSTOMER CARE ZENDESK
  //  let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
//    let zendeskChannel = FlutterMethodChannel(name: "tienda.dev/zendesk",
//                                              binaryMessenger: controller.binaryMessenger)
    
    
    //initialize zendesk SDK with credentials
//    Zendesk.initialize(appId: "82b091c3bfcf42fe91be469929c862edf6e41960aa28c25e", clientId: "mobile_sdk_client_ab97cd0b47875959102b", zendeskUrl: "https://tiendabeuniquegroup.zendesk.com")
//    Support.initialize(withZendesk: Zendesk.instance)
//    AnswerBot.initialize(withZendesk: Zendesk.instance, support: Support.instance!)
  //  Chat.initialize(accountKey: "TkPrZmaVkTcwDxSmVJVLfAbao79XxaB4")
    //zendesk set user identity
//    let identity = Identity.createAnonymous()
//    Zendesk.instance?.setIdentity(identity)

    
//    zendeskChannel.setMethodCallHandler({
//      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
//       guard call.method == "getChat" else {
//         result(FlutterMethodNotImplemented)
//         return
//       }
//       self.startZendeskChat(result: result)
//    })


    GeneratedPluginRegistrant.register(with: self)

    
    FlutterDownloaderPlugin.setPluginRegistrantCallback { registry in
            if (!registry.hasPlugin("FlutterDownloaderPlugin")) {
               FlutterDownloaderPlugin.register(with: registry.registrar(forPlugin: "FlutterDownloaderPlugin")!)
            }
    }
    
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
 
    
//    private func startZendeskChat(result: FlutterResult) {
//
//        do {
//
//          let messagingConfiguration = MessagingConfiguration()
//            let answerBotEngine = try AnswerBotEngine.engine()
//            let supportEngine = try SupportEngine.engine()
//            let chatEngine = try ChatEngine.engine()
//            let viewController = try Messaging.instance.buildUI(engines: [answerBotEngine, chatEngine, supportEngine],
//                                                    configs: [messagingConfiguration])
//
//
//
//    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
//
//           controller.present(viewController,animated: true)
//
//
//        } catch  let error {
//             result(FlutterError(code: "CHAT SYSTEM FAILED",
//                                 message: error.localizedDescription,
//                                    details: nil))
//        }
//
//      result("success")
//    }
}



