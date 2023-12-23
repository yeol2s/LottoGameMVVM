//
//  QRCodeReaderViewModel.swift
//  LottoGameMVVM
//
//  Created by 유성열 on 12/22/23.
//

import Foundation

// ⚠️ 일단 보류
//// MARK: - 델리게이트 프로토콜
//
//protocol ReaderViewDelegate: AnyObject {
//    func rederComplete(status: ReaderStatus) // 열거형 status를 가지고 함수 호출
//}


// MARK: - QRCode Reader 뷰 뷰모델

final class QRCodeReaderViewModel {
    
    // MARK: - 뷰 모델 속성
    
    // (바인딩)(QR Code)ReaderStatus(모델) 열거형을 Observable클래스로 감싸서 인스턴스 생성
    // 일단 .sucess(nil) 상태로 열거형 생성
    var readerStatus: Observable<ReaderStatus> = Observable(ReaderStatus.sucess(nil))
    
    var readerView: ReaderView! // 암시적 언래핑(IUO)
    
    // MARK: - Output
    
    func getReaderView(frame: CGRect) -> ReaderView {
        readerView = ReaderView(frame: frame)
        return readerView // 생성된 리더뷰 인스턴스의 주소값 전달되는 것
    }

    
    
    
}

