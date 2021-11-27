//
//  EpayWeather
//
//  Created by Anas khurshid on 28/11/2021.
//

import Foundation
import UIKit

struct WeatherBuilder {
    
    var iconText: String?
    var temperature: String?
    
    var forecasts: [Forecast]?
    var forecastsDaily: [ForecastDaily]?
    
    func build() -> Weather {
        return Weather(
            iconText: iconText!,
            temperature: temperature!,
            forecasts: forecasts!, forecastsDaily: forecastsDaily!)
    }
}
