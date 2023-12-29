//
//  MenuViewController.swift
//  LottoGameMVVM
//
//  Created by 유성열 on 12/14/23.
//

import UIKit

// MARK: - 메뉴 델리게이트 프로토콜(컨테이너뷰컨과 통신을 위한 프로토콜)

protocol MenuViewControllerDelegate: AnyObject { // AnyObject는 모든 클래스타입
    func didSelect(menuItem: MenuViewController.MenuOptions)
}

// MARK: - 메뉴 뷰컨트롤러

final class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - 메뉴 뷰컨트롤러 속성

    weak var delegate: MenuViewControllerDelegate?
    
    // 메뉴에 표시할 열거형(CaseIterable 채택 -> allCases 사용 가능해짐(모든 케이스를 나열한 배열을 리턴))
    enum MenuOptions: String, CaseIterable {
        case home = "메인 화면"
        case info = "최근 회차 당첨정보"
        case qrCode = "QR Code"
        
        // 열거형 내부에 get 계산속성 구현(해당하는 case에 이미지 이름을 리턴해서 SF 기호 이름을 리턴시킴)
        // 계산속성은 실질적으로 메서드이다! 잊지말자
        var imageName: String {
            switch self {
            case .home:
                return "house"
            case .info:
                return "info.bubble"
            case .qrCode:
                return "qrcode"
            }
        }
    }
    
    // 기본 테이블뷰를 만듦
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = nil
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell") // 셀을 직접 만들지 않고 기본 제공되는 UITableViewCell
        return tableView
    }()
    
    // 뷰와 테이블뷰셀 색상을 동일하게 변수로 색상 설정
    let cerBlueColor = UIColor(red: 0.25, green: 0.47, blue: 0.60, alpha: 1.00)
    
    // MARK: - 뷰 생명주기 메서드
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        view.backgroundColor = cerBlueColor
    }
    
    // 테이블뷰 프레임 설정(뷰컨트롤러와 관련된 뷰의 레이아웃이 업데이트 된 후 호출)(뷰의 레이아웃이 업데이트된 직후에 호출되므로 뷰의 크기, 위치, 계층 구조가 최종적으로 설정된 후에 실행)(뷰의 최종 레이아웃을 기반으로 사용자 정의 레이아웃)
    override func viewDidLayoutSubviews() {
        tableView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.bounds.size.width, height: view.bounds.size.height)
    }
    
    // MARK: - 테이블뷰 메서드
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOptions.allCases.count // 모든 메뉴 만큼
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = MenuOptions.allCases[indexPath.row].rawValue // 모든메뉴 기준으로 rawValue(원시값)를 가져옴
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = .boldSystemFont(ofSize: 18)
        cell.imageView?.image = UIImage(systemName: MenuOptions.allCases[indexPath.row].imageName) // UIImage로 설정하는데 메뉴 열거형에서 올케이스에서 계산속성을 사용해서 인덱스 기준 이미지 네임 스위칭해서 래핑(SF기호)
        cell.imageView?.tintColor = .white
        cell.backgroundColor = cerBlueColor // 테이블뷰 셀 백그라운드 설정
        cell.contentView.backgroundColor = cerBlueColor // 셀 내용 뷰의 배경색을 설정)
        cell.selectionStyle = .gray
        
        return cell
    }
    
    // 선택적 메서드(UITableViewDelegate)
    // 사용자가 테이블뷰의 특정 행을 선택할때 호출되는 메서드
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // 선택한 행의 선택 상태를 해제(선택 취소)(선택했을때 해당 행이 선택된 상태로 남아있지 않도록)
        let item = MenuOptions.allCases[indexPath.row] // 선택된 메뉴를 뽑아서 아이템에 넣고
        delegate?.didSelect(menuItem: item) // 델리게이트 메서드에 전달(델리게이트 대리자만 함수 호출이 가능)(특정 셀이 선택되었을때)
    }
}
