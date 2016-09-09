//
//  SpeechBubble.swift
//  HWChat
//
//  Created by Christian Schraga on 9/8/16.
//  Copyright © 2016 Straight Edge Digital. All rights reserved.
//

import UIKit

@IBDesignable class SpeechBubble: UIView {
    
    @IBInspectable var strokeWidth: CGFloat = 2.0 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var radius: CGFloat = 10.0{
        didSet{
            setNeedsDisplay()
        }
    }

    @IBInspectable var borderColor: UIColor = UIColor.blackColor() {
        didSet{
            setNeedsDisplay()
        }
    }

    @IBInspectable var fillColor: UIColor   = UIColor.lightGrayColor(){
        didSet{
            setNeedsDisplay()
        }
    }

    private var _triangleSize: CGSize = CGSize(width: 0.1, height: 0.2)
    @IBInspectable var triangleSize: CGSize {
        get{
            return _triangleSize
        }
        set(newSize){
            if newSize.width >= 0.0 && newSize.width <= 1.0 && newSize.height >= 0.0 && newSize.height <= 1.0 {
                _triangleSize = newSize
                setNeedsDisplay()
            }
        }
    }
    
    private var _triangleYPosition: CGFloat = 0.6
    @IBInspectable var triangleYPosition: CGFloat {
        get{
            return _triangleYPosition
        }
        set(newY){
            if newY >= 0.0 && newY <= 1.0 {
                var adjustedY = min(newY, 1.0 - triangleSize.height)
                adjustedY     = max(adjustedY, triangleSize.height)
                _triangleYPosition = adjustedY
                setNeedsDisplay()
            }
        }
    }
    
    override func drawRect(rect: CGRect) {
        // Drawing code
        let actualTriangleSize = CGSize(width: rect.width * triangleSize.width, height: rect.height * triangleSize.height)
        let adjRadius = radius - strokeWidth/2.0
        
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetLineJoin(context, CGLineJoin.Round);
        CGContextSetLineWidth(context, strokeWidth);
        CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
        CGContextSetFillColorWithColor(context, fillColor.CGColor);
        
        CGContextBeginPath(context)
        let left   = rect.minX + strokeWidth/2.0
        let right  = rect.maxX - strokeWidth/2.0 - actualTriangleSize.width
        let farright = rect.maxX - strokeWidth/2.0
        let top    = rect.minY + strokeWidth/2.0
        let bottom = rect.maxY - strokeWidth/2.0
        
        CGContextMoveToPoint(context, left, bottom - adjRadius) //1
        CGContextAddLineToPoint(context, left, top + adjRadius) //2
        CGContextAddArcToPoint(context, left, top, right, top, adjRadius) //3
        CGContextAddLineToPoint(context, right - adjRadius, top) //4
        CGContextAddArcToPoint(context, right, top, right, top + adjRadius, adjRadius) //5
        
        //triangle
        let trianglePeak       = CGPoint(x: farright, y: rect.minY + rect.height*triangleYPosition)
        let triangleTopLeft    = CGPoint(x: right, y: trianglePeak.y - actualTriangleSize.height/2)
        let triangleBottomLeft = CGPoint(x: right, y: trianglePeak.y + actualTriangleSize.height/2)
        
        CGContextAddLineToPoint(context, triangleTopLeft.x, triangleTopLeft.y) //6
        let cp1 = CGPoint(x: triangleTopLeft.x + actualTriangleSize.width*0.3, y: triangleTopLeft.y + actualTriangleSize.height*0.4)
        let cp2 = CGPoint(x: triangleTopLeft.x + actualTriangleSize.height*0.5, y: trianglePeak.y + actualTriangleSize.height*0.10)
        CGContextAddQuadCurveToPoint(context, cp1.x, cp1.y, farright, trianglePeak.y) //7
        CGContextAddQuadCurveToPoint(context, cp2.x, cp2.y, triangleBottomLeft.x, triangleBottomLeft.y) //8
        //end triangle

        CGContextAddArcToPoint(context, right, bottom, right - adjRadius, bottom, adjRadius) //9
        CGContextAddLineToPoint(context, left + adjRadius, bottom) //10
        CGContextAddArcToPoint(context, left, bottom, left, bottom - adjRadius, adjRadius)
        
        // Draw and fill the bubble
        CGContextClosePath(context);
        CGContextDrawPath(context, CGPathDrawingMode.FillStroke);
        
    }
    

}
