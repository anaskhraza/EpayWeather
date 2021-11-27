//
//  EpayWeather
//
//  Created by Anas khurshid on 28/11/2021.
//

import Foundation
import CoreLocation
import UIKit


class WeatherViewModel {
    // MARK: - Constants
    fileprivate let emptyString = ""
    fileprivate let emptyImage = ""
    // MARK: - Properties
    let hasError: Observable<Bool>
    let errorMessage: Observable<String?>
    
    let location: Observable<String>
    let iconText: Observable<String>
    let temperature: Observable<String>
    let forecasts: Observable<[ForecastViewModel]>
    let forecastsDaily: Observable<[ForecastDailyViewModel]>
    // MARK: - Services
    
    fileprivate var weatherService: WeatherServiceProtocol
    
    // MARK: - init
    
    init() {
        hasError = Observable(false)
        errorMessage = Observable(nil)
        
        location = Observable(emptyString)
        iconText = Observable(emptyImage)
        temperature = Observable(emptyString)
        forecasts = Observable([])
        forecastsDaily = Observable([])
        
        weatherService = OpenWeatherMapService()
    }
    
    
    // MARK: - private
    fileprivate func update(_ weather: Weather) {
        hasError.value = false
        errorMessage.value = nil
        
        
        iconText.value = weather.iconText
        temperature.value = weather.temperature
        
        let tempForecasts = weather.forecasts.map { forecast in
            return ForecastViewModel(forecast)
        }
        forecasts.value = tempForecasts
        
        let tempForecastsDaily = weather.forecastsDaily.map { forecastDaily in
            return ForecastDailyViewModel(forecastDaily)
        }
        forecastsDaily.value = tempForecastsDaily
    }
    
    fileprivate func update(_ error: SWError) {
        hasError.value = true
        
        switch error.errorCode {
        case .urlError:
            errorMessage.value = "The weather service is not working."
        case .networkRequestFailed:
            errorMessage.value = "The network appears to be down."
        case .jsonSerializationFailed:
            errorMessage.value = "We're having trouble processing weather data."
        case .jsonParsingFailed:
            errorMessage.value = "We're having trouble parsing weather data."
        }
        
        location.value = emptyString
        iconText.value = emptyImage
        temperature.value = emptyString
        self.forecasts.value = []
    }
}

// MARK: LocationServiceDelegate
extension WeatherViewModel{
    func locationDidUpdate(location: CLLocation) {
        weatherService.retrieveWeatherInfo(location) { (weather, error) -> Void in
            DispatchQueue.main.async(execute: {
                if let unwrappedError = error {
                    print(unwrappedError)
                    self.update(unwrappedError)
                    return
                }
                
                guard let unwrappedWeather = weather else {
                    return
                }
                self.update(unwrappedWeather)
            })
        }
        
    }
    
    func locationDidFail(withError error: SWError) {
        self.update(error)
    }
}
