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
        setupViewBind() // 뷰모델 바인딩 설정(Observable)
        setupViewModelAlert() // 뷰모델 Alert 설정(클로저 할당)
    }
    
    // 뷰가 스크린에 나타나기 전(뷰가 화면에 나타날때마다 계속 호출)
    // 다른 화면에 갔다올때마다 리더뷰를 다시 시작하기 위해(큐알 재실행)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true // 탭바 숨기기
        
        // 뷰가 다시 켜질때마다 셋업하기 위해
        setupReaderView() // 리더뷰 호출 및 하위뷰 추가
        buttonConstraints() // 버튼 오토레이아웃
    }
    
    // 뷰가 사라지기 전
    // addSubView 메서드로 하위뷰를 추가할때는 상위뷰컨트롤러의 뷰컨트롤러 생명주기 메서드가 호출되지 않는다.(해당 뷰컨트롤러의 상태가 변경되는 것이 아니기 때문에)
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false // 탭바 보여주기
        
        if readerView.isRunning { // 뷰가 사라질때 캡처세션이 실행중이라면
            print("viewWillDisappear:캡처세션 종료")
            readerView.stop() // 캡처세션 종료
        }
    }
    
    // MARK: - 뷰 설정 및 오토레이아웃

    private func setupReaderView() {
        print("호출됐다")
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
    
    // 뷰모델 Alert 클로저 할당
    private func setupViewModelAlert() {
        viewModel.showAlertClosure = { [weak self] status in
            self?.showAlert(title: status.title, message: status.message, cancelButtonUse: status.cancelButtonUse)
        }
    }
    
    // (바인딩)뷰모델과 바인딩(클로저로 ReaderStatus 값이 변경될때 호출될 클로저를 Observable클로저에 넣어줌)
    private func setupViewBind() {
        viewModel.readerStatus.subscribe { [weak self] readerStatus in
            switch readerStatus {
            case .sucess(let code):
                if let code = code {
                    self?.viewModel.alertPerformAction(title: "인식 성공", message: "사이트에 연결합니다.", code, cancelButtonUse: true)
                    // 성공시에도 리더뷰에서 메타데이터 처리하는 과정에서 마지막에 stop() 메서드가 실행되면서 ReaderStatus가 stop으로 변경되면서 캡처세션 중지됨(고로 따로 중지메서드 적용안함)
                } else {
                    fallthrough // code 못불러올시 다음블럭 실행
                }
            case .fail:
                self?.viewModel.alertPerformAction(title: "인식 실패", message: "인식에 실패했습니다.", cancelButtonUse: false)
                self?.captureSessionRetry() // 캡처세션 재시작
            case .stop:
                // ⚠️ 중지에 대한 처리는 일단 보류(인식 성공 후에 데이터처리 후 stop이 실행됨)
                // ❓❓❓ 어떻게 처리하는게 효율적일까.
                break
            }
        }
    }
    
    // Alert 메서드
    private func showAlert(title: String, message: [String], cancelButtonUse: Bool ) {
        
        let alert = UIAlertController(title: title, message: message[0], preferredStyle: .alert)
        if cancelButtonUse { // '취소' 버튼 사용(Dual)
            let okAction = UIAlertAction(title: "확인", style: .default) { _ in
                if title == "인식 성공" {
                    self.alertHandlerAction(title: title, message: message[1]) // 핸들러 처리
                }
            }
            let cancelAction = UIAlertAction(title: "취소", style: .default) { _ in
                self.captureSessionRetry() // 캡처세션 재시작
            }
            alert.addAction(okAction)
            alert.addAction(cancelAction)
        } else { // '확인' 버튼만 사용(Single)
            let okAction = UIAlertAction(title: "확인", style: .default)
            alert.addAction(okAction)
        }
        present(alert, animated: true)
    }
    
    // Alert 핸들러 메서드
    private func alertHandlerAction(title status: String, message: String) {
        
        switch status {
        case "인식 성공":
            if let url = URL(string: message) {
                UIApplication.shared.open(url) // 동행복권 웹사이트 연결
            } else {
                captureSessionRetry() // 캡처세션 재시작
            }
        default:
            break
        }
    }
    
    // 뷰모델에게 캡처세션 재시작 요청
    private func captureSessionRetry() {
        viewModel.setCaptureSessionRetry()
    }

}
