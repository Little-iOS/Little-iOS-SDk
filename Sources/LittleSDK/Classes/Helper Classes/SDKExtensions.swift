//
//  SDKExtensions.swift
//  LittleSDK
//
//  Created by Gabriel John on 10/05/2021.
//

import UIKit
import GoogleMaps
import CommonCrypto
import CoreTelephony
import NVActivityIndicatorView
import MessageUI

let am = SDKAllMethods()
let cn = SDKConstants()

extension UIColor {
    
    convenience init(hex: String) {
        self.init(hex: hex, alpha:1)
    }
    
    convenience init(hex: String, alpha: CGFloat) {
        var hexWithoutSymbol = hex
        if hexWithoutSymbol.hasPrefix("#") {
            hexWithoutSymbol = String(hex.dropFirst())
        }
        
        let scanner = Scanner(string: hexWithoutSymbol)
        var hexInt:UInt32 = 0x0
        scanner.scanHexInt32(&hexInt)
        
        var r:UInt32!, g:UInt32!, b:UInt32!
        switch (hexWithoutSymbol.count) {
        case 3: // #RGB
            r = ((hexInt >> 4) & 0xf0 | (hexInt >> 8) & 0x0f)
            g = ((hexInt >> 0) & 0xf0 | (hexInt >> 4) & 0x0f)
            b = ((hexInt << 4) & 0xf0 | hexInt & 0x0f)
            break;
        case 6: // #RRGGBB
            r = (hexInt >> 16) & 0xff
            g = (hexInt >> 8) & 0xff
            b = hexInt & 0xff
            break;
        default:
            // TODO:ERROR
            break;
        }
        
        self.init(
            red: (CGFloat(r)/255),
            green: (CGFloat(g)/255),
            blue: (CGFloat(b)/255),
            alpha:alpha)
    }
}

public extension UIDevice {
    
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        printVal(object: "Identifier: \(ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS")")
        
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
#if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod touch (5th generation)"
            case "iPod7,1":                                 return "iPod touch (6th generation)"
            case "iPod9,1":                                 return "iPod touch (7th generation)"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPhone12,1":                              return "iPhone 11"
            case "iPhone12,3":                              return "iPhone 11 Pro"
            case "iPhone12,5":                              return "iPhone 11 Pro Max"
            case "iPhone12,8":                              return "iPhone SE (2nd generation)"
            case "iPhone13,1":                              return "iPhone 12 mini"
            case "iPhone13,2":                              return "iPhone 12"
            case "iPhone13,3":                              return "iPhone 12 Pro"
            case "iPhone13,4":                              return "iPhone 12 Pro Max"
            case "iPhone14,2":                              return "iPhone 13 Pro"
            case "iPhone14,3":                              return "iPhone 13 Pro Max"
            case "iPhone14,4":                              return "iPhone 13 mini"
            case "iPhone14,5":                              return "iPhone 13"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad (3rd generation)"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad (4th generation)"
            case "iPad6,11", "iPad6,12":                    return "iPad (5th generation)"
            case "iPad7,5", "iPad7,6":                      return "iPad (6th generation)"
            case "iPad7,11", "iPad7,12":                    return "iPad (7th generation)"
            case "iPad11,6":                                return "iPad (8th generation)"
            case "iPad12,2":                                return "iPad (9th generation)"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad11,4", "iPad11,5":                    return "iPad Air (3rd generation)"
            case "iPad13,1", "iPad13,2":                    return "iPad Air (4th generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad mini (5th generation)"
            case "iPhone14,1":                              return "iPad mini (6th generation)"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch) (1st generation)"
            case "iPad8,9", "iPad8,10":                     return "iPad Pro (11-inch) (2nd generation)"
            case "iPad13,5":                                return "iPad Pro (11-inch) (3rd generation)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch) (1st generation)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "iPad8,11", "iPad8,12":                    return "iPad Pro (12.9-inch) (4th generation)"
            case "iPad13,10":                               return "iPad Pro (12.9-inch) (5th generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
#elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
#else
            return identifier
#endif
        }
        
        return mapToDevice(identifier: identifier)
    }()
    
}

extension GMSMapView {
    func showMapStyleForView() {
        printVal(object: "isDark: \(UIApplication.topViewController()?.traitCollection.userInterfaceStyle == .dark)")
        do {
            if UIApplication.topViewController()?.traitCollection.userInterfaceStyle == .dark {
                if let styleURL = Bundle.module.url(forResource: "darkmode", withExtension: "json") {
                    self.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                } else {
                    printVal(object: "Unable to find style.json")
                }
            } else {
                if let styleURL = Bundle.module.url(forResource: "style", withExtension: "json") {
                    self.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                } else {
                    printVal(object: "Unable to find style.json")
                }
            }
        } catch {
            printVal(object:"One or more of the map styles failed to load. \(error)")
        }
    }
}

extension UIView {
    
    func appearAnimated() {
        self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1.0
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    func createLoadingCartypes() {
        
        self.removeAnimation()
        
        let backView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0),size: CGSize(width: self.bounds.width, height: self.bounds.height)))
        backView.tag = 1031
        backView.alpha = 0.0
        backView.backgroundColor = .white
        
        let color = SDKConstants.littleSDKThemeColor
        
        let activityView: NVActivityIndicatorView = NVActivityIndicatorView(frame: CGRect(origin: CGPoint(x: backView.bounds.minX, y: backView.bounds.minY),size: CGSize(width: 40, height: 40)), type: NVActivityIndicatorType.circleStrokeSpin, color:  color)
        activityView.center = CGPoint(x: CGFloat(self.bounds.midX), y: CGFloat(self.bounds.midY))
        activityView.startAnimating()
        backView.addSubview(activityView)
        self.addSubview(backView)
        self.bringSubviewToFront(activityView)
        UIView.animate(withDuration: 0.3) {
            backView.alpha = 1.0
        }
        self.layoutIfNeeded()
    }
    
    func createLoadingDanger() {
        
        self.removeAnimation()
        
        let color = SDKConstants.littleSDKDarkThemeColor
        
        let backView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0),size: CGSize(width: self.bounds.width, height: self.bounds.height)))
        backView.tag = 1030
        backView.alpha = 0.0
        backView.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        
        let activityView: NVActivityIndicatorView = NVActivityIndicatorView(frame: CGRect(origin: CGPoint(x: backView.bounds.minX, y: backView.bounds.minY),size: CGSize(width: 40, height: 40)), type: NVActivityIndicatorType.ballPulse, color:  color)
        activityView.center = CGPoint(x: CGFloat(self.bounds.midX), y: CGFloat(self.bounds.midY))
        activityView.startAnimating()
        backView.addSubview(activityView)
        self.addSubview(backView)
        self.bringSubviewToFront(activityView)
        UIView.animate(withDuration: 0.3) {
            backView.alpha = 1.0
        }
        self.layoutIfNeeded()
    }
    
    func createLoadingNormal() {
        
        self.removeAnimation()
        
        let color = SDKConstants.littleSDKThemeColor
        
        let backView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0),size: CGSize(width: self.bounds.width, height: self.bounds.height)))
        backView.tag = 1030
        backView.alpha = 0.0
        backView.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        
        let activityView: NVActivityIndicatorView = NVActivityIndicatorView(frame: CGRect(origin: CGPoint(x: backView.bounds.minX, y: backView.bounds.minY),size: CGSize(width: 40, height: 40)), type: NVActivityIndicatorType.ballPulse, color:  color)
        activityView.center = CGPoint(x: CGFloat(self.bounds.midX), y: CGFloat(self.bounds.midY))
        activityView.startAnimating()
        backView.addSubview(activityView)
        self.addSubview(backView)
        self.bringSubviewToFront(activityView)
        UIView.animate(withDuration: 0.3) {
            backView.alpha = 1.0
        }
        self.layoutIfNeeded()
    }
    
    func createLoadingWhite() {
        
        self.removeAnimation()
        
        let backView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0),size: CGSize(width: self.bounds.width, height: self.bounds.height)))
        backView.tag = 1030
        backView.alpha = 0.0
        backView.backgroundColor = .clear
        
        let activityView: NVActivityIndicatorView = NVActivityIndicatorView(frame: CGRect(origin: CGPoint(x: backView.bounds.minX, y: backView.bounds.minY),size: CGSize(width: 30, height: 30)), type: NVActivityIndicatorType.circleStrokeSpin, color:  .white)
        activityView.center = CGPoint(x: CGFloat(self.bounds.midX), y: CGFloat(self.bounds.midY))
        activityView.startAnimating()
        backView.addSubview(activityView)
        self.addSubview(backView)
        self.bringSubviewToFront(activityView)
        UIView.animate(withDuration: 0.3) {
            backView.alpha = 1.0
        }
        self.layoutIfNeeded()
    }
    
    func createLoadingClear() {
        
        self.removeAnimation()
        
        let backView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0),size: CGSize(width: self.bounds.width, height: self.bounds.height)))
        backView.tag = 1030
        backView.alpha = 0.0
        backView.backgroundColor = .clear
        
        let activityView: NVActivityIndicatorView = NVActivityIndicatorView(frame: CGRect(origin: CGPoint(x: backView.bounds.minX, y: backView.bounds.minY),size: CGSize(width: 30, height: 30)), type: NVActivityIndicatorType.ballPulse, color: UIColor.lightGray.withAlphaComponent(0.7))
        activityView.center = CGPoint(x: CGFloat(self.bounds.midX), y: CGFloat(self.bounds.midY))
        activityView.startAnimating()
        backView.addSubview(activityView)
        self.addSubview(backView)
        self.bringSubviewToFront(activityView)
        UIView.animate(withDuration: 0.3) {
            backView.alpha = 1.0
        }
        self.layoutIfNeeded()
    }
    
    func removeAnimation() {
        let subViewArray: [UIView]? = self.subviews
        for obj: UIView in subViewArray! {
            if obj.tag == 1030 || obj.tag == 1031 {
                UIView.animate(withDuration: 0.3, animations: {
                    obj.alpha = 0.0
                }) { (finished) in
                    (obj as AnyObject).removeFromSuperview()
                }
            }
        }
    }
    
}

extension UIViewController {
    
    func showAlertPreventingInteraction(title: String, message: String) {
        
        endEditSDK()
        
        showWarningAlert(title: title, message: message, dismissOnTap: false)
        
    }
    
    func getCarrierName() -> String! {
        // Setup the Network Info and create a CTCarrier object
        let networkInfo = CTTelephonyNetworkInfo()
        let carrier = networkInfo.subscriberCellularProvider
        
        // Get carrier name
        var carrierName = carrier?.carrierName
        
        if carrierName == nil {
            carrierName = ""
        }
        
        return carrierName
    }
    
    func getPhoneType() -> String {
        let modelName = UIDevice.modelName
        return modelName
    }
    
    func getAppVersion() -> String {
        //First get the nsObject by defining as an optional anyObject
        let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject?
        
        //Then just cast the object as a String, but be careful, you may want to double check for nil
        let version = nsObject as! String
        
        return version
        
    }
    
    func scaleImage(image: UIImage, size: Float) -> UIImage {
        let size = (image.size).applying(CGAffineTransform(scaleX: CGFloat(size), y: CGFloat(size)))
        let hasAlpha = false
        let scale: CGFloat = 0.0
        UIGraphicsBeginImageContextWithOptions(size, hasAlpha, scale)
        image.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage ?? UIImage()
    }
    
    func showAlerts(title: String, message: String) {
        
        endEditSDK()
        
        showWarningAlert(title: title, message: message)
        
    }
    
    @objc func endEditSDK() {
        self.view.endEditing(true)
    }
    
    @objc func dismissSwiftAlert() {
        
    }
    
    func removeLoadingPage() {
        DispatchQueue.main.async {
            if let view = self.view.viewWithTag(1010) {
                view.removeFromSuperview()
            }
        }
    }
    
    @objc func buttonAction(sender: UIButton!) {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                printVal(object: "Settings opened: \(success)")
            })
        }
    }
    
    func getKeyboardHeight(_ notification: NSNotification) -> CGFloat {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            return keyboardHeight
        }
        return 0.0
    }
    
    func removeAllObservers(array: [String]) {
        for each in array {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: each), object: nil)
        }
    }
    
    func createLoadingScreen() -> UIView {
        
        let loadBackGround = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(UIScreen.main.bounds.size.width), height: CGFloat(UIScreen.main.bounds.size.height)))
        loadBackGround.tag = 1010
        loadBackGround.backgroundColor = SDKConstants.littleSDKThemeColor
        
        let activityView: NVActivityIndicatorView = NVActivityIndicatorView(frame: CGRect(origin: CGPoint(x: 0, y: 0),size: CGSize(width: 40, height: 40)), type: NVActivityIndicatorType.ballPulse, color: .white)
        let superCenter = CGPoint(x: CGFloat(UIScreen.main.bounds.midX), y: CGFloat(UIScreen.main.bounds.midY))
        activityView.center = superCenter
        activityView.startAnimating()
        
        var value = 0.0
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2436, 1792, 2688:
                value = Double(UIScreen.main.bounds.size.height - 110.0)
            case 960, 1136, 1334, 1920, 2208:
                value = Double(UIScreen.main.bounds.size.height - 60.0)
            default:
                value = 0
            }
        }
        
        let button = UIButton()
        button.frame = CGRect(x: CGFloat(0), y: CGFloat(value), width: CGFloat(UIScreen.main.bounds.size.width), height: CGFloat(60))
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.setTitle("", for: .normal)
        
        let label = UILabel(frame: CGRect(x: CGFloat(0), y: CGFloat(value), width: CGFloat(UIScreen.main.bounds.size.width), height: CGFloat(60)))
        label.textAlignment = .center
        label.font =  UIFont(name: "AppleSDGothicNeo-Bold", size: 15.0)
        label.textColor = .white
        label.numberOfLines = 0
        label.text = "Connection is taking longer than usual.\nCheck your internet settings?"
        
        func checkIfLoaded() {
            loadBackGround.addSubview(label)
            loadBackGround.addSubview(button)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 40.0) {
            checkIfLoaded()
        }
        
        loadBackGround.addSubview(activityView)
        
        loadBackGround.layer.zPosition = .greatestFiniteMagnitude
        
        return loadBackGround
        
    }
    
    func rearrange<T>(array: Array<T>, fromIndex: Int, toIndex: Int) -> Array<T>{
        var arr = array
        let element = arr.remove(at: fromIndex)
        arr.insert(element, at: toIndex)
        
        return arr
    }
    
    func showGeneralErrorAlert() {
        
        self.view.endEditing(true)
        
        showWarningAlert(message: "Something went wrong.".localized)
        
    }
    
    @objc func proceedCall(phone: String) {
        let number = phone
        if number != "" {
            guard let url = URL(string: "telprompt://\(number)") else {
                return
            }
            UIApplication.shared.open(url, options: [:]) { didOpen in
                didOpen ? printVal(object: "Success") : self.showAlerts(title: "", message: "Error opening call prompt to the number \(number)")
            }
        } else {
            self.showAlerts(title: "", message: "Error opening call prompt. The number cannot be empty.")
        }
    }
    
    @objc func proceedEmail(email: String, delegate: MFMailComposeViewControllerDelegate) {
        
        showWarningAlert(title: "Write Email".localized, message: "Proceed to write an email to Little Customer Care?".localized, actionButtonText: "Write Email".localized) {
            let subject = "General Inquiry".localized
            let body = ""
            let recipients = [email]
            
            let mc: MFMailComposeViewController = MFMailComposeViewController()
            mc.mailComposeDelegate = delegate
            mc.setSubject(subject)
            mc.setMessageBody(body, isHTML: false)
            mc.setToRecipients(recipients)
            
            if MFMailComposeViewController.canSendMail() {
                self.present(mc, animated: true, completion: nil)
            }
        }
        
    }
    
    @objc func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func hideNavBarShadow() {
        if #available(iOS 13.0, *) {
            guard let navBarAppearance = self.navigationController?.navigationBar.standardAppearance else { return }
            navBarAppearance.shadowColor = .clear
            navBarAppearance.shadowImage = UIImage()
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        } else {
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        }
        
    }
    
    func changeNavBarAppearance(isLightContent: Bool) {
        
        if #available(iOS 13.0, *) {
            if isLightContent {
                let navBarAppearance = UINavigationBarAppearance()
                navBarAppearance.configureWithOpaqueBackground()
                navBarAppearance.backgroundColor = .themeColor
                navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.littleWhite]
                navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.littleWhite]
                navigationController?.navigationBar.standardAppearance = navBarAppearance
                navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
            } else {
                let navBarAppearance = UINavigationBarAppearance()
                navBarAppearance.configureWithOpaqueBackground()
                navBarAppearance.backgroundColor = .littleWhite
                navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.themeColor]
                navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.themeColor]
                navigationController?.navigationBar.standardAppearance = navBarAppearance
                navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
            }
        }
        
        if isLightContent {
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.tintColor = .littleWhite
            navigationController?.navigationBar.barTintColor = .themeColor
            navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 20.0),
                                                                       .foregroundColor: UIColor.littleWhite]
        } else {
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.tintColor = .themeColor
            navigationController?.navigationBar.barTintColor = .littleWhite
            navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 20.0),
                                                                       .foregroundColor: UIColor.themeColor]
        }
    }
    
    func showActionPicker(onView view: UIView, pickerTitle: String?, items: [PickerItem], actionButtonClosure:  ((_ index: Int, _ item: PickerItem) -> Void)? = nil) {
        self.view.endEditing(true)
        if !items.isEmpty {
            let vc = UIAlertController(title: pickerTitle, message: nil, preferredStyle: .actionSheet)
            for (index, item) in items.enumerated() {
                let alertAction = UIAlertAction(title: item.displayName, style: .default) { (alertAction: UIAlertAction!) in
                    actionButtonClosure?(index, item)
                }
                vc.addAction(alertAction)
            }
            
            let cancelAction = UIAlertAction(title: "dismiss".localized, style: .cancel, handler: {
                (alert: UIAlertAction!) -> Void in
            })
            
            vc.addAction(cancelAction)
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                vc.popoverPresentationController?.sourceView = view
                vc.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.size.width / 6.0, y: view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
            }
            self.present(vc, animated: true)
        }
    }
}

public extension UIApplication {
    
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

extension String {
    func cleanLocationNames() -> String {
        
        let string = self.folding(options: .diacriticInsensitive, locale: .current)
        let alphaNumericSet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789&,.- "
        let filteredCharacters = string.filter {
            return alphaNumericSet.contains(String($0))
        }
        return String(filteredCharacters)
        
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
        
    }
    
    func filterDigitsWithHyphenOnly() -> String {
        let aSet = NSCharacterSet(charactersIn:"0123456789-").inverted
        let compSepByCharInSet = self.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return numberFiltered
    }
    
    func filterDigitsOnly() -> String {
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = self.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return numberFiltered
    }
    
    func filterNumbersOnly() -> String {
        let aSet = NSCharacterSet(charactersIn:"0123456789.").inverted
        let compSepByCharInSet = self.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return numberFiltered
    }
    
    func escapedString() -> String
    {
        // Because JSON is not a subset of JavaScript, the LINE_SEPARATOR and PARAGRAPH_SEPARATOR unicode
        // characters embedded in (valid) JSON will cause the webview's JavaScript parser to error. So we
        // must encode them first. See here: http://timelessrepo.com/json-isnt-a-javascript-subset
        // Also here: http://media.giphy.com/media/wloGlwOXKijy8/giphy.gif
        let str = self.replacingOccurrences(of: "\u{2028}", with: "\\u2028")
            .replacingOccurrences(of: "\u{2029}", with: "\\u2029")
        // Because escaping JavaScript is a non-trivial task (https://github.com/johnezang/JSONKit/blob/master/JSONKit.m#L1423)
        // we proceed to hax instead:
        let data = try! JSONSerialization.data(withJSONObject:[str], options: [])
        let encodedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
        return encodedString.substring(with: NSMakeRange(1, encodedString.length - 2))
    }
}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
}

extension String {
    func hash256() -> String {
        let inputData = Data(utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        inputData.withUnsafeBytes { bytes in
            _ = CC_SHA256(bytes.baseAddress, UInt32(inputData.count), &digest)
        }
        return String((digest.makeIterator().compactMap { String(format: "%02x", $0) }.joined()).prefix(32))
    }
}

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Date {
    
    func customFormatted() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        dateFormatter.locale = Locale(identifier: Locale.current.languageCode ?? "en")
        return dateFormatter.string(from: self)
    }
    
    func timeAgoDisplay() -> String {
        let calendar = Calendar.current
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date()) ?? Date()
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date()) ?? Date()
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        
        if minuteAgo < self {
            let diff = Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
            if diff == 1 {
                return "1 sec ago"
            } else {
                return "\(diff) secs ago"
            }
        } else if hourAgo < self {
            let diff = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
            if diff == 1 {
                return "1 min ago"
            } else {
                return "\(diff) mins ago"
            }
        } else if dayAgo < self {
            let diff = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
            if diff == 1 {
                return "1 hr ago"
            } else {
                return "\(diff) hrs ago"
            }
        } else if weekAgo < self {
            let diff = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
            if diff == 1 {
                return "Yesterday"
            } else {
                return "\(diff) days ago"
            }
        }
        
        let diff = Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear ?? 0
        if diff == 1 {
            return "1 week ago"
            
        } else if diff > 4 {
            
            let presentFormatter = DateFormatter()
            presentFormatter.locale = Locale(identifier: Locale.current.languageCode ?? "en")
            presentFormatter.dateFormat = "MMMM dd"
            return presentFormatter.string(from: self)
            
        } else {
            return "\(diff) weeks ago"
        }
        
    }
    
    static func datesInRange(from fromDate: Date, to toDate: Date, by interval: Calendar.Component) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: interval, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
    
    func adding(_ component: Calendar.Component, value: Int, using calendar: Calendar = .current) -> Date {
        calendar.date(byAdding: component, value: value, to: self)!
    }
    
    func scheduleDateOnlyFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        formatter.locale = Locale(identifier: Locale.current.languageCode ?? "en")
        return formatter.string(from: self)
    }
    
}

extension String {
    var urlEncoded: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
    }
    
    func containsIgnoringCase(_ string: String) -> Bool {
        if let _ = self.range(of: string, options: .caseInsensitive) {
            return true
        }
        
        return false
    }
    
    func equalsIgnoringCase(_ string: String) -> Bool {
        return self.caseInsensitiveCompare(string) == .orderedSame
    }
    
    public func replacingLastOccurrenceOfString(_ searchString: String, with replacementString: String, caseInsensitive: Bool = true) -> String {
        let options: String.CompareOptions
        if caseInsensitive {
            options = [.backwards, .caseInsensitive]
        } else {
            options = [.backwards]
        }

        if let range = self.range(of: searchString, options: options, range: nil, locale: nil) {

            return self.replacingCharacters(in: range, with: replacementString)
        }
        return self
    }
}

public func typingStatus(text: String) {
    #warning("Show typing message")
    /*let message = text
    let color = SDKConstants.littleSDKThemeColor
    func alertConfig() -> SwiftMessages.Config {
        var config = SwiftMessages.defaultConfig
        config.duration = .forever
        config.presentationStyle = .top
        return config
    }
    
    let messageView = MessageView.viewFromNib(layout: .statusLine)
    messageView.configureTheme(backgroundColor: color, foregroundColor: .white, iconImage: nil, iconText: nil)
    messageView.bodyLabel?.font = UIFont(name: "SFUIDisplay-Regular", size: 14.0)
    messageView.bodyLabel?.text = message
    SwiftMessages.show(config: alertConfig(), view: messageView)*/
}

func getPhoneFaceIdType() -> Bool {
    var modelName = UIDevice.modelName
    modelName = modelName.replacingOccurrences(of: "Simulator ", with: "")
    switch modelName {
    case "iPhone X","iPhone XS","iPhone XS Max","iPhone XR","iPhone 11","iPhone 11 Pro","iPhone 11 Pro Max":
        return true
    case "iPhone 12 mini","iPhone 12","iPhone 12 Pro","iPhone 12 Pro Max":
        return true
    case "iPhone 13 mini","iPhone 13","iPhone 13 Pro","iPhone 13 Pro Max":
        return true
    case "iPad mini (6th generation)":
        return true
    default:
        return false
    }
    
}

func getImage(named name : String, bundle: Bundle = .module) -> UIImage? {
    let image = UIImage(named: name, in: bundle, compatibleWith: nil)
    return image
}

func getUserImage(userImage: UIImageView, bundle: Bundle) {
    let defaultImage = "default"
    userImage.sd_setImage(with: URL(string: am.getPicture()), placeholderImage: getImage(named: defaultImage, bundle: bundle))
}

func formatCurrency(_ str: String) -> String {
    let largeNumber = Double(str)
    let currency = ""
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = NumberFormatter.Style.currency
    numberFormatter.currencySymbol = currency
    if largeNumber != nil {
        return numberFormatter.string(from: largeNumber! as NSNumber) ?? ""
    } else {
        return str
    }
}

func printVal(object: Any) {
#warning("Check logs")
#if DEBUG
    //        print("______________________________________________________________________\n")
//            print("Little:", object)
    //        print("\n______________________________________________________________________")
#endif
}

extension UIColor {
    static let littleElevatedViews = UIColor(named: "littleElevatedViews", in: Bundle.module, compatibleWith: nil)!
    
    static let littleMovieCells = UIColor(named: "littleMovieCells", in: Bundle.module, compatibleWith: nil)!
    
    static let littleCellBackgrounds = UIColor(named: "littleCellBackgrounds", in: Bundle.module, compatibleWith: nil)!
    
//    static let themeColor = UIColor(named: "themeColor", in: Bundle.module, compatibleWith: nil)!
    
    static let littleLabelColor = UIColor(named: "littleLabelColor", in: Bundle.module, compatibleWith: nil)!
    
    static let littleSecondaryLabelColor = UIColor(named: "LittleSecondaryLabelColor", in: Bundle.module, compatibleWith: nil)!
    
    static let littleSecondaryLabelColor2 = UIColor(named: "LittleSecondaryLabelColor2", in: Bundle.module, compatibleWith: nil)!

    
    static let littleWhite = UIColor(named: "littleWhite", in: Bundle.module, compatibleWith: nil)!
    
    static let littleBlack = UIColor(named: "littleBlack", in: Bundle.module, compatibleWith: nil)!
    
    static var themeColor: UIColor = {
        if let color  = UIColor(named: "LittleSDKThemeColor", in: Bundle.main, compatibleWith: nil) {
            return color
        }
        
        return UIColor(named: "LittleSDKThemeColor", in: Bundle.module, compatibleWith: nil)!
    }()
    
    static let skyBlueLight = UIColor(named: "ColorSkyBlueLight", in: Bundle.module, compatibleWith: nil)!
}

extension UIImage {
    func renderResizedImage (_ newWidth: CGFloat) -> UIImage? {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        defer { UIGraphicsEndImageContext() }
        
        self.draw(in: CGRect(origin: .zero, size: newSize))
        return UIGraphicsGetImageFromCurrentImageContext()
        
    }
    
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return rotatedImage ?? self
        }
        
        return self
    }
    
    func tinted(with color: UIColor) -> UIImage? {
        defer { UIGraphicsEndImageContext() }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color.set()
        self.withRenderingMode(.alwaysTemplate).draw(in: CGRect(origin: .zero, size: self.size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
}

extension UIView {
    func dropShadowSubtle() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor(named: "littleBlack")?.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 2
    }
    
    func dropShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor(named: "littleBlack")?.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 6
    }
    
    func dropShadowBlack() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 6
    }
    
    func pinToView(parentView: UIView, leading: Bool = true, trailing: Bool = true, top: Bool = true, bottom: Bool = true) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: parentView.leadingAnchor).isActive = leading
        self.trailingAnchor.constraint(equalTo: parentView.trailingAnchor).isActive = trailing
        self.topAnchor.constraint(equalTo: parentView.topAnchor).isActive = top
        self.bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = bottom
    }
    
    func pinToView(parentView: UIView, constant: CGFloat, leading: Bool = true, trailing: Bool = true, top: Bool = true, bottom: Bool = true) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: constant).isActive = leading
        self.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -constant).isActive = trailing
        self.topAnchor.constraint(equalTo: parentView.topAnchor, constant: constant).isActive = top
        self.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: -constant).isActive = bottom
    }
    
    func centerOnView(parentView: UIView, centerX: Bool = true, centerY: Bool = true) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.centerXAnchor.constraint(equalTo: parentView.centerXAnchor).isActive = centerX
        self.centerYAnchor.constraint(equalTo: parentView.centerYAnchor).isActive = centerY
    }
    
    func applyAspectRatio(aspectRation: CGFloat) {
        NSLayoutConstraint(item: self,
                           attribute: NSLayoutConstraint.Attribute.width,
                           relatedBy: NSLayoutConstraint.Relation.equal,
                           toItem: self,
                           attribute: NSLayoutConstraint.Attribute.height,
                           multiplier: aspectRation,
                           constant: 0).isActive = true
    }
}

extension NSLayoutConstraint {
    func activate() {
        self.isActive = true
    }
    
    func deactivate() {
        self.isActive = false
    }
}

extension Date {
    static func parseYearMonth(dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.current.languageCode ?? "en")
        formatter.dateFormat = "yyyy-MM"
        return formatter.date(from: dateString)
    }
    
    func yearMonthFormat() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.current.languageCode ?? "en")
        formatter.dateFormat = "yyyy-MM"
        
        return formatter.string(from: self)
    }
    
    func yearMonthLongFormat() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.current.languageCode ?? "en")
        formatter.dateFormat = "MMMM yyyy"
        
        return formatter.string(from: self)
    }
    
    func monthLongFormat() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.current.languageCode ?? "en")
        formatter.dateFormat = "MMMM"
        
        return formatter.string(from: self)
    }
    
    func monthFormat() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.current.languageCode ?? "en")
        formatter.dateFormat = "MMM"
        
        return formatter.string(from: self)
    }
    
    func yearFormat() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.current.languageCode ?? "en")
        formatter.dateFormat = "yyyy"
        
        return formatter.string(from: self)
    }
    
    func noon(using calendar: Calendar = .current) -> Date {
        calendar.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    
    func midnight(using calendar: Calendar = .current) -> Date {
        calendar.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
    
    func day(using calendar: Calendar = .current) -> Int {
        calendar.component(.day, from: self)
    }
    
    func month(using calendar: Calendar = .current) -> Int {
        calendar.component(.month, from: self)
    }
    
    func monthSymbol(using calendar: Calendar = .current) -> String {
        calendar.monthSymbols[calendar.component(.month, from: self)-1]
    }
    
    func year(using calendar: Calendar = .current) -> Int {
        calendar.component(.year, from: self)
    }
    
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    
    func withYear(year: Int) -> Date? {
        let calendarComponents: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let calendar = Calendar.current
        var components = calendar.dateComponents(calendarComponents, from: self)
        
        components.year = year
        
        return calendar.date(from: components)
    }
    
    func withMonth(month: Int) -> Date? {
        let calendarComponents: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let calendar = Calendar.current
        var components = calendar.dateComponents(calendarComponents, from: self)
        
        components.month = month
        
        return calendar.date(from: components)
    }
    
    static func monthName(month: Int) -> String {
        if month > 12 {
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.current.languageCode ?? "en")
        formatter.dateFormat = "MM"
        return formatter.monthSymbols[month - 1]
    }
}

extension UIViewController {
    func showWarningAlert(title: String = "", message: String, dismissOnTap: Bool = true, actionButtonText: String = "Ok".localized.localizedUppercase, dismissText: String = "Dismiss".localized, image: String = "", showCancel: Bool = true, actionButtonClosure:  (() -> Void)? = nil) {
        let vc = AlertVC()
        vc.actionButtonText = actionButtonText
        vc.messageTitle = title
        vc.message = message
        vc.actionButtonClosure = actionButtonClosure
        vc.showCancel = showCancel
        vc.dismissOnTap = dismissOnTap
        vc.image = image
        vc.dismissText = dismissText
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
    
    func showWarningAlertWithCancelAction(title: String = "", message: String, actionButtonText: String = "Ok".localized.localizedUppercase, dismissText: String = "Dismiss".localized, image: String = "", showCancel: Bool = true, actionButtonClosure:  (() -> Void)? = nil, cancelAction:  (() -> Void)? = nil) {
        let vc = AlertVC()
        vc.actionButtonText = actionButtonText
        vc.messageTitle = title
        vc.message = message
        vc.actionButtonClosure = actionButtonClosure
        vc.showCancel = showCancel
        vc.dismissOnTap = false
        vc.image = image
        vc.cancelAction = cancelAction
        vc.dismissText = dismissText
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
    
    func showWarningAlertWithTextfield(title: String = "", message: String, dismissOnTap: Bool = true, actionButtonText: String = "Ok".localized.localizedUppercase, dismissText: String = "Dismiss".localized, image: String = "", placeholderText: String = "", reasonRequired: Bool = true, showCancel: Bool = true, textSubmissionAction: @escaping ((_ text: String) -> Void), cancelAction:  (() -> Void)? = nil) {
        let vc = AlertVC()
        vc.actionButtonText = actionButtonText
        vc.messageTitle = title
        vc.message = message
        vc.actionButtonClosure = nil
        vc.textSubmissionAction = textSubmissionAction
        vc.showCancel = showCancel
        vc.dismissOnTap = dismissOnTap
        vc.image = image
        vc.dismissText = dismissText
        vc.placeholderText = placeholderText
        vc.cancelAction = cancelAction
        vc.reasonRequired = reasonRequired
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
}

extension Dictionary<String, Any> {
    func toJsonString() -> String {
        if let data = try? JSONSerialization.data(withJSONObject: self) {
            return String(data: data, encoding: .utf8) ?? ""
        }
        
        return ""
    }
}
