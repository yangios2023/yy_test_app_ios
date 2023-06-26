//
//  AdvDataManufacturerDataModel.swift
//  Yang_App_Test
//
//  Created by Yang Ding on 20.06.23.
//

import Foundation


struct AdvDataManufacturerDataModel: Codable{
    
    var numberOfScannedNeighbors : Int?
    var averageRSSI : Int?
    var bleGateway : Int?
    var numberOfConnectedReaders : Int?
    var numberOfConnectedPhones : Int?
    var clusterID : Int?
    var firmwareMajor : Int?
    var firmwareMinor : Int?
    var firmwareBugfix : Int?
    
    init?(manufacturerData: NSData){
        let data = Data(bytes: manufacturerData.bytes, count: Int(manufacturerData.length))
//        guard self.containsOnlyHexDigit(data) && 2 < data.count && data.count <= 11 && data[0] == 133 && data[1] == 4 else { return nil }
        
//
//        self.numberOfScannedNeighbors = Int(data[2])
//        if data.count > 3 {
//            self.averageRSSI = Int(data[3])
//        }
//        if data.count > 4 {
//            self.bleGateway = Int(data[4])
//        }
//        if data.count > 5 {
//            self.numberOfConnectedReaders = Int(data[5])
//        }
//        if data.count > 6 {
//            self.numberOfConnectedPhones = Int(data[6])
//        }
//        if data.count > 7 {
//            self.clusterID = Int(data[7])
//        }
//        if data.count > 8 {
//            self.firmwareMajor = Int(data[8])
//        }
//        if data.count > 9 {
//            self.firmwareMinor = Int(data[9])
//        }
//        if data.count > 10 {
//            self.firmwareBugfix = Int(data[10])
//        }
        
        
        let hexstr = data.reduce("") { $0 + String(format: "%02x", $1) + "+" } // hexstr is e.g. : 85+04+03+c0+04+00+00+64+01+04+3f+  need unit test here because manufacturerData:NSData can be some ridiculous value
        let hexStrArr = hexstr.components(separatedBy: "+")
        guard self.containsOnlyHexDigit(hexStrArr) && hexStrArr.count > 2 && hexStrArr.count <= 11 && !hexStrArr[2].isEmpty && hexStrArr[0] == "85" && hexStrArr[1] == "04" else { return nil }

        self.numberOfScannedNeighbors = Int(hexStrArr[2], radix: 16)!

        if hexStrArr.count > 3 && !hexStrArr[3].isEmpty{
            self.averageRSSI = Int(hexStrArr[3], radix: 16)!
        }
        if hexStrArr.count > 4 && !hexStrArr[4].isEmpty{
            self.bleGateway = Int(hexStrArr[4], radix: 16)!
        }
        if hexStrArr.count > 5 && !hexStrArr[5].isEmpty{
            self.numberOfConnectedReaders = Int(hexStrArr[5], radix: 16)!
        }
        if hexStrArr.count > 6 && !hexStrArr[6].isEmpty{
            self.numberOfConnectedPhones = Int(hexStrArr[6], radix: 16)!
        }
        if hexStrArr.count > 7 && !hexStrArr[7].isEmpty{
            self.clusterID = Int(hexStrArr[7], radix: 16)!
        }
        if hexStrArr.count > 8 && !hexStrArr[8].isEmpty{
            self.firmwareMajor = Int(hexStrArr[8], radix: 16)!
        }
        if hexStrArr.count > 9 && !hexStrArr[9].isEmpty{
            self.firmwareMinor = Int(hexStrArr[9], radix: 16)!
        }
        if hexStrArr.count > 10 && !hexStrArr[10].isEmpty{
            self.firmwareBugfix = Int(hexStrArr[10], radix: 16)!
        }
        
    }
    
    func containsOnlyHexDigit(_ hexstrList: [String]) -> Bool{
        for str in hexstrList{
            let allHex = str.allSatisfy { $0.isHexDigit }
            if !allHex {
                return false
            }
        }
        return true
    }
    
//    func containsOnlyHexDigit(_ data: Data) -> Bool{
//        for i in 0..<data.count {
//            let byteValue  = (data[i])
//            if byteValue < 0 || byteValue > 255 { // between 00 -> FF
//                return false
//            }
//        }
//        return true
//    }
    
}
