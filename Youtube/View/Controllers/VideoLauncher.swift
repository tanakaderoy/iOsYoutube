//
//  VideoLauncher.swift
//  Youtube
//
//  Created by Tanaka Mazivanhanga on 7/6/19.
//  Copyright © 2019 Tanaka Mazivanhanga. All rights reserved.
//

import UIKit
import AVFoundation
class VideoPlayerView: UIView {
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    lazy var playPauseButton: UIButton = {
        var button = UIButton(type: .system)
        var buttonImage = UIImage(named: "pause")
        button.setImage(buttonImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.isHidden = true
        
        button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        
        return button
    }()
    var isPlaying = false
    @objc func handlePause(){
        if isPlaying{
            player?.pause()
            let playButton = UIImage(named: "play")
            playPauseButton.setImage(playButton, for: .normal)
        }else{
            player?.play()
            let pauseImage =  UIImage(named: "pause")
            
            playPauseButton.setImage(pauseImage, for: .normal)
            
        }
        
        
        isPlaying = !isPlaying
    }
    
    let controlsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 1)
        return view
        
    }()
    
    let  videoLengthLabel: UILabel = {
        let label = UILabel()
        
        label.text = "00.00"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .right
        return label
    }()
    
    let  currentTimeLabel: UILabel = {
        let label = UILabel()
        
        label.text = "00.00"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    lazy var slider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = .red
        slider.maximumTrackTintColor = .white
        slider.setThumbImage(UIImage(named: "thumb"), for: .normal)
        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        
        return slider
    }()
    @objc func handleSliderChange(){
        if let duration = player?.currentItem?.duration{
            let totalSeconds = CMTimeGetSeconds(duration)
           let value =  Double(slider.value * Float(totalSeconds))
        
        let seekTime = CMTime(seconds: value, preferredTimescale: 1)
            playPauseButton.isHidden = true
        player?.seek(to: seekTime, completionHandler: { (completedSeek) in
            //
        })
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupPlayerView()
        setupGradientLayer()
        controlsContainerView.frame = frame
        addSubview(controlsContainerView)
        controlsContainerView.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        backgroundColor = .black
        controlsContainerView.addSubview(playPauseButton)
        playPauseButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        playPauseButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        playPauseButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        playPauseButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        controlsContainerView.addSubview(videoLengthLabel)
        videoLengthLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        videoLengthLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant:  -2).isActive = true
        videoLengthLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        videoLengthLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        controlsContainerView.addSubview(currentTimeLabel)
        
        currentTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant:  -2).isActive = true
        currentTimeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        currentTimeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        currentTimeLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true

        
        
        controlsContainerView.addSubview(slider)
        slider.rightAnchor.constraint(equalTo: videoLengthLabel.leftAnchor).isActive = true
        slider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        slider.leftAnchor.constraint(equalTo: currentTimeLabel.rightAnchor).isActive = true
        slider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    var player: AVPlayer?
    private func setupPlayerView(){
        let chromeCast = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4"
        let sintel = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4"
        let hbo = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4"
        let urlString = hbo
        if let url = URL(string: urlString){
            player = AVPlayer(url: url)
            let playerLayer = AVPlayerLayer(player: player)
            self.layer.addSublayer(playerLayer)
            playerLayer.frame = self.frame
            player?.play()
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
            let interval = CMTime(value: 1, timescale: 2)
            player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
                let totalSeconds = CMTimeGetSeconds(progressTime)
                let hours = Int(totalSeconds / 3600)
                let minutes = Int(totalSeconds) / 60
                let seconds = Int(totalSeconds) % 60
                if hours > 0 {
                    self.currentTimeLabel.text = String(format: "%i:%02i:%02i", hours, minutes, seconds)
                } else {
                    self.currentTimeLabel.text = String(format: "%02i:%02i", minutes, seconds)
                }
                if let duration = self.player?.currentItem?.duration{
                    let totalDurationSeconds = CMTimeGetSeconds(duration)

                    self.slider.value = Float(Float64(seconds) / totalDurationSeconds)
                }
            })
        }
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges"{            activityIndicatorView.stopAnimating()
            controlsContainerView.backgroundColor = .clear
            playPauseButton.isHidden = false
            isPlaying = true
            
            if let duration = player?.currentItem?.duration{
            let totalSeconds = CMTimeGetSeconds(duration)
                let hours = Int(totalSeconds / 3600)
                let minutes = Int(totalSeconds) / 60
                let seconds = Int(totalSeconds) % 60
                if hours > 0 {
                    videoLengthLabel.text = String(format: "%i:%02i:%02i", hours, minutes, seconds)
                } else {
                    videoLengthLabel.text = String(format: "%02i:%02i", minutes, seconds)
                }
        }
    }
}
    
    private func setupGradientLayer(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.clear.cgColor,UIColor.black.cgColor]
        gradientLayer.locations = [0.79,1.2]
        controlsContainerView.layer.addSublayer(gradientLayer)
    }

required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}
    
}
class VideoLauncher: NSObject {
    func showVideoPlayer() {
        print("show video")
        if let keyWindow = UIApplication.shared.keyWindow{
            let view = UIView(frame: keyWindow.frame)
            view.backgroundColor = .white
            
            view.frame = CGRect(x: keyWindow.frame.width - 10, y: keyWindow.frame.height - 10, width: 10, height: 10)
            let height = keyWindow.frame.width * 9 / 16
            let videoPlayerFrame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
            let videoPlayerView = VideoPlayerView(frame: videoPlayerFrame)
            view.addSubview(videoPlayerView)
            
            keyWindow.addSubview(view)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                view.frame = keyWindow.frame
            }) { (completedAnimation) in
                //do later
                //                UIApplication.shared.isStatusBarHidden = true
                UIApplication.shared.setStatusBarHidden(true, with: .fade)
            }
            
        }
        
    }
}
