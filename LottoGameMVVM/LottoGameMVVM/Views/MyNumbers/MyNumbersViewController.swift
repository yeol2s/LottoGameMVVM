//
//  MyNumbersViewController.swift
//  LottoGameMVVM
//
//  Created by 유성열 on 12/19/23.
//

import UIKit

// MARK: - '내 번호' 뷰컨트롤러(번호 저장 화면)

final class MyNumbersViewController: UIViewController {
    
    // MARK: - 뷰컨트롤러 속성
    
    private var viewModel: NumberSaveViewModel = NumberSaveViewModel() // 번호저장 뷰모델 인스턴스 생성
    
    private let numSelectTableView: UITableView = { // 저장된 번호 리스트 테이블 뷰
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    lazy var ballListView: NumberBallListViewModel = NumberBallListViewModel() // 공 모양으로 만드는 UIStackView 인스턴스 생성(직접 번호추가 화면에서 사용됨)(선택시마다 레이블에 공 모양으로 출력하기 위함)
    
    lazy var addNumbersCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()) // (직접 번호추가 화면)컬렉션 뷰 (오토레이아웃을 할 것이므로 .zero로 설정)
    private let numbers: [Int] = Array(1...45) // 1 ~ 45 배열 생성
    lazy var selectedNumbers: [Int] = [] // (직접 번호 추가)선택된 번호를 넣을 배열
    
    // 저장된 번호 리셋 버튼
    private lazy var resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        button.layer.borderWidth = 3
        button.layer.borderColor = #colorLiteral(red: 0.9038607478, green: 0.5367665887, blue: 0.3679499626, alpha: 1)
        button.layer.cornerRadius = 5
        button.setTitle("RESET", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(saveResetButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // 네비게이션컨트롤러 + 버튼 추가(번호 직접입력 화면 이동)
    private lazy var plusButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(inputNumber))
        return button
    }()
    
    // (직접 번호 추가 화면)컬렉션뷰 '추가' 버튼
    private lazy var addNumberButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        button.layer.borderWidth = 3
        button.layer.borderColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        button.layer.cornerRadius = 5
        button.setTitle("추가", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addNumberViewTapped), for: .touchUpInside)
        return button
    }()
    
    // (직접 번호 추가 화면)컬렉션뷰 '종료' 버튼
    private lazy var addNumberCloseButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        button.layer.borderWidth = 3
        button.layer.borderColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
        button.layer.cornerRadius = 5
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addNumberViewCloseTapped), for: .touchUpInside)
        return button
    }()
    
    // (직접 번호 추가 화면)선택된 번호 출력할 레이블
    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.layer.borderWidth = 2.0
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // (직접 번호 추가 화면)번호 선택 스택뷰에 사용될 '추가', '취소' 버튼 스택뷰
    private lazy var addNumberButtonStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 1
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // (직접 번호 추가 화면)번호 선택 추가 스택뷰
    private lazy var addNumbersStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 3 // 스택뷰 내부의 간격
        view.axis = .vertical
        view.backgroundColor = .white
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 5
        //view.distribution = .fill // 크기 분배 어떻게 할건지?
        //view.alignment = .fill // 정렬(fill은 완전히 채우는 정렬)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // (직접 번호 추가 화면)스택뷰에 하위뷰 배열
    private lazy var setViews = [addNumbersCollectionView, numberLabel, addNumberButtonStackView]
    
    
    // MARK: - 뷰컨트롤러 생명 주기 메서드
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.968886435, green: 0.9258887172, blue: 0.8419043422, alpha: 1)
        setupNaviBar() // 네비 설정
        setupTableView() // 테이블뷰 설정
        setupCollectionView() // 컬렉션뷰 설정
        setupTableViewConstraints() // 테이블뷰 오토레이아웃
        setButtonConstraints() // 버튼 오토레이아웃
    }
    
    // 화면이 다시 나타날때마다 계속 호출(뷰컨트롤러 생명주기)(뷰가 나타나기 전)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadSaveData() // UserDefaults 데이터 갱신(set)
        numSelectTableView.reloadData() // 테이블뷰 리로드(⭐️이렇게 리로드 계속 되는것이 비효율적인가?)
        if viewModel.getSaveDataCount() >= 9 { // 번호가 9개이상일때 테이블뷰 스크롤 활성화
            numSelectTableView.isScrollEnabled = true // 테이블뷰 스크롤 활성화
        } else {
            numSelectTableView.isScrollEnabled = false // 비활성화
        }
    }
    
    // 뷰가 사라지고난 후
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        resetAddNumberView() // (직접)저장중인 번호 초기화
    }
    
    // MARK: - 뷰 설정 및 오토레이아웃
    
    // 네비게이션바 설정 메서드
    private func setupNaviBar() {
        title = "내 번호"
        let appearance = UINavigationBarAppearance() // 네비게이션바 겉모습을 담당
        appearance.configureWithOpaqueBackground() // 불투명으로
        appearance.backgroundColor = .white
        // 네비게이션 모양 설정
        navigationController?.navigationBar.tintColor = .systemBlue // 네비바 틴트 색상
        navigationController?.navigationBar.standardAppearance = appearance // standard 모양 설정?
        navigationController?.navigationBar.compactAppearance = appearance // compact 모양 설정(가로 방향 화면 사용시 모양 정의?)
        navigationController?.navigationBar.scrollEdgeAppearance = appearance // 스크롤이 맨위로 도달했을 때 네비게이션 바의 모양 정의
        
        self.navigationItem.rightBarButtonItem = self.plusButton // + 번호 추가 기능
    }
    
    // 내 번호 테이블뷰 대리자 지정 및 관련 설정
    private func setupTableView() {
        numSelectTableView.delegate = self
        numSelectTableView.dataSource = self
        numSelectTableView.rowHeight = 60
        numSelectTableView.register(NumSelectListTableViewCell.self, forCellReuseIdentifier: "NumSelectCell")
    }
    
    // 저장 번호 직접 추가 컬렉션뷰 대리자 지정 및 관련 설정
    private func setupCollectionView() {
        addNumbersCollectionView.delegate = self
        addNumbersCollectionView.dataSource = self
        addNumbersCollectionView.register(AddNumbersCollectionViewCell.self, forCellWithReuseIdentifier: "AddNumbersCell")
    }
    
    // 테이블뷰 오토레이아웃
    private func setupTableViewConstraints() {
        view.addSubview(numSelectTableView)
        numSelectTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            numSelectTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            numSelectTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            numSelectTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            numSelectTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60)
        ])
    }
    
    // 리셋버튼 오토레이아웃
    private func setButtonConstraints() {
        view.addSubview(resetButton)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            resetButton.topAnchor.constraint(equalTo: numSelectTableView.bottomAnchor, constant: 10),
            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resetButton.widthAnchor.constraint(equalToConstant: 100),
            resetButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    // 번호 추가 화면 스택뷰 오토레이아웃
    private func setupAddStackViewConstraints() {
        addNumbersCollectionView.backgroundColor = .clear
        setupButtonConstraints()
        setupBallListViewConstraints() // 넘버레이블 Ball 오토레이아웃
        
        for views in setViews {
            addNumbersStackView.addArrangedSubview(views)
        }
        
        view.addSubview(addNumbersStackView) // 하위뷰로 스택뷰 추가
        
        addNumbersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        ballListView.translatesAutoresizingMaskIntoConstraints = false // 테스트
        NSLayoutConstraint.activate([
            addNumbersStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            addNumbersStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            addNumbersStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            addNumbersStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            
            numberLabel.heightAnchor.constraint(equalToConstant: 50) // 넘버레이블 직접 오토레이아웃(번호 공 표시 위해)
        ])
        
    }
    
    // (번호 추가 화면 스택뷰) 추가, 종료 버튼 스택뷰 오토레이아웃
    private func setupButtonConstraints() {
        addNumberButtonStackView.addArrangedSubview(addNumberButton)
        addNumberButtonStackView.addArrangedSubview(addNumberCloseButton)
    }
    // (번호 추가 화면 레이블) 레이블에 ballListView 올려서 선택마다 번호 공 모양으로 출력될 수 있게 하위뷰 추가
    private func setupBallListViewConstraints() {
        numberLabel.addSubview(ballListView)
        
        NSLayoutConstraint.activate([
            ballListView.centerXAnchor.constraint(equalTo: self.numberLabel.centerXAnchor),
            ballListView.centerYAnchor.constraint(equalTo: self.numberLabel.centerYAnchor)
        ])
    }
    
    
    // MARK: - Input 관련 메서드(내부로직 포함)
    
    // ❓❓❓ 이 뷰의 경우에는 Alert이 간단한 리셋 버튼 한개라서 뷰컨에다가 그냥 구현
    // 저장된 번호 리셋
    @objc func saveResetButtonTapped() {
        
        // 저장된 번호가 있을때만 실행되도록 가드문(저장된 번호가 1개 이상일때만)
        guard viewModel.getSaveDataCount() >= 1 else { return }
        
        let alert = UIAlertController(title: "번호 초기화", message: "현재 저장된 번호가 초기화됩니다. 계속하시겠습니까?", preferredStyle: .alert)
        
        let success = UIAlertAction(title: "확인", style: .default) { action in
            self.viewModel.saveDataReset() // 매니저 통해 리셋
            self.numSelectTableView.reloadData() // 테이블뷰 리로드
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(success)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
    // 네비게이션 (+)버튼 번호 추가 기능(직접입력 구현)
    @objc func inputNumber() {
        setupAddStackViewConstraints()
        resetButton.isEnabled = false // 리셋 버튼 비활성화
    }
    
    // (직접)번호 추가 컬렉션뷰 '닫는' 버튼 셀렉터 메서드
    @objc func addNumberViewCloseTapped() {
        resetAddNumberView() // (직접)번호 추가화면 리셋
        resetButton.isEnabled = true // 리셋 버튼 활성화
    }
    
    // (직접)번호 추가 컬렉션뷰 '추가' 버튼 셀렉터 메서드
    @objc func addNumberViewTapped() {
        guard !selectedNumbers.isEmpty else { return } // 추가된 번호가 있을때만 실행
        viewModel.setSaveData(selectedNumbers.sorted()) // 번호 메서드를 통해 유저디폴츠로 넣어주고
        resetAddNumberView() // (직접)번호 추가화면 리셋
        resetButton.isEnabled = true // 리셋 버튼 활성화
        numSelectTableView.reloadData() // 테이블뷰 리로드
    }
    
    
    // (직접)번호 추가화면 리셋(저장중인 번호 및 뷰 종료)
    private func resetAddNumberView() {
        if !selectedNumbers.isEmpty { // 현재 (직접)저장하고 있는 번호가 있다면
            selectedNumbers = [] // 현재 (직접)저장중인 번호 초기화
            ballListView.displayNumbers(selectedNumbers) // ballView 번호 초기화
        }
        addNumbersStackView.removeFromSuperview() // (직접)번호추가 화면 부모뷰로부터 뷰 삭제(화면 닫음)
    }
}


// MARK: - 테이블뷰

// UITableViewDelegate 확장
extension MyNumbersViewController: UITableViewDelegate {
    
    
}

// UITableViewDataSource 확장
extension MyNumbersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getSaveDataCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // dequeueReusableCell 테이블뷰 셀을을 재사용하기 위해 사용되는 메서드
        let cell = numSelectTableView.dequeueReusableCell(withIdentifier: "NumSelectCell", for: indexPath) as! NumSelectListTableViewCell
    
        // 뷰모델한테 유저디폴츠 데이터를 뽑아와서 셀의 공 모양으로 변환하는 메서드에 전달해서 셀에서 addSubView함
        cell.numbersBallListInsert(numbers: viewModel.getSaveData(row: indexPath.row))
        
        // 셀과 연결된 클로저 호출(어떤 번호를 선택해제 할껀지)
        // ❓❓❓ 와일드카드를 쓰고 콜백함수파라미터?를 뺐는데 괜찮은 코드?
        cell.saveUnCheckButton = { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.setRemoveData(row: indexPath.row) // 뷰모델한테 인덱스 전달해서 유저디폴츠에서 삭제
            self.numSelectTableView.reloadData() // 하트 해제할때마다 즉시즉시 리로드해서 번호를 화면에서 제거
        }
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
}


// MARK: - 컬렉션뷰

// UICollectionViewDelegate 확장
extension MyNumbersViewController: UICollectionViewDelegate {
    // 특정 셀 아이템 선택시 호출
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedNumber = numbers[indexPath.item] // 몇번째 아이템이 선택되었는지 뽑아서 넣고
        
        if selectedNumbers.count < 6 { // 현재 저장중인 번호가 6개 미만일때만 실행
            if !selectedNumbers.contains(selectedNumber) {
                selectedNumbers.append(selectedNumber) // 포함되어있지 않은 번호면 저장 배열에 추가
            } else { // 포함되어 있다면 삭제
                if let index = selectedNumbers.firstIndex(of: selectedNumber) {
                    selectedNumbers.remove(at: index) // 포함되어있다면 저장 배열에서 삭제
                }
            }
        } else { // 현재 저장중인 번호가 6개 이상이라면(중복 번호를 누른다면 삭제되도록)
            if let index = selectedNumbers.firstIndex(of: selectedNumber) {
                selectedNumbers.remove(at: index) // 포함되어있다면 저장 배열에서 삭제
            }
        }
        ballListView.displayNumbers(selectedNumbers.sorted()) // 배열에 추가된 번호 받아서 공 변환(오름차순 정렬로)
    }
}

// UICollectionViewDataSource 확장
extension MyNumbersViewController: UICollectionViewDataSource {
    // 컬렉션뷰 몇개의 데이터 표시할건지
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbers.count // 1~45번호 배열
    }
    
    // 셀을 어떻게 그려낼건지
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = addNumbersCollectionView.dequeueReusableCell(withReuseIdentifier: "AddNumbersCell", for: indexPath) as! AddNumbersCollectionViewCell
        let number = numbers[indexPath.item] // 아이템 인덱스번호를 뽑아서
        cell.configure(number) // 1~45까지의 번호를 한번씩 셀의 configure 메서드에 보내서 레이블에 표시
        return cell
    }
    
    
}


