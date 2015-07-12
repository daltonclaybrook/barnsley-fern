//
//  ViewController.swift
//  BarnsleyFern
//
//  Created by Dalton Claybrook on 7/11/15.
//  Copyright © 2015 Claybrook Software, LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var fernView: FernView!
    @IBOutlet var progressView: UIProgressView!
    
    private let fernController = FernController()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.fernView.pointColor = self.fernColor()
        self.progressView.progress = 0.0
    }
    
    // MARK: - Actions
    
    @IBAction func drawButtonPressed(sender: UIButton) {
        
        self.fernView.clearFern()
        self.fernController.generatePointsWithIterations(1_000_000, progress: { (progress) -> Void in
            
            self.progressView.progress = progress
            }) { (points) -> Void in
                
                self.fernView.drawWithPoints(points)
                self.progressView.progress = 1.0
        }
    }
    
    // MARK: - Private
    
    func fernColor() -> CGColorRef {
        
        return UIColor(red: 0.4, green: 1.0, blue: 0.4, alpha: 1.0).CGColor
    }
}


