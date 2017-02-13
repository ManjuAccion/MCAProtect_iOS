//
//  MCASetMPinVC.swift
//  MCAProtect
//
//  Created by Sarath NS on 2/10/17.
//  Copyright © 2017 Accionlabs. All rights reserved.
//

import UIKit

class MCASetMPinVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var newPinSecureInputView1: SecureInputView!
    @IBOutlet weak var newPinSecureInputView2: SecureInputView!
    @IBOutlet weak var newPinSecureInputView3: SecureInputView!
    @IBOutlet weak var newPinSecureInputView4: SecureInputView!
    @IBOutlet weak var newPinSecureInputTF: UITextField!
    @IBOutlet weak var confirmPinSecureInputView1: SecureInputView!
    @IBOutlet weak var confirmPinSecureInputView2: SecureInputView!
    @IBOutlet weak var confirmPinSecureInputView3: SecureInputView!
    @IBOutlet weak var confirmPinSecureInputView4: SecureInputView!
    @IBOutlet weak var confirmPinSecureInputTF: UITextField!
    @IBOutlet weak var setPinButton: UIButton!
    @IBOutlet weak var newPinSecureInputContainerView: UIView!
    @IBOutlet weak var confirmPinSecureInputContainerView: UIView!
    
    var activeTextField : UITextField?
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        // Hide the Navigation Bar Back Button
        
        let backButton = UIBarButtonItem(title: "",
                                         style: UIBarButtonItemStyle.plain,
                                         target: navigationController,
                                         action: nil)
        navigationItem.leftBarButtonItem = backButton

        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    //MARK: - Custom Functions
    
    func loadUI() {
        
        newPinSecureInputView1.inputImageView.isHidden = true
        newPinSecureInputView2.inputImageView.isHidden = true
        newPinSecureInputView3.inputImageView.isHidden = true
        newPinSecureInputView4.inputImageView.isHidden = true
        
        confirmPinSecureInputView1.inputImageView.isHidden = true
        confirmPinSecureInputView2.inputImageView.isHidden = true
        confirmPinSecureInputView3.inputImageView.isHidden = true
        confirmPinSecureInputView4.inputImageView.isHidden = true
        
        setPinButton.layer.cornerRadius = 5.0
        
        newPinSecureInputTF.becomeFirstResponder()
        
        
        let newPinContainerViewTapGesture = UITapGestureRecognizer(target: self, action:#selector(handleNewPinContainerViewTapGesture))
        newPinSecureInputContainerView.addGestureRecognizer(newPinContainerViewTapGesture)
        
        let confirmContainerViewTapGesture = UITapGestureRecognizer(target: self, action:#selector(handleConfirmPinContainerViewTapGesture))
        confirmPinSecureInputContainerView.addGestureRecognizer(confirmContainerViewTapGesture)
        
    }
    
    func handleNewPinContainerViewTapGesture() {
        newPinSecureInputTF.becomeFirstResponder()
    }
    
    func handleConfirmPinContainerViewTapGesture() {
        confirmPinSecureInputTF.becomeFirstResponder()
    }

    
    func registerForKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillBeShown(sender: NSNotification) {
        
        let info: NSDictionary = sender.userInfo! as NSDictionary
        let value: NSValue = info.value(forKey: UIKeyboardFrameBeginUserInfoKey) as! NSValue
        let keyboardSize: CGSize = value.cgRectValue.size
        let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
        var aRect: CGRect = self.view.frame
        aRect.size.height -= keyboardSize.height
        let activeTextFieldRect: CGRect? = activeTextField?.frame
        let activeTextFieldOrigin: CGPoint? = activeTextFieldRect?.origin
        if (!aRect.contains(activeTextFieldOrigin!)) {
            scrollView.scrollRectToVisible(activeTextFieldRect!, animated:true)
        }
    }
    
    func keyboardWillBeHidden(sender: NSNotification) {
        let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(64.0, 0, 0, 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    //MARK: - IBActions Functions
    
    @IBAction func setPinButtonTapped(_ sender: Any) {
        self.view.endEditing(true)

        if (newPinSecureInputTF.text?.isEmpty)! || (newPinSecureInputTF.text?.characters.count)! < 4 {
            presentAlertWithTitle(title: "Error", message: "Please enter new pin")
        }
        if (confirmPinSecureInputTF.text?.isEmpty)! || (confirmPinSecureInputTF.text?.characters.count)! < 4 {
            presentAlertWithTitle(title: "Error", message: "Please enter confirm pin")
        }
        if (newPinSecureInputTF.text?.characters.count == 4 && confirmPinSecureInputTF.text?.characters.count == 4) && newPinSecureInputTF.text == confirmPinSecureInputTF.text {
            let storyboard = UIStoryboard(name: "mPin", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MCAChangeMPinVCID") as! MCAChangeMPinVC
            navigationController?.pushViewController(vc,
                                                     animated: true)
        }
        else
        {
            presentAlertWithTitle(title: "Error", message: "mPin doesn't match")
        }
    }
    
    //MARK: - UITextFiled Delegates
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.characters.count <= 3 && range.location <= 3 {
            switch range.location {
                
            case 0:
                if string.isEmpty {
                    if textField.tag == 1
                    {
                        newPinSecureInputView1.inputImageView.isHidden = true
                    }
                    else
                    {
                        confirmPinSecureInputView1.inputImageView.isHidden = true
                    }
                }
                else {
                    if(textField.tag == 1)
                    {
                        newPinSecureInputView1.inputImageView.isHidden = false
                    }
                    else
                    {
                        confirmPinSecureInputView1.inputImageView.isHidden = false
                    }
                }
                
            case 1:
                if string.isEmpty {
                    if textField.tag == 1
                    {
                        newPinSecureInputView2.inputImageView.isHidden = true
                    }
                    else
                    {
                        confirmPinSecureInputView2.inputImageView.isHidden = true
                    }
                }
                else {
                    if(textField.tag == 1)
                    {
                        newPinSecureInputView2.inputImageView.isHidden = false
                    }
                    else
                    {
                        confirmPinSecureInputView2.inputImageView.isHidden = false
                    }
                }

            case 2:
                if string.isEmpty {
                    if textField.tag == 1
                    {
                        newPinSecureInputView3.inputImageView.isHidden = true
                    }
                    else
                    {
                        confirmPinSecureInputView3.inputImageView.isHidden = true
                    }
                }
                else {
                    if(textField.tag == 1)
                    {
                        newPinSecureInputView3.inputImageView.isHidden = false
                    }
                    else
                    {
                        confirmPinSecureInputView3.inputImageView.isHidden = false
                    }
                }

            case 3:
                if string.isEmpty {
                    if textField.tag == 1
                    {
                        newPinSecureInputView4.inputImageView.isHidden = true
                    }
                    else
                    {
                        confirmPinSecureInputView4.inputImageView.isHidden = true
                    }
                }
                else {
                    if(textField.tag == 1)
                    {
                        newPinSecureInputView4.inputImageView.isHidden = false
                    }
                    else
                    {
                        confirmPinSecureInputView4.inputImageView.isHidden = false
                    }
                }
            default:
                print("Default Value")
            }
            
            return true
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        activeTextField?.inputAccessoryView = inputToolbar
        activeTextField?.autocorrectionType = UITextAutocorrectionType.no
        scrollView.isScrollEnabled = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        activeTextField = nil
//        scrollView.isScrollEnabled = false
        let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(64.0, 0, 0, 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.newPinSecureInputTF {
            textField.resignFirstResponder()
            confirmPinSecureInputTF.becomeFirstResponder()
        }
        else if textField == self.confirmPinSecureInputTF {
            textField.resignFirstResponder()
        }
        return true
    }
    
    lazy var inputToolbar: UIToolbar = {
        var toolbar = UIToolbar()
        toolbar.barStyle = .blackTranslucent
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
        
        var doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.inputToolbarDonePressed))
        var flexibleSpaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexibleSpaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        return toolbar
    }()
    
    func inputToolbarDonePressed() {
        if activeTextField == self.newPinSecureInputTF {
            self.newPinSecureInputTF.resignFirstResponder()
            confirmPinSecureInputTF.becomeFirstResponder()
        }
        else if activeTextField == self.confirmPinSecureInputTF {
            confirmPinSecureInputTF.resignFirstResponder()
        }
    }
}


