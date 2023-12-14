//
//  NumberGenViewModel.swift
//  LottoGameMVVM
//
//  Created by 유성열 on 12/14/23.
//

import UIKit

// MARK: - 메인 뷰컨트롤러 델리게이트 패턴(컨테이너뷰컨과 통신을 위해)
// 탭을 눌렀을때 전달을 위한 프로토콜
protocol NumberGenViewControllerDelegate: AnyObject { // AnyObject로 클래스타입만
    func didTapMenuButton() // (요구사항 메서드)메뉴 버튼 누를시
}

// MARK: - 메인 뷰컨트롤러(번호 생성) 뷰모델
final class NumberGenViewModel {
    
    private let userDefaults = UserDefaults.standard // 유저디폴츠 사용을 위한 변수 생성(유저디폴츠의 싱글톤 인스턴스를 참조)
    private let saveKey: String = "MyNumbers" // 유저디폴츠 번호저장 키
    private var defaultsTemp: [[Int]] = [] // 유저디폴츠 데이터 임시공간 배열
    
    var numbers: [NumbersGen] = [] // 모델 인스턴스 생성
    
    
    // MARK: - Input
    
    // 번호 생성 메서드(생성 버튼 누를시)
    func generateNumbersTapped() -> Bool {
        var lottoNumbers: [Int] = [] // 번호 생성시마다 번호 임시 저장
        
        guard numbers.count <= 9 else { return false } // 테이블뷰에 (모델)번호 리스트가 10개이상 생성되지 않게 guard문 처리
        
        while lottoNumbers.count < 6 { // 임시 저장 배열의 번호가 6개가 될때까지 반복
            let randomNumber = Int.random(in: 1...45)
            
            if !lottoNumbers.contains(randomNumber) {
                lottoNumbers.append(randomNumber) // 생성된 번호가 임시 배열에 포함되지 않는 경우에만 저장
            }
        }
        
        // ❓ (성준 질문) 이렇게 중복 번호 방지하는 것 괜찮은 로직인가?
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
        return true
    }
    
    // 번호 리셋 메서드
    func resetNumbersButtonTapped() {
        numbers.removeAll() // (모델)구조체 배열 초기화
        defaultsTemp.removeAll() // (하트 초기화)유저디폴츠 임시 저장 초기화
    }
    
    // 이어서 구현하자..
    
    // MARK: - Output
    
    // 전체 번호 배열 Count 리턴(테이블뷰 행)
    func getNumbersCount() -> Int {
        return numbers.count
    }




    
    
}



