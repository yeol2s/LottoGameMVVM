//
//  NumberBallListViewModel.swift
//  LottoGameMVVM
//
//  Created by 유성열 on 12/16/23.
//

import UIKit

// ❓❓❓ 공 변환 클래스 여러 뷰에서 접근하니까 뷰모델-커먼뷰모델에 속하게 하는게 올바른건가?
// 번호를 받아서 공 모양으로 변환해주는 UIStackView
final class NumberBallListViewModel: UIStackView {
    // 6개 번호 배열로 받을때
    func displayNumbers(_ numbers: [Int]) {
        // 기존 하위뷰 제거
        // 디스플레이 콘텐츠에 대한 뷰를 준비하기 위한 깨끗한 상태를 보장하는 일반적인 방법
        // removewFromSuperView() - 해당 뷰가 현재 부모 뷰에서 제거되며 뷰 계층 구조에서 제거됨
        // 메모리에서 제거되는 작업은 아님(다른 객체가 뷰에 대한 강한 참조를 가지고 있지 않다면 해당 뷰는 메모리에서 해제되긴 함 - 한마디로 nil)
        // 한마디로 새로운 공 모양의 숫자를 표시하기 전에, 기존의 숫자를 모두 지워 새로운 숫자를 표시
        // 이걸 안하면 테이블뷰 셀이 추가로 생성될 때 번호가 겹침
        // forEach 고차함수로 각각을 가지고 일을하고 끝냄(리턴타입 없음)
        self.subviews.forEach { $0.removeFromSuperview() }
        
        let ballDiameter: CGFloat = 40 // 공의 지름(공 크기)
        let ballRadius: CGFloat = ballDiameter / 2 // 공의 반지름
        
        var arrangedSubViews: [UIView] = []
        
        // 파라미터로 받은 숫자 배열을 반복시켜서 각 숫자에 대한 공 모양 UILabel을 생성
        for number in numbers {
            let ball = UILabel()
            ball.text = "\(number)"
            ball.textAlignment = .center
            ball.layer.cornerRadius = ballRadius // 원 모양으로 깎아줌
            ball.layer.masksToBounds = true // 경계를 벗어나는 부분 잘라내기
            ball.font = UIFont.boldSystemFont(ofSize: 16)
            ball.textColor = .white
            ball.widthAnchor.constraint(equalToConstant: ballDiameter).isActive = true
            ball.heightAnchor.constraint(equalToConstant: ballDiameter).isActive = true
            // 여기서 UILabel 의 translatesAutoresizingMaskIntoConstraints = false (즉 Autoresizing Mask를 비활성화)를 안해줘도 되는 이유는
            // UIStackView로 레이아웃을 구성하고 있고, UIStackView는 자체적으로 오토레이아웃을 사용하여 하위뷰를 배치하고 관리하기 때문
            
            // 번호 단위별 공의 색상 설정
            switch number {
            case 1...9:
                ball.backgroundColor = UIColor.systemPink
            case 10...19:
                ball.backgroundColor = UIColor.systemOrange
            case 20...29:
                ball.backgroundColor = UIColor.systemBrown
            case 30...39:
                ball.backgroundColor = UIColor.systemIndigo
            case 40...45:
                ball.backgroundColor = UIColor.systemGreen
            default:
                ball.backgroundColor = UIColor.white
            }
            arrangedSubViews.append(ball) // [UIView]에 공 모양 하나씩 추가(반복문으로)
        }
        self.spacing = 10 // 각 공 사이 간격 조절
        arrangedSubViews.forEach { self.addArrangedSubview($0) // 스택뷰에 UIView 하나씩 추가
            // forEach 고차함수는 각각을 가지고 일을하고 끝냄(배열 리턴하지않고, 리턴값이 없다.)
        }
    }
    
    // (보너스 포함)7개의 번호를 받을때(배열 + 정수)(오버로딩)
    func displayNumbers(_ numbers: [Int], bns bnsNumber: Int) {
        self.subviews.forEach { $0.removeFromSuperview() }
        
        let ballDiameter: CGFloat = 30 // 공의 지름 (스택뷰를 오버할 수 있어서 작게함)
        let ballRadius: CGFloat = ballDiameter / 2 // 공의 반지름
        
        func createBallNumbers(number: Int) -> UILabel {
            let ball = UILabel()
            ball.text = "\(number)"
            ball.textAlignment = .center
            ball.layer.cornerRadius = ballRadius // 원 모양으로 깎아줌
            ball.layer.masksToBounds = true // 경계를 벗어나는 부분 잘라내기
            ball.font = UIFont.boldSystemFont(ofSize: 16)
            ball.textColor = .white
            ball.widthAnchor.constraint(equalToConstant: ballDiameter).isActive = true
            ball.heightAnchor.constraint(equalToConstant: ballDiameter).isActive = true
            
            switch number {
            case 1...9:
                ball.backgroundColor = UIColor.systemPink
            case 10...19:
                ball.backgroundColor = UIColor.systemOrange
            case 20...29:
                ball.backgroundColor = UIColor.systemBrown
            case 30...39:
                ball.backgroundColor = UIColor.systemIndigo
            case 40...45:
                ball.backgroundColor = UIColor.systemGreen
            default:
                ball.backgroundColor = UIColor.white
            }
            return ball
        }
        
        // 여기서 파라미터로 받은 번호를 createBallNumbers 함수에 넣어준다.
        // forEach 고차함수는 각각 하나의 일처리를 하고 리턴하지 않는다.(배열 리턴도 x)
        numbers.forEach { num in
            let ball = createBallNumbers(number: num) // 6개의 일반번호를 넣어서 UILabel 공 모양으로 만들어서 ball에 넣고
            self.addArrangedSubview(ball) // UIStackView의 하나씩 하위뷰 배열로 넣어줌
            if num == numbers.last { // numbers의 마지막 Index요소가 num과 같을때 싫행
                let plusLabel = UILabel()
                plusLabel.text = " + "
                plusLabel.textAlignment = .center
                plusLabel.widthAnchor.constraint(equalToConstant: ballRadius).isActive = true
                self.addArrangedSubview(plusLabel) // 마지막 번호 이후 '+' 추가 (보너스 번호 표시 위해)
            }
        }
        
        let bonusNumber = createBallNumbers(number: bnsNumber) // 1개의 보너스 번호 넣어서 UILabel 공 모양으로 만들어서 bonusNumber에 넣고
        self.addArrangedSubview(bonusNumber) // UIStackView 하위뷰 배열에 마지막으로 추가
        
        self.spacing = 10 // UIStackView의 각 공 사이 간격 조절
    }

}
