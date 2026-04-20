//
//  NewProjectsModels.swift
//  Home
//
//  Created by Hammad Shahid on 13/04/2026.
//

import Foundation

enum Emirates: String, CaseIterable {
    case dubai = "5002"
    case abuDhabi = "6020"
    case sharjah = "5351"
    case ajman = "5385"
    case rasAlKhaimah = "5509"
    case ummAlQuwain = "5544"
    var displayName: String {
        switch self {
        case .dubai: return "Dubai"
        case .abuDhabi: return "Abu Dhabi"
        case .sharjah: return "Sharjah"
        case .ajman: return "Ajman"
        case .rasAlKhaimah: return "Ras Al Khaimah"
        case .ummAlQuwain: return "Umm Al Quwain"
        }
    }
}

enum UAECity: String {
    case dubai = "Dubai"
    case abuDhabi = "Abu Dhabi"
    case sharjah = "Sharjah"
    case ajman = "Ajman"
    case alain = "Al Ain"
    case rasAlKhaimah = "Ras Al Khaimah"
    case ummAlQuwain = "Umm Al Quwain"
    case fujairah = "Fujairah"
    
    var slug: String {
        switch self {
        case .dubai: return "/dubai"
        case .abuDhabi: return "/abu-dhabi"
        case .sharjah: return "/sharjah"
        case .ajman: return "/ajman"
        case .alain: return "/al-ain"
        case .rasAlKhaimah: return "/ras-al-khaimah"
        case .ummAlQuwain: return "/umm-al-quwain"
        case .fujairah: return "/fujairah"
        }
    }
    
    var id: String {
        switch self {
        case .dubai: return "5002"
        case .abuDhabi: return "6020"
        case .sharjah: return "5351"
        case .ajman: return "5385"
        case .alain: return "6057"
        case .rasAlKhaimah: return "5509"
        case .ummAlQuwain: return "5544"
        case .fujairah: return "6542"
        }
    }
}

public struct ProjectHit: Codable, Hashable {
    public let objectID: String
    public let externalID: String?
    public let title: String?
    public let price: Double?
    public let completionDetails: CompletionDetails?
    public let unitCategories: [[UnitCategory]]?
    public let location: [Location]?
    public let coverPhoto: CoverPhoto?
    
    public let completionStatus: String?
    public let _geoloc: Geography?
    
    enum CodingKeys: String, CodingKey {
        case objectID, externalID, title, price, completionDetails, unitCategories, location, coverPhoto, completionStatus, _geoloc
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let str = try? container.decode(String.self, forKey: .objectID) {
            self.objectID = str
        } else if let int = try? container.decode(Int.self, forKey: .objectID) {
            self.objectID = String(int)
        } else {
            self.objectID = try container.decode(String.self, forKey: .objectID)
        }
        
        if let str = try? container.decode(String.self, forKey: .externalID) {
            self.externalID = str
        } else if let int = try? container.decode(Int.self, forKey: .externalID) {
            self.externalID = String(int)
        } else {
            self.externalID = try? container.decode(String.self, forKey: .externalID)
        }
        
        self.title = try? container.decode(String.self, forKey: .title)
        self.price = try? container.decode(Double.self, forKey: .price)
        self.completionDetails = try? container.decode(CompletionDetails.self, forKey: .completionDetails)
        self.unitCategories = try? container.decode([[UnitCategory]].self, forKey: .unitCategories)
        self.location = try? container.decode([Location].self, forKey: .location)
        self.coverPhoto = try? container.decode(CoverPhoto.self, forKey: .coverPhoto)
        self.completionStatus = try? container.decode(String.self, forKey: .completionStatus)
        self._geoloc = try? container.decode(Geography.self, forKey: ._geoloc)
    }
    
    public func tojsonDict(imageBaseUrl: String) -> [String: Any] {
        var dict: [String: Any] = [:]
        dict["externalID"] = externalID
        dict["title"] = title
        dict["price"] = price
        dict["completionStatus"] = completionStatus
        
        if let photoID = coverPhoto?.id {
            dict["coverPhoto"] = ["url": "\(imageBaseUrl)\(photoID)-240x180.jpeg"]
        }
        
        if let geoloc = _geoloc {
            dict["geography"] = ["lat": geoloc.lat ?? 0.0, "lng": geoloc.lng ?? 0.0]
        }
        
        if let locations = location {
            dict["location"] = locations.map { loc -> [String: Any] in
                var locJSON: [String: Any] = [:]
                locJSON["externalID"] = loc.externalID
                locJSON["name"] = loc.name
                locJSON["name_l1"] = loc.nameL1
                locJSON["level"] = loc.level
                locJSON["slug"] = loc.slug
                locJSON["type"] = loc.type
                locJSON["id"] = loc.id
                return locJSON
            }
        }
        
        return dict
    }
    
    public struct Geography: Codable, Hashable {
        public let lat: Double?
        public let lng: Double?
    }
    
    public struct CompletionDetails: Codable, Hashable {
        public let completionDate: Double?
        public let startDate: Double?
    }
    
    public struct UnitCategory: Codable, Hashable {
        public let name: String?
        public let externalID: String?
        public let id: Int?
        
        enum CodingKeys: String, CodingKey {
            case name, externalID, id
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.name = try? container.decode(String.self, forKey: .name)
            self.id = try? container.decode(Int.self, forKey: .id)
            
            if let str = try? container.decode(String.self, forKey: .externalID) {
                self.externalID = str
            } else if let int = try? container.decode(Int.self, forKey: .externalID) {
                self.externalID = String(int)
            } else {
                self.externalID = try? container.decode(String.self, forKey: .externalID)
            }
        }
    }
    
    public struct Location: Codable, Hashable {
        public let name: String?
        public let nameL1: String?
        public let externalID: String?
        public let level: Int?
        public let id: Int?
        public let slug: String?
        public let type: String?
        
        enum CodingKeys: String, CodingKey {
            case name, externalID, id, level, slug, type
            case nameL1 = "name_l1"
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.name = try? container.decode(String.self, forKey: .name)
            self.id = try? container.decode(Int.self, forKey: .id)
            self.level = try? container.decode(Int.self, forKey: .level)
            
            if let str = try? container.decode(String.self, forKey: .externalID) {
                self.externalID = str
            } else if let int = try? container.decode(Int.self, forKey: .externalID) {
                self.externalID = String(int)
            } else {
                self.externalID = try? container.decode(String.self, forKey: .externalID)
            }
            
            self.nameL1 = try? container.decode(String.self, forKey: .nameL1)
            self.slug = try? container.decode(String.self, forKey: .slug)
            self.type = try? container.decode(String.self, forKey: .type)
        }
    }
    
    public struct CoverPhoto: Codable, Hashable {
        public let id: Int?
        public let externalID: String?
        
        enum CodingKeys: String, CodingKey {
            case id, externalID
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try? container.decode(Int.self, forKey: .id)
            
            if let str = try? container.decode(String.self, forKey: .externalID) {
                self.externalID = str
            } else if let int = try? container.decode(Int.self, forKey: .externalID) {
                self.externalID = String(int)
            } else {
                self.externalID = try? container.decode(String.self, forKey: .externalID)
            }
        }
    }
}

// MARK: - Helpers
extension Array where Element == ProjectHit {
    func uniqueByID() -> [ProjectHit] {
        var seenIDs = Set<String>()
        return filter { hit in
            let id = hit.externalID ?? hit.objectID
            return seenIDs.insert(id).inserted
        }
    }
}
