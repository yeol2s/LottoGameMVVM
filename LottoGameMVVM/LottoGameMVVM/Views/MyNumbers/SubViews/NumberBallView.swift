//
//  NumberBallView.swift
//  LottoGameMVVM
//
//  Created by 유성열 on 12/19/23.
//

import UIKit

// MARK: - 번호 저장 화면에서 사용되는 뷰(컬렉션뷰에서 단일 번호 공 모양으로 변환)

// 단일 번호 공 모양으로 변환(컬렉션뷰에서 사용위해)
final class NumberBallView: UILabel {
    
    func displayNumber(_ number: Int) {
        
        let ballDiameter: CGFloat = 40 // 공의 지름
        let ballRadius: CGFloat = ballDiameter / 2 // 공의 반지름
        
        self.text = "\(number)"
        self.textAlignment = .center
        self.layer.cornerRadius = ballRadius
        self.layer.masksToBounds = true
        self.font = UIFont.boldSystemFont(ofSize: 16)
        self.textColor = .white
        self.widthAnchor.constraint(equalToConstant: ballDiameter).isActive = true
        self.heightAnchor.constraint(equalToConstant: ballDiameter).isActive = true
        
        // 번호 단위별 컬러 설정
        switch number {
        case 1...9:
            self.backgroundColor = UIColor.systemPink
        case 10...19:
            self.backgroundColor = UIColor.systemOrange
        case 20...29:
            self.backgroundColor = UIColor.systemBrown
        case 30...39:
            self.backgroundColor = UIColor.systemIndigo
        case 40...45:
            self.backgroundColor = UIColor.systemGreen
        default:
            self.backgroundColor = UIColor.white
        }
    }
}
