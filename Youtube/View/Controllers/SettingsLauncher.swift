//
//  SettingsLauncher.swift
//  Youtube
//
//  Created by Tanaka Mazivanhanga on 7/3/19.
//  Copyright © 2019 Tanaka Mazivanhanga. All rights reserved.
//

import Foundation
import UIKit
class Setting: NSObject {
    let name: SettingName
    let imageName: String
    init(name: SettingName, imageName: String){
        self.name = name
        self.imageName = imageName
    }
}

enum SettingName: String{
    
    case settings = "Settings"
    case terms = "Terms & Privacy Policy"
    case feedback = "Send Feedback"
    case help = "Help"
    case switchAccount = "Switch Account"
    case cancel = "Cancel"
}

class SettinsLauncher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let setting = settings[indexPath.item]
        
        handleDismiss(setting: setting)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SettingCell
        let setting = settings[indexPath.item]
        cell.setting = setting
        //        cell.nameLabel.text = setting.name
        //        cell.iconImageView.image = UIImage(named: setting.imageName)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override init() {
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SettingCell.self, forCellWithReuseIdentifier: cellId)
        //start
    }
    let blackView = UIView()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
        
    }()
    
    let settings: [Setting] = {
        let settingsSetting = Setting(name: .settings, imageName: "settings")
        let termsSetting = Setting(name: .terms, imageName: "privacy")
        let cancelSetting = Setting(name: .cancel, imageName: "cancel")
        let feedbackSetting = Setting(name: .feedback, imageName: "feedback")
        let helpSetting = Setting(name: .help, imageName: "help")
        let switchSetting = Setting(name: .switchAccount, imageName: "switch_account")
        return [settingsSetting, termsSetting, feedbackSetting, helpSetting,switchSetting ,cancelSetting]
        
    }()
    
    let cellId = "cellId"
    let cellHeight = CGFloat(50)
    
    var homeController: HomeController?
    
    @objc func showSttings(){
        
        
        if let window = UIApplication.shared.keyWindow {
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            window.addSubview(blackView)
            window.addSubview(collectionView)
            let height: CGFloat = CGFloat(settings.count) * cellHeight
            
            let y = window.frame.height - height
            
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
                
            }, completion: nil)
            
            
        }
    }
    @objc func handleDismiss(setting: Setting) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
            
        }) { (completed: Bool) in
            if setting.name != .cancel {
                self.homeController?.showControllerForSetting(setting: setting )
            }
        }
    }}
