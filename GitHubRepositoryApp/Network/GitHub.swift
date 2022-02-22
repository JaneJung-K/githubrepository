//
//  File.swift
//  GitHubRepositoryApp
//
//  Created by imac on 2022/02/22.
//

import Foundation
import Moya

public enum GitHub {
    case repos(org: String)
}

extension GitHub: TargetType {
    public var baseURL: URL {
        return URL(string: "https://api.github.com/orgs")!
    }
    
    public var path: String {
        switch self {
        case .repos(let org): return "/\(org)/repos"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .repos(org: _):
            return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .repos(org: _):
            return .requestPlain
        }
    }
    
    public var headers: [String: String]? {
        return ["Content-Type": "application/json"]
      }

      public var validationType: ValidationType {
        return .successCodes
      }
}
