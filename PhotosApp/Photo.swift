
//  Photo.swift

import Foundation

struct Photo: Codable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let downloadURL: String

    enum CodingKeys: String, CodingKey {
        case id
        case author
        case width
        case height
        case downloadURL = "download_url"
    }
}

