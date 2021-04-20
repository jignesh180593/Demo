//
//  TableViewController.swift
//  Left_Drawer
//
//  Created by Romal Tandel on 9/25/17.
//  Copyright © 2017 Romal Tandel. All rights reserved.
//

import UIKit
import DropDown

class MenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView : UITableView!
    
    var menuNameArr:Array = [String]()
    var menuImage:Array = [UIImage]()
    var selectArr:Array = [Int]()

    let dropDown = DropDown()
    var arrLanguage = ["English","Urdu"]
    var ISEnglish = true
    override func viewDidLoad() {
        super.viewDidLoad()
        selectArr = [0,0,0,0,0,0,0,0,0,0]
        
        menuImage = [UIImage(named : "home")!,UIImage(named : "MyAppointment")!,UIImage(named : "Appointment")!,UIImage(named : "contact_us")!,UIImage(named : "about")!,UIImage(named : "share")!,UIImage(named : "Language")!,UIImage(named : "Terms")!,UIImage(named : "Privacy")!,UIImage(named : "LoginM")!]
    }
    override func viewDidAppear(_ animated: Bool) {
        if COMMON.isKeyPresentInUserDefaults(key: CONSTANT.IsEnglish){
            let IsEnglish = UserDefaults.standard.bool(forKey: CONSTANT.IsEnglish)
            if !IsEnglish {
                ISEnglish = false
                menuNameArr = [Strings.HOMEUR,Strings.MY_APPOINTMENTUR,Strings.APPOINTMENTUR,Strings.CONTACT_USUR,Strings.ABOUT_USUR,Strings.SHAREUR,Strings.LANGUAGEUR,Strings.TERMSUR,Strings.PRIVACYUR,Strings.LOGINUR]
            }else{
                ISEnglish = true
                menuNameArr = [Strings.HOME,Strings.MY_APPOINTMENT,Strings.APPOINTMENT,Strings.CONTACT_US,Strings.ABOUT_US,Strings.SHARE,Strings.LANGUAGE,Strings.TERMS,Strings.PRIVACY,Strings.LOGIN]
            }
        }else{
            menuNameArr = [Strings.HOME,Strings.MY_APPOINTMENT,Strings.APPOINTMENT,Strings.CONTACT_US,Strings.ABOUT_US,Strings.SHARE,Strings.LANGUAGE,Strings.TERMS,Strings.PRIVACY,Strings.LOGIN]
        }
        
        if COMMON.isKeyPresentInUserDefaults(key: CONSTANT.IsLogin){
            menuNameArr[9] = ISEnglish ? Strings.LOGOUT : Strings.LOGOUTUR
            tableView.reloadData()
        }else{
            menuNameArr[9] = ISEnglish ? Strings.LOGIN : Strings.LOGINUR
            tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func sentToLogin(){
        UserDefaults.standard.setValue("Menu", forKey: "Screen")
        let mainStoryBoard:UIStoryboard = UIStoryboard(name : "Main" ,bundle : nil)
        let desController = mainStoryBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let newFrontviewController = UINavigationController.init(rootViewController:desController)
        revealViewController().pushFrontViewController(newFrontviewController,animated:true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuNameArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as! MenuTableViewCell
        cell.imgIcon.image = menuImage[indexPath.row]
        cell.lblMenu.text = menuNameArr[indexPath.row]
        
        cell.imgIcon.image = cell.imgIcon.image?.withRenderingMode(.alwaysTemplate)
        if selectArr[indexPath.row] != 0 {
            cell.imgIcon.tintColor = .white
            cell.lblMenu.textColor = .white
            cell.bgView.backgroundColor = UIColor(red: 64/255, green: 114/255, blue: 99/255, alpha: 1)
        }else{
            cell.imgIcon.tintColor = .red
            cell.lblMenu.textColor = .red
            cell.bgView.backgroundColor = UIColor.clear
        }
        
        cell.tag = indexPath.row
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:MenuTableViewCell = tableView.cellForRow(at: indexPath) as! MenuTableViewCell
        for index in 0...selectArr.count-1 {
            if selectArr[index] == 1 {
                selectArr[index] = 0
            }
        }
        
        selectArr[indexPath.row] = 1
        
        if (ISEnglish && cell.lblMenu.text == Strings.HOME) || (!ISEnglish && cell.lblMenu.text == Strings.HOMEUR){
            let mainStoryBoard:UIStoryboard = UIStoryboard(name : "Main" ,bundle : nil)
            let desController = mainStoryBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            let newFrontviewController = UINavigationController.init(rootViewController:desController)
            revealViewController().pushFrontViewController(newFrontviewController,animated:true)
        }
        if (ISEnglish && cell.lblMenu.text == Strings.ABOUT_US) || (!ISEnglish && cell.lblMenu.text == Strings.ABOUT_USUR){
            let mainStoryBoard:UIStoryboard = UIStoryboard(name : "Main" ,bundle : nil)
            let desController = mainStoryBoard.instantiateViewController(withIdentifier: "AboutusViewController") as! AboutusViewController
            let newFrontviewController = UINavigationController.init(rootViewController:desController)
            revealViewController().pushFrontViewController(newFrontviewController,animated:true)
        }
        if (ISEnglish && cell.lblMenu.text == Strings.MY_APPOINTMENT && indexPath.row == 1) || (!ISEnglish && cell.lblMenu.text == Strings.MY_APPOINTMENTUR && indexPath.row == 1){
            if  COMMON.isKeyPresentInUserDefaults(key: CONSTANT.IsLogin){
                UserDefaults.standard.setValue("MenuAppointment", forKey: "Screen")
                let mainStoryBoard:UIStoryboard = UIStoryboard(name : "Main" ,bundle : nil)
                let desController = mainStoryBoard.instantiateViewController(withIdentifier: "MyAppointmentViewController") as! MyAppointmentViewController
                let newFrontviewController = UINavigationController.init(rootViewController:desController)
                revealViewController().pushFrontViewController(newFrontviewController,animated:true)
            }else{
                sentToLogin()
            }
        }
        if (ISEnglish && cell.lblMenu.text == Strings.APPOINTMENT && indexPath.row == 2) || (!ISEnglish && cell.lblMenu.text == Strings.MY_APPOINTMENTUR && indexPath.row == 2){
            if  COMMON.isKeyPresentInUserDefaults(key: CONSTANT.IsLogin){
                UserDefaults.standard.setValue("MenuAppointment", forKey: "Screen")
                let mainStoryBoard:UIStoryboard = UIStoryboard(name : "Main" ,bundle : nil)
                let desController = mainStoryBoard.instantiateViewController(withIdentifier: "AppointmentViewController") as! AppointmentViewController
                let newFrontviewController = UINavigationController.init(rootViewController:desController)
                revealViewController().pushFrontViewController(newFrontviewController,animated:true)
            }else{
                sentToLogin()
            }
        }
        if  (ISEnglish && cell.lblMenu.text == Strings.PRIVACY) || (!ISEnglish && cell.lblMenu.text == Strings.PRIVACYUR){
            let mainStoryBoard:UIStoryboard = UIStoryboard(name : "Main" ,bundle : nil)
            let desController = mainStoryBoard.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as! PrivacyPolicyViewController
            let newFrontviewController = UINavigationController.init(rootViewController:desController)
            revealViewController().pushFrontViewController(newFrontviewController,animated:true)
        }
        if  (ISEnglish && cell.lblMenu.text == Strings.TERMS) || (!ISEnglish && cell.lblMenu.text == Strings.TERMSUR){
            let mainStoryBoard:UIStoryboard = UIStoryboard(name : "Main" ,bundle : nil)
            let desController = mainStoryBoard.instantiateViewController(withIdentifier: "TermConditionViewController") as! TermConditionViewController
            let newFrontviewController = UINavigationController.init(rootViewController:desController)
            revealViewController().pushFrontViewController(newFrontviewController,animated:true)
        }
        if  (ISEnglish && cell.lblMenu.text == Strings.SHARE) || (!ISEnglish && cell.lblMenu.text == Strings.SHAREUR){
            let items = ["click to download https://apps.apple.com/us/app/id1558798719"]
            let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
            let excludeActivities = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.print, UIActivity.ActivityType.assignToContact, UIActivity.ActivityType.saveToCameraRoll, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.postToFlickr, UIActivity.ActivityType.postToVimeo, UIActivity.ActivityType.postToFacebook, UIActivity.ActivityType.message, UIActivity.ActivityType.postToWeibo]
            ac.excludedActivityTypes = excludeActivities
            present(ac, animated: true)
        }
        if  (ISEnglish && cell.lblMenu.text == Strings.CONTACT_US) || (!ISEnglish && cell.lblMenu.text == Strings.CONTACT_USUR){
            let mainStoryBoard:UIStoryboard = UIStoryboard(name : "Main" ,bundle : nil)
            let desController = mainStoryBoard.instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController
            let newFrontviewController = UINavigationController.init(rootViewController:desController)
            revealViewController().pushFrontViewController(newFrontviewController,animated:true)
        }
        if (ISEnglish && cell.lblMenu.text == Strings.LANGUAGE) || (!ISEnglish && cell.lblMenu.text == Strings.LANGUAGEUR) {
            dropDown.dataSource = arrLanguage
            dropDown.anchorView = cell.lblMenu //5
               dropDown.bottomOffset = CGPoint(x: 0, y: 50) //6
               dropDown.show() //7
               dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
               
                 guard let _ = self else { return }
//                cell.lblMenu.text = item//9
                item == "English" ? UserDefaults.standard.setValue(true, forKey: CONSTANT.IsEnglish):UserDefaults.standard.setValue(false, forKey: CONSTANT.IsEnglish)
                self?.tableView.reloadData()
                let mainStoryBoard:UIStoryboard = UIStoryboard(name : "Main" ,bundle : nil)
                let desController = mainStoryBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                let newFrontviewController = UINavigationController.init(rootViewController:desController)
                self!.revealViewController().pushFrontViewController(newFrontviewController,animated:true)
               }
        }
        if  (ISEnglish && cell.lblMenu.text == Strings.LOGIN) || (!ISEnglish && cell.lblMenu.text == Strings.LOGINUR){
            sentToLogin()
        }
        if  (ISEnglish && cell.lblMenu.text == Strings.LOGOUT) || (!ISEnglish && cell.lblMenu.text == Strings.LOGOUTUR){
            let alert = UIAlertController(title: "Pulse Hospital", message: "Do you really want to Logout?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                  switch action.style{
                  case .default:
                        print("default")
                    UserDefaults.standard.removeObject(forKey: CONSTANT.IsLogin)
                  UserDefaults.standard.removeObject(forKey: CONSTANT.User_Email)
                  UserDefaults.standard.removeObject(forKey: CONSTANT.User_Mobile)
                  UserDefaults.standard.removeObject(forKey: CONSTANT.User_id)
                    self.menuNameArr[9] = Strings.LOGIN
                    self.sentToLogin()
                self.tableView.reloadData()
                  case .cancel:
                        print("cancel")

                  case .destructive:
                        print("destructive")

                  @unknown default:
                    print("default")
            }}))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                  switch action.style{
                  case .default:
                        print("default")

                  case .cancel:
                        print("cancel")
                    alert.dismiss(animated: true, completion: nil)

                  case .destructive:
                        print("destructive")

                  @unknown default:
                    print("default")
                  }}))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
}
