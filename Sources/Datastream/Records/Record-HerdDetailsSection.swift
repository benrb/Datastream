//
//  Record-HerdDetailsSection.swift
//  
//
//  Created by Ben Barnett on 21/10/2021.
//

import Foundation

public struct NMRDetails: Record {
    public var recordIdentifier: RecordIdentifier
    public static var representableIdentifiers: [RecordIdentifier] {
        return [.nmrDetails]
    }

    public var nmrCounty: Int
    public var nmrOffice: Int
    public var recordingScheme: RecordingScheme
    public var weighingSequence: Int
    public var lastWeighNumber: Int
    public var nationalHerdMark: String
    public var predominantBreedCode: Int
    public var herdPrefix: String
    public var enrolDate: Date

    public init(string content: String) throws {
        recordIdentifier = try Field.identifierField.extractValue(from: content)
        Self.assertCanRepresentRecordIdentifier(recordIdentifier)

        nmrCounty = try Field(location: 3, length: 2).extractValue(from: content)
        nmrOffice = try Field(location: 6, length: 2).extractValue(from: content)
        recordingScheme = try Field(location: 9, length: 2).extractValue(from: content)
        weighingSequence = try Field(location: 12, length: 2).extractValue(from: content)
        lastWeighNumber = try Field(location: 15, length: 2).extractValue(from: content)
        nationalHerdMark = try Field(location: 33, length: 5).extractValue(from: content)
        predominantBreedCode = try Field(location: 39, length: 2).extractValue(from: content)
        herdPrefix = try Field(location: 42, length: 20).extractValue(from: content)
        enrolDate = try Field(location: 63, length: 6).extractValue(from: content)
    }
}

public enum RecordingScheme: Int {
    case premium   = 1
    case cmr       = 2
    case pmr       = 3
    case fmr       = 4
    case goats     = 5
    case isleOfMan = 6
    case jersey    = 7
    case guernsey  = 8
    case standard1 = 11
    case standard2 = 12
    case standard3 = 13
    case standard4 = 14
    case basic1    = 15
    case basic2    = 16
}

public struct AddressRecord: Record {
    public var recordIdentifier: RecordIdentifier
    public static var representableIdentifiers: [RecordIdentifier] {
        return [.address1, .address2, .address3, .address4, .address5]
    }
    
    public var content: String
    
    public init(string content: String) throws {
        recordIdentifier = try Field.identifierField.extractValue(from: content)
        Self.assertCanRepresentRecordIdentifier(recordIdentifier)
        
        self.content = try Field(location: 3, length: 35).extractValue(from: content).trimmingCharacters(in: CharacterSet.whitespaces)
    }
}

// MARK: -

public struct ServiceIndicators: Record {
    public var recordIdentifier: RecordIdentifier
    public static var representableIdentifiers: [RecordIdentifier] {
        return [.serviceIndicators]
    }

    public var county: String
    public var postcode: String
    public var serviceType: ServiceType
    public var isProgenyTesting: Bool
    public var isLifetimeYieldMember: Bool
    public var cowCardCycle: CowCardPrinting
    public var calfCropListCycle: Int

    public init(string content: String) throws {
        recordIdentifier = try Field.identifierField.extractValue(from: content)
        Self.assertCanRepresentRecordIdentifier(recordIdentifier)

        self.county = try Field(location: 3, length: 25).extractValue(from: content)
        self.postcode = try Field(location: 29, length: 8).extractValue(from: content)
        self.serviceType = try Field(location: 52, length: 1).extractValue(from: content)
        self.isProgenyTesting = try Field(location: 54, length: 1).extractValue(from: content)
        self.isLifetimeYieldMember = try Field(location: 56, length: 1).extractValue(from: content)
        self.cowCardCycle = try Field(location: 64, length: 1).extractValue(from: content)
        self.calfCropListCycle = try Field(location: 66, length: 1).extractValue(from: content)    
    }
}

public enum ServiceType: String {
    case automatic = "A"
    case manual    = "M"
    case unknown   = " "
}

public enum CowCardPrinting: Int {
    case none       = 0
    case end305     = 1
    case endNatural = 2
    case both       = 3
}

// MARK: -

public struct ServiceIndicatorsContinued: Record {
    public var recordIdentifier: RecordIdentifier
    public static var representableIdentifiers: [RecordIdentifier] {
        return [.serviceIndicatorsContinued]
    }

    public var isHerdwatchMember: Bool
    public var cellCountMembership: CellCountMembership

    public init(string content: String) throws {
        recordIdentifier = try Field.identifierField.extractValue(from: content)
        Self.assertCanRepresentRecordIdentifier(recordIdentifier)

        self.isHerdwatchMember = try Field(location: 3, length: 1).extractValue(from: content)
        self.cellCountMembership = try Field(location: 49, length: 1).extractValue(from: content)
    }
}

public enum CellCountMembership: Int {
    case notaMember    = 0
    case currentMember = 1
    case resigned      = 3 // There is no two
}
