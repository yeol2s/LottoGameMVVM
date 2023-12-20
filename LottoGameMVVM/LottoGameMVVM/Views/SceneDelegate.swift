//
//  SceneDelegate.swift
//  LottoGameMVVM
//
//  Created by 유성열 on 12/14/23.
//

import UIKit
// 씬델리게이트는 다른 씬으로 넘어가거나, 그런 시점들을 파악하기 위한 대리자
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    // (앱의 생명주기) 특정 Scene 객체가 처음 생성되고 연결될 때 호출(초기화 및 설정 작업을 수행하기 적합한 시점)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let _ = (scene as? UIWindowScene) else { return }
        
        
        let tabBarVC = UITabBarController() // 탭바 컨트롤러 생성
        
        //let containerVC = ContainerViewController() // 컨테이너 뷰컨트롤러 인스턴스 생성
        // 테스트뷰컨
        let testVC = NumbersGenViewController()
        let secondVC = UINavigationController(rootViewController: MyNumbersViewController()) // '내 번호' 뷰컨트롤러 인스턴스 및 네비컨트롤러 생성
        
        //tabBarVC.setViewControllers([containerVC, secondVC], animated: false) // 탭바 설정
        tabBarVC.setViewControllers([testVC, secondVC], animated: false) // 테스트 설정
        tabBarVC.modalPresentationStyle = .fullScreen
        tabBarVC.tabBar.backgroundColor = .white
        //containerVC.tabBarItem = UITabBarItem(title: "메인 화면", image: UIImage(systemName: "house.fill"), selectedImage: nil)
        testVC.tabBarItem = UITabBarItem(title: "메인 화면", image: UIImage(systemName: "house.fill"), selectedImage: nil) // 테스트
        secondVC.tabBarItem = UITabBarItem(title: "내 번호", image: UIImage(systemName: "heart.fill"), selectedImage: nil)
    
        // 기본 rootView 탭바로 설정
        window?.rootViewController = tabBarVC // 탭바의 첫 화면은 '컨테이너 뷰컨트롤러'
        window?.makeKeyAndVisible() // 터치 이벤트 사용자 입력 활성화
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

