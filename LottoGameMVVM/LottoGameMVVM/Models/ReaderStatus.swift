//
//  ReaderStatus.swift
//  LottoGameMVVM
//
//  Created by 유성열 on 12/22/23.
//

// MARK: - QR코드 인식결과 뷰 모델


// 뷰컨트롤러에 리더뷰에서 QRCode 인식 성공, 실패에 대한 처리를 위해 status를 열거형으로 관리하고 델리게이트를 만들어줌
enum ReaderStatus {
    case sucess(_ code: String?) // 열거형 연관값
    case fail
    case stop
}

