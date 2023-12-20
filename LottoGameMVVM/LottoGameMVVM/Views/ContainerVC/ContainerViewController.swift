////
////  ViewController.swift
////  LottoGameMVVM
////
////  Created by 유성열 on 12/14/23.
////
//
//
//import UIKit
//
//// MARK: - 사이드바 메뉴를 위한 컨테이너 뷰컨트롤러 (뷰모델없이 구현)
//// ❓❓❓ MVVM 패턴에서 컨테이너뷰컨, 메뉴뷰컨 정도는 뷰모델 없이 지금 처럼 그냥 뷰컨 내부에 다 때려박아도 괜찮을까?
//final class ContainerViewController: UIViewController {
//    
//    // 현재의 메뉴가 열려있는지 닫혀있는지 열거형 선언
//    enum MenuState {
//        case opend
//        case closed
//    }
//    
//    private var menuState: MenuState = .closed // 닫혀있는 상태의 (열거형)메뉴 인스턴스 생성
//    
//    // 뷰컨트롤러들 인스턴스 생성
//    let menuVC = MenuViewController() // 메뉴뷰컨트롤러
//    let mainVC = NumberGenerateViewContoller() // 메인뷰컨트롤러(번호 생성화면)
//    var navVC = UINavigationController? // 네비게이션컨트롤러 인스턴스 생성(메인뷰컨은 컨테이너뷰컨에서 root 시키기 위함)
//    lazy var apiVC = LottoAPIViewController() // APIViewController(API 접속시 사용을 위해 지연저장속성)
//    lazy var qrVC = QRCodeReaderViewController() // QRCodeViewController(QR 사용시 사용을 위해 지연저장속성)
//    
//    override func viewDidLoad() {
//        view.backgroundColor = .systemGray
//        addChildVCs()
//    }
//    
//    // 메인뷰컨트롤러, 메뉴뷰컨트롤러 하위뷰로 추가하는 메서드
//    private func addChildVCs() {
//        // 메뉴뷰컨트롤러
//        menuVC.delegate = self
//        addChild(menuVC) // 자식뷰컨트롤러로 menuVC를 추가(첫번째 단계로서 계층구조에 포함시킴 - 화면에 나타나진 않음)
//        view.addSubview(menuVC) // 자식뷰로 menuVC 뷰를 추가(두번째 단계로서 - 화면에 나타남)
//        menuVC.didMove(toParent: self) // 자식뷰컨이 부모뷰컨에 성공적으로 추가될때 호출(세번째 단계 - 부모<->자식 상호작용 및 화면전환 가능-생명주기)
//        
//        // 메인뷰컨트롤러
//        mainVC.delegate = self
//        let navVC = UINavigationController(rootViewController: mainVC)
//        addChild(navVC)
//        view.addSubview(navVC.view) // 순서대로 메뉴뷰위에 올라간다.
//        navVC.didMove(toParent: self)
//        self.navVC = navVC
//    }
//}
//
//// 메인뷰컨트롤러 델리게이트 확장 구현
//extension ContainerViewController: NumberGenerateViewContoller {
//    
//}
//
//// 메뉴뷰컨트롤러 델리게이트 확장 구현
//extension ContainerViewController: MenuViewController {
//    
//}
