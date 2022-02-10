//
//  Repository.swift
//  GitHubRepositoryApp
//
//  Created by Bo-Young PARK on 2021/08/24.
//

import Foundation

struct Repository: Decodable {
    let id: Int
    let name: String
    let description: String?
    let stargazersCount: Int
    let language: String

    enum CodingKeys: String, CodingKey {
        case id, name, description, language
        case stargazersCount = "stargazers_count"
    }
    
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//
//        self.id = try values.decode(Int.self, forKey:  .id)
//        self.name = try values.decode(String.self, forKey: .name)
//
//        do {
//            self.description = try values.decode(String.self, forKey: .description)
//        } catch {
//            self.description = ""
//        }
//
//        self.stargazersCount = try values.decode(Int.self, forKey: .stargazersCount)
//        self.language = try values.decode(String.self, forKey: .language)
//    }
}


