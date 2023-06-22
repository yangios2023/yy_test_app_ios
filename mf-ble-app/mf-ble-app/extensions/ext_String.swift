//
//  ext_String.swift
//  mf-ble-app
//
//  Created by Yang Ding on 22.06.23.
//

import Foundation
extension String {
    var uInt16: UInt16 {
        return UInt16(self, radix: 16) ?? 0
    }
    
    @discardableResult
    func log(printLog: Bool = true, prefix: String = "") -> String {
        let formattedString = "\(prefix)\(Date.formatTimestamp()) | \(self)"
//        if MobileFlowPluginImpl.shared?.environment == Environment.intDev {
//            print(formattedString)
//        }
        
        print(formattedString)
        return formattedString
    }
    
    
    func splitStringInHalf() -> (firstHalf: String, secondHalf: String) {
        let index = self.index(startIndex, offsetBy: count / 2)
        return (firstHalf: String(self[..<index]), secondHalf: String(self[index...]))
    }
    
}


