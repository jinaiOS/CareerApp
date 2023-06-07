//
//  Navigatable.swift
//  CareerApp
//
//  Created by 김지은 on 2023/05/10.
//

import Foundation
import UIKit

protocol Navigatable {
    func changeInitViewController(type : StartType)
}
/**
 @enum StartType
 
 @brief  화면시작 지점 구분 enum
 */
enum StartType : String {
    case SignIn = "SignIn" // 로그인이 필요한 화면
    case Main = "Main" // 자동 로그인
    case SplashAuthority = "SplashAuthority" // 권한요청안내 화면
}

extension Navigatable where Self: UIViewController {
   
    /**
     @brief storyBoard를 변경한다.
     */
    func changeInitViewController(type : StartType) {
        AppDelegate.applicationDelegate.tabBarController = nil
        switch type {
            // 네비게이션
        case .SignIn:
            let signInVC = SignInViewController.instantiate(storyboard: .SignIn)
            AppDelegate.applicationDelegate.navigationController = UINavigationController.init(rootViewController: signInVC);
        case .Main:
            let storyBoard = UIStoryboard(name: type.rawValue, bundle: nil)
            AppDelegate.applicationDelegate.navigationController = nil
            AppDelegate.applicationDelegate.tabBarController = nil
            let navigationController : UINavigationController?
            navigationController =  storyBoard.instantiateInitialViewController() as? UINavigationController
            if  navigationController?.topViewController is UITabBarController {
                AppDelegate.applicationDelegate.tabBarController = navigationController!.topViewController as? BaseTabbarController
            }
            AppDelegate.applicationDelegate.navigationController = navigationController
        case .SplashAuthority:
            let splachVC = SplashAuthorityPopupViewController.instantiate(storyboard: .SplashAuthorityPopup)
            AppDelegate.applicationDelegate.navigationController = UINavigationController.init(rootViewController: splachVC);
        }
        
        //네비게이션바 히든
        AppDelegate.applicationDelegate.navigationController?.isNavigationBarHidden = true
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
                AppDelegate.applicationDelegate.window?.rootViewController?.view.alpha = 0
        }) { (finished) in
            DispatchQueue.main.async {
                AppDelegate.applicationDelegate.window?.rootViewController = AppDelegate.applicationDelegate.navigationController
                    AppDelegate.applicationDelegate.window?.rootViewController?.view.alpha = 0
                UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
                    AppDelegate.applicationDelegate.window?.rootViewController?.view.alpha = 1
                }, completion: { (finished) in
                })
            }
        }
    }
    /**
     @brief deleteCount만큼 뒤로 이동한다. 네비게이션 이동(이전단계로 이동)
     
     @param animated - 애니메이션 여부
     
     @param deleteCount - 삭제할 스택의 수 (입력하지 않으면 기본적으로 바로 앞으로 이동한다)
     
     @param completion - 실행 후 적용할 closure
     */
    func navigationPopViewController(animated : Bool = true, deleteCount : Int = 1, completion : (() -> (Void))? = nil)
    {
        let array = self.navigationViewControllers()
        
        if (array.count - deleteCount) <= 1
        {
            //쌓여있는 스택의 수보다 삭제하려는 수가 많으면 메인으로 이동한다.
            AppDelegate.applicationDelegate.navigationController?.popToRootViewController(animated: true)
            //            self.navigationController?.popToRootViewController(animated: true)
        }
        else
        {
            //쌓여있는 스택에서 count만큼 삭제 한 viewcontroller로 이동한다.
            var mArr = Array<UIViewController>()
            for index in 0..<array.count
            {
                if array.count - deleteCount == index
                {
                    break
                }
                mArr.append(array[index])
            }
            
            if mArr.count > 0
            {
                AppDelegate.applicationDelegate.navigationController?.popToViewController(mArr.last!, animated: true)
            }
        }
        completion?()
    }
    
    func navigationPushViewController(_ viewController: UIViewController, animated : Bool = true, completion : (() -> (Void))? = nil) {
        AppDelegate.applicationDelegate.navigationController?.pushViewController(viewController, animated: animated, completion: {
            completion?()
        })
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
        
        guard var controllerArr = AppDelegate.applicationDelegate.navigationController?.viewControllers else {return}
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
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
        AppDelegate.applicationDelegate.navigationController?.setViewControllers(controllerArr, animated: withAnimation)
        CATransaction.commit()
    }
}
