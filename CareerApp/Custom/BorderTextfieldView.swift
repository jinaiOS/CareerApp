//
//  CustomTextfieldView.swift
//  CareerApp
//
//  Created by 김지은 on 2023/06/02.
//

import UIKit

protocol BorderTextfieldViewDelegate : AnyObject {
    
    /// textfield should return
    func borderTextFieldShouldReturn(_ textField: UITextField) -> Bool
    
    /// textfield의 값이 바뀔때
    func borderTextFieldValueChanged(_ textfield: UITextField)
    
    /// textfield의 값입력 후
    func borderTextFieldDidEndEditing(_ textField: UITextField)
    
    /// textfield의 입력 시작
    func borderTextFieldDidBeginEditing(_ textField: UITextField)
    
    /// textfield의 입력 허용 validationCheck
    func borderTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    
    /// 에러인 상황
    func errorStatus(isError: Bool, view: BorderTextfieldView)
}

extension BorderTextfieldViewDelegate {
    /// textfield should return
    func borderTextFieldShouldReturn(_ textField: UITextField) -> Bool {return true}
    /// textfield의 입력 허용 validationCheck
    func borderTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {return true}
}

class BorderTextfieldView : UIView {
    
    /// 컨테이너뷰
    @IBOutlet var vContainer: UIView!
    
    /// border가 있는 view
    @IBOutlet var vBorder: UIView!
    
    /// textField
    @IBOutlet var tf: UITextField!
    
    /// 애니메이션으로 위로 이동하는 버튼
    @IBOutlet var btnAnim: UIButton!
    
    /// 애니메이션 이동을 위한 btnAnim 의 center Y constraint
    @IBOutlet var csrAnimCenter: NSLayoutConstraint!
        
    var placeHolderText = ""

    weak var tfDelegate : BorderTextfieldViewDelegate?
        
    /// 에러상태변환 체크
    var isError : Bool = false {
        didSet {
            if isError {
                vBorder.layer.borderWidth = 1
                vBorder.layer.borderColor = UIColor.borderRed.cgColor
                btnAnim.setTitleColor(.borderRed, for: .normal)
            } else {
                if tf.isFirstResponder {
                    vBorder.layer.borderWidth = 2
                    vBorder.layer.borderColor = UIColor.borderBlack.cgColor
                    btnAnim.setTitleColor(.borderBlack, for: .normal)
                } else {
                    vBorder.layer.borderWidth = 1
                    vBorder.layer.borderColor = UIColor.borderGray.cgColor
                    btnAnim.setTitleColor(.borderGray, for: .normal)
                }
            }
            tfDelegate?.errorStatus(isError: isError, view: self)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initLayout()
    }
    
    func initTextFieldText(placeHolder : String, delegate: BorderTextfieldViewDelegate) {
        btnAnim.setTitle(placeHolder, for: .normal)
        placeHolderText = placeHolder
        tf.placeholder = placeHolderText
        tfDelegate = delegate
    }
    private func initLayout() {
        Bundle.main.loadNibNamed("BorderTextfieldView", owner: self, options: nil)
        vContainer.layer.frame = self.bounds
        self.addSubview(vContainer)
        //textfield 패딩
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 17, height: frame.size.height))
        tf.leftView = paddingView
        tf.leftViewMode = .always
        //textfield cursor color change
        tf.tintColor = #colorLiteral(red: 0.1333333333, green: 0.1333333333, blue: 0.1333333333, alpha: 1)
        
        //버튼 패딩
        btnAnim.isHidden = true
        btnAnim.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        btnAnim.tintColor = .white
        btnAnim.isUserInteractionEnabled = false
        
        self.tf.addTarget(self, action: #selector(textfieldValueChanged(_:)), for: .editingChanged)
        vBorder.layer.borderWidth = 1
        vBorder.layer.borderColor = UIColor.borderGray.cgColor
        btnAnim.setTitleColor(.borderGray, for: .normal)
    }
    
    func textfieldEditing(isEditing : Bool)  {
        if isEditing {
            vBorder.layer.borderWidth = 2
            vBorder.layer.borderColor = UIColor.borderBlack.cgColor
            btnAnim.setTitleColor(.borderBlack, for: .normal)
        } else {
            vBorder.layer.borderWidth = 1
            vBorder.layer.borderColor = UIColor.borderGray.cgColor
            btnAnim.setTitleColor(.borderGray, for: .normal)
        }
    }
    
    func setDefaultAnimationText() {
        self.placeHolderAnimation(isEditing: true)
    }
    
    func placeHolderAnimation(isEditing : Bool) {
        if isEditing {
            btnAnim.isHidden = false
            self.csrAnimCenter.constant = 0
            tf.placeholder = ""
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) { [weak self] in
                guard let `self` = self else {return}
                self.csrAnimCenter.constant = -(self.frame.height / 2)
                self.layoutIfNeeded()
            } completion: { (finished) in
                
            }

        } else {
            self.csrAnimCenter.constant = -(self.frame.height / 2)
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) { [weak self] in
                guard let `self` = self else {return}
                self.csrAnimCenter.constant = 0
                self.btnAnim.alpha = 0
                self.layoutIfNeeded()
            } completion: {[weak self] (finished) in
                guard let `self` = self else {return}
                self.tf.placeholder = self.placeHolderText
                self.btnAnim.isHidden = true
                self.btnAnim.alpha = 1
            }
        }
    }
    @objc func textfieldValueChanged(_ textField: UITextField) {
        tfDelegate?.borderTextFieldValueChanged(textField)
    }
}
extension BorderTextfieldView : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tfDelegate?.borderTextFieldDidBeginEditing(textField)
        isError = false
        textfieldEditing(isEditing: true)

        if textField.text?.isEmpty ?? true {
            placeHolderAnimation(isEditing: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textfieldEditing(isEditing: false)
        if textField.text?.isEmpty ?? true {
            placeHolderAnimation(isEditing: false)
        }
        tfDelegate?.borderTextFieldDidEndEditing(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return tfDelegate?.borderTextFieldShouldReturn(self.tf) ?? true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return tfDelegate?.borderTextField(self.tf, shouldChangeCharactersIn: range, replacementString: string) ?? true
//        guard let text = textField.text else {return false}
//        let maxLength = 20
//               // 최대 글자수 이상을 입력한 이후에는 중간에 다른 글자를 추가할 수 없게끔 작동(25자리)
//               if text.count >= maxLength && range.length == 0 && range.location >= maxLength {
//                   return false
//               }
//
//               return true
    }
}

