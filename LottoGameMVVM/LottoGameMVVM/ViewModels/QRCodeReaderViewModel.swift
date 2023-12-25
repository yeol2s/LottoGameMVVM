//
//  QRCodeReaderViewModel.swift
//  LottoGameMVVM
//
//  Created by 유성열 on 12/22/23.
//

import Foundation

// MARK: - (타입애일리어스)네임드 튜플 타입 정의(QR Alert)
// Alert 상태 전달하기 위한 네임드튜플타입(message는 인식 성공의 경우 성공 메세지와, URL 주소 전달)
typealias QRAlertStatusTuple = (title: String, message: [String], cancelButtonUse: Bool)

// MARK: - QRCode Reader 뷰 뷰모델

final class QRCodeReaderViewModel {
    
    // MARK: - 뷰 모델 속성
    
    // (바인딩)(QR Code)ReaderStatus(모델) 열거형을 Observable클래스로 감싸서 인스턴스 생성
    // 일단 .sucess(nil) 상태로 열거형 생성
    var readerStatus: Observable<ReaderStatus> = Observable(ReaderStatus.sucess(nil))
    
    private var readerView: ReaderView! // 암시적 언래핑(IUO)
    
    // 뷰 Alert 이벤트 발생시 메시지 업데이트(타입애일리어스 네임드튜플 타입)(title-message-cancelbutton)
    private var alertSet: QRAlertStatusTuple? {
        didSet { // 속성감시자 설정(Alert 메세지가 변경되면 클로저 호출)
            if let alertSet = alertSet {
                showAlertClosure?((alertSet.title, alertSet.message, alertSet.cancelButtonUse)) // 클로저에 네임드튜플 타이플,메세지,버튼 값 전달
            }
        }
    }
    
    var showAlertClosure: ((QRAlertStatusTuple) -> Void)? // Alert 클로저 선언(뷰에서 할당)
    
    // MARK: - Output
    
    func getReaderView(frame: CGRect) -> ReaderView {
        self.readerView = ReaderView(frame: frame, viewModel: self) // 리더뷰 인스턴스 생성과 함께 뷰모델을 전달(커스텀 생성자)
        return readerView // 생성된 리더뷰 인스턴스의 주소값 전달되는 것
    }
    
    // MARK: - Input
    
    // 리더뷰로 부터 ReaderStatus 열거형 값을 전달받아서 Observable클래스의 속성감시자 값을 변경해줌
    func setReaderStatus(_ status: ReaderStatus) {
        self.readerStatus.value = status
    }
    
    // 리더뷰컨으로 부터 캡처세션 재시작 요청 받고 상황에 따른 처리
    func setCaptureSessionRetry() {
        if readerView.isRunning { // 캡처세션 실행중이라면
            readerView.stop() // 중지
        } else { // 캡처세션 중지상태라면
            readerView.start() // 캡처세션 시작
        }
    }
    
//    // 캡처 세션 중지
//    func setCaptureSessionStop() {
//        readerView.captureSession?.stopRunning()
//    }
    
    // MARK: Alert
    // 리더뷰로 부터 alertSet 값이 변경되면 속성감시자가 실행되면서 클로저 호출
    // message는 QR Code가 인식 성공인 경우에는 완료 메세지와 성공 code(URL 주소)가 담겨야함
    func alertPerformAction(title: String, message: String..., cancelButtonUse: Bool) {
        alertSet = (title, message, cancelButtonUse)
    }
}

