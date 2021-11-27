//
//  EpayWeather
//
//  Created by Anas khurshid on 28/11/2021.
//

import Foundation
import UIKit

struct ForecastDailyViewModel {
      let weatherDescription: String
      let dateFull: String
      let iconLabel: String
      let temperatureLabel: String

  init(_ forecast: ForecastDaily) {
      weatherDescription = forecast.weatherDescription
      dateFull = forecast.dateFull
      iconLabel = forecast.iconLabel
      temperatureLabel = forecast.temperatureLabel
  }
}
