//
//  FernController.swift
//  BarnsleyFern
//
//  Created by Dalton Claybrook on 7/11/15.
//  Copyright © 2015 Claybrook Software, LLC. All rights reserved.
//

import UIKit

typealias FernControllerCompletion = (points: [CGPoint]) -> Void
typealias FernControllerProgress = (progress: Float) -> Void

class FernController {
    
    private var currentPoint: CGPoint
    
    // MARK: - Initializers
    
    init() {
        self.currentPoint = CGPointZero
    }
    
    // MARK: - Public
    
    func generatePointsWithIterations(iterations: UInt, completion: FernControllerCompletion) {
        self.generatePointsWithIterations(iterations, progress: nil, completion: completion)
    }
    
    func generatePointsWithIterations(iterations: UInt, progress: FernControllerProgress?, completion: FernControllerCompletion) {
        
        if iterations == 0 {
            assertionFailure("iterations must be > 0")
            return
        }
        
        var iterationsLeft = iterations
        let progressReportCount = 50
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            
            var currentPoint = CGPointZero
            var points = [currentPoint]
            while iterationsLeft > 0 {
                iterationsLeft--
                currentPoint = self.nextPointWithCurrentPoint(currentPoint)
                points.append(currentPoint)
                
                let mod = (Int(iterationsLeft) % Int(progressReportCount))
                if let progress = progress where mod == 0 {
                    let progressVal = Float(iterations - iterationsLeft) / Float(iterations)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        progress(progress: progressVal)
                    }
                }
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                completion(points: points)
            }
        }
    }
    
    // MARK: - Private
    
    func nextPointWithCurrentPoint(point: CGPoint) -> CGPoint {
        
        let randVal = arc4random_uniform(100)
        if (randVal < 1) {
            return self.f1PointFromPoint(point)
        } else if (randVal < 1 + 7) {
            return self.f3PointFromPoint(point)
        } else if (randVal < 1 + 7 + 7) {
            return self.f4PointFromPoint(point)
        } else {
            return self.f2PointFromPoint(point)
        }
    }
    
    // MARK: - Point Functions
    
    func f1PointFromPoint(point: CGPoint) -> CGPoint {
        // xn + 1 = 0
        // yn + 1 = 0.16 yn
        return CGPointMake(0, 0.16 * point.y)
    }
    
    func f2PointFromPoint(point: CGPoint) -> CGPoint {
        // xn + 1 = 0.85 xn + 0.04 yn
        // yn + 1 = −0.04 xn + 0.85 yn + 1.6
        return CGPointMake(0.85 * point.x + 0.04 * point.y, -0.04 * point.x + 0.85 * point.y + 1.6)
    }
    
    func f3PointFromPoint(point: CGPoint) -> CGPoint {
        // xn + 1 = 0.2 xn − 0.26 yn
        // yn + 1 = 0.23 xn + 0.22 yn + 1.6
        return CGPointMake(0.2 * point.x - 0.26 * point.y, 0.23 * point.x + 0.22 * point.y + 1.6)
    }
    
    func f4PointFromPoint(point: CGPoint) -> CGPoint {
        // xn + 1 = −0.15 xn + 0.28 yn
        // yn + 1 = 0.26 xn + 0.24 yn + 0.44
        return CGPointMake(-0.15 * point.x + 0.28 * point.y, 0.26 * point.x + 0.24 * point.y + 0.44)
    }
}
