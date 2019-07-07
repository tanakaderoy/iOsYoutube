//
//  VideoCell.swift
//
//
//  Created by Tanaka Mazivanhanga on 7/2/19.
//

import UIKit


class VideoCell: BaseCell{
    
    var video: Video? {
        didSet {
            if let video = video{
                titleLabel.text = video.title
                
                setupThumbnailImage()
                setupProfileImage()
                
               
              
             
                if let channelName = video.channel?.name, let numberOfViews = video.number_of_views{
                    
                    let numberFormatter = NumberFormatter()
                    numberFormatter.numberStyle = .decimal
                    
                    let subtitleText = "\(channelName) • \(numberFormatter.string(from: NSNumber(value: numberOfViews))!) • 2 years ago"
                    subtitleTextView.text = subtitleText
                }
                //measure title text
                if let title = video.title {
                    let size = CGSize(width: frame.width - 16 - 44 - 8 - 16, height: 1000)
                    let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                    let estimatedRect = NSString(string: title).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
                    
                    if estimatedRect.size.height > 15 {
                        titleLabelHeightConstraint?.constant = 44
                    } else {
                        titleLabelHeightConstraint?.constant = 20
                    }
                }
                
            }
        }
    }
    
    func setupProfileImage(){
        if let url = video?.channel?.profile_image_name{
         
            userProfileImageView.image = getImageFromURL(url: url)
            
        }
        
    }
    
    func setupThumbnailImage(){
        if let url = video?.thumbnail_image_name{
        thumbnailImageView.image = getImageFromURL(url: url)
        }
        
    }
    func getImageFromURL(url: String) -> UIImage{
        
        
            do{
                let urlData = try Data(contentsOf: URL(string: url)!)
                return UIImage(data: urlData)!
                
            }
            catch let error{
                print(error)
            }
        
        return UIImage(named: "kanye_profile")!
    }
    
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "blankSpace")
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    let userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "taylor")
        imageView.layer.cornerRadius = 22
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        
        return imageView
    }()
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 238)
        return view
        
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Taylor Swift - Blank Space"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
        
    }()
    let subtitleTextView: UITextView = {
        let textView = UITextView()
        textView.text = "TaylorSwift • 1,684,804,607 • 2 years"
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textContainerInset = UIEdgeInsets(top: 0,left: -3,bottom: 0,right: 0)
        textView.textColor = .lightGray
        textView.font = UIFont(name: textView.font!.fontName, size: 14)
        return textView
        
    }()
    var titleLabelHeightConstraint: NSLayoutConstraint?
    override func setupViews() {
        
        addSubview(thumbnailImageView)
        addSubview(separatorView)
        addSubview(userProfileImageView)
        addSubview(titleLabel)
        addSubview(subtitleTextView)
        
        addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: thumbnailImageView)
        addConstraintsWithFormat(format: "H:|-16-[v0(44)]", views: userProfileImageView)
        
        addConstraintsWithFormat(format: "V:|-16-[v0]-8-[v1(44)]-36-[v2(1)]|", views: thumbnailImageView,userProfileImageView,separatorView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: separatorView)
        //top constraint titlelabel
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: thumbnailImageView, attribute: .bottom, multiplier: 1, constant: 8))
        //left
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: userProfileImageView, attribute: .right, multiplier: 1, constant: 0))
        //right
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: thumbnailImageView, attribute: .right, multiplier: 1, constant: 0))
        //height
        titleLabelHeightConstraint = NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 44)
        addConstraint(titleLabelHeightConstraint!)
        
        //top constraint subtitletextview
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 4))
        //left
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .left, relatedBy: .equal, toItem: userProfileImageView, attribute: .right, multiplier: 1, constant: 0))
        //right
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .right, relatedBy: .equal, toItem: thumbnailImageView, attribute: .right, multiplier: 1, constant: 0))
        //height
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 30))
        
    }
    
    
}
