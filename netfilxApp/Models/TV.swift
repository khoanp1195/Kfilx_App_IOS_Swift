//
//  TV.swift
//  netfilxApp
//
//  Created by Nguyen  Khoa on 03/03/2023.
//

import Foundation

struct TrendingTVResponse: Codable
{
    let results: [TV]
}
struct TV: Codable
{
    let id: Int
    let media_type: String?
    let original_name: String?
    let original_tittle: String?
    let original_path: String?
    let overview: String?
    let vote_count: Int
    let release_date: String?
    let vote_average: Double
}
