//
//  EpayWeather
//
//  Created by Anas khurshid on 28/11/2021.
//

import Foundation
import CoreLocation

typealias WeatherCompletionHandler = (Weather?, SWError?) -> Void

protocol WeatherServiceProtocol {
    func retrieveWeatherInfo(_ location: CLLocation, completionHandler: @escaping WeatherCompletionHandler)
}
