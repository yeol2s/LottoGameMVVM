//
//  NumberGenViewModel.swift
//  LottoGameMVVM
//
//  Created by 유성열 on 12/14/23.
//

// 📌 Foundation으로 뷰모델에 UIKit 코드없는 것 확인
import Foundation

// MARK: - 메인 뷰컨트롤러 델리게이트 프로토콜(컨테이너뷰컨과 통신을 위해)
// 탭을 눌렀을때 전달을 위한 프로토콜
protocol NumberGenViewControllerDelegate: AnyObject { // AnyObject로 클래스타입만
    func didTapMenuButton() // (요구사항 메서드)메뉴 버튼 누를시
}

// MARK: - (타입애일리어스)네임드 튜플 타입 정의(Alert)
// ❓❓❓네임드 튜플 이렇게 클래스 외부에 선언했는데 이렇게 해도 정석인가?
// Alert 상태(title-message-button개수) 전달하기 위한 네임드 튜플 타입 선언
typealias AlertStatusTuple = (title: String, message: String, cancelButtonUse: Bool)

// MARK: - 메인 뷰컨트롤러(번호 생성) 뷰모델
final class NumberGenViewModel {
    
    // MARK: - 뷰모델 속성
    
    // 유저디폴츠 관련 설정
    private let userDefaults = UserDefaults.standard // 유저디폴츠 사용을 위한 변수 생성(유저디폴츠의 싱글톤 인스턴스를 참조)
    private let saveKey: String = "MyNumbers" // 유저디폴츠 번호저장 키
    private var defaultsTemp: [[Int]] = [] // 유저디폴츠 데이터 임시공간 배열
    
    var numbers: [NumbersGen] = [] // 모델 인스턴스 생성
    
    // 뷰 Alert 이벤트 발생시 메세지 업데이트
    private var alertSet: AlertStatusTuple? { // (타입애일리어스)네임드 튜플(title, message, cancelButtonUse)
        didSet { // 속성감시자(Alert 메세지가 변경되면 클로저 호출)
            if let alertSet = alertSet {
                showAlertClosure?((alertSet.title, alertSet.message, alertSet.cancelButtonUse)) // 타이틀, 메세지, 버튼 설정
            }
        }
    }
    
    var showAlertClosure: ((AlertStatusTuple) -> Void)? // Alert 클로저 선언(뷰에서 클로저 할당)(타입애일리어스(튜플) 파라미터 사용-(title,message,button))
    
    
    // MARK: - Input
    
    // 번호 생성 메서드(생성 버튼 누를시)
    func generateNumbersTapped() /*-> Bool*/ {
        
        // guard문으로 현재 생성된 번호가 10개이상인지 체크해서 번호생성 or Alert생성
        guard numbers.count <= 9 else { 
            alertPerformAction(title: "생성된 번호 10개", message: "생성 가능한 번호는 최대 10개입니다.", cancelButtonUse: false)
            return }
        
        var lottoNumbers: [Int] = [] // 번호 생성시마다 번호 임시 저장
        
        while lottoNumbers.count < 6 { // 임시 저장 배열의 번호가 6개가 될때까지 반복
            let randomNumber = Int.random(in: 1...45)
            
            if !lottoNumbers.contains(randomNumber) {
                lottoNumbers.append(randomNumber) // 생성된 번호가 임시 배열에 포함되지 않는 경우에만 저장
            }
        }
        
        // ❓❓❓ 이렇게 중복 번호 방지하는 것 괜찮은 로직인가?
        // 이미 화면에 생성된 중복된 값이 나오면 처리
        if !numbers.isEmpty { // (모델)구조체 배열이 비어있지 않다면(생성된 번호가 없을때 코드 넘기게끔)
            for num in numbers {
                if num.numbersList == lottoNumbers.sorted() {
                    print("중복 번호 생성방지 코드 실행")
                    lottoNumbers = [] // 중복시 임시 저장 배열 초기화
                    repeat {
                        while lottoNumbers.count < 6 { // 다시 한번 랜덤 번호 생성
                            let randomNumber = Int.random(in: 1...45)
                            
                            if lottoNumbers.contains(randomNumber) {
                                lottoNumbers.append(randomNumber)
                            }
                        }
                    } while num.numbersList == lottoNumbers.sorted() // false일때 repeat-while 반복문 종료(번호가 같지 않을때까지)
                }
            }
        }
        // 생성완료 된 6개의 번호를 (모델)구조체 배열에 넣어준다.(구조체 배열은 append시 이렇게 인스턴스 생성해서 넣어줘야 함)
        numbers.append(NumbersGen(numbersList: lottoNumbers.sorted()))
       //return true
    }
    
    // 번호 리셋 메서드
    func numbersResetButtonTapped() {
        numbers.removeAll() // (모델)구조체 배열 초기화
        defaultsTemp.removeAll() // (하트 초기화)유저디폴츠 임시 저장 초기화
    }
    
    // (뷰의 번호 생성 화면에서) 번호 저장시 호출되는 메서드
    // 테이블뷰의 셀에서 인덱스를 가지고 모델의 isSaved를 토글 시킴
    // Result 타입 사용(연관값 미사용으로 성공인 경우 true 필요없이 Success는 Void 타입 사용)
    func setNumberSaved(row: Int) -> Result<Void, SaveError> {
        // (저장된)유저디폴츠 데이터가 없으면 이 바인딩은 nil이므로 아래 토글부터 실행됨
        // 먼저 바인딩이 완료되면 저장데이터가 10개 이상인지 확인하고 -> '체크했던 것'을 '체크 해제'하는 건지 확인해서 처리
        if let saveData = userDefaults.array(forKey: saveKey) as? [[Int]] {
            // MARK: 10개이상 처리, 체크 후 체크해제 처리, 중복 번호 처리
            if saveData.count >= 10 { // 유저디폴츠 데이터가 10개 이상이 되면
                return Result.failure(.overError) // error 처리(초과)
            }
            if saveData.contains(numbers[row].numbersList) { // (저장할 번호가)유저디폴츠에 이미 저장되어 있다면
                if numbers[row].isSaved { // 체크가 되어있다면 true일 것  (뷰에서 체크했다가 -> 체크해제시)
                    numbers[row].isSaved.toggle() // 토글로 false로 변환
                    userSavedSelectRemove(row: row) // (내부로직)유저디폴츠에서도 삭제
                    return Result.success(()) // Success(void)
                } else { // 중복된 번호가 체크될 시(뷰에서 체크했는데 -> 이미 저장되어있던 번호라면)
                    return Result.failure(.duplicationError) // error 처리(중복)
                }
            }
        }
        numbers[row].isSaved.toggle() // 모델에 인덱스로 접근해서 토글해서 모델의 isSaved true로 변경
        //(모델의)isSaved의 상태
        // ❓❓❓ (질문) if문 처리하는 거 그냥 빼는 것이 더 좋을까? (else 부분을 뭔가 안정성을 위해서 그대로 사용했는데.)
        if numbers[row].isSaved { // true일때 유저디폴츠에 저장
            userSaveSelectDataAdd(row: row)
        }else { // false일때 유저디폴츠에서 삭제(하트 해제) // (이 부분은 굳이 필요없다. 위에서 처리하니까. 그래도 한번 더 확인차 그대로 둠)
            userSavedSelectRemove(row: row)
        }
        
        return Result.success(()) // Success(void)
    }
    
    // MARK: Alert
    // Alert Title,Message,Bool 튜플로 받아와서 네임드 튜플로 설정(속성감시자)
    // alertSet의 값이 변경되면 속성감시자가 실행되면서 클로저 호출
    func alertPerformAction(title: String, message: String, cancelButtonUse: Bool) {
        alertSet = (title, message, cancelButtonUse) // 튜플타입으로 할당
    }
    
    // MARK: - Output
    
    // 전체 번호 배열 Count 리턴(테이블뷰 행)
    func getNumbersCount() -> Int {
        return numbers.count
    }
    
    // 생성된 번호 indexPath에 맞춰 (뷰의)테이블뷰에 전달
    func getNumbersList(row: Int) -> [Int] {
        return numbers[row].numbersList
    }
    
    // (저장 확인) 테이블뷰에게 전달하기 위한 현재 저장 상태 확인 메서드
    func getNumberSaved(row: Int) -> Bool {
        let isSaved = numbers[row].isSaved // number 구조체 배열의 현재 저장 상태를 전달
        return isSaved
    }
    
    // (번호 저장) 번호 생성화면에서 번호를 유저디폴츠와 현재 번호와 비교해서 있는지 없는지 확인
    // 생성 화면에서 번호 저장 후 '내 번호' 화면에서 번호 저장을 해제했을 때 생성 화면에서도 해당 번호의 하트가 지워지도록.
    // 테이블뷰 메서드에서 셀을 다시 그릴때마다 확인(Bool 리턴)
    func isBookmarkNumbers(numbers: [Int]) -> Bool {
        if let saveData = userDefaults.array(forKey: saveKey) as? [[Int]] {
            if saveData.contains(numbers) {
                return true
            }
        }
        return false
    }
    // (번호 저장) isBookmarkNumbers 메서드에서 false 반환시 테이블뷰 셀 메서드에서 indexPath를 가지고 해당 번호의 isSaved를 false로 변경
    func isBookmarkUnsavedToggle(row: Int) {
        numbers[row].isSaved = false
    }
    
    
    
    
    // MARK: - 뷰모델 내부 로직들
    
    
    // (유저디폴츠)번호 저장 메서드(하트 선택)
    private func userSaveSelectDataAdd(row: Int) {
        defaultsTemp.removeAll() // (유저디폴츠)임시배열 초기화
        
        if let saveData = userDefaults.array(forKey: saveKey) as? [[Int]] {
            defaultsTemp = saveData // 유저디폴츠 데이터를 일단 임시 저장 배열에 넣어주고
        }
        
        defaultsTemp.append(numbers[row].numbersList) // 선택된 번호 배열을 추가
        userDefaults.setValue(defaultsTemp, forKey: saveKey) // 유저디폴츠에 임시 저장된 배열로 다시 설정
    }
    
    // (유저디폴츠)저장된 번호 삭제 메서드(하트 선택 해제)
    private func userSavedSelectRemove(row: Int) {
        if let saveData = userDefaults.array(forKey: saveKey) as? [[Int]] {
            for value in saveData { // 유저디폴츠 데이터로 반복문 돌려서
                if numbers[row].numbersList == value { // 현재 선택해제 된 번호의 값과 같은지 찾고
                    if let index = defaultsTemp.firstIndex(of: value) { // 현재 값이 임시배열에서 몇번째 인덱스값인지 찾고
                        defaultsTemp.remove(at: index) // 임시배열에서 인덱스 기준으로 삭제
                    }
                }
            }
            userDefaults.set(defaultsTemp, forKey: saveKey) // 정리된 상태의 임시배열로 유저디폴츠에 다시 넣어줌
        }
    }
    
}



