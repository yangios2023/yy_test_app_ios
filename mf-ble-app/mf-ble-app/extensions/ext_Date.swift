//
//  ext_Date.swift
//  mf-ble-app
//
//  Created by Yang Ding on 22.06.23.
//

import Foundation

extension Date{
    static func formatTimestamp(from date: Date = Date(), format: String = "yyyy-MM-dd' 'HH:mm:ss.SSS") -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = format
        
        return "\(fmt.string(from: date))"
    }
    
    
    init(millis: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(millis / 1000))
        addTimeInterval(TimeInterval(Double(millis % 1000) / 1000))
    }
}
