//
//  Record-HerdDetailsSection.swift
//  
//
//  Created by Ben Barnett on 21/10/2021.
//

import Foundation

public struct NMRDetails: Record {
    public var descriptor: RecordDescriptor
    public var checksum: Int
    public var checksumIsValid: Bool

    public var nmrCounty: Int
    public var nmrOffice: Int
    public var recordingScheme: RecordingScheme
    public var weighingSequence: Int
    public var lastWeighNumber: Int
    public var nationalHerdMark: String
    public var predominantBreed: Int
    public var herdPrefix: String
    public var enrolDate: Date

    public init(string content: String) throws {
        descriptor = try RecordConstants.descriptorField.extractValue(from: content)
        guard descriptor == .nmrDetails else {
            fatalError("Attempting to create NMRDetails with wrong record type: \(descriptor)")
        }
        checksum = try RecordConstants.checksumField.extractValue(from: content)
        checksumIsValid = NMRDetails.validateRecordStringChecksum(content)

        self.nmrCounty = try Field(location: 3, length: 2).extractValue(from: content)
        self.nmrOffice = try Field(location: 6, length: 2).extractValue(from: content)
        self.recordingScheme = try Field(location: 9, length: 2).extractValue(from: content)
        self.weighingSequence = try Field(location: 12, length: 2).extractValue(from: content)
        self.lastWeighNumber = try Field(location: 15, length: 2).extractValue(from: content)
        self.nationalHerdMark = try Field(location: 33, length: 5).extractValue(from: content)
        self.predominantBreed = try Field(location: 39, length: 2).extractValue(from: content)
        self.herdPrefix = try Field(location: 42, length: 20).extractValue(from: content)
        self.enrolDate = try Field(location: 63, length: 6).extractValue(from: content)
    }
}

public struct ServiceIndicators: Record {
    public var descriptor: RecordDescriptor
    public var checksum: Int
    public var checksumIsValid: Bool

    public var county: String
    public var postcode: String
    public var serviceType: ServiceType
    public var isProgenyTesting: Bool
    public var isLifetimeYieldMember: Bool
    public var cowCardCycle: CowCardPrinting
    public var calfCropListCycle: Int

    public init(string content: String) throws {
        descriptor = try RecordConstants.descriptorField.extractValue(from: content)
        guard descriptor == .serviceIndicators else {
            fatalError("Attempting to create ServiceIndicators with wrong record type: \(descriptor)")
        }
        checksum = try RecordConstants.checksumField.extractValue(from: content)
        checksumIsValid = NMRDetails.validateRecordStringChecksum(content)

        self.county = try Field(location: 3, length: 25).extractValue(from: content)
        self.postcode = try Field(location: 29, length: 8).extractValue(from: content)
        self.serviceType = try Field(location: 52, length: 1).extractValue(from: content)
        self.isProgenyTesting = try Field(location: 54, length: 1).extractValue(from: content)
        self.isLifetimeYieldMember = try Field(location: 56, length: 1).extractValue(from: content)
        self.cowCardCycle = try Field(location: 64, length: 1).extractValue(from: content)
        self.calfCropListCycle = try Field(location: 66, length: 1).extractValue(from: content)    
    }
}

public struct ServiceIndicatorsContinued: Record {
    public var descriptor: RecordDescriptor
    public var checksum: Int
    public var checksumIsValid: Bool

    public var isHerdwatchMember: Bool
    public var cellCountMembership: CellCountMembership

    public init(string content: String) throws {
        descriptor = try RecordConstants.descriptorField.extractValue(from: content)
        guard descriptor == .serviceIndicatorsContinued else {
            fatalError("Attempting to create ServiceIndicatorsContinued with wrong record type: \(descriptor)")
        }
        checksum = try RecordConstants.checksumField.extractValue(from: content)
        checksumIsValid = NMRDetails.validateRecordStringChecksum(content)

        self.isHerdwatchMember = try Field(location: 3, length: 1).extractValue(from: content)
        self.cellCountMembership = try Field(location: 49, length: 1).extractValue(from: content)
    }
}
