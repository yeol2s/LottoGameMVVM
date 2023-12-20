//
//  Question.swift
//  LottoGameMVVM
//
//  Created by 유성열 on 12/15/23.
//

// MARK: - 추가로 궁금한거 여기에 정리!

import Foundation

struct Question {
    
    // MARK: - 질문

    // MVVM 패턴 적용한 것 전체적으로 어떤지(MVVM 패턴에서 폴더 정리 개념좀)
    
    // UIColor 정리하는 방법?
    
    // 테이블뷰,셀 - View - 뷰모델 지금 내가 한 방식이 MVVM 패턴에 준수하는건지?
    
    // 개선된 클로저 문법?
    
    // 비즈니스 로직의 정확한 개념(get set으로 사용했던 메서드들, 결국 데이터 처리하는 것이 비즈니스 로직이 아닌가?)
    // 비즈니스 로직을 뷰모델이 아닌 모델에서 정의하는게 올바른건가?(나는 뷰모델에서 했는데, 챗지피티에서는 모델에서 하는거라고 함)
    
}


struct Advice {
    // MARK: - 뷰 로직에 대해
    
    // 📌 뷰 로직은 뷰를 위한 간단한 로직이고 복잡하면 잘못짠거다라고 의심해보자.
    // 로직이라 할만한 것들은 뷰모델로 다 보내야됨. (아래와 같은 경우)
    
    // 메인 뷰컨 번호 생성버튼 셀렉터 메서드(뷰모델에게 전달)
//    @objc private func genButtonTapped() {
//        // 📌 이런 판단은 뷰모델에서 할 것
//        if viewModel.generateNumbersTapped() { // 번호가 10개 이하 일때만 true -> 번호 생성
//            numTableView.reloadData()
//        } else {
//            // 생성번호 10개이상 발생시 false -> Alert 발생(뷰모델에서 처리할 수 있도록 구현)
//            // 뷰모델에게 title, message, cancel action 사용유무를 전달해서 alert 띄움
//            viewModel.alertPerformAction(title: "생성된 번호 10개", message: "생성된 가능한 번호는 최대 10개입니다.", cancelButtonUse: false)
//        }
//    }
    
    // MARK: - 뷰모델 점검

    // 📌 뷰모델에서 import Foundation으로 변경해서 UIKit 코드없는 것 확인
    //import Foundation
    
    
    // MARK: - MVVM 패턴의 핵심은 바인딩
    
    // 📌 아래 getNumbersList 부분 같은 경우에는 바인딩 사용하는 것이 MVVM 패턴의 핵심
    
//    // UITableViewDataSource 확장
//    extension NumbersGenViewController: UITableViewDataSource {
//        // 테이블뷰 몇개의 데이터 표시할건지
//        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            return viewModel.getNumbersCount()
//        }
//        // 테이블뷰 셀을 어떻게 구성할건지(numberOfRowsInSection과 함께 동작한다.)(데이터의 개수에 따라 이 메서드가 동작하며 스크롫할때마다 재구성이 됨)
//        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            let cell = numTableView.dequeueReusableCell(withIdentifier: "NumCell", for: indexPath) as! NumTableViewCell // 재사용 셀 등록
//            
//            // 📌 getNumbersList 바인딩 해볼 것(데이터 바인딩) - 클로저로 해볼 것
//            let numbers = viewModel.getNumbersList(row: indexPath.row) // 현재 생성된 번호를 index 기준으로 가져와서 담음
//            cell.numbersBallListInsert(numbers: numbers) // 셀에게 번호 전달해서 공 모양의 번호로 표시 (❓❓❓ 이 부분 MVVM 패턴 준수하는건가?)
//            cell.selectionStyle = .none // 셀 선택시 회색으로 표시하지 않도록 설정
//            
//            // MARK: '번호 저장'누를 때 마다 '번호 저장 상태' 설정 (하트 표시 유무)
//            // (번호 생성화면 하트 눌러서) 번호 저장 (버튼은 셀에서 구현)
//            // 번호 저장 버튼 눌릴때 호출
//            cell.saveButtonPressed = { [weak self] senderCell in
//                guard let self = self else { return }
//                
//                let saveResult = self.viewModel.setNumberSaved(row: indexPath.row) // 번호 저장 메서드 호출 -> Rsult로 리턴
//                
//                switch saveResult {
//                case .success: // 연관값 미사용(void)
//                    // ❓❓❓ MVVM 패턴에서 셀에 set 메서드 이렇게 두는 것 괜찮은지?
//                    senderCell.setButtonStatus(isSaved: self.viewModel.getNumberSaved(row: indexPath.row))
//                case .failure(let error): // 에러 처리
//                    switch error {
//                    case .duplicationError:
//                        showAlert(title: "알림", message: "이미 저장된 번호입니다.", cancelButtonUse: false)
//                        break
//                    case .overError:
//                        showAlert(title: "알림", message: "저장된 번호가 10개입니다.", cancelButtonUse: false)
//                        break
//                    }
//                }
//            }
//            
//            // MARK: 셀 재사용시 마다 '번호 저장 상태' 설정 (하트 표시 유무)
//            // 셀 메서드 호출마다 현재 화면의 번호가 저장 상태인지 확인해서 하트 표시
//            cell.setButtonStatus(isSaved: viewModel.isBookmarkNumbers(numbers: numbers))
//            
//            if !viewModel.isBookmarkNumbers(numbers: numbers) {
//                viewModel.isBookmarkUnsavedToggle(row: indexPath.row)
//            }
//            return cell
//        }
//        
//    }
    
}
