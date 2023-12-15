//
//  NumberGen.swift
//  LottoGameMVVM
//
//  Created by 유성열 on 12/14/23.
//

import Foundation

// MARK: - 번호 데이터 모델

// 로또 번호 모델
struct NumbersGen {
    
    // 멤버와이즈 이니셜라이저 사용(기본값 및 생성자 미구현)
    let numbersList: [Int]
    
    // 번호 저장여부를 여기에 저장시킴(테이블뷰 셀 리로드시 불러오기 위해)
    var isSaved: Bool = false

}
