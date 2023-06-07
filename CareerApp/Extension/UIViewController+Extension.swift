//
//  UIViewController+Extension.swift
//  CareerApp
//
//  Created by 김지은 on 2023/05/11.
//

import UIKit

extension UIViewController {
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    /*      Alert       */
    func alert(message: String, title: String = "", OKAction:@escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okTab = UIAlertAction(title: "확인", style: .default, handler: { _ in
            OKAction()
        })
        alertController.addAction(okTab)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // https://stackoverflow.com/a/55801259/13049349
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            Log.d("Check T : :: \(T.self)")
            return T.init(nibName: String(describing: T.self), bundle: nil)
        }
        return instantiateFromNib()
    }
    
    func displayTokenExpiredMessage(okAction: @escaping() -> Void) {
        let alertController = UIAlertController(title: "", message: "로그인 토큰이 만료되었습니다. 다시 로그인 해주세요.", preferredStyle: .alert)
        let okTab = UIAlertAction(title: "확인", style: .default, handler: { _ in
            okAction()
        })
        alertController.addAction(okTab)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // https://stackoverflow.com/questions/23620276/how-to-check-if-a-view-controller-is-presented-modally-or-pushed-on-a-navigation
    var isModal: Bool {
        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController
        return presentingIsModal || presentingIsNavigation || presentingIsTabBar
    }
    
    /**
     @brief navigationController의 쌓여있는 스택을 리턴
     */
    func navigationViewControllers() -> [UIViewController]{
        return AppDelegate.applicationDelegate.navigationController!.viewControllers
    }
    
    /**
     @brief 최상위ViewController의 객체를 리턴
     */
    func applicationTopViewController() -> UIViewController? {
        return topViewController()
    }
    
    func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
