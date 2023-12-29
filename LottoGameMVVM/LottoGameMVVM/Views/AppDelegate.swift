//
//  AppDelegate.swift
//  LottoGameMVVM
//
//  Created by 유성열 on 12/14/23.
//

import UIKit

@main
// 앱델리게이트는 앱의 생명주기를 관리(앱이 시작되거나, 종료될 때 발생하는 이벤트를 다룸)
class AppDelegate: UIResponder, UIApplicationDelegate {

    // 앱이 처음 실행될 때 호출되는 메서드(초기 설정 및 초기화 작업을 할 수 있음)
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        return true
    }

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

