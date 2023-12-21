//
//  Observable.swift
//  LottoGameMVVM
//
//  Created by 유성열 on 12/21/23.
//

import Foundation

// MARK: - 바인딩을 위한 옵저버블
// 속성감시자(Box 방식) - 클래스로 감싸진 데이터
class Observable<T> {
    
    // 핵심은 클래스로 데이터를 감싸고, 클래스 내부에다가 클로저를 내장시켜서 데이터가 바뀔때마다 클로저를 호출할 수 있도록 구현하는 것이 핵심
    
    // 값이 변할때마다 클로저 호출
    var value: T {
        didSet {
            listener?(value) // 클로저를 호출할때 현재 들어온 값을 넣어줌
        }
    }
    
    // '데이터 값'이 변할 때 함수 호출
    var listener: ((T) -> Void)?
    
    // 생성자
    init(_ value: T) {
        self.value = value
    }
    
    // 클로저를 input으로 받아서 listener에 클로저를 할당해준다.
    // 콜백함수를 받아서 단순히 listener 변수에 할당해주는 메서드
    // 여기서 @escaping은 외부의 함수를 받아서 외부의 변수에 저장하는 것이므로 사용되는 것
    func subscribe(listener: @escaping (T) -> Void) {
        //listener(value) // 이 부분은 값을 넣어서 할당해주는 것?
        self.listener = listener
    }
}

