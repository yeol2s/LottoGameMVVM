//
//  NumbersGenViewController.swift
//  LottoGameMVVM
//
//  Created by 유성열 on 12/14/23.
//

import UIKit

// MARK: - 메인 뷰컨트롤러(번호 생성화면)
final class NumbersGenViewController: UIViewController {
    
    // MARK: - 뷰컨트롤러 속성
    
    private var viewModel: NumberGenViewModel! // ! -> 뷰모델 인스턴스 생성(IUO - 암시적 추출 옵셔널 : 벗겨질 준비가 되어있고, 변수에 담을때 자동으로 언래핑)
    
    weak var delegate: NumberGenViewControllerDelegate? // 델리게이트 대리자 지정 변수 선언(컨테이너뷰-메뉴바 사용)
    
    private let numTableView = UITableView() // 테이블뷰 생성(번호 10줄)
    
    // 번호 생성 버튼
    private lazy var generateButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 0, green: 0.8178957105, blue: 1, alpha: 1)
        button.layer.borderWidth = 3
        button.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        button.layer.cornerRadius = 5
        button.setTitle("번호 생성", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20) // 폰트 설정
        button.addTarget(self, action: #selector(genButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // 리셋 버튼
    private lazy var resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 0, green: 0.9895486236, blue: 0.7555574179, alpha: 1)
        button.layer.borderWidth = 3
        button.layer.borderColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        button.layer.cornerRadius = 5
        button.setTitle("RESET", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // 햄버거 메뉴
    private lazy var menuButton: UIBarButtonItem = {
        var button = UIBarButtonItem(image: UIImage(named: "bugericon"), style: .plain, target: self, action: #selector(didTapMenuButton))
        return button
    }()
    
    // MARK: - 뷰컨트롤러 생명 주기 메서드
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // 뷰모델의 Alert 설정 클로저에 할당
        // 뷰모델에서 클로저를 호출시면서 alert 설정한 정보를 status로 받음(title, message, button 튜플)
        // 이 할당된 클로저는 뷰모델에서 alertSet 속성이 변경되었을때 속성감시자를 통해 호출될 것(여기선 할당만)
        viewModel.showAlertClosure = { [weak self] status in
            self?.showAlert(title: status.title, message: status.message, cancelButtonUse: status.cancelButtonUse) // showAlert 메서드를 호출하면서 데이터를 전달해서 Alert 실행
        }
    }
    
    // (뷰컨 생명주기)뷰가 나타날때마다 호출(뷰가 나타나기 전)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        numTableView.reloadData()
    }
    
    
    // MARK: - 뷰 설정 및 오토레이아웃
    
    // 네비게이션 설정 메서드
    private func setupNaviBar() {
        title = "Lotto Pick"
        
        // appearance 변수는 네비게이션바의 외관을 구성할 수 있는 컨테이너 역할의 변수가 됨
        let appearance = UINavigationBarAppearance() // 네비게이션바 겉모습을 담당하는 인스턴스 생성
        appearance.configureWithOpaqueBackground() // 불투명으로
        appearance.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .systemBlue // 네비바 틴트 색상
        navigationController?.navigationBar.standardAppearance = appearance // 네비바 표준모드(일반)에서 사용할 외관 설정
        navigationController?.navigationBar.compactAppearance = appearance // compact 모양 설정(가로 방향 화면 사용시 모양 정의)
        navigationController?.navigationBar.scrollEdgeAppearance = appearance // 스크롤이 맨위로 도달했을 때 네비게이션바의 모양 정의
        
        self.navigationItem.leftBarButtonItem = self.menuButton // 메뉴 버튼 설정(햄버거 아이콘)
    }
    
    // 테이블뷰 대리자 및 관련 설정
    private func setupTableView() {
        numTableView.delegate = self
        numTableView.dataSource = self
        
        numTableView.rowHeight = 70 // 테이블뷰 셀 높이
        numTableView.register(NumTableViewCell.self, forCellReuseIdentifier: "NumCell") // 셀 등록(셀 메타타입 등록)
    }
    
    // 테이블뷰 오토레이아웃
    private func setupTableViewConstraints() {
        view.addSubview(numTableView) // 하위 뷰 추가(테이블뷰)
        numTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            numTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            numTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            numTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            numTableView.bottomAnchor.constraint(equalTo: view.centerYAnchor) // 화면에 반만 사용하도록
        ])
    }
    
    // 번호 생성 버튼 오토레이아웃
    private func setupGenButtonConstraints() {
        view.addSubview(generateButton)
        generateButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            generateButton.widthAnchor.constraint(equalToConstant: 200),
            generateButton.heightAnchor.constraint(equalToConstant: 50),
            generateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            generateButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100) // 화면에 반에서 100 띄움
        ])
    }
    
    // 리셋 버튼 오토레이아웃
    private func resetButtonConstraints() {
        view.addSubview(resetButton)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            resetButton.widthAnchor.constraint(equalToConstant: 100),
            resetButton.heightAnchor.constraint(equalToConstant: 40),
            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resetButton.topAnchor.constraint(equalTo: numTableView.bottomAnchor, constant: 80)
        ])
        
    }
    
    // MARK: - Input 관련 메서드
    
    // 번호 생성버튼 셀렉터 메서드(뷰모델에게 전달)
    @objc private func genButtonTapped() {
        if viewModel.generateNumbersTapped() { // 번호가 10개 이하 일때만 true -> 번호 생성
            numTableView.reloadData()
        } else {
            // 생성번호 10개이상 발생시 false -> Alert 발생(뷰모델에서 처리할 수 있도록 구현)
            // 뷰모델에게 title, message, cancel action 사용유무를 전달해서 alert 띄움
            viewModel.alertPerformAction(title: "생성된 번호 10개", message: "생성된 가능한 번호는 최대 10개입니다.", cancelButtonUse: false)
        }
    }
    
    // 번호 리셋버튼 셀렉터 메서드(뷰모델에게 전달)
    @objc private func resetButtonTapped() {
        guard !viewModel.numbers.isEmpty else { return } // 번호가 생성되어 있을때만 실행되도록 가드문 처리
        
        viewModel.alertPerformAction(title: "번호 초기화", message: "번호를 초기화 하시겠습니까?", cancelButtonUse: true) // '취소' 버튼 추가해서 Alert 요청해서 핸들러 처리
        
    }
    
    //❓❓❓ Alert 이렇게 처리하는거 괜찮은건지(뭔가 어거지 느낌이 강해짐)
    // ⚠️ Alert 구현 부분은 뷰모델과 함께 빌드 후 테스트해보자. (미완성으로 아직 실행 테스트 못해봄)
    // Alert 메서드('확인' 버튼만 구현할 것인지? '취소' 버튼까지 추가 구현할 것인지? -> Bool 여부에 따라 결정)
    // title, message는 호출과 함께 전달
    func showAlert(title: String , message: String, cancelButtonUse: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if cancelButtonUse { // '취소' 버튼 사용(Dual)
            let okAction = UIAlertAction(title: "확인", style: .default) { _ in
                self.alertHandlerAction(title) // 핸들러 처리
            }
            let cancelAction = UIAlertAction(title: "취소", style: .default)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
        } else { // '확인' 버튼만 사용(Single)
            let okAction = UIAlertAction(title: "확인", style: .default)
            alert.addAction(okAction)
        }
        present(alert, animated: true)
    }
    
    // Alert 핸들러 메서드
    private func alertHandlerAction(_ status: String) {
        
        switch status {
        case "번호 초기화":
            viewModel.resetNumbersButtonTapped() // 뷰모델에 번호 초기화 요청
            numTableView.reloadData() // 테이블뷰 리로드
        default:
            break
        }
    }
    
    // 메뉴버튼 눌렀을때 셀렉터 메서드(네비바 햄버거 아이콘)
    @objc private func didTapMenuButton() {
        delegate?.didTapMenuButton() // 델리게이트 프로토콜을 준수하는 객체에서만 실행가능한 메서드(해당 프로토콜을 채택하지 않으면 nil이 반환)
    }
    
    
}


// MARK: - 테이블뷰 관련 델리게이트 확장

// UITableViewDelegate 확장
extension NumbersGenViewController: UITableViewDelegate {
    
}

// UITableViewDataSource 확장
extension NumbersGenViewController: UITableViewDataSource {
    // 테이블뷰 몇개의 데이터 표시할건지
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumbersCount()
    }
    // 테이블뷰 셀을 어떻게 구성할건지(numberOfRowsInSection과 함께 동작한다.)(데이터의 개수에 따라 이 메서드가 동작하며 스크롫할때마다 재구성이 됨)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = numTableView.dequeueReusableCell(withIdentifier: "NumCell", for: indexPath) as! NumTableViewCell // 재사용 셀 등록
        
        let numbers = viewModel.getNumbersList(row: indexPath.row) // 현재 생성된 번호를 index 기준으로 가져와서 담음
        cell.numbersBallListInsert(numbers: numbers) // 셀에게 번호 전달해서 공 모양의 번호로 표시 (❓❓❓ 이 부분 MVVM 패턴 준수하는건가?)
        cell.selectionStyle = .none // 셀 선택시 회색으로 표시하지 않도록 설정
        
        // (번호 생성화면 하트 눌러서) 번호 저장 (버튼은 셀에서 구현)
        cell.saveButtonPressed = { [weak self] senderCell in
            guard let self = self else { return }
            
            // ⚠️ 여기서부터 마저 구현하자 (뷰모델과 함께 작성중이었음)
            
            
            
        }
        
        
        return cell
    }
    
    
}
