//
//  IosBlePeripheral.swift
//  mf-ble-app
//
//  Created by Yang Ding on 21.06.23.
//
import Foundation
import CoreBluetooth

class IosBlePeripheral {
    let v3AdvertisementName: String = "MobileFlowV3_"
    
    var peripheralName = ""
    var rssi:Int = 0
    var displayStr = ""
    var advManufacturerData: AdvDataManufacturerDataModel?
    
    var clusterIDStr = ""
    var bleStatusStr = ""
    
    init(_ peripheral: CBPeripheral?, _ rssi: NSNumber, _ advManuData: AdvDataManufacturerDataModel? ) {
        setPeripheralRssi(rssi)
        setAdvManufacturerData(advManuData)
        
        if let p = peripheral{
            if let pname = p.name{
                self.peripheralName = pname
                if pname.starts(with: v3AdvertisementName){
                    let majorMinor = extractMajorMinor(advertismentString: pname)
                    self.displayStr = "CID: \(majorMinor.major) DID: \(majorMinor.minor)"
                }
            }
        }
    }
    
    func setAdvManufacturerData(_ advManuData: AdvDataManufacturerDataModel? ){
        clusterIDStr = "unknown"
        bleStatusStr = "unknown"
        if let data = advManuData{
            self.advManufacturerData = data
            if let cid = self.advManufacturerData?.clusterID {
                clusterIDStr = String(cid)
            }
            if let ble = self.advManufacturerData?.bleGateway{
                bleStatusStr = String(ble)
            }
        }
    }
    
    func setPeripheralRssi(_ rssi: NSNumber){
        self.rssi = rssi.intValue
    }
      
    private func extractMajorMinor(advertismentString: String) -> (major: UInt16, minor: UInt16) {
        let majorMinor = advertismentString.replacingOccurrences(of: self.v3AdvertisementName, with: "", options: [.caseInsensitive, .regularExpression])
        guard majorMinor.count == 8 else {
            return (major: 0, minor: 0)
        }
        let majorRaw = majorMinor.splitStringInHalf().firstHalf.uInt16
        let minorRaw = majorMinor.splitStringInHalf().secondHalf.uInt16
        return (majorRaw, minorRaw)
    }
}
