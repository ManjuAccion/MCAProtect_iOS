//
//  MCABaseViewController.swift
//  MCAProtect
//
//  Created by Manjunath on 07/02/17.
//  Copyright © 2017 Accionlabs. All rights reserved.
//

import UIKit
import MessageUI
import Alamofire


class MCABaseViewController: UIViewController,MFMailComposeViewControllerDelegate {
    
    var activityView:UIView!
    var activityIndicatorCount = 0
    var  spinner : UIImageView!

    
    func startNetworkReachabilityObserver() {
        let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")
        reachabilityManager?.listener = { status in
            
            switch status {
                
            case .notReachable:
                print("The network is not reachable")
                
            case .unknown :
                print("It is unknown whether the network is reachable")
                
            case .reachable(.ethernetOrWiFi):
                print("The network is reachable over the WiFi connection")
                
            case .reachable(.wwan):
                print("The network is reachable over the WWAN connection")
                
            }
        }
        
        // start listening
        reachabilityManager?.startListening()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startNetworkReachabilityObserver()
        print("---Controller====>//",self.description)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated);
        
      
        self.view.setNeedsLayout();
    }


    @IBAction func backButtonPressed (_ : Any)
    {
        self.navigationController?.popViewController(animated: true);
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    public func emailButtonTapped(emailString : String)
    {
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients([emailString])
                mail.setMessageBody("", isHTML: true)
                
                present(mail, animated: true)
            } else {
                // show failure alert
            }
        }
        
        func mailComposeController(_ controller:MFMailComposeViewController , didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true)
    }
    
    func callButtonTapped(phoneNumber: String!)
    {
        let alertViewController = UIAlertController(title : "", message : phoneNumber.toUSPhoneNumberFormat(), preferredStyle : .alert)
        alertViewController.view.tintColor = ColorConstants.red
        alertViewController.addAction(UIAlertAction(title : "Cancel" , style : .default , handler : nil))
        
        alertViewController.addAction(UIAlertAction(title : "Call" , style : .default , handler : { action in
            
            if let url = NSURL(string: "tel://\(phoneNumber!)"), UIApplication.shared.canOpenURL(url as URL) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open((url as URL),  options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url as URL)
                }
            }
            
        }))

        present(alertViewController, animated: true , completion: nil)

    }
    
    func checkNetworkConnection() -> Bool
    {
        if MCAReachability.isConnectedToNetwork() == false {
            let alertViewController = UIAlertController(title : "No Internet Connection", message : "Make sure your device is connected to the internet.", preferredStyle : .alert)
            alertViewController.addAction(UIAlertAction(title : "OK" , style : .default , handler : nil))
            self.present(alertViewController, animated: true , completion: nil)
        }
        
        return MCAReachability.isConnectedToNetwork()
    }
    

    func showActivityIndicator() {
    
        
        UIApplication.shared.keyWindow?.viewWithTag(987)?.removeFromSuperview()
        self.view.layoutIfNeeded();
        if  nil == activityView {
            
            activityView = UIView(frame: self.view.bounds)
            activityView.tag = 987;
            activityView.backgroundColor = UIColor.init(patternImage:UIImage(named: "transparentBg")!)
            activityView.alpha = 1.0
            let bgView = UIView(frame: activityView.bounds)
            bgView.backgroundColor = UIColor.clear
            bgView.alpha = 1.0
            activityView.addSubview(bgView)
             spinner = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
            spinner.contentMode = .scaleAspectFit
            spinner.image = UIImage(named: "splashLogoWhite")
            spinner.alpha = 1.0
            activityView.addSubview(spinner)
            spinner.center = self.view.center
            spinner.backgroundColor = UIColor.clear
            self.addRotation(forLayer: spinner.layer)
        }

        self.addRotation(forLayer: spinner.layer)
        UIApplication.shared.keyWindow?.addSubview(activityView)

        
    }

    
    func stopActivityIndicator() {
        spinner.layer.removeAllAnimations()

        self.activityView.removeFromSuperview()

        UIView.animate(withDuration: 0.2, animations:
        {
        }, completion: { (true: Bool) in
        })
    }
    
    func addRotation(forLayer layer : CALayer) {
        
        let rotation : CABasicAnimation = CABasicAnimation(keyPath:"transform.rotation.y")
        
        rotation.duration = 0.5
        rotation.isRemovedOnCompletion = false
        rotation.repeatCount = HUGE
        rotation.fillMode = kCAFillModeForwards
        rotation.fromValue = NSNumber(value: 0.0)
        rotation.toValue = NSNumber(value: 2 * 3.14 )
        rotation.isRemovedOnCompletion = false
        rotation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        
        layer.add(rotation, forKey: "rotation")
    }

    
}
