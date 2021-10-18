//
//  Record.swift
//  
//
//  Created by Ben Barnett on 18/10/2021.
//

import Foundation

private let RECORD_LENGTH: Int = 76
private let DESCRIPTOR_LENGTH: Int = 2
private let CHECKSUM_LENGTH: Int = 5


/// The minimal properties of a datasteam record item
///
/// All datastream records start with a record descriptor and end with a checksum.
/// Content between these two varies between record types.
///
/// See ``BaseRecord`` for a minimal `Record` implementation
public protocol Record {
    var descriptor: RecordDescriptor { get }
    var checksum: Int { get }
}


public extension Record {
    
    static func validateRecordString(_ value: String) -> Bool {
        return validateRecordLength(value) && validateRecordStringChecksum(value)
    }
    
    static func validateRecordLength(_ value: String) -> Bool {
        return (value.lengthOfBytes(using: .ascii) == RECORD_LENGTH)
    }
    
    static func validateRecordStringChecksum(_ content: String) -> Bool {
        let endOffset = content.index(content.endIndex, offsetBy: -CHECKSUM_LENGTH)
        let contentToCheck = content.prefix(upTo: endOffset)
        let expectedSum = Int(content.suffix(CHECKSUM_LENGTH))!
        return (expectedSum == contentToCheck.asciiValues.map({ Int($0) }).reduce(0, +))
    }
}


enum RecordError: Error {
    case invalidLength
    case invalidChecksum
    case nonNumberChecksum
    case notEnoughContentSections
    case unknownDescriptor(value: String)
}


/// A basic implementation of a datasteam record item
///
/// Implements `Record`. It also provides:
/// - A variable containing the body content of the record
/// - An initializer to build a `BaseRecord` from a string, validating the
///  record length and checksum which doing so.
public struct BaseRecord: Record {
    private(set) public var descriptor: RecordDescriptor
    private(set) public var content: String
    private(set) public var checksum: Int
    
    init(string value: String) throws {
        guard BaseRecord.validateRecordLength(value) else {
            throw RecordError.invalidLength
        }
        guard BaseRecord.validateRecordStringChecksum(value) else {
            throw RecordError.invalidChecksum
        }
        let split = value.split(separator: ",").map { String($0) }
        guard split.count >= 3 else {
            throw RecordError.notEnoughContentSections
        }
        guard let ident = RecordDescriptor(rawValue: split.first!) else {
            throw RecordError.unknownDescriptor(value: split.first!)
        }
        guard let checksumValue = Int(split.last!) else {
            throw RecordError.nonNumberChecksum
        }
        
        // Offset by one more than the record size to trim out the commas
        // used to separate records. This will make later processing easier
        let contentStart = value.index(value.startIndex, offsetBy: DESCRIPTOR_LENGTH+1)
        let contentEnd = value.index(value.endIndex, offsetBy: -CHECKSUM_LENGTH-1)
        let trimmedContent = value[contentStart ..< contentEnd]
        
        descriptor = ident
        content = String(trimmedContent)
        checksum = checksumValue
    }
}
