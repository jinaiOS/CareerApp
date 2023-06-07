//
//  BaseViewController.swift
//  CareerApp
//
//  Created by 김지은 on 2023/05/10.
//

//import SnapKit
import UIKit

protocol BaseViewControllerProtocol {
    func viewModelInit()
}

extension BaseViewController: Navigatable, KeyboardFrameControlable, Presentable {}

public class BaseViewController<Model>: UIViewController, BaseViewControllerProtocol where Model : BaseViewModel {
    
    fileprivate var viewModelStorage : Model?
    var viewModel : Model? {
        get {
            return self.viewModelStorage
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        Log.d("Init in coder")
        // fatalError("init(coder:) has not been implemented")
    }
    
    /**
     이 함수 안에 viewModel을 init한 경우에는 setViewModel을 꼭 불러준다. 아닌 경우는 굳이 부를 필요 없으나, viewModelInit()함수는 꼭 사용해야 한다. 단 super.viewModelInit()은 쓰지 않는다.
     ViewDidLoad대신 사용해도 된다.
     */
    func viewModelInit() {
        fatalError("Must Override this Function")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        Log.d("Super Class ViewDidLoad")
        
        self.hideKeyboardWhenTappedAround()
        viewModelInit()
        
        if Constants.SCREEN_HEIGHT() <= 568 {
            self.seResolution()
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        Log.d("DEINIT in \(self)")
    }
    
    public func setViewModel(_ viewModelValue : Model) {
        self.viewModelStorage = viewModelValue
        Log.d("Set View Model.")
        self.bindingViewModel()
    }
    
    /**
     setViewModel을 사용하고 나면 호출되는 함수. super.bindingViewModel은 쓰지 않아도 된다.
     */
    public func bindingViewModel() { Log.d("Override binding View Model") }
    
    /// 스크린 높이가 568보다 같거나 작을 때 불린다. SE 1세대 및 그 이하 해상도(4") 대응을 위한 함수
    func seResolution() { Log.d("called if SCREEN_HEIGHT() <= 568") }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue =
            notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue

            let keyboardHeight : CGFloat
            if #available(iOS 11.0, *) {
                keyboardHeight = keyboardRectangle.height - self.view.safeAreaInsets.bottom
            } else {
                keyboardHeight = keyboardRectangle.height
            }
            Log.d("Keyboard height : \(keyboardHeight)")
            
            self.keyboardHeight(keyboardHeight, notification: notification)
        } else {
            self.keyboardHeight(0.0, notification: notification)
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        self.keyboardHeight(0.0, notification: notification)
    }
    
    public func keyboardHeight(_ value : CGFloat, notification : Notification?) {
        
    }
    
    /// 임시 구현한 토스트 생성기, BaseViewController를 상속한 뷰에서 가장 위에 등장한다. 키보드 상태가 적용되진 않으니 필요할 경우 수정 해야함.
    /// - Parameters:
    ///   - message: 토스트에 들어갈 메시지
    ///   - font: 글자 사이즈나 웨이트 삽입 (기본값은 18, .bold)
    ///   - backgroundColor: 배경 색 변경 시 (Black(0.6))
    func  showToast(message : String, font: UIFont = UIFont.systemFont(ofSize: 18, weight: .bold), backgroundColor: UIColor = UIColor(red: 65, green: 65, blue: 65).withAlphaComponent(0.85)) {
        let toastview = UIView(frame: CGRect(x: 20, y: self.view.frame.size.height-100, width: self.view.frame.size.width - 70, height: 60))
        toastview.layer.applySketchShadow(color: UIColor(red: 78, green: 78, blue: 78), alpha: 0.15, x: 0, y: 3, blur: 10, spread: 0)
        toastview.backgroundColor = backgroundColor
        toastview.layer.cornerRadius = 12;
        let toastLabel = UILabel()
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.clipsToBounds = true
        toastLabel.numberOfLines = 0
        toastLabel.allowsDefaultTighteningForTruncation = true
        toastview.addSubview(toastLabel)
        toastLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(12)
            make.bottom.trailing.equalToSuperview().offset(-12)
        }
        self.view.addSubview(toastview)
        toastview.snp.updateConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-74)
        }
        UIView.animate(withDuration: 0.35, delay: 1.35, options: .curveEaseOut, animations: {
            toastview.alpha = 0.0
        }, completion: {(isCompleted) in
            toastview.removeFromSuperview()
        })
    }
}
