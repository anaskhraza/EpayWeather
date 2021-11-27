//
//  EpayWeather
//
//  Created by Anas khurshid on 28/11/2021.
//

import Foundation

struct SWError {
    enum Code: Int {
        case urlError                 = -6000
        case networkRequestFailed     = -6001
        case jsonSerializationFailed  = -6002
        case jsonParsingFailed        = -6003
    }
    
    let errorCode: Code
}
