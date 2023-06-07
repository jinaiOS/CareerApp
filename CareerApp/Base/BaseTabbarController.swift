//
//  BaseTabbarController.swift
//  CareerApp
//
//  Created by 김지은 on 2023/05/10.
//

import UIKit

class BaseTabbarController: UITabBarController {

    enum TabBarMenu : Int {
        case Home = 0
        case EcoStory
        case My
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabControllers()
        self.delegate = self
        // Do any additional setup after loading the view.
    }
    
    /**
     @brief TabBarController의 item 이미지 및 컬러 설정
     */
    func setTabControllers() {
        
        let homeVC = HomeViewController.instantiate(storyboard: .Home)
        
        let ecoVC = EcoStoryViewController.instantiate(storyboard: .EcoStory)
        
        let myMenuVC = MyMenuViewController.instantiate(storyboard: .MyMenu)
        
        //init tabbar controller
        let controllers = [homeVC, ecoVC, myMenuVC]
        self.viewControllers = controllers
        
        self.tabBar.borderWidth = 1
        self.tabBar.borderColor = #colorLiteral(red: 0.9176470588, green: 0.9176470588, blue: 0.9176470588, alpha: 1)
        
        // 홈
        self.tabBar.items![0].imageInsets = UIEdgeInsets.init(top: 7, left: 0, bottom: 0, right: 0)
        self.tabBar.items![0].image = UIImage.init(named: "icNaviHomeOff")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items![0].selectedImage = UIImage.init(named: "icNaviHomeOn")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items![0].title = "홈"
        
        // 에코뉴스
        self.tabBar.items![1].imageInsets = UIEdgeInsets.init(top: 7, left: 0, bottom: 0, right: 0)
        self.tabBar.items![1].image = UIImage.init(named: "icNaviEcostoryOff")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items![1].selectedImage = UIImage.init(named: "icNaviEcostoryOn")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items![1].title = "에코뉴스"
        
        // 마이페이지
        self.tabBar.items![2].imageInsets = UIEdgeInsets.init(top: 7, left: 0, bottom: 0, right: 0)
        self.tabBar.items![2].image = UIImage.init(named: "icNaviMyOff")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items![2].selectedImage = UIImage.init(named: "icNaviMyOn")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items![2].title = "마이페이지"
        
     
        //iOS13이상에서 탭바의 타이틀 컬러가 적용안되는 이슈 해결 modify by subway 20191024
        if #available(iOS 13, *) {
              let appearance = UITabBarAppearance()

              appearance.backgroundColor = .white
              appearance.shadowImage = UIImage()
              appearance.shadowColor = .white

              appearance.stackedLayoutAppearance.normal.iconColor = .black
              appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
              NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 0.5333333333, alpha: 1),
              NSAttributedString.Key.font: UIFont(name: "NotoSansKR-Medium", size: 12)!
              ]

              appearance.stackedLayoutAppearance.selected.iconColor = .blue
              appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
              NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.0862745098, green: 0.5411764706, blue: 0.4941176471, alpha: 1),
              NSAttributedString.Key.font: UIFont(name: "NotoSansKR-Medium", size: 12)!
              ]

              self.tabBar.standardAppearance = appearance

        } else {
            //init tabbar item textColor
                 UITabBarItem.appearance().setTitleTextAttributes([
                     NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 0.5333333333, alpha: 1),
                     NSAttributedString.Key.font: UIFont(name: FontType.NotoSansKr.Medium.getFontType, size: 12)!
                     ], for: .normal)
                 
                 UITabBarItem.appearance().setTitleTextAttributes([
                     NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.0862745098, green: 0.5411764706, blue: 0.4941176471, alpha: 1),
                     NSAttributedString.Key.font: UIFont(name: FontType.NotoSansKr.Medium.getFontType, size: 12)!
                     ], for: .selected)
        }
    }
    
    /**
     @brief TabBarController에서 입력받은 index로 이동
     
     @param TabBarController에서 이동하고자 하는 index
     */
    func moveToTabBarIndex(index : TabBarMenu) {
        AppDelegate.applicationDelegate.tabBarController!.selectedIndex = index.rawValue
    }
    
    
    /**
     @brief TabBarController에 현재 선택되어진 index를 리턴
     */
    func selectedTabBarIndex() -> TabBarMenu {
        return TabBarMenu(rawValue: AppDelegate.applicationDelegate.tabBarController!.selectedIndex) ?? TabBarMenu.Home
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension BaseTabbarController : UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 0 {
            //do your stuff
        }
        if tabBarIndex == 1 {
            print("tabBarIndex : \(viewController)")
            if let vc = viewController as? EcoStoryViewController {
                vc.tabMove(type: .EcoInformation)
            }
        }
        print("tabBarIndex : \(tabBarIndex)")
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let idx = tabBar.items?.firstIndex(of: item), tabBar.subviews.count > idx + 1, let imageView = tabBar.subviews[idx + 1].subviews.compactMap({ $0 as? UIImageView }).first else {
            return
        }
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.4, 0.9, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(0.3)
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        imageView.layer.add(bounceAnimation, forKey: nil)

    }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let currentIndex = tabBarController.selectedIndex
        print("currentIndex : \(currentIndex)")
        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
          return false // Make sure you want this as false
        }

        if fromView != toView {
          UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
        }

        return true
    }
}
