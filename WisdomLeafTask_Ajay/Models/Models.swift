//
//  Models.swift
//  WisdomLeafTask_Ajay
//
//  Created by Venkata Ajay Sai Nellori on 17/05/23.
//

import Foundation
// MARK: - AuthorInfo
struct AuthorInfo: Codable {
    let id, author: String?
    let width, height: Int?
    let url, downloadURL: String?
    var selected = false
    enum CodingKeys: String, CodingKey {
        case id, author, width, height, url
        case downloadURL = "download_url"
    }
}
