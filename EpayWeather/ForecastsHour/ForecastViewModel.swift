//
//  EpayWeather
//
//  Created by Anas khurshid on 28/11/2021.
//

import Foundation
import UIKit

struct ForecastViewModel {
    let time: String
    let iconText: String
    let temperature: String
    let pop: String
    
    init(_ forecast: Forecast) {
        time = forecast.time
        iconText = forecast.iconText
        temperature = forecast.temperature
        pop = forecast.pop
        
    }
}
