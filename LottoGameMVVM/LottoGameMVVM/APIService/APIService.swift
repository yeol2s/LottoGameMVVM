//
//  APIService.swift
//  LottoGameMVVM
//
//  Created by 유성열 on 12/21/23.
//

import Foundation

// MARK: - API 통신하는 네트워크 서비스
// 싱글톤으로 구현(현재는 하나의 객체에서만 접근해서 굳이 싱글톤 패턴을 사용할 이유 없지만 공부를 위해 싱글톤 패턴으로 구현 사용)
final class APIService {
    
    static let shared = APIService() // 싱글톤 선언
    private init() {}
    
    // URL 통신 메서드(round는 회차입력) Result 타입으로 콜백
    func fechLotto(round: Int, completion: @escaping (Result<LottoInfo, NetworkError>) -> Void) {
        let lottoURL = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=" // 동행복권 URL+(=회차입력)
        let urlString = "\(lottoURL)\(String(round))"
        guard let url = URL(string: urlString) else { return } // URL 구조체 만들기
        
        // URLSession 만들기 + 작업부여 동시
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                completion(.failure(.networkingError))
                return
            }
            // data가 바인딩에 실패했다면 nil 콜백 / 성공하면 가드문 아래로 진행
            guard let safeData = data else {
                completion(.failure(.dataError))
                return
            }
            
            // 데이터 분석
            if let lottoInfo = self.parseJSON(safeData) {
                completion(.success(lottoInfo))
            } else {
                completion(.failure(.parseError))
            }
        }.resume() // task 작업 시작(일시정지된 상태로 resume을 호출해야 작업이 시작됨)
    }
    
    // JSON 데이터 파싱 메서드(데이터를 받아서 LottoInfo 구조체 형태로 리턴)
    private func parseJSON(_ lottoData: Data) -> LottoInfo? {
        let decoder = JSONDecoder() // JSONDecoder 객체 생성
        
        // JSONDecoder의 decode 메서드는 디코딩하는 메서드로 에러가 발생할 수 있다. do-try-Catch 문을 사용
        do {
            let decodeData = try decoder.decode(LottoAPI.self, from: lottoData) // lottoData(JSON)을 하나하나 LottoAPI로 바꾸고 decodeData에 할당
            
            // 1~6 번호 정수들을 배열로 만들어줌
            let numbers: [Int] = [decodeData.drwtNo1, decodeData.drwtNo2, decodeData.drwtNo3, decodeData.drwtNo4, decodeData.drwtNo5, decodeData.drwtNo6]
            
            // (사용자 정의 구조체)로또 구조체에 디코딩된 데이터를 넣어준다.
            let lottoData = LottoInfo(drawData: decodeData.drawDate, drwNo: decodeData.drawNo, firstWinMoney: addCommas(number: decodeData.firstWinMoney), firstTicketsCount: decodeData.firstTicketCount, numbers: numbers, bnusNum: decodeData.bnusNo)
            
            return lottoData // 생성된 LottoInfo 구조체 리턴
            
        } catch {
            print("JSON decoding error: \(error)")
            return nil
        }
    }
    
    // 숫자 포맷터 함수(천단위로 쉼표를 추가하고 문자열로 반환)
    private func addCommas(number: Int) -> String {
        let numberFormatter = NumberFormatter() // 넘버포맷터 객체 생성
        numberFormatter.numberStyle = .decimal // decimal 속성 설정(천 단위마다 쉼표 추가)
        
        // NSNumber는 Objective-C에서 숫자 데이터를 캡슐화하는 클래스(기본 데이터타입을 객체로 래핑?)
        if let formateedString = numberFormatter.string(from: NSNumber(value: number)) {
            return formateedString
        }
        return "\(number)" // 변환 실패시, 기본 문자열로 반환
    }
}


