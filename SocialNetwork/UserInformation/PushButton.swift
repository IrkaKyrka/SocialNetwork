//
//  PushButton.swift
//  SocialNetwork
//
//  Created by Ira Golubovich on 1/3/19.
//  Copyright © 2019 Ira Golubovich. All rights reserved.
//

import UIKit

@IBDesignable
class PushButton: UIButton {

    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(rect: rect)
        UIColor.blue.setFill()
        path.fill(with: .colorBurn, alpha: 0.5)
        
       
        let plusSize: CGFloat = bounds.height * Constants.plusButtonScale
        let halfPlusSize = plusSize / 2
        let plusPath = UIBezierPath()
        let offset: CGFloat = bounds.height * Constants.offsetScale
        
        plusPath.lineWidth = Constants.plusLineWidth
        plusPath.move(to: CGPoint(
            x: width - plusSize - offset,
            y: halfHeight))
        plusPath.addLine(to: CGPoint(
            x: width - offset,
            y: halfHeight))
        
        plusPath.move(to: CGPoint(
            x: width - halfPlusSize - offset,
            y: offset))
        plusPath.addLine(to: CGPoint(
            x: width - halfPlusSize - offset,
            y: offset + plusSize))
        
        UIColor.white.setStroke()
        
        plusPath.stroke()
    }


    private var width: CGFloat {
        return bounds.width
    }
    
    private var halfHeight: CGFloat {
        return bounds.height / 2
    }

}

private struct Constants {
    static let plusLineWidth: CGFloat = 3.0
    static let plusButtonScale: CGFloat = 0.6
    static let halfPointShift: CGFloat = 0.5
    static let offsetScale: CGFloat = 0.2
}
    
