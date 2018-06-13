//
// LineDialSlider

//
//  Created by Alex Gibson on 1/11/16.
//  Copyright © 2016 AG. All rights reserved.
//

import UIKit

protocol CustomSliderViewDelegate: class {
    func didFinishSliding(sender: Float)
}

@IBDesignable
class LineDialSlider: UISlider {
    
    @IBInspectable override var value: Float{
        didSet{
        }
    }
    @IBInspectable var trackerColor : UIColor = UIColor.whiteColor(){
        didSet{
            setNeedsDisplay()
      
        }
    }
    
    @IBInspectable var separaterColor  : UIColor = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1){
        didSet{
            setNeedsLayout()
        }
    }
    
    @IBInspectable var numberOfLines  : CGFloat = 100{
        didSet{
            setNeedsLayout()
        }
    }

    var trackerView = UIView()
    var circleView =  UIView()
    weak var delegate : CustomSliderViewDelegate?
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.userInteractionEnabled = true
        trackerView.backgroundColor = trackerColor
        self.addSubview(trackerView)
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(LineDialSlider.dragging(_:)))
        self.addGestureRecognizer(gesture)
        circleView.layer.cornerRadius = circleView.bounds.height / 2
        circleView.layer.masksToBounds = true
        circleView.backgroundColor = trackerColor
        circleView.alpha = 0
        self.addSubview(circleView)
        
        trackerView.frame = CGRectMake(0,0,5,self.bounds.height)
        // put it in the center
        let valuePoint = CGPointMake(CGFloat(self.value) * (self.bounds.width), CGRectGetMidY(bounds))
        trackerView.center = valuePoint
        circleView.frame = CGRectMake(0,0,self.bounds.height - 4,self.bounds.height - 4)
        circleView.layer.cornerRadius = circleView.bounds.height / 2
        circleView.center = valuePoint

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        trackerView.frame = CGRectMake(0,0,5,self.bounds.height)
        // put it in the center
        let center = CGPointMake(CGFloat(value) * (self.bounds.width), CGRectGetMidY(bounds))
        trackerView.center = center
        circleView.frame = CGRectMake(0,0,self.bounds.height - 4,self.bounds.height - 4)
        circleView.layer.cornerRadius = circleView.bounds.height / 2
        circleView.center = center

    }
    
    override func setValue(value: Float, animated: Bool) {
       
        if animated == true{
            self.layoutIfNeeded()
            super.setValue(value, animated: false)
            let valuePoint = CGPointMake(CGFloat(value) * (self.bounds.width), CGRectGetMidY(bounds))
            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { 
                self.trackerView.center = valuePoint
                }, completion: { (finished) in
                    
            })
        }else{
            super.setValue(value, animated: animated)
        }
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // animate
        self.circleView.center = trackerView.center
        let flip = CABasicAnimation(keyPath: "transform.rotation.y")
        let startValue =  CGFloat(M_PI) / 2
        let endValue = 0
        flip.fromValue = startValue
        flip.toValue = endValue
        flip.duration = 0.2
        self.circleView.layer.addAnimation(flip, forKey: nil)
        
        UIView.animateWithDuration(0.1, animations: {
            self.trackerView.alpha = 0
            self.circleView.alpha = 1
        })
        UIView.animateWithDuration(0.3, animations: {
            self.transform = CGAffineTransformMakeTranslation(0, -30)
        })
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
        self.trackerView.center = circleView.center
        let flip = CABasicAnimation(keyPath: "transform.rotation.y")
        let startValue =  0
        let endValue = CGFloat(M_PI) / 2
        flip.fromValue = startValue
        flip.toValue = endValue
        flip.duration = 0.2
        self.circleView.layer.addAnimation(flip, forKey: nil)

        UIView.animateWithDuration(0.3, animations: {
            
            self.transform = CGAffineTransformIdentity
            self.trackerView.alpha = 1
            self.circleView.alpha = 0
        })
        
        
    }

    
    func dragging(gesture: UIPanGestureRecognizer){
        var touch = gesture.locationInView(self)
        touch.y = CGRectGetMidY(bounds)
        self.circleView.center = touch
        self.trackerView.center = touch
        //self.setValue(Float(circleView.center.x / self.bounds.width), animated: false)
        delegate?.didFinishSliding(Float(circleView.center.x / self.bounds.width))
        if gesture.state == UIGestureRecognizerState.Ended{
            
            let flip = CABasicAnimation(keyPath: "transform.rotation.y")
            let startValue =  0
            let endValue = CGFloat(M_PI) / 2
            flip.fromValue = startValue
            flip.toValue = endValue
            flip.duration = 0.2
            self.circleView.layer.addAnimation(flip, forKey: nil)

            UIView.animateWithDuration(0.3, animations: {
                self.transform = CGAffineTransformIdentity
                self.trackerView.alpha = 1
                self.circleView.alpha = 0
            })
        }
    }

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code

        let width = self.bounds.width
        let lines : CGFloat = numberOfLines
        let linesWidth : CGFloat = 1.0
        let spacers = lines - 1.0
        let freeSpace = width - (lines * linesWidth)
        let spaceForSpacer = freeSpace / spacers
        
        let tallestLine = self.bounds.height - 10
        
        for x in 0...Int(numberOfLines){
            var height = tallestLine
            if numberOfLines == 100{
                let multipler = 5 + Int(x % 5)
                if multipler % 5 == 0{
                // tall line
                }else if multipler % 3 == 0{
                    height = height * 0.85
                }else{
                    height = height * 0.77
                    }
            }
            
            let verticalBuffer = (self.bounds.height - height) / 2
            
            if x == 0{
            /* Set the color that we want to use to draw the line */
            separaterColor.set()
            /* Get the current graphics context */
            let currentContext = UIGraphicsGetCurrentContext()
            /* Set the width for the line */
            CGContextSetLineWidth(currentContext, linesWidth)
            /* Start the line at this point */
            CGContextMoveToPoint(currentContext, spaceForSpacer * CGFloat(x), verticalBuffer)
            //CGContextMoveToPoint(currentContext,spaceForSpacer, self.bounds.size.height)
            /* And end it at this point */
            CGContextAddLineToPoint(currentContext,spaceForSpacer * CGFloat(x), self.bounds.height - verticalBuffer)
            /* Use the context's current color to draw the line */
            CGContextStrokePath(currentContext);
            }else{
                /* Set the color that we want to use to draw the line */
                UIColor.whiteColor().set()
                /* Get the current graphics context */
                let currentContext = UIGraphicsGetCurrentContext()
                /* Set the width for the line */
                CGContextSetLineWidth(currentContext, linesWidth)
                /* Start the line at this point */

                CGContextMoveToPoint(currentContext, (spaceForSpacer * CGFloat(x)) + (linesWidth * CGFloat(x)), verticalBuffer)
                //CGContextMoveToPoint(currentContext,spaceForSpacer, self.bounds.size.height)
                /* And end it at this point */
                CGContextAddLineToPoint(currentContext, (spaceForSpacer * CGFloat(x)) + (linesWidth * CGFloat(x)), self.bounds.height)
                /* Use the context's current color to draw the line */
                CGContextStrokePath(currentContext);
            }
        }
        
      }
    
    override func layoutSubviews() {
        trackerView.frame = CGRectMake(0,0,5,self.bounds.height)
        // put it in the center
        let valuePoint = CGPointMake(CGFloat(value) * (self.bounds.width), CGRectGetMidY(bounds))
        trackerView.center = valuePoint
        circleView.frame = CGRectMake(0,0,self.bounds.height - 4,self.bounds.height - 4)
        circleView.layer.cornerRadius = circleView.bounds.height / 2
        circleView.center = valuePoint
    }

}
