//
//  AppDelegate.swift
//  FindParkingLot
//
//  Created by 김재동 on 2023/02/09.
//

import UIKit
import Firebase
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
    
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
//
//        let config = GIDConfiguration(clientID: clientID)
//        
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        let LoginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
//        GIDSignIn.sharedInstance.signIn(withPresenting: <#T##UIViewController#>)
//
//        if let error = error {
//            return
//        }
//
//        guard
//            let authentication = user?.authentication,
//            let idToken = authentication.idToken
//        else {
//            return
//        }
//
//        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
//
//        let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController")
//        mainViewController.modalPresentationStyle = .fullScreen
//        UIApplication.shared.windows.first?.rootViewController?.show(mainViewController, sender: nil)
//    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

