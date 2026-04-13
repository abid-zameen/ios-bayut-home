//
//  NewProjectsModels.swift
//  Home
//
//  Created by Hammad Shahid on 13/04/2026.
//

import Foundation

public enum Emirates: String, CaseIterable {
    case dubai = "5002"
    case abuDhabi = "6020"
    case sharjah = "5351"
    case ajman = "5385"
    case alain = "6057"
    case rasAlKhaimah = "5509"
    case ummAlQuwain = "5544"
    case fujairah = "6542"
    
    public var displayName: String {
        switch self {
        case .dubai: return "Dubai"
        case .abuDhabi: return "Abu Dhabi"
        case .sharjah: return "Sharjah"
        case .ajman: return "Ajman"
        case .alain: return "Al Ain"
        case .rasAlKhaimah: return "Ras Al Khaimah"
        case .ummAlQuwain: return "Umm Al Quwain"
        case .fujairah: return "Fujairah"
        }
    }
}

public enum UAECity: String {
    case dubai = "Dubai"
    case abuDhabi = "Abu Dhabi"
    case sharjah = "Sharjah"
    case ajman = "Ajman"
    case alain = "Al Ain"
    case rasAlKhaimah = "Ras Al Khaimah"
    case ummAlQuwain = "Umm Al Quwain"
    case fujairah = "Fujairah"
    
    public var slug: String {
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
    
    public var id: String {
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

struct ProjectHit: Codable, Hashable {
    let objectID: String
    let externalID: String?
    let title: String?
    let price: Double?
    let completionDetails: CompletionDetails?
    let unitCategories: [[UnitCategory]]?
    let location: [Location]?
    let coverPhoto: CoverPhoto?
    
    enum CodingKeys: String, CodingKey {
        case objectID, externalID, title, price, completionDetails, unitCategories, location, coverPhoto
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Handle objectID as String or Int
        if let str = try? container.decode(String.self, forKey: .objectID) {
            self.objectID = str
        } else if let int = try? container.decode(Int.self, forKey: .objectID) {
            self.objectID = String(int)
        } else {
            self.objectID = try container.decode(String.self, forKey: .objectID)
        }
        
        // Handle externalID as String or Int
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
    }
    
    struct CompletionDetails: Codable, Hashable {
        let completionDate: Double?
        let startDate: Double?
    }
    
    struct UnitCategory: Codable, Hashable {
        let name: String?
        let externalID: String?
        let id: Int?
        
        enum CodingKeys: String, CodingKey {
            case name, externalID, id
        }
        
        init(from decoder: Decoder) throws {
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
    
    struct Location: Codable, Hashable {
        let name: String?
        let externalID: String?
        let id: Int?
        
        enum CodingKeys: String, CodingKey {
            case name, externalID, id
        }
        
        init(from decoder: Decoder) throws {
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
    
    struct CoverPhoto: Codable, Hashable {
        let id: Int?
        let externalID: String?
        
        enum CodingKeys: String, CodingKey {
            case id, externalID
        }
        
        init(from decoder: Decoder) throws {
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
