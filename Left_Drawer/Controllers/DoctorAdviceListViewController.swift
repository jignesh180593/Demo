//
//  DoctorAdviceListViewController.swift
//  Left_Drawer
//
//  Created by admin on 03/03/21.
//  Copyright © 2021 Romal Tandel. All rights reserved.
//

import UIKit

class DoctorAdviceListViewController: UIViewController {
    @IBOutlet weak var collectionView : UICollectionView!
    var arrDoctorAdviceData = [DoctorAdvice]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        arrDoctorAdviceData = []
        
        // Do any additional setup after loading the view.
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        let size = CGSize(width:(self.view.layer.frame.width/2)-15, height: 177)
        layout.itemSize = size
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        getDoctoradviceData()
    }
    func getDoctoradviceData(){
        HOSPITALAPI.getDoctorAdviceData { [self] (DoctorAdviceData) in
            arrDoctorAdviceData = DoctorAdviceData
            collectionView.reloadData()
         } failureHandler: { (Error) in
            print(Error)
        }
    }
    func showAlert(title: String?, message: String, actionTitle:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    @objc func tapYoutube(sender:UIButton){
        for data in arrDoctorAdviceData {
            guard let youtube = data.youtube,let phone = data.phone else {
                return
            }
            if sender.tag == 10 {
                if let url = URL(string: youtube) {
                    UIApplication.shared.open(url)
                }
            }
            if sender.tag == 11 {
                if let phoneCallURL = URL(string: "tel://\(phone)") {
                   let application:UIApplication = UIApplication.shared
                   if (application.canOpenURL(phoneCallURL)) {
                       application.open(phoneCallURL, options: [:], completionHandler: nil)
                   }
               }
            }
        }
    }
}
extension DoctorAdviceListViewController : UICollectionViewDelegate ,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrDoctorAdviceData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DoctorAdviceListViewCell", for: indexPath) as! DoctorAdviceListViewCell
        cell.setData(data: arrDoctorAdviceData[indexPath.row])
        cell.btnYoutube.tag = 10
        cell.btnYoutube.addTarget(self, action: #selector(tapYoutube(sender:)), for: .touchUpInside)
        cell.btnCall.tag = 11
        cell.btnCall.addTarget(self, action: #selector(tapYoutube(sender:)), for: .touchUpInside)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mainStoryBoard:UIStoryboard = UIStoryboard(name : "Main" ,bundle : nil)
        let desController = mainStoryBoard.instantiateViewController(withIdentifier: "DetailAdviceViewController") as! DetailAdviceViewController
        desController.doctorAdvice = arrDoctorAdviceData[indexPath.row]
        self.navigationController?.pushViewController(desController, animated: true)
    }
}
