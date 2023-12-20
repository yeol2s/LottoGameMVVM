//
//  NumberSaveViewModel.swift
//  LottoGameMVVM
//
//  Created by 유성열 on 12/19/23.
//

// 📌 Foundation으로 뷰모델에 UIKit 코드없는 것 확인
import Foundation

// MARK: - 번호 저장 뷰컨트롤러(내 번호) 뷰모델

final class NumberSaveViewModel {
    
    // MARK: - 뷰모델 속성
    
    // 유저디폴츠 관련 설정
    private let userDefaults = UserDefaults.standard // 유저디폴츠 사용을 위한 변수 생성(유저디폴츠의 싱글톤 인스턴스를 참조)
    private let saveKey: String = "MyNumbers" // 유저디폴츠 번호저장 키
    private var defaultsTemp: [[Int]] = [] // 유저디폴츠 데이터 임시공간 배열
    
    // ❓❓❓ 이 뷰모델에서는 딱히 모델을 갖고있지 않고 유저디폴츠에서 가져다 쓰는데 괜찮은건지?
    
    // MARK: - Output
    
    // 저장된 번호 카운트(테이블뷰 셀 표시)
    func getSaveDataCount() -> Int {
        return defaultsTemp.count
    }
    
    // 유저디폴츠의 현재 저장된 번호 전달(셀 인덱스 기준)(테이블뷰 셀 메서드에서 호출)
    func getSaveData(row: Int) -> [Int] {
        return defaultsTemp[row]
    }
    
    
    // MARK: - Input
    
    // 유저디폴츠에 저장된 번호를 가져와서 데이터 갱신(뷰에서 화면 다시 나타날때마다 호출)
    func loadSaveData() {
        if let saveData = userDefaults.array(forKey: saveKey) as? [[Int]] {
            defaultsTemp = saveData
        }
    }
    
    // 유저디폴츠에 저장된 번호를 삭제(체크 해제시)
    func setRemoveData(row: Int) {
        if var saveData = userDefaults.array(forKey: saveKey) as? [[Int]] {
            saveData.remove(at: row) // 유저디폴츠에서 인덱스 기준 번호 삭제
            
            userDefaults.set(saveData, forKey: saveKey) // 유저디폴츠에 데이터 다시 설정
            loadSaveData() // 재설정된 데이터 다시 임시배열에 넣어주는 메서드 호출
        }
    }
    
    // (유저디폴츠 초기화)저장된 번호 초기화
    func saveDataReset() {
        defaultsTemp.removeAll() // 임시 저장 배열 초기화
        userDefaults.removeObject(forKey: saveKey) // 유저디폴츠 초기화(키 기준)
    }
    
    // (직접 번호 추가 화면) 직접 번호 추가시 번호들 유저디폴츠에 전달
    func setSaveData(_ numbers: [Int]) {
        if let saveData = userDefaults.array(forKey: saveKey) as? [[Int]] {
            defaultsTemp = saveData // (먼저 유저디폴츠 데이터가 있을시)임시 저장 배열에 유저디폴츠 데이터 추가
        }
        defaultsTemp.append(numbers) // (직접)입력된 번호 임시배열에 담아주고
        userDefaults.set(defaultsTemp, forKey: saveKey) // 유저디폴츠에 다시 설정
    }
}
