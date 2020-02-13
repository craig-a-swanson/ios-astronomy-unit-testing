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
        
        mock.data = validSol1JSON
        
        let photoResultsExpectation = expectation(description: "Wait for photo results")
        
        marsRoverClient.fetchPhotos(from: rover!, onSol: 1) { (possibleData, possibleError) in
            photoResultsExpectation.fulfill()
            
            photos = possibleData!
        }
        wait(for: [photoResultsExpectation], timeout: 2)
        XCTAssertTrue(photos.count == 16)
    }

}
