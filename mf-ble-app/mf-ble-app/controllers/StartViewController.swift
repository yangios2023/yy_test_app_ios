//
//  ViewController.swift
//  mf-ble-app
//
//  Created by Yang Ding on 19.06.23.
//

import UIKit
import Combine

class StartViewController: UIViewController {
    
    @IBOutlet weak var clickLocationSwitch: UISwitch!
    @IBOutlet weak var clickBluetoothSwitch: UISwitch!
    @IBOutlet weak var peripheralListTableView: UITableView!
    
    var hasUserLocationPermission: Bool = false
    var userLocationManager: UserLocationManager?
    var isBluetoothPowerOn: Bool = false
    var peripheralsManager : PeripheralsManager?
    
    //use combine to replace RxSwift
    var userLocationSubscriptions = Set<AnyCancellable>()
    var bluetoothStatusSubscriptions = Set<AnyCancellable>()
    //use combine to get newest peripheral list
    var peripheralListSubscriptions = Set<AnyCancellable>()
    
    var peripheralList: [IosBlePeripheral] = []
    var tappedPeripheral: IosBlePeripheral?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userLocationManager = UserLocationManager.shared
        self.peripheralsManager = PeripheralsManager.shared
        
        peripheralListTableView.delegate = self
        peripheralListTableView.dataSource = self
        self.peripheralListTableView.reloadData()
        
        self.handleSubscribedSequences()
        
    }
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toToPeripheralDetail" {
            let destinationVC = segue.destination as! PeripheralDetailControllerViewController
           
            let indexPath = self.peripheralListTableView.indexPathForSelectedRow
            if let idxpath = indexPath {
                //self.peripheralsManager?.centralManager?.stopScan()
                destinationVC.peripheral = self.peripheralsManager?.blePeripheralList[idxpath.row]
            }
        }
    }
    
    func handleSubscribedSequences(){
        //use combine to get location authorization status from UserLocation manager
        if let publisher_userLocationPermission = self.userLocationManager?.userLocationAuthorizationCombinePublisher {
            publisher_userLocationPermission
                .sink { hasPermission in
                    self.hasUserLocationPermission = hasPermission 
                    self.initialLocationSwitchButtons()
                    self.handleChangeAuthorization(hasPermission)
                }
                .store(in: &self.userLocationSubscriptions)
        }
        //use combine to get bluetooth state value from Peripherals manager
        if let publisher_bluetoothState = self.peripheralsManager?.bluetoothActiveCombinePublisher {
            publisher_bluetoothState
                .sink { state in
                    self.isBluetoothPowerOn = state
                    self.initialBluetoothSwitchButtons()
                    self.handleChangeAuthorization(state)
                }
                .store(in: &self.bluetoothStatusSubscriptions)
        }
        
        //use combine to get peripherals from Peripherals manager
        if let publisher_peripherals = self.peripheralsManager?.peripheralListCombinePublisher {
            publisher_peripherals
                .sink { list in
                    self.peripheralList = list
                    self.peripheralListTableView.reloadData()
                }
                .store(in: &self.peripheralListSubscriptions)
        }
        
    }
    
    func handleChangeAuthorization(_ hasPermission:Bool){
        if self.hasUserLocationPermission && isBluetoothPowerOn {
            self.peripheralsManager?.triggerScan()
        } else {
            self.peripheralsManager?.centralManager?.stopScan()
            self.peripheralList = []
            self.peripheralListTableView.reloadData()
        }
    }
    
    func initialBluetoothSwitchButtons(){
        clickBluetoothSwitch.isOn = self.isBluetoothPowerOn
        clickBluetoothSwitch.isEnabled = false // always set to false since bluetooth on/off only set in device configureation
        clickBluetoothSwitch.addTarget(self, action: #selector(bluetoothSwitchValueChanged(_:)), for: UIControl.Event.valueChanged)
    }
    
    func initialLocationSwitchButtons(){
        clickLocationSwitch.isOn = self.hasUserLocationPermission
        if(self.hasUserLocationPermission){
            clickLocationSwitch.isEnabled = false
        }
        clickLocationSwitch.addTarget(self, action: #selector(locationSwitchValueChanged(_:)), for: UIControl.Event.valueChanged)
    }
    
    @objc func locationSwitchValueChanged(_ sender: UISwitch){
        if sender.isOn && !self.hasUserLocationPermission{
            if let manager = self.userLocationManager{
                manager.requestUserLocationAuthorization()
            }
        }
    }
    @objc func bluetoothSwitchValueChanged(_ sender: UISwitch){
        if sender.isOn{
            if !self.isBluetoothPowerOn {// !self.isBluetoothPowerOn
                self.promptUserToEnableBluetooth()
            }
        }
    }
    
    func promptUserToEnableBluetooth() {
        let alert = UIAlertController(title: "Bluetooth is disabled", message: "Please enable Bluetooth in Settings", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (action) in guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil) }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    
} // end of StartViewController class

// MARK: --- Extension TableView DataSource
extension StartViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.peripheralList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = peripheralListTableView.dequeueReusableCell(withIdentifier: "peripheralCell", for: indexPath)
        //Default Content Configuration
        var content = cell.defaultContentConfiguration()
        content.text = self.peripheralList[indexPath.item].displayStr 
        content.secondaryText = "rssi: \(self.peripheralList[indexPath.item].rssi) \nClusterID:\(self.peripheralList[indexPath.item].clusterIDStr)\nBLE Status:\(self.peripheralList[indexPath.item].bleStatusStr)"
        cell.contentConfiguration = content
        return cell
    } 
}

// MARK: --- Extension TableView Delegate
extension StartViewController: UITableViewDelegate{
    // UITableViewDelegate method
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("here tapped:")
//        print(self.peripheralList[indexPath.row].rssi)
//        self.tappedPeripheral = self.peripheralList[indexPath.row]
    }
}

