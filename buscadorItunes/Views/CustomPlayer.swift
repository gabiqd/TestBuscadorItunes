//
//  CustomPlayer.swift
//  buscadorItunes
//
//  Created by Gabriel Quispe Delgadillo on 25/6/18.
//  Copyright © 2018 Gabriel Quispe Delgadillo. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Kingfisher

class CustomPlayer: UIView {
    var songTitleLabel: UILabel!
    var songArtistLabel: UILabel!
    var auxSongDetailsView: UIView!
    var discImageView: UIImageView!
    var pauseButton: UIButton!
    var resumeButton: UIButton!
    
    var avPlayer: AVPlayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.primaryDarkColor
        self.isHidden = true
        
        initViews()
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        
        auxSongDetailsView = {
            let auxSongDetailsView = UIView()
            auxSongDetailsView.translatesAutoresizingMaskIntoConstraints = false
            return auxSongDetailsView
        }()
        
        songTitleLabel = {
            let songTitleLabel = UILabel()
            songTitleLabel.translatesAutoresizingMaskIntoConstraints = false
            songTitleLabel.textColor = .white
            songTitleLabel.numberOfLines = 0
            songTitleLabel.lineBreakMode = .byWordWrapping
            songTitleLabel.sizeToFit()
            songTitleLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
            return songTitleLabel
        }()
        
        songArtistLabel = {
            let songArtistLabel = UILabel()
            songArtistLabel.translatesAutoresizingMaskIntoConstraints = false
            songArtistLabel.textColor = UIColor.white
            songArtistLabel.numberOfLines = 0
            songArtistLabel.lineBreakMode = .byWordWrapping
            songArtistLabel.sizeToFit()
            songArtistLabel.font = UIFont.systemFont(ofSize: 12.0)
            return songArtistLabel
        }()
        
        discImageView = {
            let discImageView = UIImageView()
            discImageView.translatesAutoresizingMaskIntoConstraints = false
            discImageView.layer.cornerRadius = 4
            discImageView.layer.masksToBounds = true
            discImageView.contentMode = .scaleAspectFill
            return discImageView
        }()
        
        pauseButton = {
            let pauseButton = UIButton()
            pauseButton.translatesAutoresizingMaskIntoConstraints = false
            pauseButton.setImage(UIImage(named: "pause"), for: .normal)
            pauseButton.imageView?.contentMode = .scaleAspectFit
            pauseButton.addTarget(self, action: #selector(self.pausePreview), for: .touchUpInside)
            return pauseButton
        }()
        
        resumeButton = {
            let resumeButton = UIButton()
            resumeButton.translatesAutoresizingMaskIntoConstraints = false
            resumeButton.setImage(UIImage(named: "play"), for: .normal)
            resumeButton.imageView?.contentMode = .scaleAspectFit
            resumeButton.addTarget(self, action: #selector(self.resumePreview), for: .touchUpInside)
            resumeButton.isHidden = true
            return resumeButton
        }()
    }
    
    func setUpConstraints() {
        self.addSubview(auxSongDetailsView)
        auxSongDetailsView.addSubview(songTitleLabel)
        auxSongDetailsView.addSubview(songArtistLabel)
        self.addSubview(discImageView)
        self.addSubview(pauseButton)
        self.addSubview(resumeButton)
        
        auxSongDetailsView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v0]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": songTitleLabel]))
        auxSongDetailsView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v0]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": songArtistLabel]))
        auxSongDetailsView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-4-[v0]-6-[v1]-4-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": songTitleLabel, "v1": songArtistLabel]))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[v0]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": auxSongDetailsView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0(48)]-24-[v1]-8-[v2(30)]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": discImageView, "v1": auxSongDetailsView, "v2": pauseButton]))
        
        let centerYConst = NSLayoutConstraint(item: discImageView, attribute: .centerY, relatedBy: .equal, toItem: auxSongDetailsView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        let heightConstraint = NSLayoutConstraint(item: discImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 48.0)
        discImageView.addConstraint(heightConstraint)
        NSLayoutConstraint.activate([centerYConst])
        
        let centerYConstPause = NSLayoutConstraint(item: pauseButton, attribute: .centerY, relatedBy: .equal, toItem: auxSongDetailsView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        NSLayoutConstraint.activate([centerYConstPause])
        
        let centerYConstResume = NSLayoutConstraint(item: resumeButton, attribute: .centerY, relatedBy: .equal, toItem: pauseButton, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        NSLayoutConstraint.activate([centerYConstResume])
        resumeButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16.0).isActive = true
    }
    
    func playPreview(music: Music) {
        self.isHidden = false
        guard let imageUrl = music.previewURL, let previewUrl = URL.init(string: imageUrl) else {
            return
        }
        
        let itemPlayer = AVPlayerItem.init(url: previewUrl)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishSong), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: itemPlayer)

        avPlayer = AVPlayer(playerItem: itemPlayer)
        avPlayer.rate = 0.5
        avPlayer.play()
        
        pauseButton.isHidden = false
        setPlayerInfo(music: music)
    }
    
    @objc func pausePreview() {
        avPlayer.pause()
        configureButtonisHidden()
    }
    
    @objc func resumePreview() {
        avPlayer.play()
        configureButtonisHidden()
    }
    
    @objc func playerDidFinishSong() {
        self.clearPlayer()
    }
    func configureButtonisHidden() {
        resumeButton.isHidden = !resumeButton.isHidden
        pauseButton.isHidden = !pauseButton.isHidden
    }
    
    func setPlayerInfo(music: Music) {
        songTitleLabel.text = music.title
        songArtistLabel.text = music.artistName
        
        let musicPlaceholderString = "musicPlaceholder"
        guard let discPicURL = music.discImageURL else{
            discImageView.image = UIImage(named: musicPlaceholderString)
            return
        }
        
        let picURL = URL(string: discPicURL)!
        let placeholderImage = UIImage(named: musicPlaceholderString)
        discImageView.kf.indicatorType = .activity
        discImageView.kf.setImage(with: picURL, placeholder: placeholderImage)
    }
    
    func clearPlayer() {
        songTitleLabel.text = ""
        songArtistLabel.text = ""
        discImageView.image = UIImage()
        pauseButton.isHidden = true
        
        if let safePlayer = avPlayer {
            safePlayer.pause()
        }
        
        self.isHidden = true
    }
}
