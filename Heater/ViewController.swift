//
//  ViewController.swift
//  Heater
//
//  Created by Alex Gibson on 1/11/16.
//  Copyright © 2016 AG. All rights reserved.
//

import UIKit

class ViewController: UIViewController,CustomSliderViewDelegate {

    @IBOutlet weak var sliderLabel: UILabel!
    @IBOutlet weak var slider: LineDialSlider!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        slider.delegate = self

        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = .PercentStyle
        sliderLabel.text = numberFormatter.stringFromNumber(NSNumber(float: slider.value))
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    @IBAction func setSliderDidPress(sender: AnyObject) {
        self.slider.setValue(0.9, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didFinishSliding(sender: Float) {
        print("Finished with value \(sender)")
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = .PercentStyle
        sliderLabel.text = numberFormatter.stringFromNumber(NSNumber(float: sender))

    }
    



}

