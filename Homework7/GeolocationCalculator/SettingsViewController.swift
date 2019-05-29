//
//  settingsViewController.swift
//  GeolocationCalculatorApplication
//
//  Created by Joseph Stahle on 5/15/19.
//  Copyright © 2019 SWGVSUCIS657. All rights reserved.
//

import UIKit

protocol SettingsSelectionViewControllerDelegate
{
    func indicateSelection(pickerOption: String)
}

class SettingsViewController: UIViewController
{
    //Model data
    var distancePickerData: [String] = [String]()
    var bearingPickerData: [String] = [String]()
    var distancePickerSelection: String = ""
    var bearingPickerSelection: String = ""
    var delegate: SettingsSelectionViewControllerDelegate?
    
    //test
    var d1 = ""
    var b1 = ""
    
    //Outlets
    @IBOutlet weak var distanceUnitDisplayLabel: UILabel!
    @IBOutlet weak var bearingUnitDisplayLabel: UILabel!
    @IBOutlet weak var distanceUnitPickerView: UIPickerView!
    @IBOutlet weak var bearingUnitPickerView: UIPickerView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //Styling
        setNeedsStatusBarAppearanceUpdate()
        
        //
        distanceUnitDisplayLabel.text = d1
        bearingUnitDisplayLabel.text = b1
        
        let tapDistanceUnitDisplayLabel: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.tapDistanceUnitDisplayLabel))
        distanceUnitDisplayLabel.isUserInteractionEnabled = true
        distanceUnitDisplayLabel.addGestureRecognizer(tapDistanceUnitDisplayLabel)
        
        let tapBearingUnitDisplayLabel: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.tapBearingUnitDisplayLabel))
        bearingUnitDisplayLabel.isUserInteractionEnabled = true
        bearingUnitDisplayLabel.addGestureRecognizer(tapBearingUnitDisplayLabel)
        
        let hidePicker: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.hidePickerView))
        view.addGestureRecognizer(hidePicker)
    }
    
    @objc func hidePickerView(sender: UITapGestureRecognizer)
    {
        distanceUnitPickerView.isHidden = true
        bearingUnitPickerView.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        if let d = delegate
        {
            d.indicateSelection(pickerOption: distancePickerSelection)
            d.indicateSelection(pickerOption: bearingPickerSelection)
        }
    }
    
    @objc func tapDistanceUnitDisplayLabel(sender: UITapGestureRecognizer)
    {
        bearingUnitPickerView.isHidden = true
        
        if(d1 == "Kilometers")
        {
            distancePickerData = ["Kilometers", "Miles"]
        }
        else if(d1 == "Miles")
        {
            distancePickerData = ["Miles", "Kilometers"]
        }
        
        distanceUnitPickerView.delegate = self
        distanceUnitPickerView.dataSource = self
        distanceUnitPickerView.isHidden = false
    }
    
    @objc func tapBearingUnitDisplayLabel(sender: UITapGestureRecognizer)
    {
        distanceUnitPickerView.isHidden = true
        
        if(b1 == "Degrees")
        {
            bearingPickerData = ["Degrees", "Mils"]
        }
        else if(b1 == "Mils")
        {
            bearingPickerData = ["Mils", "Degrees"]
        }
        
        bearingUnitPickerView.delegate = self
        bearingUnitPickerView.dataSource = self
        bearingUnitPickerView.isHidden = false
    }
    
    @IBAction func saveButton(_ sender: UIBarButtonItem)
    {
        if let d = delegate
        {
            d.indicateSelection(pickerOption: distancePickerSelection)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    //Styling
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }

}

extension SettingsViewController: UIPickerViewDataSource, UIPickerViewDelegate
{
    //Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        if(pickerView == distanceUnitPickerView)
        {
            return 1
        }
        else
        {
            return 1
        }
    }

    //Number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if(pickerView == distanceUnitPickerView)
        {
            return distancePickerData.count
        }
        else
        {
            return bearingPickerData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if(pickerView == distanceUnitPickerView)
        {
            return distancePickerData[row]
        }
        else
        {
            return bearingPickerData[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if(pickerView == distanceUnitPickerView)
        {
            distancePickerSelection = distancePickerData[row]
            
            if(distancePickerSelection == "Kilometers")
            {
                distanceUnitDisplayLabel.text = distancePickerSelection
            }
            else if(distancePickerSelection == "Miles")
            {
                distanceUnitDisplayLabel.text = distancePickerSelection
            }
        }
        else
        {
            bearingPickerSelection = bearingPickerData[row]
            
            if(bearingPickerSelection == "Degrees")
            {
                bearingUnitDisplayLabel.text = bearingPickerSelection
            }
            else if(bearingPickerSelection == "Mils")
            {
                bearingUnitDisplayLabel.text = bearingPickerSelection
            }
        }
    }
}

extension UINavigationController
{
    override open var preferredStatusBarStyle: UIStatusBarStyle
        {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}
