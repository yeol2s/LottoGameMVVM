//
//  NumTableViewCell.swift
//  LottoGameMVVM
//
//  Created by 유성열 on 12/15/23.
//

import UIKit

// MARK: - 메인뷰컨트롤러 (번호생성)테이블뷰 셀

// (번호 생성 테이블뷰)테이블뷰 셀
class NumTableViewCell: UITableViewCell {
    
    // MARK: - 테이블뷰 셀 속성
    
    private let ballListView = NumberBallListView() // 번호 공 모양 만드는 객체 생성(UIStackView)
    
    // 숫자 출력 레이블(UIStackView로 공모양으로 받아와서 이 레이블에 addSubView)
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 5 // 코너 둥글게 처리
        label.clipsToBounds = true // 경계를 벗어나는 내용을 잘라내는 것(masksToBounds속성으로도 대체 가능)
        label.layer.borderWidth = 2.0 // 테두리 두깨
        label.layer.borderColor = #colorLiteral(red: 0.7499064803, green: 0.9831754565, blue: 0.9550266862, alpha: 1)
        return label
    }()
    
    // '번호 저장' 버튼
    let saveButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "heart"), for: .normal) // 하트아이콘 넣기
        button.tintColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.backgroundColor = .clear
        return button
    }()
    
    // '숫자 레이블' + '번호 저장 버튼'묶기 위한 스택뷰 생성
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 2 // 스택뷰 내부의 간격
        view.axis = .horizontal // axis: 축 (묶을때 가로, 세로 방향 결정)(vertical(세로-수직), horizontal(가로-수평)
        view.distribution = .fill // 크기 분배 어떻게 할건지?
        view.alignment = .fill // 정렬(fill은 완전히 채우는 정렬)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    // 번호저장 버튼을 위한 클로저 저장(뷰컨에 있는 클로저를 저장할 예정(테이블뷰 셀 내부에서는 셀(자신)을 전달))
    // 이 클로저는 메인뷰컨트롤러와 연결되어 동작
    var saveButtonPressed: ((NumTableViewCell) -> ()) = { sender in }
    
    // MARK: - 테이블뷰 셀 생성자(오토레이아웃)
    
    // 오토레이아웃을 생성자로 설정(스토리보드인 경우 awakeFromNib 함수에서 해주면 되는데 여기선 코드로 구현하는 것이기 때문에 생성자를 사용)
    // init(style) 생성자(애플이 UITableViewCell을 만들때 기본적으로 세팅해주는 생성자를 구현해놓음)
    // 셀을 가져올때 내부적으로 호출된다고 한다.(챗지피티 설명)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        setupStackView() // 스택뷰 올리기
        stackViewConstraints() // 스택뷰 오토레이아웃
        
        // 버튼 addTarget 설정(여기서 한 이유는 버튼 자체에 설정시 노란색 경고표시)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 테이블뷰 셀 설정 및 오토레이아웃
    
    // 스택뷰 설정
    private func setupStackView() {
        self.contentView.addSubview(stackView) // 스택뷰를 셀에 올림
        
        ballListView.translatesAutoresizingMaskIntoConstraints = false
        
        // 스택뷰위에 레이블, 버튼을 배열형태로 올린다.
        stackView.addArrangedSubview(numberLabel)
        stackView.addArrangedSubview(saveButton)
        numberLabel.addSubview(ballListView) // 넘버레이블위에 ballListView 스택뷰 넣어줌
    }
    
    // 스택뷰 오토레이아웃
    private func stackViewConstraints() {
        // 셀에서는 self.addSubview보다 self.contentView.addSubview로 잡는게 더 정확함 ⭐️
        // contentView는 테이블뷰 셀의 내용을 포함하는 뷰(UITableViewCell의 속성)
        NSLayoutConstraint.activate([
            stackView.heightAnchor.constraint(equalToConstant: 60),
            stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            stackView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
        
        // ballListView 오토레이아웃(레이블 기준으로)
        NSLayoutConstraint.activate([
            ballListView.centerXAnchor.constraint(equalTo: self.numberLabel.centerXAnchor),
            ballListView.centerYAnchor.constraint(equalTo: self.numberLabel.centerYAnchor)
        ])
    }
    
    // MARK: - Input & Output

    
    // 번호 받아서 공 모양으로 바꾸기 위한 메서드(UIStackView)
    func numbersBallListInsert(numbers: [Int]) {
        ballListView.displayNumbers(numbers)
    }
    
    // 번호저장 버튼 눌렸을때 셀렉터
    @objc private func saveButtonTapped() {
        saveButtonPressed(self) // 셀 자신을 클로저로 보내줌
    }
    
    // 번호저장 버튼 설정
    func setButtonStatus(isSaved: Bool) {
        if isSaved {
            saveButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            saveButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
}

