//
//  FernView.swift
//  BarnsleyFern
//
//  Created by Dalton Claybrook on 7/11/15.
//  Copyright © 2015 Claybrook Software, LLC. All rights reserved.
//

import UIKit

class FernView: UIView {
    
    // MARK: - Public Properties
    
    var pointColor = UIColor.greenColor().CGColor
    
    // MARK: - Private Properties
    
    private let pointSize: CGSize = CGSizeMake(1, 1)
    private var allPoints = [CGPoint]()
    
    // MARK: - Superclass
    
    override func drawRect(rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, self.pointColor)
        
        for point in self.allPoints {
            let pointRect = self.rectFromPoint(point)
            if (CGRectContainsRect(rect, pointRect) || CGRectIntersectsRect(rect, pointRect)) {
                CGContextFillRect(context, pointRect)
            }
        }
    }
    
    // MARK: - Public
    
    func clearFern() {
        
        self.allPoints.removeAll()
        self.setNeedsDisplay()
    }
    
    func drawWithPoints(points: [CGPoint]) {
        
        self.allPoints = points.map() { self.convertedPointFromPoint($0) }
        self.setNeedsDisplay()
    }
    
    // Mark: - Private
    
    private func convertedPointFromPoint(point: CGPoint) -> CGPoint {
        
        let multiplier = 55.0 as CGFloat
        let xShift = CGRectGetWidth(self.bounds) * 0.5
        let yShift = 40.0 as CGFloat
        
        return CGPointMake(point.x * multiplier + xShift, point.y * multiplier + yShift)
    }
    
    private func rectFromPoint(point: CGPoint) -> CGRect {
        
        return CGRectMake(point.x - (self.pointSize.width/2.0), point.y - (self.pointSize.height/2.0), self.pointSize.width, self.pointSize.height)
    }
}
