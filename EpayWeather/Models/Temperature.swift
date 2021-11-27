//
//  EpayWeather
//
//  Created by Anas khurshid on 28/11/2021.
//
import Foundation

struct Temperature {
    let degrees: String
    
    init(openWeatherMapDegrees: Double) {
        
        degrees = String(TemperatureConverter.kelvinToCelsius(openWeatherMapDegrees))+"°"
        
    }
}
