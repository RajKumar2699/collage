//
//  College Data.swift
//  College Management
//
//  Created by ADMIN on 06/01/24.
//

import Foundation

class collegeData {
    // Add properties based on your data structure
}

import Foundation

// Model for the Course
struct Course: Codable {
    let id: String
    let name: String
    let duration: Int
    let branches: [String]
    let isSemester: Bool
    let semester: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case duration
        case branches = "branch"
        case isSemester
        case semester
    }
}

// Model for the API response
struct APIResponse: Codable {
    let success: Bool
    let status: Int
    let message: String
    let response: [Course]
}
struct Branch {
    let name: String
    // Add other properties if needed
}
