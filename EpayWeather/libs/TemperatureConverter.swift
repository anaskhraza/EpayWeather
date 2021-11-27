//
//  EpayWeather
//
//  Created by Anas khurshid on 28/11/2021.
//

import Foundation

struct TemperatureConverter {
    static func kelvinToCelsius(_ degrees: Double) -> Int {
        return Int(round(degrees - 273.15))
    }
    
    static func kelvinToFahrenheit(_ degrees: Double) -> Int {
        return Int(round(degrees * 9 / 5 - 459.67))
    }
}
