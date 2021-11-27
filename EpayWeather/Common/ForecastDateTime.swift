//
//  EpayWeather
//
//  Created by Anas khurshid on 28/11/2021.
//

import Foundation

struct ForecastDateTime {
    let rawDate: Double
    let timeZone: TimeZone
    
    init(date: Double, timeZone: TimeZone) {
        self.timeZone = timeZone
        self.rawDate = date
    }
    
    var shortTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = "HH:mm"
        let date = Date(timeIntervalSince1970: rawDate)
        return dateFormatter.string(from: date)
    }
}

struct ForecastDailyDateTime {
    let rawDate: Double
    let timeZone: TimeZone
    
    init(date: Double, timeZone: TimeZone) {
        self.timeZone = timeZone
        self.rawDate = date
    }
    
    var detailTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = "E, MMM dd"
        let date = Date(timeIntervalSince1970: rawDate)
        return dateFormatter.string(from: date)
    }
}
