//
//  GeolocationCalculatorButton.swift
//  GeolocationCalculator
//
//  Created by Joseph Stahle on 5/22/19.
//  Copyright © 2019 SWGVSUCIS657. All rights reserved.
//

import UIKit

class GeolocationCalculatorButton: UIButton
{
    override func awakeFromNib()
    {
        backgroundColor = FOREGROUND_COLOR
        tintColor = BACKGROUND_COLOR
        layer.cornerRadius = 5.0
    }
}
