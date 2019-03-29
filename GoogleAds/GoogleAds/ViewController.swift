//
//  ViewController.swift
//  GoogleAds
//
//  Copyright © 2019 Ssky. All rights reserved.
//

import UIKit
import GoogleInteractiveMediaAds

class ViewController: UIViewController {

    var adTagUrl = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ct%3Dlinear&correlator="
    var adsLoader: IMAAdsLoader!
    var contentPlayhead: IMAAVPlayerContentPlayhead!
    var adsManager: IMAAdsManager!
    var adTimer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
        
        requestAd()
    }

//    MARK: 广告请求
    func requestAd() {
        
        self.adsLoader = IMAAdsLoader(settings: nil)
        self.adsLoader.delegate = self
        
        let adDisplayContainer = IMAAdDisplayContainer(adContainer: self.view, companionSlots: nil)
        let request = IMAAdsRequest(
            adTagUrl: self.adTagUrl,
            adDisplayContainer: adDisplayContainer,
            contentPlayhead: self.contentPlayhead,
            userContext: nil)
        
        self.adsLoader.requestAds(with: request)
        
    }
    
    func openTimer() {
        closeTimer()
        adTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(resumeADS), userInfo: nil, repeats: true)
        RunLoop.current.add(adTimer, forMode: .common)
    }
    
    @objc func closeTimer() {
        if adTimer != nil {
            adTimer.invalidate()
            adTimer = nil
        }
    }
    
    @objc func resumeADS() {
        if adsManager != nil {
            adsManager.resume()
        }
    }
    
    deinit {
        closeTimer()
    }
}

//    MARK: IMAAdsLoaderDelegate - 广告代理
extension ViewController: IMAAdsLoaderDelegate {
    
    func adsLoader(_ loader: IMAAdsLoader!, adsLoadedWith adsLoadedData: IMAAdsLoadedData!) {
        
        self.adsManager = adsLoadedData.adsManager
        self.adsManager.delegate = self
        
        let adsRenderingSettings = IMAAdsRenderingSettings()
        
        self.adsManager.initialize(with: adsRenderingSettings)
        
    }
    
    func adsLoader(_ loader: IMAAdsLoader!, failedWith adErrorData: IMAAdLoadingErrorData!) {
        
    }
}

extension ViewController: IMAAdsManagerDelegate {
    
    
    func adsManager(_ adsManager: IMAAdsManager!, didReceive event: IMAAdEvent!) {
        
        if event.type == IMAAdEventType.LOADED {
            self.adsManager.start()
            openTimer()
        } else if event.type == IMAAdEventType.COMPLETE {
            
        } else if event.type == IMAAdEventType.SKIPPED {
            
        } else if event.type == IMAAdEventType.RESUME {
            
        } else if event.type == IMAAdEventType.LOG {
            
        }
        
    }
    
    func adsManager(_ adsManager: IMAAdsManager!, didReceive error: IMAAdError!) {
        
        
    }
    
    func adsManagerDidRequestContentPause(_ adsManager: IMAAdsManager!) {
        
    }
    
    func adsManagerDidRequestContentResume(_ adsManager: IMAAdsManager!) {
        
    }
}
