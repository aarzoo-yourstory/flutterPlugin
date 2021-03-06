import UIKit
import Flutter
import youtube_ios_player_helper

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        JWPlayerController.setPlayerKey("mswNqzMr9cCVFx//SDGryIaWA/bfgCnRvZPfU2y9LZXxEIls")
        
//        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
//        let batteryChannel = FlutterMethodChannel(name: "test.battery_level",
//                                                  binaryMessenger: controller.binaryMessenger)
//        batteryChannel.setMethodCallHandler({
//            [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
//            // Note: this method is invoked on the UI thread.
//            if (call.method == "getBatteryLevel") {
//                self?.receiveBatteryLevel(result: result)
//            }
//            else if (call.method == "showVideo"){
//
////                if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
////                    navigationController.pushViewController(VideoPlayerViewController(), animated: true)
////                }
////
////                let storyboard : UIStoryboard? = UIStoryboard.init(name: "Main", bundle: nil);
////                let window: UIWindow = ((UIApplication.shared.delegate?.window)!)!
////
////                let objVC: UIViewController? = storyboard!.instantiateViewController(withIdentifier: "WebinarDetailViewController")
////                let aObjNavi = UINavigationController(rootViewController: objVC!)
////                window.rootViewController = aObjNavi
////                aObjNavi.pushViewController(VideoPlayerViewController(), animated: true)
//            }
//            else if (call.method == "stopVideo"){
//
//            }
//            else{
//                result(FlutterMethodNotImplemented)
//            }
//
//        })
        
        GeneratedPluginRegistrant.register(with: self)
        let viewFactory = VideoViewFactory()
        registrar(forPlugin: "Video").register(viewFactory, withId: "CustomVideoPlayer")
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func receiveBatteryLevel(result: FlutterResult) {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        if device.batteryState == UIDevice.BatteryState.unknown {
            result(FlutterError(code: "UNAVAILABLE",
                                message: "Battery info unavailable",
                                details: nil))
        } else {
            result(Int(device.batteryLevel * 100))
        }
    }
    
}

class VideoViewFactory: NSObject, FlutterPlatformViewFactory{
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return CustomVideoPlayer(frame: frame, viewId: viewId, argd: args)
    }
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
    
}

class CustomVideoPlayer: NSObject, FlutterPlatformView{
    
    let controller : FlutterViewController = ((UIApplication.shared.delegate?.window)!)!.rootViewController as! FlutterViewController
    let channel : FlutterMethodChannel
    var playerView: VideoView
    
    init(frame: CGRect, viewId: Int64, argd: Any?) {
        
        playerView = VideoView(frame: frame, viewId: viewId, argd: argd)
        channel = FlutterMethodChannel(name: "com.yourstory.videoplayer", binaryMessenger: controller.binaryMessenger)
        super.init()
        channel.setMethodCallHandler({[weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
            // Note: this method is invoked on the UI thread.
            switch call.method{
            case "loadYT":
                self?.playerView.loadYoutubeVedio()
            case "playYT":
                self?.playerView.playYT()
            case "stopYT":
                self?.playerView.pauseYT()
            case "loadJW":
                self?.playerView.loadJWVedio()
            case "playJW":
                self?.playerView.playJW()
            case "stopJW":
                self?.playerView.player?.pause()
            default:
                print("test default")
            }
        })
    }
    
    func view() -> UIView {
        return playerView.getVideoView()
    }
}

class VideoView: NSObject, YTPlayerViewDelegate{
    let frame: CGRect
    let viewID: Int64
    let videoID: String
    let videoPlatform: String
    
    let youtubeView =  YTPlayerView()
    var jwplayer = UIView()
    var player: JWPlayerController?
    
    init(frame: CGRect, viewId: Int64, argd: Any?) {
        self.frame = frame
        self.viewID = viewId
        jwplayer.backgroundColor = .black
        youtubeView.backgroundColor = .black
        if let argument = argd as? [String:String]{
            self.videoID = argument["videoid"] ?? ""
            self.videoPlatform = argument["platform"] ?? ""
        }
        else{
            self.videoID = ""
            self.videoPlatform = ""
        }
        jwplayer.backgroundColor = .black
    }
    
    //    func view() -> UIView {
    //        return loadVideo()
    //    }
    
    func getVideoView() -> UIView{
        switch self.videoPlatform{
        case "jwplayer":
            return jwplayer
        case "zoom":
            print("zoom")
        case "youtube":
            return youtubeView
        default://youtube TODO: for zoom too.
            print("")
        }
        return youtubeView
    }
    
    func loadVideo() -> UIView{
//        playJWVedio()
//        return jwplayer
        switch self.videoPlatform{
        case "jwplayer":
            youtubeView.isHidden = true
            loadJWVedio()
            return jwplayer
        case "zoom":
            print("zoom")
        case "youtube":
            loadYoutubeVedio()
            return youtubeView
        default://youtube TODO: for zoom too.
            print("")
        }
        return youtubeView
    }
    
    func loadJWVedio(){
        print("in play jwplayer link: \(self.videoID)")
//        for view in jwplayer.subviews{
//            jwplayer.willRemoveSubview(view)
//        }
        let config = JWConfig()
        config.file = self.videoID
        config.title = "title"
        config.displayTitle = true
        config.controls = true
        config.autostart = true
        self.player = JWPlayerController(config: config)
        if let pView = self.player?.view {
            let jwPlayerView: UIView = pView
//            jwPlayerView.tag = 999
//            jwPlayerView.frame = jwplayer.frame
            self.jwplayer = jwPlayerView//addSubview(jwPlayerView)
//            self.jwplayer.layer.name = "JWplayer"
        }
    }
    
    func loadYoutubeVedio(){
        let playerVars = ["playsinline": 1, "autoplay": 0, "controls": 1, "iv_load_policy": 3, "modestbranding" : 1]
        youtubeView.delegate = self
        youtubeView.load(withVideoId: self.videoID, playerVars: playerVars)
        youtubeView.tag = 999
        youtubeView.layer.name = "youtubePlayer"
//        youtubeView.playVideo()
    }
    
    func playYT() {
//        loadJWVedio()
        youtubeView.playVideo()
    }
    
    func pauseYT() {
        youtubeView.pauseVideo()
    }
    
    func stopYT(){
        youtubeView.stopVideo()
    }

    func playJW() {
//        loadJWVedio()
        player?.play()
    }
    
    func pauseJW() {
        player?.pause()
    }
    
    func stopJW(){
        player?.stop()
        
    }
}
