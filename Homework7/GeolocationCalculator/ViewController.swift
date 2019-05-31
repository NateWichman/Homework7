//
//  ViewController.swift
//  GeolocationCalculatorApplication
//
//  Created by Joseph Stahle on 5/14/19.
//  Copyright © 2019 SWGVSUCIS657. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, SettingsSelectionViewControllerDelegate, HistoryTableViewControllerDelegate
{
    var entries : [LocationLookup] = [
        LocationLookup(origLat: 90.0, origLng: 0.0, destLat: -90.0, destLng: 0.0, timestamp: Date.distantPast),
        LocationLookup(origLat: -90.0, origLng: 0.0, destLat: 90.0, destLng: 0.0, timestamp: Date.distantFuture)]

    
    //Model data
    var distanceMetric: String = "Kilometers"
    var angleMetric: String = "Degrees"

    //Outlets
    @IBOutlet weak var latitudeP1: UITextField!
    @IBOutlet weak var latitudeP2: UITextField!
    
    @IBOutlet weak var longitudeP1: UITextField!
    @IBOutlet weak var longitudeP2: UITextField!
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var bearingLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //Styling
        view.backgroundColor = BACKGROUND_COLOR
        
        //
        let detectTouch: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(detectTouch)
    }
    
    func indicateSelection(pickerOption: String)
    {
        if(pickerOption == "Kilometers" || pickerOption == "Miles")
        {
            distanceMetric = pickerOption
        }
        else if(pickerOption == "Degrees" || pickerOption == "Mils")
        {
            angleMetric = pickerOption
        }
        if(!(self.latitudeP1.text == "" || self.latitudeP2.text == "" || self.longitudeP1.text == "" || self.longitudeP2.text == ""))
        {
            calculateButton(1)
        }
    }
    
    func selectEntry(entry: LocationLookup) {
       self.latitudeP1.text = "\(entry.origLat)"
       self.longitudeP1.text = "\(entry.origLng)"
       self.latitudeP2.text = "\(entry.destLat)"
       self.longitudeP2.text = "\(entry.destLng)"
        
       self.calculateButton(1)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == "settingsSegue")
        {
            if let navigationController = segue.destination as? UINavigationController
            {
                if let settingsController = navigationController.children[0] as? SettingsViewController
                {
                    settingsController.delegate = self
                    settingsController.d1 = distanceMetric
                    settingsController.b1 = angleMetric
                }
            }
        }
        if ( segue.identifier == "historySegue"){
            
            let vc = segue.destination as? HistoryTableViewController
            //vc?.entries.append(LocationLookup(origLat: latP1, origLng: lonP1, destLat: latP2, destLng: lonP2, timestamp: Date()))
            vc?.entries = entries
            vc?.delegate = self
        }
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }

    @IBAction func calculateButton(_ sender: Any)
    {
        if(!(self.latitudeP1.text == "" || self.latitudeP2.text == "" || self.longitudeP1.text == "" || self.longitudeP2.text == ""))
        {
            let latP1: Double = Double(latitudeP1.text!)!
            let lonP1: Double = Double(longitudeP1.text!)!
        
            let latP2: Double = Double(latitudeP2.text!)!
            let lonP2: Double = Double(longitudeP2.text!)!
        
            //Calculates distance in kilometers
            distanceLabel.text = "Distance: " + calculateDistance(latitudeP1: latP1, longitudeP1: lonP1, latitudeP2: latP2, longitudeP2: lonP2)
        
            //Calculates bearing in degrees
            bearingLabel.text = "Bearing: " + calculateBearing(latitudeP1: latP1, longitudeP1: lonP1, latitudeP2: latP2, longitudeP2: lonP2)
            
            entries.append(LocationLookup(origLat: latP1, origLng: lonP1, destLat: latP2, destLng: lonP2, timestamp: Date()))
        }
        
        view.endEditing(true)
    }
   
    @IBAction func clearButton(_ sender: Any)
    {
        latitudeP1.text = ""
        longitudeP1.text = ""
        
        latitudeP2.text = ""
        longitudeP2.text = ""
        
        distanceLabel.text = "Distance: "
        bearingLabel.text = "Bearing: "
        
        view.endEditing(true)
    }
    
    @IBAction func cancel(segue: UIStoryboardSegue)
    {
        
    }
    
    func calculateDistance(latitudeP1: Double, longitudeP1: Double, latitudeP2: Double, longitudeP2: Double) -> String
    {
        var distanceUnit: String = ""
        
        let coordinate1: CLLocation = CLLocation(latitude: latitudeP1, longitude: longitudeP1)
        let coordinate2: CLLocation = CLLocation(latitude: latitudeP2, longitude: longitudeP2)
        
        var distanceInMeters: Double = coordinate1.distance(from: coordinate2)
        
        //Convert from meters to kilometers
        distanceInMeters = distanceInMeters / 1000
        
        //Round to 2 decimal places of precision
        if(distanceMetric == "Miles")
        {
            distanceInMeters = distanceInMeters * 0.621371
            distanceUnit = " miles"
        }
        else if(distanceMetric == "Kilometers")
        {
            distanceUnit = " kilometers"
        }
        
        distanceInMeters = Double(round(100 * distanceInMeters) / 100)
        
        return String(distanceInMeters) + distanceUnit
    }

    func calculateBearing(latitudeP1: Double, longitudeP1: Double, latitudeP2: Double, longitudeP2: Double) -> String
    {
        var bearingUnit: String = ""
        
        let coordinate1: CLLocation = CLLocation(latitude: latitudeP1, longitude: longitudeP1)
        let coordinate2: CLLocation = CLLocation(latitude: latitudeP2, longitude: longitudeP2)
        
        let latP1: Double = degreesToRadians(degrees: coordinate1.coordinate.latitude)
        let lonP1: Double = degreesToRadians(degrees: coordinate1.coordinate.longitude)
        
        let latP2: Double = degreesToRadians(degrees: coordinate2.coordinate.latitude)
        let lonP2: Double = degreesToRadians(degrees: coordinate2.coordinate.longitude)
        
        let dLon = lonP2 - lonP1
        
        let y = sin(dLon) * cos(latP2)
        let x = cos(latP1) * sin(latP2) - sin(latP1) * cos(latP2) * cos(dLon)
        
        var radiansBearing: Double = atan2(y, x)
    
        radiansBearing = radiansToDegrees(radians: radiansBearing)
        
        if(angleMetric == "Degrees")
        {
            bearingUnit = " degrees"
        }
        else if(angleMetric == "Mils")
        {
            bearingUnit = " mils"
            radiansBearing = radiansBearing * 17.777778
        }
        
        //Round to 2 decimal places of precision
        radiansBearing = Double(round(100 * radiansBearing) / 100)
        
        return String(radiansBearing) + bearingUnit
    }
    
    func degreesToRadians(degrees: Double) -> Double
    {
        return degrees * .pi / 180.0
    }
    
    func radiansToDegrees(radians: Double) -> Double
    {
        return radians * 180.0 / .pi
    }
}
