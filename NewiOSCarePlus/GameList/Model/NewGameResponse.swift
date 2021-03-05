//
//  NewGameResponse.swift
//  NewiOSCarePlus
//
//  Created by 이승재 on 2021/03/05.
//

import Foundation

struct NewGameResponse: Decodable {
    var contents: [NewGameContent]
    let length: Int
    let offset: Int
    let total: Int
}

struct NewGameContent: Decodable {
    let formalName: String
    let heroBannerURL: String
    let id: Int
    let screenshots: [ScreenShots]
    enum CodingKeys: String, CodingKey {
        case formalName = "formal_name"
        case heroBannerURL = "hero_banner_url"
        case id, screenshots
    }
}

struct ScreenShots: Decodable {
    let images: [Image]
}

struct Image: Decodable {
    let url: String
}
