//
//  ViewController.swift
//  iOS-MusicApp
//
//  Created by H43RO on 2021/06/12.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var playPauseButton: UIButton!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var progressSlider: UISlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func touchUpPlayPauseButton(_ sender: UIButton){
        print("Button tapped")
    }
    
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        print("Slider Value Changed")
    }
}

