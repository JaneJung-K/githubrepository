//
//  ApiManager.swift
//  GitHubRepositoryApp
//
//  Created by imac on 2022/02/09.
//

import RxSwift
import Foundation

//struct GitHupApi {
//    static let scheme = "https"
//    static let host = "dapi.kakao.com"
//    static let path = "/v2/search/"
//
//    func searchBlog(query: String) -> URLComponents {
//        var components = URLComponents()
//        components.scheme = GitHupApi.scheme
//        components.host = SearchBlogAPI.host
//        components.path = SearchBlogAPI.path + "blog"
//
//        components.queryItems = [
//            URLQueryItem(name: "query", value: query),
//            URLQueryItem(name: "size", value: "25")
//        ]
//
//        return components
//    }
//}

class GitHupNetwork {
    static let shared = GitHupNetwork()
    private let session: URLSession
//    let api = GitHupApi()
    let disposeBag = DisposeBag()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchRepositories(query: String) -> Single<Result<[Repository], GitHubNetworkError>> {
        guard let url = URL(string: "https://api.github.com/orgs/\(query)/repos") else {
            return .just(.failure(.invalidURL))
        }

        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"

        return session.rx.data(request: request as URLRequest)
            .map { data in
                do {
                    
                    let repositoryData = try JSONDecoder().decode([Repository].self, from: data)
                    return .success(repositoryData)
                } catch {
                    return .failure(.invalidJSON)
                }
            }
            .catch { _ in
                .just(.failure(.networkError))
            }
            .asSingle()
    }
    

}
