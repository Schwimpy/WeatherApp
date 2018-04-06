//
//  ViewController.swift
//  WeatherApp
//
//  Created by Simon Winther on 2018-03-15.
//  Copyright © 2018 Simon Winther. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON


class ViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate2 {
    
    
    var dynamicAnimator : UIDynamicAnimator!
    var gravity : UIGravityBehavior!
    var collision : UICollisionBehavior!
    var pushB1, pushB2, pushB3 :UIPushBehavior!

    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "49ce4de544b8d27059946cdda6ae29b6"
    
    @IBOutlet weak var TheCity: UILabel!
    @IBOutlet weak var Degrees: UILabel!
    @IBOutlet weak var ShowInfo: UILabel!
    @IBOutlet weak var WeatherInfo: UIImageView!
    @IBOutlet weak var Background: UIImageView!
    @IBOutlet weak var beachBall1: UIImageView!
    @IBOutlet weak var beachBall2: UIImageView!
    @IBOutlet weak var beachBall3: UIImageView!
    
    
    
    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //TODO: Set up the location manager here
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //animations
        dynamicAnimator = UIDynamicAnimator(referenceView: view)
        gravity = UIGravityBehavior(items: [beachBall1, beachBall2, beachBall3])
        collision = UICollisionBehavior(items: [beachBall1, beachBall2, beachBall3])
        collision.translatesReferenceBoundsIntoBoundary = true
        dynamicAnimator.addBehavior(gravity)
        dynamicAnimator.addBehavior(collision)
        
        //Pharallax (funkar bara på riktig device)
        applyEffect(onView: Background, magnitude: 15)
        applyEffect(onView: WeatherInfo, magnitude: -10)
       
    }
    
    @IBAction func ScreenTapped(_ sender: UITapGestureRecognizer) {
        
        pushB1 = UIPushBehavior(items: [beachBall1], mode: .instantaneous)
        pushB2 = UIPushBehavior(items: [beachBall2], mode: .instantaneous)
        pushB3 = UIPushBehavior(items: [beachBall3], mode: .instantaneous)
        
        let n = Int(arc4random_uniform(2))
        var b1, b2, b3 : Double
        
        if (n == 0){
            b1 = -drand48()
            b2 = -drand48()
            b3 = drand48()
        } else {
            b1 = drand48()
            b2 = drand48()
            b3 = -drand48()
        }
        
        pushB1.pushDirection = CGVector(dx: b1, dy: 1)
        pushB2.pushDirection = CGVector(dx: b2, dy: 1)
        pushB3.pushDirection = CGVector(dx: b3, dy: 1)
        
        pushB1.magnitude = 10.0
        pushB2.magnitude = 10.0
        pushB3.magnitude = 10.0
        
        dynamicAnimator.addBehavior(pushB1)
        dynamicAnimator.addBehavior(pushB2)
        dynamicAnimator.addBehavior(pushB3)
    }
    
    
    //Background pharallax effect (funkar bara på riktig device)
    func applyEffect(onView: UIView, magnitude: Double) {
        //X axis
        let xAxisEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        xAxisEffect.minimumRelativeValue = -magnitude
        xAxisEffect.maximumRelativeValue = magnitude

        //Y axis
        let yAxisEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        yAxisEffect.minimumRelativeValue = -magnitude
        yAxisEffect.maximumRelativeValue = magnitude

        let effectGroup = UIMotionEffectGroup()
        effectGroup.motionEffects = [xAxisEffect, yAxisEffect]

        onView.addMotionEffect(effectGroup)
    }

   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    
    func getWeatherData(url: String, parameters: [String: String]) {
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                
                
                let weatherJSON : JSON = JSON(response.result.value!)
                
                
                
                self.updateWeatherData(json: weatherJSON)
                
                
            }
            else {
                print("Error \(String(describing: response.result.error))")
                self.TheCity.text = "Connection Issues"
            }
        }
        
    }
    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    
    //Write the updateWeatherData method here:
    
    func updateWeatherData(json : JSON) {
        
        if let tempResult = json["main"]["temp"].double {
        
        weatherDataModel.temperature = Int(tempResult - 273.15)

        weatherDataModel.city = json["name"].stringValue
        
        weatherDataModel.condition = json["weather"][0]["id"].intValue
        
        weatherDataModel.weatherArray = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            
            
        updateUIWithWeatherData()
            
        }
        else {
            TheCity.text = "Weather unavailable"
            Degrees.text = "??°C"
            WeatherInfo.image = UIImage(named: "dunno")
            ShowInfo.text = "Couldn't fetch \nthe weather \nfor that location"
        }
    }
    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    
    func updateUIWithWeatherData() {
        
        TheCity.text = weatherDataModel.city
        Degrees.text = "\(weatherDataModel.temperature)°C"
        WeatherInfo.image = UIImage(named: weatherDataModel.weatherArray[0])
        ShowInfo.text = weatherDataModel.weatherArray[1]
    }
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            //print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
            
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
    }
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        TheCity.text = "Could not find Location"
        ShowInfo.text = "An error occured"
    }
    
    
    
    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    
    func userEnteredANewCity(city: String) {
        
        let params : [String : String] = ["q" : city, "appid" : APP_ID]
        
        getWeatherData(url: WEATHER_URL, parameters: params)
        
    }
    
    //Write the PrepareForSegue Method here
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ChangeCityName" {
            let destinationVC = segue.destination as! ChangeCityTableViewController
            
            destinationVC.delegate = self
            
            //print(destinationVC.delegate)
        }
    }
    
    
}





















