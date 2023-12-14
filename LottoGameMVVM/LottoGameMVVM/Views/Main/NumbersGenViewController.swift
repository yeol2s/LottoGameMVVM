//
//  NumbersGenViewController.swift
//  LottoGameMVVM
//
//  Created by 유성열 on 12/14/23.
//

import UIKit

// MARK: - 메인 뷰컨트롤러(번호 생성화면)
final class NumbersGenViewController: UIViewController {
    
    var viewModel: NumberGenViewModel! // ! -> 뷰모델 인스턴스 생성(IUO - 암시적 추출 옵셔널 : 벗겨질 준비가 되어있고, 변수에 담을때 자동으로 언래핑)
    
    weak var delegate: NumberGenViewControllerDelegate? // 델리게이트 대리자 지정 변수 선언

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

}
