//
//  MediaServices.swift
//  buscadorItunes
//
//  Created by Gabriel Quispe Delgadillo on 25/6/18.
//  Copyright © 2018 Gabriel Quispe Delgadillo. All rights reserved.
//

import Foundation
import AVFoundation
import AVKit

class VideoServices: NSObject {
    func launchVideoPlayer(previewUrl: String?, presenterViewController: UIViewController) {
        guard let safeUrl = previewUrl, let videoURL = URL(string: safeUrl) else {
            return
        }
        let player = AVPlayer(url: videoURL)
        player.allowsExternalPlayback = false
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        presenterViewController.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
}
