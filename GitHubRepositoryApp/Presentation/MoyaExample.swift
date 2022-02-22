//
//  MoyaExample.swift
//  GitHubRepositoryApp
//
//  Created by imac on 2022/02/22.
//

import UIKit
import Moya
import RxSwift

class MoyaExampleViewController: UIViewController {
    
    let provider = MoyaProvider<GitHub>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        provider.request(.repos(org: "apple")) { [weak self] result in
//            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                do {
                    try response.map(GitHubResponse<[Repository]>.self)
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
