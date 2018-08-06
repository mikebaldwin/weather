//
//  SummaryViewControllerTests.swift
//  WeatherTests
//
//  Created by Michael Baldwin on 8/4/18.
//  Copyright © 2018 mikebaldwin.co. All rights reserved.
//

import XCTest
@testable import Weather

class SummaryViewControllerTests: XCTestCase {
    
    var storyboard: UIStoryboard!
    var summaryViewController: SummaryViewController!
    
    override func setUp() {
        super.setUp()
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        summaryViewController = storyboard.instantiateViewController(withIdentifier: "SummaryViewController") as! SummaryViewController
        summaryViewController.loadViewIfNeeded()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testIBOutletsLoaded() {
        XCTAssertNotNil(summaryViewController.summaryLabel)
        XCTAssertNotNil(summaryViewController.temperatureLabel)
        XCTAssertNotNil(summaryViewController.locationLabel)
        XCTAssertNotNil(summaryViewController.detailsButton)
        XCTAssertNotNil(summaryViewController.refreshButton)
    }
        
}
