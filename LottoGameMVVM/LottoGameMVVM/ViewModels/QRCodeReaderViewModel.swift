//
//  QRCodeReaderViewModel.swift
//  LottoGameMVVM
//
//  Created by 유성열 on 12/22/23.
//

import Foundation

// MARK: - QRCode Reader 뷰 뷰모델

final class QRCodeReaderViewModel {
    
    // MARK: - 뷰 모델 속성
    
    // (바인딩)(QR Code)ReaderStatus(모델) 열거형을 Observable클래스로 감싸서 인스턴스 생성
    // 일단 .sucess(nil) 상태로 열거형 생성
    var readerStatus: Observable<ReaderStatus> = Observable(ReaderStatus.sucess(nil))
    
    private var readerView: ReaderView! // 암시적 언래핑(IUO)
    
    // MARK: - Output
    
    func getReaderView(frame: CGRect) -> ReaderView {
        readerView = ReaderView(frame: frame, viewModel: self) // 리더뷰 인스턴스 생성과 함께 뷰모델을 전달(커스텀 생성자)
        return readerView // 생성된 리더뷰 인스턴스의 주소값 전달되는 것
    }
    
    // MARK: - Input
    
    // 리더뷰로 부터 ReaderStatus 열거형 값을 전달받아서 Observable클래스의 속성감시자 값을 변경해줌
    func setReaderStatus(_ status: ReaderStatus) {
        self.readerStatus.value = status
    }


    
    
    
}

