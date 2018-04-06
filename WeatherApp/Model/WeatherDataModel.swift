//
//  WeatherDataModel.swift
//  WeatherApp
//
//  Created by Simon Winther on 2018-04-03.
//  Copyright © 2018 Simon Winther. All rights reserved.
//

import UIKit

class WeatherDataModel {

    //Declare your model variables here
    
    var temperature : Int = 0
    var condition : Int = 0
    var city : String = ""
    
    //fick göra såhär. .append("string" at: "siffra") funkade inte.
    var weatherArray = ["0", "1"]
    
    //This method turns a condition code into the name of the weather condition image
    
    func updateWeatherIcon(condition: Int) -> Array<String> {
    switch (condition) {
    
        case 0...300 :
            weatherArray[0] = "light_storm"
            weatherArray[1] = "Thunderous! \nBe carefull \nof high grounds"
            return weatherArray
        
        case 301...500 :
            weatherArray[0] = "light_rain"
            weatherArray[1] = "Light rain! \nTake umbrella \nif needed"
            return weatherArray
        
        case 501...600 :
            weatherArray[0] = "heavy_rain"
            weatherArray[1] = "Heavy rain! \nBring umbrella \nand coat"
            return weatherArray
        
        case 601...700 :
            weatherArray[0] = "light_snow"
            weatherArray[1] = "Light snow! \nWatch out \nfor hidden ice"
            return weatherArray
        
        case 701...771 :
            weatherArray[0] = "fog"
            weatherArray[1] = "It's foggy! \nBe carefull \nwhen driving"
            return weatherArray
        
        case 772...799 :
            weatherArray[0] = "heavy_storm"
            weatherArray[1] = "Rain and thunder! \nBe safe \nStay inside"
            return weatherArray
        
        case 800 :
            weatherArray[0] = "sunny"
            weatherArray[1] = "It's sunny! \nBe carefull \nof overexposure"
            return weatherArray
        
        case 801...804 :
            weatherArray[0] = "cloudy"
            weatherArray[1] = "Sun and clouds!\nPerfect weather \nfor a run"
            return weatherArray
        
        case 900...903, 905...1000  :
            weatherArray[0] = "heavy_storm"
            weatherArray[1] = "Rain and thunder! \nBe safe \nStay inside"
            return weatherArray
        
        case 903 :
            weatherArray[0] = "heavy_snow"
            weatherArray[1] = "Heavy snow! \nBe safe \nStay inside"
            return weatherArray
        
        case 904 :
            weatherArray[0] = "sunny"
            weatherArray[1] = "It's sunny! \nBe carefull \nof overexposure"
            return weatherArray
        
        default :
            weatherArray[0] = "dunno"
            weatherArray[1] = "Couldn't fetch \nthe weather"
            return weatherArray
        }
    }
}
