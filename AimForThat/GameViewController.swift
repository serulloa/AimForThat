//
//  ViewController.swift
//  AimForThat
//
//  Created by Sergio Ulloa on 23/7/18.
//  Copyright © 2018 Sergio Ulloa. All rights reserved.
//

import UIKit
import QuartzCore

class GameViewController: UIViewController {
    
    // MARK: - Properties
    var currentValue : Int = 0
    var targetValue : Int = 0
    var score : Int = 0
    var round : Int = 0
    var time : Int = 0
    var timer : Timer?
    
    // MARK: IBOutlets
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var labelTarget: UILabel!
    @IBOutlet weak var labelScore: UILabel!
    @IBOutlet weak var labelRound: UILabel!
    @IBOutlet weak var labelTimer: UILabel!
    @IBOutlet weak var labelRecord: UILabel!
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSlider()
        
        resetGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: IBActions
    @IBAction func btnHitNowPressed() {
        let difference : Int = abs(self.currentValue - self.targetValue)
        var points = 100 - difference
        
        let title : String
        switch difference {
        case 0:
            title = "Perfect score!!!"
            points = Int(10.0 * Float(points))
        case 1...5:
            title = "Almost perfect!"
            points = Int(1.5 * Float(points))
        case 6...12:
            title = "Whoa! That was close"
            points = Int(1.2 * Float(points))
        default:
            title = "Well, that was a little too far..."
        }
        score += points
        
        let message = "You scored \(points) points"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Nice!", style: .default, handler: { action in
            self.startNewRound()
            self.updateLabels()
        })
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    @IBAction func sliderMoved(_ sender: UISlider) {
        self.currentValue = lroundf(sender.value)
    }
    
    @IBAction func btnRestartPressed(_ sender: Any) {
        self.resetGame()
        
        let transition = CATransition()
        transition.type = kCATransitionFade
        transition.duration = 1
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        self.view.layer.add(transition, forKey: nil) 
    }
    
    // MARK: Custom methods
    func startNewRound() {
        self.targetValue = 1 + Int(arc4random_uniform(100))
        self.currentValue = 50;
        self.slider.value = Float(self.currentValue)
        self.round += 1
    }
    
    func updateLabels() {
        self.labelTarget.text = "\(self.targetValue)"
        self.labelScore.text = "\(self.score)"
        self.labelRound.text = "\(self.round)"
        self.labelTimer.text = "\(self.time)"
    }
    
    func resetGame() {
        var maxScore = UserDefaults.standard.integer(forKey: "maxScore")
        if maxScore < self.score {
            maxScore = self.score
            UserDefaults.standard.set(maxScore, forKey: "maxScore")
        }
        self.labelRecord.text = "\(maxScore)"
        
        self.score = 0
        self.round = 0
        self.time = 60
        
        if self.timer != nil {
            self.timer?.invalidate()
        }
        
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
        
        self.startNewRound()
        self.updateLabels()
    }
    
    func setupSlider() {
        let thumbImageNormal = #imageLiteral(resourceName: "SliderThumb-Normal")
        let thumbImageHightlighted = #imageLiteral(resourceName: "SliderThumb-Highlighted")
        let trackLeftImage = #imageLiteral(resourceName: "SliderTrackLeft")
        let trackRightImage = #imageLiteral(resourceName: "SliderTrackRight")
        
        self.slider.setThumbImage(thumbImageNormal, for: .normal)
        self.slider.setThumbImage(thumbImageHightlighted, for: .highlighted)
        
        let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        let trackLeftResizable = trackLeftImage.resizableImage(withCapInsets: insets)
        let trackRightResizable = trackRightImage.resizableImage(withCapInsets: insets)
        
        self.slider.setMinimumTrackImage(trackLeftResizable, for: .normal)
        self.slider.setMaximumTrackImage(trackRightResizable, for: .normal)
    }
    
    @objc func tick() {
        self.time -= 1
        self.labelTimer.text = "\(self.time)"
        
        if self.time <= 0 {
            self.resetGame()
        }
    }
    
}

