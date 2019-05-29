//
//  GeolocationCalculatorTextField.swift
//  GeolocationCalculator
//
//  Created by Joseph Stahle on 5/22/19.
//  Copyright © 2019 SWGVSUCIS657. All rights reserved.
//

import UIKit

class GeolocationCalculatorTextField: DecimalMinusTextField
{
    override func awakeFromNib()
    {
        layer.borderWidth = 1.0
        layer.borderColor = FOREGROUND_COLOR.cgColor
        layer.cornerRadius = 5.0
        borderStyle = .roundedRect
        backgroundColor = UIColor.clear
        textColor = FOREGROUND_COLOR
        
        guard let placeholderText = placeholder
        else
        {
            return
        }
        
        attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: FOREGROUND_COLOR])
    }
}
