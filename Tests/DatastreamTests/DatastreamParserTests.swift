//
//  DatastreamParserTests.swift
//  
//
//  Created by Ben Barnett on 19/10/2021.
//

import XCTest
@testable import Datastream

final class DatastreamParserTests: XCTestCase {
    
    func testAsyncIterator() async throws {
        let fileURL = Bundle.module.url(forResource: "SampleRecords", withExtension: "txt")!
        let parser = DatastreamParser(url: fileURL)
        for try await record in parser.records {
            XCTAssertNotNil(record)
        }
    }
    
    func testStructSpecialising() async throws {
        let fileURL = Bundle.module.url(forResource: "SampleRecords", withExtension: "txt")!
        let parser = DatastreamParser(url: fileURL)
        
        var iterator = parser.records.makeAsyncIterator()
        var currentRecord = try await iterator.next()
        XCTAssertTrue(currentRecord is NMRDetails)
        currentRecord = try await iterator.next()
        XCTAssertTrue(currentRecord is RecordingPart1)
        currentRecord = try await iterator.next()
        XCTAssertTrue(currentRecord is RecordingPart2)
        
    }
}
