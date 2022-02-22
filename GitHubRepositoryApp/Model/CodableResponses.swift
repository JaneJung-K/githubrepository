//
//  CodabelResponses.swift
//  GitHubRepositoryApp
//
//  Created by imac on 2022/02/22.
//

import Foundation

struct GitHubResponse<T: Codable>: Codable {
    let data: [T]
}

