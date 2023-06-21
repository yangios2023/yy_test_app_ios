//
//  ViewController.swift
//  mf-ble-app
//
//  Created by Yang Ding on 19.06.23.
//

import UIKit

class StartViewController: UIViewController {
    
    
    @IBOutlet weak var peripheralListTableView: UITableView!
    
    
    @IBAction func startButton(_ sender: UIButton) {
        
        print("11111111")
    }
    
    var p1 : IosBlePeripheral?
    var p2  : IosBlePeripheral?
    var p3  : IosBlePeripheral?
    var peripheralList: [IosBlePeripheral] = []
    var tappedPeripheral: IosBlePeripheral?
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toToPeripheralDetail" {
            let destinationVC = segue.destination as! PeripheralDetailControllerViewController
            //self.blePeripheralServiceDelegate = destinationVC
            let indexPath = self.peripheralListTableView.indexPathForSelectedRow
            if let idxpath = indexPath {
                destinationVC.peripheral = self.peripheralList[idxpath.row]
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        p1 = IosBlePeripheral("one" , 111)
        p2 = IosBlePeripheral("two" , 222)
        p3 = IosBlePeripheral("three" , 333)
        peripheralList.append(p1!)
        peripheralList.append(p2!)
        peripheralList.append(p3!)
        
        peripheralListTableView.delegate = self
        peripheralListTableView.dataSource = self
        self.peripheralListTableView.reloadData()
    }
}

// MARK: --- Extension TableView DataSource
extension StartViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.peripheralList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = peripheralListTableView.dequeueReusableCell(withIdentifier: "peripheralCell", for: indexPath)
        //Default Content Configuration
        var content = cell.defaultContentConfiguration()
        content.text = self.peripheralList[indexPath.item].pname //.capitalized
        cell.contentConfiguration = content
        return cell
    }
    
    
}

// MARK: --- Extension TableView Delegate
extension StartViewController: UITableViewDelegate{
    // UITableViewDelegate method
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("here tapped:")
        print(self.peripheralList[indexPath.row].rssi)
        self.tappedPeripheral = self.peripheralList[indexPath.row]
    }
}

