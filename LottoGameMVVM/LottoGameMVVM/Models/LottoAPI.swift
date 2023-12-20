//
//  LottoAPI.swift
//  LottoGameMVVM
//
//  Created by 유성열 on 12/20/23.
//

import UIKit

// MARK: - 로또 API 모델

// 서버에서 주는 데이터 형태(로또 API)
struct LottoAPI: Codable {
    let drawDate: String // 발표 날짜
    let firstWinMoney: Int // 1등 1개당 당첨금
    let firstTicketCount: Int // 1등 당첨 복권수
    let drwtNo1, drwtNo2, drwtNo3, drwtNo4, drwtNo5, drwtNo6, bnusNo: Int // 1~6번호+보너스번호
    let drawNo: Int // 회차
    
    // CodingKey 사용 -> 서버에서 주는 데이터형태의 이름을 가지고 있어야 하기 때문에 데이터 이름을 변경하고 싶다면 위에서 변경 후 아래 CodingKey를 열거형에서
    // 채택하여 원시값으로 서버에서 내려주는 데이터 이름을 사용해서 지정해줘야 함.
    enum CodingKeys: String, CodingKey {
        case drawDate = "drwNoDate"
        case firstWinMoney = "firstWinamnt"
        case firstTicketCount = "firstPrzwnerCo"
        case drwtNo1, drwtNo2, drwtNo3, drwtNo4, drwtNo5, drwtNo6, bnusNo
        case drawNo = "drwNo"
    }
}

// 직접 설정한 데이터형태(앱에서 실제 사용 위함)
// 데이터 타입 변경 및 배열 설정을 위해서 사용
struct LottoInfo {
    // 위의 서버에서 주는 데이터 형태에서 속성들 옵셔널 처리 대신 직접 만든 구조체에서 선언함
    let drawDate: String? // 발표 날짜
    let drawNo: String? // 회차
    let firstWinMoney: String? // 1등 1개당 당첨금
    let firstTicketsCount: String? // 1등 당첨 복권수
    let numbers: [Int]? // 배열로 받아옴
    let bnusNum: Int? // 보너스 번호

    init(drawData: String, drwNo: Int, firstWinMoney: String, firstTicketsCount: Int, numbers: [Int], bnusNum: Int) {
        self.drawDate = drawData
        self.drawNo = String(drwNo) // (당첨회차) 정수->문자열 변환
        self.firstWinMoney = firstWinMoney
        self.firstTicketsCount = String(firstTicketsCount) // (당첨복권수)정수->문자열 변환
        self.numbers = numbers // 배열로 생성
        self.bnusNum = bnusNum
    }
}
    
    
    
    

