//
//  IosBlePeripheral.swift
//  mf-ble-app
//
//  Created by Yang Ding on 21.06.23.
//

import Foundation


class IosBlePeripheral {
    var pname = ""
    var rssi = 0
    
    init(_ name: String = "", _ rssi: Int = 0) {
        self.pname = name
        self.rssi = rssi
    }
}
