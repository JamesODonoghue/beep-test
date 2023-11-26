//
//  BeepTest_Watch_AppTests.swift
//  BeepTest Watch AppTests
//
//  Created by James O'Donoghue on 11/13/23.
//

import XCTest
@testable import BeepTest_Watch_App
final class BeepTest_Watch_AppTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testReturnOne() throws {
        let prefixSums = [7, 15, 23]
        let totalShuttlesCompleted = 1
        let currentLevel = LevelModel().getCurrentLevel(sumOfShuttles: prefixSums, totalShuttlesCompleted: totalShuttlesCompleted)
        
        XCTAssertEqual(currentLevel, 1, "The current level should be 2 for the given prefixSum and totalShuttlesCompleted values.")
    }

    func testShouldReturnTwo() throws {
        let prefixSums = [7, 15, 23]
        let totalShuttlesCompleted = 8
        let currentLevel = LevelModel().getCurrentLevel(sumOfShuttles: prefixSums, totalShuttlesCompleted: totalShuttlesCompleted)
        
        XCTAssertEqual(currentLevel, 2, "The current level should be 2 for the given prefixSum and totalShuttlesCompleted values.")
    }
    
    func testShouldReturn1() throws {
        let prefixSums = [7, 15, 23]
        let totalShuttlesCompleted = 7
        let currentLevel = LevelModel().getCurrentLevel(sumOfShuttles: prefixSums, totalShuttlesCompleted: totalShuttlesCompleted)
        
        XCTAssertEqual(currentLevel, 2, "The current level should be 2 for the given prefixSum and totalShuttlesCompleted values.")
    }
    
    func testShouldReturnThree() throws {
        let prefixSums = [7, 15, 23]
        let totalShuttlesCompleted = 17
        let currentLevel = LevelModel().getCurrentLevel(sumOfShuttles: prefixSums, totalShuttlesCompleted: totalShuttlesCompleted)
        
        XCTAssertEqual(currentLevel, 3, "The current level should be 2 for the given prefixSum and totalShuttlesCompleted values.")
    }
    
    func testLevelCompletedShouldReturnCurrentShuttle() throws {
        let prefixSums = [7, 15, 23]
        let totalShuttlesCompleted = 17
        let currentLevel = LevelModel().getCurrentLevel(sumOfShuttles: prefixSums, totalShuttlesCompleted: totalShuttlesCompleted)
        let currentShuttle = LevelModel().getCurrentShuttle(totalShuttlesCompleted: totalShuttlesCompleted, prefixSum: prefixSums, currentLevel: currentLevel)
        XCTAssertEqual(currentShuttle, 2)
    }
    func testLevelCompletedShouldReturnCurrentShuttleAnotherOne() throws {
        let prefixSums = [7, 15, 23]
        let totalShuttlesCompleted = 4
        let currentLevel = LevelModel().getCurrentLevel(sumOfShuttles: prefixSums, totalShuttlesCompleted: totalShuttlesCompleted)
        let currentShuttle = LevelModel().getCurrentShuttle(totalShuttlesCompleted: totalShuttlesCompleted, prefixSum: prefixSums, currentLevel: currentLevel)
        XCTAssertEqual(currentShuttle, 4)
    }
    
    func testLevelCompletedShouldReturnAnotherShuttle() throws {
        let prefixSums = [7, 15, 23, 32]
        let totalShuttlesCompleted = 7
        let currentLevel = LevelModel().getCurrentLevel(sumOfShuttles: prefixSums, totalShuttlesCompleted: totalShuttlesCompleted)
        let currentShuttle = LevelModel().getCurrentShuttle(totalShuttlesCompleted: totalShuttlesCompleted, prefixSum: prefixSums, currentLevel: currentLevel)
        XCTAssertEqual(currentShuttle, 0)
    }
    
    func testGetShuttle() throws {
        let prefixSums = [7, 15, 23, 32]
        let totalShuttlesCompleted = 7
        let currentLevel = LevelModel().getCurrentLevel(sumOfShuttles: prefixSums, totalShuttlesCompleted: totalShuttlesCompleted)
        let currentShuttle = LevelModel().getCurrentShuttle(totalShuttlesCompleted: totalShuttlesCompleted, prefixSum: prefixSums, currentLevel: currentLevel)
        XCTAssertEqual(currentShuttle, 0)
    }
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
