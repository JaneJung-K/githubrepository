//
//  RepositoryListViewController.swift
//  GitHubRepositoryApp
//
//  Created by Bo-Young PARK on 2021/08/24.
//

import UIKit
import RxSwift
import RxCocoa

class RepositoryListViewController: UIViewController {
    private let organization = "GitHub"
    private let disposeBag = DisposeBag()
    let serviceManager = GitHupNetwork.shared
    
    let searchBar = SearchBar()
    let listView = RepositoryListView()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super .init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        bind()
//        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = organization + " Repositories"
        view.backgroundColor = .white

    }
    
    private func bind() {
        let repositoryResult = searchBar.shouldLoadResult
            .flatMapLatest{
                self.serviceManager.fetchRepositories(query: $0)
            }
            .share()
        
        let repositoryValue = repositoryResult
            .map { data -> [Repository]? in
                guard case .success(let value) = data else {
                    return nil
                }
                return value
            }
            .filter {  $0 != nil }
        
        let repositoryError = repositoryResult
            .map { data -> String? in
                guard case .failure(let error) = data else {
                    return nil
                }
                return error.message
            }
            .filter { $0 != nil }
                .subscribe { alert in
                    let alert = UIAlertController(title: "앗!", message: "검색되지 않는 이름입니다.\n다른 organization을 입력해주세요.", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default)
                    alert.addAction(ok)
                    DispatchQueue.main.async {
                        self.present(alert, animated: true)
                    }
                    
                }
    
        
        let cellData = repositoryValue
            .map { repository -> [RopositoryData] in
                guard let repository = repository else {
                    return []
                }
                var data = [RopositoryData]()
                for i in 0...repository.count-1 {
                    let countString = String(repository[i].stargazersCount)
                    data.append(RopositoryData(
                        name: repository[i].name,
                        description: repository[i].description ?? "",
                        stargazersCount: countString,
                        language: repository[i].language)
                    )
                }
                return data
            }
            .bind(to: listView.cellData)
            .disposed(by: disposeBag)
    }
        
    
    
    private func layout() {
        [searchBar, listView].forEach { view.addSubview($0) }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        listView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

