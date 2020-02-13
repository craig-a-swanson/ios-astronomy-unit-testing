//
//  AstronomyTests.swift
//  AstronomyTests
//
//  Created by Craig Swanson on 2/12/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import XCTest
@testable import Astronomy

class AstronomyTests: XCTestCase {

    // Does decoding work?
    // Does decoding fail when given bad data?
    // Does it build the correct URL?
    // Does it build the correct URLRequest?
    // Are the results saved properly?
    // Is completion handler called if the networking fails
    // is completion handler called if the data is bad?  and if the data is good?
    
    func testForSomeNetworkResults() {
        let marsRoverClient = MarsRoverClient()
        var rover: MarsRover?
        var photos: [MarsPhotoReference] = []
        
        let roverResultsExpectation = expectation(description: "Wait for rover Rover results")
        
        marsRoverClient.fetchMarsRover(named: "curiosity") { (possibleRover, possibleError) in
            roverResultsExpectation.fulfill()
            if let error = possibleError {
                print("Error fetching rover \(error)")
                return
            }
            rover = possibleRover
        }
        wait(for: [roverResultsExpectation], timeout: 5)
        XCTAssertNotNil(rover)
        
        let photoResultsExpectation = expectation(description: "Wait for photo results")
        
        marsRoverClient.fetchPhotos(from: rover!, onSol: 2) { (possibleData, possibleError) in
            photoResultsExpectation.fulfill()
            photos = possibleData!
        }
        wait(for: [photoResultsExpectation], timeout: 5)
        XCTAssertTrue(photos.count == 74)
    }
    
    func testForValidMockData() {
        let mock = MockLoader()
        var rover: MarsRover?
        var photos: [MarsPhotoReference] = []
        mock.data = validRoverJSON
        let marsRoverClient = MarsRoverClient(dataLoader: mock)
        
        // This section completes the call to fetch the MarsRover photo_manifest
        let roverResultsExpectation = expectation(description: "Wait for rover results")
        
        marsRoverClient.fetchMarsRover(named: "curiosity") { (possibleRover, possibleError) in
            roverResultsExpectation.fulfill()
            if let error = possibleError {
                print("Error fetching rover \(error)")
                return
            }
            rover = possibleRover
        }
        wait(for: [roverResultsExpectation], timeout: 2)
        
        XCTAssertTrue(rover?.maxSol == 10)
        
        // This section uses the MarsRover from above and fetches the [MarsPhotoReference]
        mock.data = validSol1JSON
        
        let photoResultsExpectation = expectation(description: "Wait for photo results")
        
        marsRoverClient.fetchPhotos(from: rover!, onSol: 1) { (possibleData, possibleError) in
            photoResultsExpectation.fulfill()
            photos = possibleData!
        }
        wait(for: [photoResultsExpectation], timeout: 2)
        XCTAssertTrue(photos.count == 16)
    }
    
    func testForBadRoverData() {
        let mock = MockLoader()
        var rover: MarsRover?
        mock.data = invalidRoverJSON
        let marsRoverClient = MarsRoverClient(dataLoader: mock)
        
        // This section completes the call to fetch the MarsRover photo_manifest
        let roverResultsExpectation = expectation(description: "Wait for rover results")
        
        marsRoverClient.fetchMarsRover(named: "curiosity") { (possibleRover, possibleError) in
            roverResultsExpectation.fulfill()
            if let error = possibleError {
                print("Error fetching rover \(error)")
                return
            }
            rover = possibleRover
        }
        wait(for: [roverResultsExpectation], timeout: 2)
        
        XCTAssertFalse(rover?.maxSol == 10)
        XCTAssertNil(rover?.maxSol)
        XCTAssertNil(rover)
    }
    
    func testForBadPhotoData() {
        let mock = MockLoader()
        var rover: MarsRover?
        var photos: [MarsPhotoReference] = []
        mock.data = validRoverJSON
        let marsRoverClient = MarsRoverClient(dataLoader: mock)
        
        // This section completes the call to fetch the MarsRover photo_manifest
        let roverResultsExpectation = expectation(description: "Wait for rover results")
        
        marsRoverClient.fetchMarsRover(named: "curiosity") { (possibleRover, possibleError) in
            roverResultsExpectation.fulfill()
            if let error = possibleError {
                print("Error fetching rover \(error)")
                return
            }
            rover = possibleRover
        }
        wait(for: [roverResultsExpectation], timeout: 2)
        
        XCTAssertTrue(rover?.maxSol == 10)
        XCTAssertNotNil(rover)
        
        // This section uses the MarsRover from above and fetches the [MarsPhotoReference]
        mock.data = invalidSol1JSON
        
        let photoResultsExpectation = expectation(description: "Wait for photo results")
        
        marsRoverClient.fetchPhotos(from: rover!, onSol: 1) { (possibleData, possibleError) in
            photoResultsExpectation.fulfill()
            photos = possibleData ?? []
        }
        wait(for: [photoResultsExpectation], timeout: 2)
        XCTAssertFalse(photos.count == 16)
        XCTAssertTrue(photos.count == 0)
    }

}
