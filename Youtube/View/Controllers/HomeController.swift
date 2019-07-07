//
//  HomeController.swift
//  Youtube
//
//  Created by Tanaka Mazivanhanga on 7/2/19.
//  Copyright © 2019 Tanaka Mazivanhanga. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
     let cellId = "cellId"
    let trendingCellId = "trendingCellId"
    let subscriptionCellId = "subscriptionCellId"
    let titles: [String] = ["Home","Trending","Subscriptions","Account"]
 

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationController?.navigationBar.isTranslucent = false
        let titleLabel = UILabel(frame: CGRect(x: 0,y: 0,width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "  Home"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
        
        setupCollectionView()
        setUpMenuBar()
        setupNavBarButtons()
    }
    
    
    func setupCollectionView(){
        if let flowlayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowlayout.scrollDirection = .horizontal
            flowlayout.minimumLineSpacing = 0
        }
        // Register cell classes
        collectionView.backgroundColor = UIColor.white
        
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(TrendingCell.self, forCellWithReuseIdentifier: trendingCellId)
        collectionView.register(SubscriptionCell.self, forCellWithReuseIdentifier: subscriptionCellId)
        collectionView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView.isPagingEnabled = true
        
    }
    
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.homeController = self
        return mb
    }()
    
    private func setUpMenuBar(){
        navigationController?.hidesBarsOnSwipe = true
        
        let redView = UIView()
        redView.backgroundColor = .rgb(red: 230, green: 32, blue: 31)
        view.addSubview(redView)
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: redView)
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: redView)
        
        view.addSubview(menuBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar  )
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: menuBar)
        menuBar.topAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
    }
    func setupNavBarButtons(){
        let searchImage = UIImage(named: "search_icon")?.withRenderingMode(.alwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        
        let moreButton = UIBarButtonItem(image: UIImage(named: "nav_more_icon")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self
            , action: #selector(handleMore))
        
        navigationItem.rightBarButtonItems = [ moreButton,searchBarButtonItem]
    }
    
    //lazy var only instantiates it once when the variable is nill
    lazy var settingsLauncher: SettinsLauncher = {
        let launcher = SettinsLauncher()
        launcher.homeController = self
        return launcher
    }()
    @objc func handleMore(){
        
        
        settingsLauncher.showSttings()
        //       showControllerForSetting()
        
    }
    
    func showControllerForSetting(setting: Setting){
        let dummySettingsViewController = UIViewController()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        dummySettingsViewController.navigationItem.title = setting.name.rawValue
        navigationController?.navigationBar.tintColor = .white
        dummySettingsViewController.view.backgroundColor = .white
        
        navigationController?.pushViewController(dummySettingsViewController, animated: true)
    }
    
    @objc func handleSearch(){
        scrollToMenuIndex(menuIndex: 2)    }
    func scrollToMenuIndex(menuIndex: Int){
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        setTitleForIndex(index: menuIndex)
        
    }
    private func setTitleForIndex(index: Int){
        if let titleLabel = navigationItem.titleView as? UILabel {
            titleLabel.text = titles[index]
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        if indexPath.item == 1{
            return collectionView.dequeueReusableCell(withReuseIdentifier: trendingCellId, for: indexPath)
        }else if indexPath.item == 2{
            return collectionView.dequeueReusableCell(withReuseIdentifier: subscriptionCellId, for: indexPath)
        }
        
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - 50)
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        menuBar.horizontalBarLeftAnchorConstraint?.constant = (scrollView.contentOffset.x) / 4
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = IndexPath(item: Int(targetContentOffset.pointee.x / view.frame.width), section: 0)

        setTitleForIndex(index: index.item)
        
        
        print(targetContentOffset.pointee.x / view.frame.width)
        menuBar.collectionView.selectItem(at: (index), animated: true, scrollPosition: UICollectionView.ScrollPosition.top)
        
    }
    
}


