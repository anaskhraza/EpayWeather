//
//  EpayWeather
//
//  Created by Anas khurshid on 28/11/2021.
//

import Foundation
import CoreLocation
import SwiftyJSON


struct OpenWeatherMapService: WeatherServiceProtocol {
    fileprivate let urlPath = "https://api.openweathermap.org/data/2.5/onecall"
    fileprivate let imageUrl = "http://openweathermap.org/img/wn/"
    
    //retrieve forecasts for next 9 hours
    fileprivate func getFirstFourForecasts(_ json: JSON) -> [Forecast] {
        var forecasts: [Forecast] = []
        
        for index in 0...8 {
            guard let forecastTempDegrees = json["hourly"][index]["temp"].double,
                  let rawDateTime = json["hourly"][index]["dt"].double,
                  let forecastPop = json["hourly"][index]["pop"].int,
                  let forecastIcon = json["hourly"][index]["weather"][0]["icon"].string else {
                      break
                  }
            
            let forecastTemperature = Temperature(
                openWeatherMapDegrees: forecastTempDegrees)
            let forecastTimeString = ForecastDateTime(date: rawDateTime, timeZone: TimeZone.current).shortTime
            
            //            let forcastIconText = weatherIcon.iconText
            
            let forecast = Forecast(time: forecastTimeString,
                                    iconText: forecastIcon,
                                    temperature: forecastTemperature.degrees, pop: String(forecastPop))
            
            forecasts.append(forecast)
        }
        
        return forecasts
    }
    
    //retrieve forecasts for next 5 days
    fileprivate func getDailyForecasts(_ json: JSON) -> [ForecastDaily] {
        var forecastsDaily: [ForecastDaily] = []
        
        for index in 0...4 {
            guard let forecastTemp1Degrees = json["daily"][index]["temp"]["max"].double,
                  let forecastTemp2Degrees = json["daily"][index]["temp"]["min"].double,
                  let rawDateTime = json["daily"][index]["dt"].double,
                  let weatherDescription = json["daily"][index]["weather"][0]["description"].string,
                  let forecastIcon = json["daily"][index]["weather"][0]["icon"].string else {
                      break
                  }
            
            
            let forecastTemperature1 = Temperature(
                openWeatherMapDegrees: forecastTemp1Degrees)
            let forecastTemperature2 = Temperature(
                openWeatherMapDegrees: forecastTemp2Degrees)
            
            let forecastTemprature = "\(forecastTemperature1.degrees)  \(forecastTemperature2.degrees)"
            
            let forecastTimeString = ForecastDailyDateTime(date: rawDateTime, timeZone: TimeZone.current).detailTime
            
            //            let forcastIconText = weatherIcon.iconText
            
            let forecast = ForecastDaily(weatherDescription: weatherDescription, dateFull: forecastTimeString, iconLabel: forecastIcon, temperatureLabel: forecastTemprature)
            
            forecastsDaily.append(forecast)
        }
        
        return forecastsDaily
    }
    
    //retrieve weather info for current tempratue
    func retrieveWeatherInfo(_ location: CLLocation, completionHandler: @escaping WeatherCompletionHandler) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        
        guard let url = generateRequestURL(location) else {
            let error = SWError(errorCode: .urlError)
            completionHandler(nil, error)
            return
        }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            // Check network error
            guard error == nil else {
                let error = SWError(errorCode: .networkRequestFailed)
                completionHandler(nil, error)
                return
            }
            
            // Check JSON serialization error
            guard let data = data else {
                let error = SWError(errorCode: .jsonSerializationFailed)
                completionHandler(nil, error)
                return
            }
            
            guard let json = try? JSON(data: data) else {
                let error = SWError(errorCode: .jsonParsingFailed)
                completionHandler(nil, error)
                return
            }
            
            // Get temperature, location and icon and check parsing error
            guard let tempDegrees = json["current"]["temp"].double,
                  let iconString = json["current"]["weather"][0]["icon"].string else {
                      let error = SWError(errorCode: .jsonParsingFailed)
                      completionHandler(nil, error)
                      return
                  }
            
            var weatherBuilder = WeatherBuilder()
            let temperature = Temperature( openWeatherMapDegrees:tempDegrees)
            weatherBuilder.temperature = temperature.degrees
            
            weatherBuilder.iconText = iconString
            
            weatherBuilder.forecasts = self.getFirstFourForecasts(json)
            weatherBuilder.forecastsDaily = self.getDailyForecasts(json)
            
            completionHandler(weatherBuilder.build(), nil)
        }
        
        task.resume()
    }
    
    
    
    // function to generate request url for weather API
    fileprivate func generateRequestURL(_ location: CLLocation) -> URL? {
        guard var components = URLComponents(string:urlPath) else {
            return nil
        }
        
        // get appId from Info.plist
        let filePath = Bundle.main.path(forResource: "Info", ofType: "plist")!
        let parameters = NSDictionary(contentsOfFile:filePath)
        let appId = parameters!["OWMAccessToken"]! as! String
        
        let latitude = String(location.coordinate.latitude)
        let longitude = String(location.coordinate.longitude)
        
        components.queryItems = [URLQueryItem(name:"lat", value:latitude),
                                 URLQueryItem(name:"lon", value:longitude),
                                 URLQueryItem(name:"appid", value:appId)]
        
        return components.url
    }
}
