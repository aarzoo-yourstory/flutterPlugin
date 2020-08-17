//
//  VideoPlayerViewController.swift
//  Runner
//
//  Created by Aarzoo Varshney on 11/08/20.
//

import UIKit

class VideoPlayerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addPlayerView()
    }
    
    func addPlayerView(){
        let playerView = UIView()
        playerView.backgroundColor = .black
        playerView.frame = self.view.frame
        self.view.addSubview(playerView)
    }
}
