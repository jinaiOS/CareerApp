//
//  Presentable.swift
//  CareerApp
//
//  Created by 김지은 on 2023/05/10.
//

import Foundation
import UIKit

protocol Presentable {
    func presentViewController(_ vc: UIViewController, presentationStyle: UIModalPresentationStyle, transitionStyle: UIModalTransitionStyle, animated: Bool, completion: (() -> Void)?)
    func dismissViewController(animated : Bool, completion : (() -> (Void))?)
}

extension Presentable where Self: UIViewController {
    
    /// 뷰컨트롤러를 등장시킨다.
    /// - Parameters:
    ///   - vc: 띄우고 싶은 뷰 컨트롤러
    ///   - transitionStyle: 트랜지션스타일 - 기본값 coverVertical
    ///   - animated: animation 여부 - 기본값 true
    ///   - completion: 완료 후 실행될 completion 클로저 - 기본값 nil
    func presentViewController(_ vc: UIViewController, presentationStyle: UIModalPresentationStyle = .fullScreen, transitionStyle: UIModalTransitionStyle = .coverVertical, animated: Bool = true, completion: (() -> Void)? = nil) {
        vc.modalPresentationStyle = presentationStyle
        vc.modalTransitionStyle = transitionStyle
        self.present(vc, animated: animated, completion: completion)
    }
    
    /// 최상위 프레젠트된 뷰컨트롤러를 내린다.
    /// - Parameters:
    ///   - animated: animation 여부 - 기본값 true
    ///   - completion: 완료 후 실행될 completion 클로저 - 기본값 nil
    func dismissViewController(animated : Bool = true, completion : (() -> (Void))? = nil) {
        self.dismiss(animated: animated, completion: completion)
    }
}
