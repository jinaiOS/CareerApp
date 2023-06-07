//
//  UINavigationViewController+Extension.swift
//  CareerApp
//
//  Created by 김지은 on 2023/05/11.
//

import UIKit

extension UINavigationController {
    func removeFromController<T: UIViewController>(type : T.Type) -> [UIViewController] {
        var controllerArr = self.viewControllers
        controllerArr = controllerArr.map({ element -> UIViewController? in
            if element.isKind(of: type) {
                return nil
            } else {
                return element
            }
        }).compactMap { $0 }
        return controllerArr
    }
    
    /**
     없에고 싶은 controller와 대체할 controller를 넣어서 사용 할 수 있는 함수
     ### Using Example: ###
     ```
     guard let naviController = self.navigationController,
     let vc = UIStoryboard(name: vcName, bundle: nil)
     .instantiateViewController(withIdentifier: vcName)
     as? RecordDiagnosisViewController
     else { return }
     naviController.removeAndReplaceController(
     PhotoDiagnosisViewController.self,
     replace: vc,
     inLast: true,
     withAnimation: true)
     ```
     - Parameters:
     - removeController: 없에고자 하는 ViewController.self를 넣는다.
     - replace: 변경하고자 하는 ViewController. default는 nil
     - inLast: replace 값을 어디에 넣을지. default는 true, true인 경우 가장 마지막에 추가되고, 아닌 경우는 removeController의 위치에 들어가게 된다.
     - withAnimation: animate를 할지 여부. default는 true
     */
    func removeAndReplaceController<T: UIViewController, N: UIViewController>(_ removeController : T.Type, replace: N? = nil, inLast: Bool = true, withAnimation: Bool = true, completion: @escaping () -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        var controllerArr = self.viewControllers
        Log.d("\(#function) :: controllerArr1 \(controllerArr)")
        controllerArr = controllerArr.map({ element -> UIViewController? in
            if element.isKind(of: removeController) {
                if replace != nil, false == inLast {
                    return replace!
                } else {
                    return nil
                }
            } else {
                return element
            }
        }).compactMap {$0}
        Log.d("\(#function) :: controllerArr2 \(controllerArr)")
        if replace != nil, inLast {
            controllerArr.append(replace!)
        }
        self.setViewControllers(controllerArr, animated: withAnimation)
        CATransaction.commit()
    }
    
    // https://stackoverflow.com/questions/31878108/ios-swift-poptoviewcontroller-by-name
    func popToClass<T: UIViewController>(type: T.Type) -> Bool {
        for viewController in self.viewControllers {
            guard let _ = viewController as? T else { continue }
            self.popToViewController(viewController, animated: true)
            return true
        }
        return false
    }
    
    func popToViewControllerWithHandler(_ viewController: UIViewController, animated: Bool, completion: @escaping () -> Void) {
        // self.popToViewController(element, animated: true)
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.popToViewController(viewController, animated: animated)
        CATransaction.commit()
        
    }
    
    func popViewControllerWithHandler(_ animate: Bool = true, completion: @escaping () -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.popViewController(animated: animate)
        CATransaction.commit()
    }
    
    public func pushViewController(
        _ viewController: UIViewController,
        animated: Bool,
        completion: @escaping () -> Void) {
            pushViewController(viewController, animated: animated)
            
            guard animated, let coordinator = transitionCoordinator else {
                DispatchQueue.main.async { completion() }
                return
            }
            
            coordinator.animate(alongsideTransition: nil) { _ in completion() }
        }
    
    public func goBackSpecificViewWithCompletion(
        _ viewController: AnyClass,
        animated: Bool = true,
        _ completion: @escaping() -> Void,
        _ notComplete: @escaping() -> Void) {
            var compBool = false
            for element in self.viewControllers {
                if element.isKind(of: viewController.self) {
                    compBool = true
                    self.popToViewControllerWithHandler(element, animated: animated) {
                        completion()
                        return
                    }
                    break
                }
            }
            if !compBool {
                notComplete()
            }
        }
    
    func popToRootViewController(animated: Bool = true, completion: @escaping () -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popToRootViewController(animated: animated)
        CATransaction.commit()
    }
}

extension UINavigationController : UIGestureRecognizerDelegate {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        /// 기존 네비게이션 바를 지우면 스와이프제스쳐가 먹지 않으므로 새로 할당해줘야한다.
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
