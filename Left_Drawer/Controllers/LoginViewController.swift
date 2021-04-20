//
//  LoginViewController.swift
//  Left_Drawer
//
//  Created by admin on 08/03/21.
//  Copyright © 2021 Romal Tandel. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import GoogleSignIn
import AuthenticationServices

class LoginViewController: UIViewController ,UITextFieldDelegate{
    @IBOutlet weak var textfiledID : UITextField!
    @IBOutlet weak var textfiledPassword : UITextField!
    @IBOutlet weak var btnLogin : UIButton!
    @IBOutlet weak var btnDoctorLogin : UIButton!
    @IBOutlet weak var btnUserAccout : UIButton!
    @IBOutlet weak var viewAppleSignIn: UIView!
    
    var textFields : [[UITextField : String]] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textFields = [[textfiledID : "User name"], [textfiledPassword : "Password"]]
        
        textfiledID.delegate = self
        textfiledPassword.delegate = self
        guard let screen = UserDefaults.standard.string(forKey: "Screen") else {
            return
        }
        if screen == "Menu" {
            let newBtn = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector(BackButton))
               self.navigationItem.leftItemsSupplementBackButton = true
               self.navigationItem.leftBarButtonItem = newBtn
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if COMMON.isKeyPresentInUserDefaults(key: CONSTANT.IsEnglish){
            let IsEnglish = UserDefaults.standard.bool(forKey: CONSTANT.IsEnglish)
            IsEnglish ? btnLogin.setTitle(Localizable.ENLogin, for: .normal) : btnLogin.setTitle(Localizable.URLogin, for: .normal)
            IsEnglish ? btnDoctorLogin.setTitle(Localizable.ENDoctorLogin, for: .normal) : btnDoctorLogin.setTitle(Localizable.URDoctorLogin, for: .normal)
            IsEnglish ? btnUserAccout.setTitle(Localizable.ENNewUser, for: .normal) : btnUserAccout.setTitle(Localizable.URNewUser, for: .normal)

            if IsEnglish {
                title = Localizable.ENLogin
                textfiledID.placeholder = Localizable.ENUsername
                textfiledPassword.placeholder = Localizable.ENPassword
            }else {
                title = Localizable.URLogin
                textfiledID.placeholder = Localizable.URUsername
                textfiledPassword.placeholder = Localizable.URPassword
            }
        }else{
            UserDefaults.standard.setValue(true, forKey: CONSTANT.IsEnglish)
        }
        self.setupAppleSignInButton()
    }
    override func viewDidDisappear(_ animated: Bool) {
        UserDefaults.standard.removeObject(forKey: "Screen")
    }
  /*  override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated);
        if self.isMovingFromParent
        {
            exit(0)
        }
        if self.isBeingDismissed
        {
            //Dismissed
            print("Dismissed")
        } 
    }*/
    func setupAppleSignInButton()
    {
        if #available(iOS 13.0, *) {
            let objASAuthorizationAppleIDButton = ASAuthorizationAppleIDButton()
            objASAuthorizationAppleIDButton.frame = CGRect(x: 0, y: (viewAppleSignIn.bounds.size.height/2 - 20), width: (viewAppleSignIn.bounds.size.width), height: 40)
            objASAuthorizationAppleIDButton.addTarget(self, action: #selector(actionHandleAppleSignin), for: .touchUpInside)
            self.viewAppleSignIn.addSubview(objASAuthorizationAppleIDButton)
        } else {
            // Fallback on earlier versions
            self.viewAppleSignIn.isHidden = true
        }
    }
    @objc func actionHandleAppleSignin()
    {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        } else {
            // Fallback on earlier versions
        }
    }
    func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        if #available(iOS 13.0, *) {
            let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                        ASAuthorizationPasswordProvider().createRequest()]
        // Create an authorization controller with the given requests.
            let authorizationController = ASAuthorizationController(authorizationRequests: requests)
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }
    }

    @objc func BackButton(){
        self.Dashboard()
//        self.dismiss(animated: true, completion: nil)
        //self.navigationController?.popToRootViewController(animated: true)
    }
    func Dashboard(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        //animation
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        //end
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
        guard let navigationController = self.navigationController else { return }
        var navigationArray = navigationController.viewControllers // To get all UIViewController stack as Array
        if navigationArray.count > 1{
            navigationArray.remove(at: navigationArray.count - 2) // To remove second last UIViewController
        }else{
            navigationArray.remove(at: navigationArray.count - 1) // To remove second last UIViewController
        }
        self.navigationController?.viewControllers = navigationArray
     }
    @IBAction func loginPress(_ sender: UIButton) {
        if !checkIfTextFieldsAreEmpty(textfields: textFields) {
            var login = Login()
            login.UserName = textfiledID.text!
            login.Password = textfiledPassword.text!
            sentLoginData(login: login)
        }
    }
    @IBAction func newUserPress(_ sender: UIButton) {
        let mainStoryBoard:UIStoryboard = UIStoryboard(name : "Main" ,bundle : nil)
        let desController = mainStoryBoard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(desController, animated: true)
    }
    @IBAction func doctorLoginPress(_ sender: UIButton) {
        let mainStoryBoard:UIStoryboard = UIStoryboard(name : "Main" ,bundle : nil)
        let desController = mainStoryBoard.instantiateViewController(withIdentifier: "DoctorLoginViewController") as! DoctorLoginViewController
        self.navigationController?.pushViewController(desController, animated: true)
    }
    @IBAction func fbLoginPress(_ sender: UIButton) {
        facebooklogin()
    }
    @IBAction func gmailLoginPress(_ sender: UIButton) {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
    @IBAction func mobileLoginPress(_ sender: UIButton) {
        let mainStoryBoard:UIStoryboard = UIStoryboard(name : "Main" ,bundle : nil)
        let desController = mainStoryBoard.instantiateViewController(withIdentifier: "MobileViewController") as! MobileViewController
        self.navigationController?.pushViewController(desController, animated: true)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func sentLoginData(login:Login){
        HOSPITALAPI.sentLoginData(login: login, successHandler: { (message) in
            self.textfiledID.text = ""
            self.textfiledPassword.text = ""
            self.Dashboard()
        }) { (message) in
            self.showAlert(title: nil, message:message , actionTitle: "OK")
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    func showAlert(title: String?, message: String, actionTitle:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    func checkIfTextFieldsAreEmpty(textfields: [[UITextField : String]]) -> Bool{
        var isEmpty = false
        var endExecution = false
        for dictionary in textfields {
            if endExecution {
                break
            }
            for (textfield, name) in dictionary {
                guard (textfield.text?.isEmpty)! else {
                    isEmpty = false
                    continue
                }
                showAlert(title: nil, message: "\(name) is mandatory!", actionTitle: "OK")
                isEmpty = true
                endExecution = true
            }
        }
        return isEmpty
    }
}
extension LoginViewController {
    func facebooklogin() {
        //ActivityIndication Start
        ActivityIndicator.activityIndicator("", parentView: self.view)
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.defaultAudience = .everyone
        fbLoginManager.logOut()
        fbLoginManager.logIn(permissions: ["email"], from: nil) { (result, error) in
            //104360264607338
            if (error == nil) {
                let fbloginresult : LoginManagerLoginResult = result!
                if(fbloginresult.isCancelled) {
                    //Show Cancel alert
                    print("cancelled")
                } else if(fbloginresult.grantedPermissions.contains("email")) {
                    self.returnUserData()
                    //fbLoginManager.logOut()
                }
            }
        }
    }
    func returnUserData() {
        let graphRequest : GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields":"email,first_name,last_name,name,picture.type(large)"])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            if ((error) != nil) {
                // Process error
                print("\n\n Error: \(error)")
            } else {
                let resultDic = result as! NSDictionary
                var social = Social()
                
                print("\n\n  fetched user: \(result)")
                //The url is nested 3 layers deep into the result so it's pretty messy
                    if let imageURL = ((resultDic["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                        //Download image from imageURL
                        UserDefaults.standard.setValue(imageURL, forKey: "Profile")
                        social.pro_img = imageURL
                    }
                
                if (resultDic.value(forKey:"name") != nil) {
                    let userName = resultDic.value(forKey:"name")! as! String
                    print("\n User Name is: \(userName)")
                    UserDefaults.standard.set(userName, forKey: "username")
                }
                
                if (resultDic.value(forKey:"email") != nil) {
                    let userEmail = resultDic.value(forKey:"email")! as! String
                    print("\n User Email is: \(userEmail)")
                    UserDefaults.standard.set(userEmail, forKey: CONSTANT.User_Email)
                    social.email = userEmail
                }
                
                if (resultDic.value(forKey:"id") != nil) {
                    let id = resultDic.value(forKey:"id")! as! String
                    print("\n User id is: \(id)")
                    UserDefaults.standard.set(id, forKey: "facebook_id")
                  //  User.myUser.password = id
                    social.user_id = id
                }
                
                if (resultDic.value(forKey:"first_name") != nil) {
                    let first_name = resultDic.value(forKey:"first_name")! as! String
                    social.first_name = first_name
                }
                
                if (resultDic.value(forKey:"last_name") != nil) {
                    let last_name = resultDic.value(forKey:"last_name")! as! String
                    social.last_name = last_name
                }
                
                //ActivityIndication Start
                ActivityIndicator.activityIndicator("", parentView: self.view)
                HOSPITALAPI.registerUser(social: social, successHandler: {_ in
                    UserDefaults.standard.setValue(false, forKey: CONSTANT.SocialId)
                    self.Dashboard()
                    
                }) { (ErrorMessage) in
                    self.showAlert(title: nil, message: ErrorMessage, actionTitle: "OK")
                    //ActivityIndication Stop
                    let delay = 2 // seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
                        ActivityIndicator.removeActivityIndicator()
                    }
                }
                
            }
        })
    }
}
//gmail
extension LoginViewController : GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        var social = Social()
 
        // Perform any operations on signed in user here.
        social.user_id = user.userID                  // For client-side use only!
       // let idToken = user.authentication.idToken // Safe to send to the server
       // let fullName = user.profile.name
        social.first_name = user.profile.givenName
        social.last_name = user.profile.familyName
        social.email = user.profile.email
        UserDefaults.standard.setValue(social.email, forKey: CONSTANT.User_Email)
        if user.profile.hasImage{
             let imageUrl = signIn.currentUser.profile.imageURL(withDimension: 120)
             UserDefaults.standard.setValue(imageUrl!.absoluteString, forKey: "Profile")
            social.pro_img = imageUrl!.absoluteString
        }
        
        //ActivityIndication Start
        ActivityIndicator.activityIndicator("", parentView: self.view)
        HOSPITALAPI.registerUser(social: social, successHandler: {_ in
            UserDefaults.standard.setValue(true, forKey: CONSTANT.SocialId)
            self.Dashboard()
        }) { (ErrorMessage) in
            self.showAlert(title: nil, message: ErrorMessage, actionTitle: "OK")
            //ActivityIndication Stop
            let delay = 2 // seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
                ActivityIndicator.removeActivityIndicator()
            }
        }
        
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("logout")
    }
    
}
//end

//Appple signin
extension LoginViewController : ASAuthorizationControllerPresentationContextProviding
{
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor
    {
        return view.window!
    }
}
@available(iOS 13.0, *)
extension LoginViewController : ASAuthorizationControllerDelegate
{
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization)
    {
        switch authorization.credential {
            
        case let credentials as ASAuthorizationAppleIDCredential:
            DispatchQueue.main.async {
                var social = Social()
                 if "\(credentials.user)" != "" {
                    social.user_id = credentials.user
                    //UserDefaults.standard.set("\(credentials.user)", forKey: "User_AppleID")
                }
                if credentials.email != nil {
                    social.email = credentials.email!
                    UserDefaults.standard.setValue(social.email, forKey: CONSTANT.User_Email)
                }
                if credentials.fullName!.givenName != nil {
                    social.first_name = credentials.fullName!.givenName!
                   // UserDefaults.standard.set("\(credentials.fullName!.givenName!)", forKey: "User_FirstName")
                }
                if credentials.fullName!.familyName != nil {
                    social.last_name = credentials.fullName!.familyName!
                   // UserDefaults.standard.set("\(credentials.fullName!.familyName!)", forKey: "User_LastName")
                }
                
                //ActivityIndication Start
                ActivityIndicator.activityIndicator("", parentView: self.view)
                HOSPITALAPI.registerUser(social: social, successHandler: {_ in
                    UserDefaults.standard.setValue(true, forKey: CONSTANT.SocialId)
                    self.Dashboard()
                }) { (ErrorMessage) in
                    self.showAlert(title: nil, message: ErrorMessage, actionTitle: "OK")
                    //ActivityIndication Stop
                    let delay = 2 // seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
                        ActivityIndicator.removeActivityIndicator()
                    }
                }
             }
            
        case let credentials as ASPasswordCredential:
            DispatchQueue.main.async {
                if "\(credentials.user)" != "" {

                    UserDefaults.standard.set("\(credentials.user)", forKey: "User_AppleID")
                }
                if "\(credentials.password)" != "" {

                    UserDefaults.standard.set("\(credentials.password)", forKey: "User_Password")
                }
                UserDefaults.standard.synchronize()
             }
            
        default :
            let alert: UIAlertController = UIAlertController(title: "Apple Sign In", message: "Something went wrong with your Apple Sign In!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error)
    {
        let alert: UIAlertController = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
         self.present(alert, animated: true, completion: nil)
    }
}

//end
