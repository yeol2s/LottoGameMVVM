//
//  LottoAPIViewModel.swift
//  LottoGameMVVM
//
//  Created by 유성열 on 12/21/23.
//

import Foundation

// MARK: - API 뷰 뷰모델

final class LottoAPIViewModel {
    
    // MARK: - 뷰모델 속성
    
    // (바인딩)LottoInfo 구조체(모델)를 Observable클래스로 감싸서 인스턴스 생성
    // LottoInfo 내부에 있는 데이터가 바뀔때마다 속성감시자가 내부에 있는 클로저를 호출
    var lottoAPI: Observable<LottoInfo> = Observable(LottoInfo(drawData: nil, drwNo: nil, firstWinMoney: nil, firstTicketsCount: nil, numbers: nil, bnusNum: nil)) // 기본적으로 nil로 일단 생성

    // MARK: - Input
    
    // API 뷰컨에서 호출
    func setupAPI() {
        fetchNewLotto(round: calculateLottoRound()) // 네트워킹 작업 요청
    }


    
    // MARK: - Logic
    
    // URL Session 네트워킹 호출해서 작업시작(Result로 결과 받아옴)
    private func fetchNewLotto(round: Int) {
        APIService.shared.fechLotto(round: round) { [weak self] result in
            switch result {
            case .success(let lotto):
                self?.lottoAPI.value = lotto // 데이터가 전달되면 Observable 객체의 속성감시자가 실행되면서 lotto 데이터 전달후 뷰에서 할당한 클로저 호출
            case .failure(let error):
                switch error {
                case .dataError:
                    print("데이터 에러")
                case .networkingError:
                    print("네트워킹 에러")
                case .parseError:
                    print("파싱 에러")
                }
            }
        }
    }
    
    // Date를 가지고 날짜별 회차로 조회가 자동으로 되게끔 설정하는 메서드
    // 날짜 + 시간 9시를 기준으로 회차를 바꾸고 리턴하면 될 것
    // 로또 1회차는 2002-12-07
    private func calculateLottoRound() -> Int {
        let dateFormatter = DateFormatter() // 데이터포맷터를 사용해서 날짜를 원하는 형식으로 파싱(날짜를 원하는 형식으로 표시하기 위한 문자열?)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let firstDrawDateString = "2002-12-07 21:00:00" // 첫 번째 추첨일 및 시간(1회차)
        guard let firstDrawDate = dateFormatter.date(from: firstDrawDateString) else { return 0 } // 첫번째 추첨 날짜 형식을 Date 객체로 변환하는 메서드(날짜 형식이 맞지 않는 경우 에러 처리)(변환된 결과가 옵셔널 Data? 형식임 그래서 언래핑)
        
        let currentData = Date() // Data 구조체를 사용해서 현재 날짜와 시간을 가져옴
        let calender = Calendar.current // Calender 구조체를 사용해서 현재의 달력을 가져옴
        // ⭐️Set - 집합(컬렉션) (왜 파라미터값을 Set으로 받지?)
        //Calendar.Component.weekOfYear (열거형으로 되어있음 그리고 Set으로 되어있다?? 뭐지)
        //calender.dateComponents(<#T##components: Set<Calendar.Component>##Set<Calendar.Component>#>, from: <#T##Date#>, to: <#T##Date#>)
        // 어쨌든 dateComponents(.weekOfYear: from: to:) 함수는 두 날짜 사이의 주차 수를 계산하는 것
        let weeksBetween = calender.dateComponents([.weekOfYear], from: firstDrawDate, to: currentData).weekOfYear ?? 0 // 닐코얼레싱(nil이면 0을 제시)
        // .weekday는 주일
        // 현재 시간이 토요일 저녁 9시 이후인지 확인하여 회차를 결정
        // .component는 요소화 시키는 메서드 (.component(요소, from: Date))
        let currentWeekday = calender.component(.weekday, from: currentData) // 현재 요일 가져옴
        let currentHour = calender.component(.hour, from: currentData) // 현재 시간 가져옴
        
        // (현재날짜와 시간이)토요일인 경우 다음 회차로 이동
        if currentWeekday == 7 {
            if currentHour >= 21 {
                return weeksBetween + 1 // 토요일 저녁 9시 이후라면 다음 회차로 진행
            } else {
                return weeksBetween // 토요일 저녁 9시 이전이라면 현재 회차로 진행
            }
        } else {
            // 토요일이 아닌 경우 다음 회차로 이동
            return weeksBetween + 1
        }
    }
}


