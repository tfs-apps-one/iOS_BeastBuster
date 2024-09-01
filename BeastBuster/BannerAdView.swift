//
//  BannerAdView.swift
//  BeastBuster
//
//  Created by 古川貴史 on 2024/08/31.
//

import SwiftUI
import GoogleMobileAds

struct BannerAdView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = UIViewController()
        let banner = GADBannerView(adSize: GADAdSizeBanner)
        
        banner.adUnitID = "ca-app-pub-4924620089567925/8525709588"  // ここにあなたの広告ユニットIDを入れます
        banner.rootViewController = viewController
        
        viewController.view.addSubview(banner)
        
        banner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            banner.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            banner.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor)
        ])
        
        banner.load(GADRequest())
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

