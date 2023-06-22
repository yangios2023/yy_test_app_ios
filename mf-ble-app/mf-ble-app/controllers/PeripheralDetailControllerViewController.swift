//
//  PeripheralDetailControllerViewController.swift
//  mf-ble-app
//
//  Created by Yang Ding on 21.06.23.
//

import UIKit
import Combine

class PeripheralDetailControllerViewController: UIViewController {

    @IBAction func button2(_ sender: UIButton) {
        //dump(peripheral)
    }
    
    var peripheral : IosBlePeripheral?
    //use combine to get tapped peripheral
    var tappedPeripheralSubscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func handleSubscribedSequences(){
        //use combine to get peripheral 
    }
    
 

}
