//
//  ViewController.swift
//  TextGradien
//
//  Created by Hardip Kalola on 27/03/18.
//  Copyright © 2018 SOTSYS113. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // Declarations

    @IBOutlet weak var sliderDirection: UISlider!
    @IBOutlet weak var sliderColor: UISlider!
    @IBOutlet weak var lblText: UILabel!
    
    var startPoint:CGFloat = 0.5
    var endPoint:CGFloat = 0.5

    
    override func viewDidLoad() {
        super.viewDidLoad()

        if lblText.applyGradientWith(startColor: .red, endColor: .blue,startPoint: 0.5,endPoint: 0.5,direction: 0.0) {
            print("Gradient applied!")
        }
        else {
            print("Could not apply gradient")
            lblText.textColor = .black
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // Gradient Direction to change X Point

    @IBAction func sliderDirectionValue(_ sender: Any) {
        if lblText.applyGradientWith(startColor: .red, endColor: .blue,startPoint: startPoint,endPoint: endPoint,direction: CGFloat(sliderDirection.value)) {
            print("Direction applied!")
        }
        else {
            print("Could not apply Direction")
            lblText.textColor = .black
        }
    }
    // Gradient Value Changed
    @IBAction func sliderColorValue(_ sender: Any) {
        print(self.sliderColor.value)
        if (self.sliderColor.value < 0.5){
            if lblText.applyGradientWith(startColor: .red, endColor: .blue,startPoint: CGFloat(self.sliderColor.value),endPoint: 0.5,direction: 0) {
                startPoint = CGFloat(self.sliderColor.value)
                endPoint = 0.5
                print("Gradient applied!")
            }
            else {
                print("Could not apply gradient")
                lblText.textColor = .black
            }
        }else{
            if lblText.applyGradientWith(startColor: .red, endColor: .blue,startPoint: 0.5,endPoint: CGFloat(self.sliderColor.value),direction: 0) {
                print("Gradient applied!")
                startPoint = 0.5
                endPoint = CGFloat(self.sliderColor.value)
            }
            else {
                print("Could not apply gradient")
                lblText.textColor = .black
            }
        }
    }
}
//Extension for Label

extension UILabel {
    
    func applyGradientWith(startColor: UIColor, endColor: UIColor,startPoint: CGFloat, endPoint: CGFloat,direction: CGFloat) -> Bool {
        
        var startColorRed:CGFloat = 0
        var startColorGreen:CGFloat = 0
        var startColorBlue:CGFloat = 0
        var startAlpha:CGFloat = 0
        
        if !startColor.getRed(&startColorRed, green: &startColorGreen, blue: &startColorBlue, alpha: &startAlpha) {
            return false
        }
        var endColorRed:CGFloat = 0
        var endColorGreen:CGFloat = 0
        var endColorBlue:CGFloat = 0
        var endAlpha:CGFloat = 0
        
        if !endColor.getRed(&endColorRed, green: &endColorGreen, blue: &endColorBlue, alpha: &endAlpha) {
            return false
        }
        let gradientText = self.text ?? ""
        let name:String = NSAttributedStringKey.font.rawValue
        let textSize: CGSize = gradientText.size(withAttributes: [NSAttributedStringKey(rawValue: name):self.font])
        let width:CGFloat = textSize.width
        let height:CGFloat = textSize.height
        
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return false
        }
        
        UIGraphicsPushContext(context)
        
        let glossGradient:CGGradient?
        let rgbColorspace:CGColorSpace?
        let num_locations:size_t = 2
        let locations:[CGFloat] = [ startPoint, endPoint ]
        let components:[CGFloat] = [startColorRed, startColorGreen, startColorBlue, startAlpha, endColorRed, endColorGreen, endColorBlue, endAlpha]
        rgbColorspace = CGColorSpaceCreateDeviceRGB()
        glossGradient = CGGradient(colorSpace: rgbColorspace!, colorComponents: components, locations: locations, count: num_locations)
        
        let topCenter = CGPoint.zero
        let bottomCenter = CGPoint(x: direction, y: textSize.height)
        context.drawLinearGradient(glossGradient!, start: bottomCenter, end: topCenter, options: CGGradientDrawingOptions.drawsBeforeStartLocation)
        
        UIGraphicsPopContext()
        
        guard let gradientImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return false
        }
        UIGraphicsEndImageContext()
        self.textColor = UIColor(patternImage: gradientImage)
        return true
    }
}

