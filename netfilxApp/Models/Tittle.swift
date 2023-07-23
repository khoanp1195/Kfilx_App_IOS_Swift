//
//  Movie.swift
//  netfilxApp
//
//  Created by Nguyen  Khoa on 26/02/2023.
//

import Foundation

struct TrendingTittleResponse: Codable
{
    let results: [Tittle]
}
struct Tittle: Codable
{
    let id: Int 
    let media_type: String?
    let original_name: String?
    let original_title: String?
    let original_path: String?
    let overview: String?
    let vote_count: Int
    let release_date: String?
    let vote_average: Double
    let poster_path : String?
}
