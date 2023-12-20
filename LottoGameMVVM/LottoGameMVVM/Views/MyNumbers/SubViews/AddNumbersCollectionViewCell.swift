//
//  AddNumbersCollectionViewCell.swift
//  LottoGameMVVM
//
//  Created by 유성열 on 12/19/23.
//

import UIKit

// MARK: - (번호 저장 화면)직접 번호 추가 화면('내 번호'화면의 네비바 + 버튼)

// 저장 번호 직접 추가하는 컬렉션뷰셀
final class AddNumbersCollectionViewCell: UICollectionViewCell {
    
    // MARK: - 컬렉션뷰 속성
    
    private let numberBallView: NumberBallView = NumberBallView() // (단일 번호)공 모양 변환 인스턴스 생성
    
    
    // MARK: - 컬렉션뷰 생성자(오토레이아웃)
    
    // 코드로 작성해서 생성자로 오토레이아웃
    // frame: CGRect을 사용하는 이유는 해당 셀의 초기 프레임을 설정하기 위함(셀이 화면에 표시될 때 초기 위치와 크기를 정함)
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUIConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 컬렉션뷰 셀 설정 및 오토레이아웃

    // 번호 나열하는 레이블 오토레이아웃
    private func setupUIConstraints() {
        self.contentView.addSubview(numberBallView) // 레이블을 셀 하위뷰로 추가
        numberBallView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            numberBallView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            numberBallView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
    
    // MARK: - Input & Output
    
    func configure(_ number: Int) {
        numberBallView.displayNumber(number) // 공 모양으로 변환
    }
    
}

