//
//  SceneDelegate.swift
//  EUerayher-SwiftUI
//
//  Created by ALi on 2019. 12. 25..
//  Copyright © 2019. ALi. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            if Config.buildConfiguration == Config.unitTestConfig {
                window.rootViewController = UIHostingController(rootView: Text("Unit tests are running...").font(.title))
            } else {
                window.rootViewController = UIHostingController(rootView: CurrentWeatherView(viewModel: CurrentWeatherViewModel()))
            }
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}

