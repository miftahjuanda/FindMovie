//
//  SceneDelegate.swift
//  FindMovie
//
//  Created by Miftah Juanda Batubara on 24/02/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.backgroundColor = UIColor.white
        
        if let window = window {
            let navigationController = UINavigationController()
            navigationController.navigationBar.tintColor = .black
            window.rootViewController = UINavigationController(rootViewController: FindMovieViewController())
            
            window.overrideUserInterfaceStyle = .light
            window.windowScene = windowScene
            window.makeKeyAndVisible()
        }
    }
}

