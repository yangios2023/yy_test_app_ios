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
        guard self.containsOnlyHexDigit(data) && 2 < data.count && data.count <= 11 && data[0] == 133 && data[1] == 4 else { return nil }
        
        self.numberOfScannedNeighbors = Int(data[2])
        if data.count > 3 {
            self.averageRSSI = Int(data[3])
        }
        if data.count > 4 {
            self.bleGateway = Int(data[4])
        }
        if data.count > 5 {
            self.numberOfConnectedReaders = Int(data[5])
        }
        if data.count > 6 {
            self.numberOfConnectedPhones = Int(data[6])
        }
        if data.count > 7 {
            self.clusterID = Int(data[7])
        }
        if data.count > 8 {
            self.firmwareMajor = Int(data[8])
        }
        if data.count > 9 {
            self.firmwareMinor = Int(data[9])
        }
        if data.count > 10 {
            self.firmwareBugfix = Int(data[10])
        } 
        
    }
    
    func containsOnlyHexDigit(_ data: Data) -> Bool{
        
        for i in 0..<data.count {
            let byteValue  = (data[i])
            if byteValue < 0 || byteValue > 255 { // between 00 -> FF
                return false
            }
        }
        return true
    }
    
}
