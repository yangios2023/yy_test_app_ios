//
//  PeripheralsManager.swift
//  mf-ble-app
//
//  Created by Yang Ding on 22.06.23.
//

import CoreBluetooth
import RxSwift
import Combine

class PeripheralsManager : NSObject{
    
    let serviceUUID = CBUUID(string: "70de11e0-8504-4108-b387-6ceb6ea8886e") // Service UUID
    let peripheralUUID = CBUUID(string: "305725AD-0F6F-3F24-9BE1-4AE48A3F8BC8") // Peripheral UUID
    let characteristic1UUID = CBUUID(string: "70de11e1-8504-4108-b387-6ceb6ea8886e") // Character UUID
    let characteristic2UUID = CBUUID(string: "70de11e2-8504-4108-b387-6ceb6ea8886e") // Character UUID
    let v3AdvertisementName: String = "MobileFlowV3_"
    
    var myPeripheral: CBPeripheral?
    var blePeripheralList:[IosBlePeripheral] = []
    
    var centralManager: CBCentralManager?
    // RxSwift to transmit turn on/off bluetooth state
    var bluetoothStatusSubject = PublishSubject<CBManagerState>()
    var bluetoothStatusObserver: AnyObserver<CBManagerState> { bluetoothStatusSubject.asObserver() }
    var disposeBag = DisposeBag()
    
    //use combine to transmit bluetooth state to main view controller
    private let bluetoothActiveCombineSubject = PassthroughSubject<Bool, Never>()
    var bluetoothActiveCombinePublisher: AnyPublisher<Bool, Never> {
        bluetoothActiveCombineSubject.eraseToAnyPublisher()
    }
    //use combine to transmit peripheral list to plugin view controller
    private let peripheralListCombineSubject = PassthroughSubject<[IosBlePeripheral], Never>()
    var peripheralListCombinePublisher: AnyPublisher<[IosBlePeripheral], Never> {
        peripheralListCombineSubject.eraseToAnyPublisher()
    }
    
    
    var isBluetoothPowerOn = false
    static let shared = PeripheralsManager()
    
    private(set) var aliveTimer: Timer?
    private var aliveTimerActive: Bool { aliveTimer != nil }
    
    private override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        self.bluetoothStatusSubject.subscribe{
            status in
            self.handleChangeBluetoothStatus(status)
        } onError: { error in
            print(error)
        }.disposed(by: disposeBag)
        
    } // end of init()
    
    func handleChangeBluetoothStatus(_ centralState: CBManagerState){
        if centralState == CBManagerState.poweredOn{
            print("bluetooth is power on")
            self.isBluetoothPowerOn = true
            self.bluetoothActiveCombineSubject.send(true)
        } else {
            print("bluetooth not working")
            self.isBluetoothPowerOn = false
            self.bluetoothActiveCombineSubject.send(false)
        }
    }
    
    func triggerScan(){
        self.blePeripheralList = []
        centralManager?.scanForPeripherals(withServices: [serviceUUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
    }
}

// MARK: --- Extention CBCentralManagerDelegate
extension PeripheralsManager: CBCentralManagerDelegate{
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        //case unknown = 0
        //case resetting = 1
        //case unsupported = 2
        //case unauthorized = 3
        //case poweredOff = 4
        //case poweredOn = 5
        bluetoothStatusObserver.onNext(central.state)
    }
    
    func centralManager(_: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        // don't duplicate discovered devices
        guard RSSI.intValue < 0 else { return }
//        print("new peripherals discoverd:")
//        print(peripheral)
//        print("---------------------------------------------------")
//        dump(advertisementData)
//        print("---------------------------------------------------")
//        print(RSSI)
//        print()
        var manuObj: AdvDataManufacturerDataModel?
        if let manufacturerData = advertisementData["kCBAdvDataManufacturerData"]  as? NSData{
            manuObj = AdvDataManufacturerDataModel(manufacturerData: manufacturerData)
        }
        
        if  !self.blePeripheralList.contains(where: {$0.peripheralName == peripheral.name}){
            let ibp = IosBlePeripheral(peripheral, RSSI, manuObj)
            self.blePeripheralList.append(ibp)
            self.peripheralListCombineSubject.send(self.blePeripheralList)
        } else {
            if let foundPeripheral = self.blePeripheralList.first(where: { $0.peripheralName == peripheral.name }){
                foundPeripheral.setPeripheralRssi(RSSI)
                foundPeripheral.setAdvManufacturerData(manuObj)
                self.peripheralListCombineSubject.send(self.blePeripheralList)
            }
        } 
    }
    
    func centralManager(_: CBCentralManager, didConnect peripheral: CBPeripheral) {
        // "BleManager | \(#function) | peripheral: \(peripheral.description)".log()
        print("successful connected")
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        // Handle error
        print("did Fail To Connect peripheral")
    }
    
    
    func centralManager(_: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("My PeripheralManager   DISCONNECTED from:  \(peripheral.name ?? "unknown peripheral")")
    }
}  // end of  Extention CBCentralManagerDelegate
