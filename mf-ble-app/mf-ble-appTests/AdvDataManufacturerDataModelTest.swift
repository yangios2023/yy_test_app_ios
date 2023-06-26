//
//  AdvDataManufacturerDataModelTest.swift
//  mf-ble-appTests
//
//  Created by Yang Ding on 25.06.23.
//

import XCTest
@testable import mf_ble_app

final class AdvDataManufacturerDataModelTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testAdvDataManufacturerDataModel_WhenInvalidNsDataForHexStringProvided_ShouldReturnFalse() {
        // Create a hex string
        let hexString = "mm00400007"
        // Convert the hex string to a byte array
        var byteArray = [UInt8]()
        var index = hexString.startIndex
        while index < hexString.endIndex {
            let byteString = hexString[index..<hexString.index(index, offsetBy: 2)]
            if let byte = UInt8(byteString, radix: 16) {
                byteArray.append(byte)
            }
            index = hexString.index(index, offsetBy: 2)
        }
        // Create an NSData object from the byte array
        let nsData = NSData(bytes: byteArray, length: byteArray.count)
        // Arrange
        let advObj = AdvDataManufacturerDataModel(manufacturerData: nsData)
        let isAdvObjCreated = advObj != nil
        dump(advObj)
        
        // Assert
        XCTAssertFalse(isAdvObjCreated, "Should have returned False for a invalid NSData")
    }
    
    func testAdvDataManufacturerDataModel_WhenValidNsDataForHexStringProvided_ShouldReturnTrue() {
        // Create a hex string
        let hexString = "850400000400007f010440"
        // Convert the hex string to a byte array
        var byteArray = [UInt8]()
        var index = hexString.startIndex
        while index < hexString.endIndex {
            let byteString = hexString[index..<hexString.index(index, offsetBy: 2)]
            if let byte = UInt8(byteString, radix: 16) {
                byteArray.append(byte)
            }
            index = hexString.index(index, offsetBy: 2)
        }
        // Create an NSData object from the byte array
        let nsData = NSData(bytes: byteArray, length: byteArray.count)
        let advObj = AdvDataManufacturerDataModel(manufacturerData: nsData)
        
        let isAdvObjCreated = advObj != nil
        
        // Assert
        XCTAssertTrue(isAdvObjCreated, "Should have returned TRUE for a valid NSData")
    }
    
    func testAdvDataManufacturerDataModel_WhenValidNsDataProvided_ReturnTrue() {
        // Create a hex string
        let hexString = "850400000400007f010440"
        var isAdvObjCreated = false
        var advObj: AdvDataManufacturerDataModel?
        if let nsdata = hexString.data(using: .utf8) as NSData?{
            advObj = AdvDataManufacturerDataModel(manufacturerData: nsdata)
        }
          
        isAdvObjCreated = advObj != nil
        
        // Assert
        XCTAssertTrue(isAdvObjCreated, "Should have returned TRUE for a valid NSData")
    }
}
