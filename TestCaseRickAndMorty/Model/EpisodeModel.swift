//
//  EpisodeModel.swift
//  TestCaseRickAndMorty
//
//  Created by Ruslan Magomedov on 17.08.2023.
//

import Foundation

struct EpisodeModel: Codable {
    let id: Int
    let name: String
    let air_date: String
    var episode: String
}
