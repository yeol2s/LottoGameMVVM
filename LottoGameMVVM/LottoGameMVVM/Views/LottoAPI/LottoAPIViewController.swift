//
//  LottoAPIViewController.swift
//  LottoGameMVVM
//
//  Created by 유성열 on 12/20/23.
//

import UIKit

// MARK: - 로또 API 뷰컨트롤러

// 로또 API 네트워크 매니저와 통신하는 뷰컨
final class LottoAPIViewController: UIViewController {
    
    // MARK: - 뷰컨트롤러 속성
    
    private var viewModel: LottoAPIViewModel = LottoAPIViewModel() // 뷰모델 인스턴스 생성
    
    private let ballListView: NumberBallListView = NumberBallListView() // 공 모양으로 만드는 UIStackView 인스턴스 생성
    
    let mintGreenColor = UIColor(red: 0.86, green: 0.98, blue: 0.96, alpha: 1.00) // 뷰 백그라운드 컬러
    
    // 타이틀
    private let drawDateLabel: UILabel = {
        let label = UILabel()
        label.text = "당첨 번호 조회"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        label.backgroundColor = UIColor(red: 0.86, green: 0.98, blue: 0.96, alpha: 1.00)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    // 추첨일
    private let drawDate: UILabel = {
        let label = UILabel()
        label.text = " "
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textAlignment = .center
        label.backgroundColor = UIColor(red: 0.86, green: 0.98, blue: 0.96, alpha: 1.00)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 추첨 회차
    private let drawRound: UILabel = {
        let label = UILabel()
        label.text = " "
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.backgroundColor = UIColor(red: 0.86, green: 0.98, blue: 0.96, alpha: 1.00)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 1등 당첨번호 타이틀
    private let numbersLabelTitle: UILabel = {
        let label = UILabel()
        label.text = "1등 당첨번호"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.backgroundColor = UIColor(red: 0.30, green: 0.80, blue: 0.74, alpha: 1.00) // Turquoise Color
        label.layer.borderWidth = 2.0
        label.layer.borderColor = UIColor.black.cgColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 1~6(보너스)숫자 출력할 레이블
    private let numbersLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.layer.borderWidth = 2.0
        label.layer.borderColor = UIColor.black.cgColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 1등 당첨 복권수 타이틀
    private let firstTicketCountTitle: UILabel = {
        let label = UILabel()
        label.text = "1등 당첨 복권수"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 1등 당첨 복권수
    private let firstTicketCount: UILabel = {
        let label = UILabel()
        label.text = " "
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 1등 당첨금액 타이틀
    private let firstWinMoneyTitle: UILabel = {
        let label = UILabel()
        label.text = "1등 당첨 금액"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 1등 당첨금액
    let firstWinMoney: UILabel = {
        let label = UILabel()
        label.text = " "
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // (레이블)스택뷰를 묶을 스택뷰
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 30
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill // .center로 하면 중앙 위치 뷰들은 크기 유지(fill은 모든 뷰가 스택뷰의 크기에 맞게 확장되어 정렬됨)
        view.backgroundColor = UIColor(red: 0.86, green: 0.98, blue: 0.96, alpha: 1.00)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 당첨번호 스택뷰
    private let numbersStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 0
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 당첨복권수 스택뷰
    private let ticketStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 0
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.backgroundColor = UIColor(red: 0.87, green: 0.95, blue: 0.89, alpha: 1.00)
        view.layer.borderWidth = 1.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 당첨금액 스택뷰
    private let winMoneyStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 0
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.backgroundColor = UIColor(red: 0.87, green: 0.95, blue: 0.89, alpha: 1.00)
        view.layer.borderWidth = 1.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 레이블 배열(레이블, 스택뷰등)
    private lazy var setLabels = [drawDateLabel, drawDate, drawRound, numbersStackView, ticketStackView, winMoneyStackView]
    
    // MARK: - 뷰컨트롤러 생명 주기 메서드

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = mintGreenColor
        setupAPIBindViewModel() // API 뷰모델 바인딩 메서드 호출(Observable 데이터의 클로저에 할당 위해)(뷰모델에 묶어 놓는다.)
        setupStackView() // 스택뷰 설정 및 오토레이아웃 메서드 호출
        naviBackButtonTitle() // 네비게이션바 타이틀 변경("뒤로 가기")
        viewModel.setupAPI() // 뷰모델에게 네트워킹 작업 요청(바인딩 시작)
    }
    
    // 스크린에서 뷰가 사라진 후 호출(뷰컨 생명주기)
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.popViewController(animated: true) // 이전 메인화면으로 되돌림
    }
    
    // MARK: - 뷰 설정 및 오토레이아웃
    
    // 네비게이션바 타이틀 변경
    private func naviBackButtonTitle() {
        let newBackButtonTitle = "뒤로 가기"
        let backButton = UIBarButtonItem()
        backButton.title = newBackButtonTitle
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    // 스택뷰 설정
    private func setupStackView() {
        numbersStackView.addArrangedSubview(numbersLabelTitle)
        numbersStackView.addArrangedSubview(numbersLabel)
        ballListView.translatesAutoresizingMaskIntoConstraints = false
        numbersLabel.addSubview(ballListView) // 넘버레이블위에 공변환 뷰 올려줌
        ticketStackView.addArrangedSubview(firstTicketCountTitle)
        ticketStackView.addArrangedSubview(firstTicketCount)
        winMoneyStackView.addArrangedSubview(firstWinMoneyTitle)
        winMoneyStackView.addArrangedSubview(firstWinMoney)
        
        // 배열로 레이블들을 스택뷰에 올려줌
        for label in setLabels {
            stackView.addArrangedSubview(label)
        }

        view.addSubview(stackView) // 스택뷰를 뷰위에 올려줌
        setConstraints() // 오토레이아웃 메서드 호출
    }
    
    // 오토레이아웃 설정 메서드
    private func setConstraints() {
        setDrawDateLabelConstraints()
        setNumbersLaebelConstraints()
        setFirstTicketCountConstraints()
        setFirstWinMoneyConstraints()
        setStackViewConstraints()
    }
    
    // 스택뷰 안에 UILabel들은 크게 오토레이아웃을 하지 않았다. 스택뷰는 안에 포함된 요소들을 자동으로 레이아웃하고 정렬하는 UI컨테이너 이므로 스택뷰안에 UILabel또는 다른 뷰를 추가하면 추가된 뷰들을 자동으로 배치하고 크기를 조절함.(스택뷰 안에 스택뷰를 추가해도 마찬가지)
    // 레이블 오토레이아웃(레이블들은 스택뷰에 넣으므로 높이, 넓이정도만 설정)
    private func setDrawDateLabelConstraints() { // '타이틀' 레이블 오토레이아웃
        drawDateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            drawDateLabel.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    private func setNumbersLaebelConstraints() { // '당첨번호' 타이틀 + 레이블 오토레이아웃
        NSLayoutConstraint.activate([
            numbersLabelTitle.heightAnchor.constraint(equalToConstant: 40),
            numbersLabel.heightAnchor.constraint(equalToConstant: 50),
        ])
        // ballListView 오토레이아웃(레이블 기준으로)
        NSLayoutConstraint.activate([
            ballListView.centerXAnchor.constraint(equalTo: numbersLabel.centerXAnchor),
            ballListView.centerYAnchor.constraint(equalTo: numbersLabel.centerYAnchor)
        ])
    }
    
    private func setFirstTicketCountConstraints() { // '당첨 복권수' 레이블 오토레이아웃
        NSLayoutConstraint.activate([
            firstTicketCount.heightAnchor.constraint(equalToConstant: 30),
            firstTicketCountTitle.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    private func setFirstWinMoneyConstraints() { // '1등 당첨금액' 레이블 오토레이아웃
        NSLayoutConstraint.activate([
            firstTicketCountTitle.heightAnchor.constraint(equalToConstant: 30),
            firstWinMoney.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    // numbersStackView, ticketStackView 스택뷰는 레이아웃 생략하고 메인 스택뷰만 레이아웃함
    // 전체적인 넓이를 위해 좌우 오토레이아웃을 직접 지정
    private func setStackViewConstraints() { // '스택뷰' 오토레이아웃
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
        ])
    }
    
    // MARK: - Input 관련 메서드(내부로직 포함)
    
    // (네트워크) API 셋업(바인딩클로저에 클로저 할당)
    private func setupAPIBindViewModel() {

        // subscribe 메서드를 거쳐서 이 클로저를 listener 클로저에다가 할당하는 것
        self.viewModel.lottoAPI.subscribe { [weak self] lottoData in
            DispatchQueue.main.async {
                self?.drawDate.text = lottoData.drawDate
                self?.drawRound.text = lottoData.drawNo! + "회차"
                self?.numbersBallListInsert(arrayNumbers: lottoData.numbers!, bonusNumber: lottoData.bnusNum!) // API뷰컨 내부 메서드에 API 전달받은 번호를 전달해줌
                self?.firstTicketCount.text = lottoData.firstTicketsCount! + "장"
                self?.firstWinMoney.text = lottoData.firstWinMoney! + "원"
            }
        }
    }
    
    // 번호 받아서 공 모양으로 바꾸기 위한 메서드(UIStackView)
    private func numbersBallListInsert(arrayNumbers numbers: [Int], bonusNumber bnsNumber: Int) {
        
        ballListView.displayNumbers(numbers, bns: bnsNumber) // API로 번호를 전달받아 UIStackView객체로 전달하고 addSubView진행(표시는 numbersLabel에 addSubView)
        // API뷰컨내에서 numbersLabel에 ballListView(UIStackView)를 addSubView 하고 오토레이아웃
    }

    
    
}
