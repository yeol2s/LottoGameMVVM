//
//  QRcodeReaderViewController.swift
//  LottoGameMVVM
//
//  Created by 유성열 on 12/22/23.
//

import UIKit

// MARK: - QRCode 뷰 컨트롤러

final class QRcodeReaderViewController: UIViewController {
    
    // MARK: - 뷰 컨트롤러 속성
    
    private var viewModel: QRCodeReaderViewModel = QRCodeReaderViewModel()
    
    private var readerView: ReaderView!
    
    lazy var stopButton: UIButton = {
        let button = UIButton()
        button.setTitle("종료", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(qrCancelButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - 뷰 컨트롤러 생명주기 메서드

    override func viewDidLoad() {
        super.viewDidLoad()
        setupReaderView() // 리더뷰 호출 및 하위뷰 추가
        
    }
    
    // 뷰가 스크린에 나타나기 전(뷰가 화면에 나타날때마다 계속 호출)
    // 다른 화면에 갔다올때마다 리더뷰를 다시 시작하기 위해(큐알 재실행)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true // 탭바 숨기기
        
    }
    
    // 뷰가 사라지기 전
    // addSubView 메서드로 하위뷰를 추가할때는 상위뷰컨트롤러의 뷰컨트롤러 생명주기 메서드가 호출되지 않는다.(해당 뷰컨트롤러의 상태가 변경되는 것이 아니기 때문에)
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false // 탭바 보여주기
        
    }
    
    // MARK: - 뷰 설정 및 오토레이아웃

    private func setupReaderView() {
        readerView = viewModel.getReaderView(frame: view.bounds) // 뷰모델의 리더뷰 인스턴스와 동일한 주소를 참조전달 받음(뷰모델까지 가리키는 인스턴스가 생성되서 전달됨)
        view.addSubview(readerView)
    }
    
    // QR 코드 종료 버튼 오토레이아웃
    private func buttonConstraints() {
        view.addSubview(stopButton) // 뷰위에 종료버튼을 올린다.
        NSLayoutConstraint.activate([
            stopButton.widthAnchor.constraint(equalToConstant: 100),
            stopButton.heightAnchor.constraint(equalToConstant: 40),
            stopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stopButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - 뷰 Input 관련 메서드(내부로직 포함)
    
    // QR코드 종료버튼 눌렀을때
    @objc private func qrCancelButtonTapped() {
        dismiss(animated: true)
    }
    
    // 뷰모델과 바인딩(클로저로 ReaderStatus 값이 변경될때 호출될 클로저를 Observable클로저에 넣어줌)
    private func setupViewBind() {
        viewModel.readerStatus.subscribe { readerStatus in
            switch readerStatus {
            case .sucess(let code):
                if let code = code {
                    
                } else {
                    
                }
            case .fail:
                break
            case .stop:
                break
            }
        }
    }
    
    

}
