//
//  YoutubeSearchResponse.swift
//  netfilxApp
//
//  Created by Nguyen  Khoa on 12/03/2023.
//

import Foundation

struct YoutubeSearchResponse: Codable{
    let items: [VideoElement]
}

struct VideoElement: Codable
{
    let id: IdVideoELement
}
struct IdVideoELement: Codable
{
    let kind: String
    let videoId: String
}
