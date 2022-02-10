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
    private let organization = "Apple"
//    private let repositories = BehaviorSubject<[Repository]>(value: [])
//    let cellData = PublishSubject<[Repository]>()
    private let bag = DisposeBag()
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
//        self.refreshControl = UIRefreshControl()
//        let refreshControl = self.refreshControl!
//        refreshControl.backgroundColor = .white
//        refreshControl.tintColor = .darkGray
//        refreshControl.attributedTitle = NSAttributedString(string: "당겨서 새로고침")
//        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)

    }
    
//    @objc func refresh() {
//        DispatchQueue.global(qos: .background).async {[weak self] in
//            guard let self = self else { return }
//            self.fetchRepositories(of: self.organization)
//        }
//    }
    
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
            .disposed(by: bag)
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
    
//    func fetchRepositories(of organization: String) {
//        Observable.from([organization])
//            .map { organization -> URL in
//                return URL(string: "https://api.github.com/orgs/\(organization)/repos")!
//            }
//            .map { url -> URLRequest in
//                var request = URLRequest(url: url)
//                request.httpMethod = "GET"
//                return request
//            }
//            .flatMap { request -> Observable<(response: HTTPURLResponse, data: Data)> in
//                return URLSession.shared.rx.response(request: request)
//            }
//            .filter { response, _ in
//                return 200..<300 ~= response.statusCode
//            }
//            .map { _, data -> [[String: Any]] in
//                guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
//                      let result = json as? [[String: Any]] else {
//                    return []
//                }
//                return result
//            }
//            .filter { objects in
//                return objects.count > 0
//            }
//            .map { objects in
//                return objects.compactMap { dic -> Repository? in
//                    guard let id = dic["id"] as? Int,
//                          let name = dic["name"] as? String,
//                          let description = dic["description"] as? String,
//                          let stargazersCount = dic["stargazers_count"] as? Int,
//                          let language = dic["language"] as? String else {
//                        return nil
//                    }
//
//                    return Repository(id: id, name: name, description: description, stargazersCount: stargazersCount, language: language)
//                }
//            }
//            .subscribe(onNext: {[weak self] newRepositories in
//                self?.repositories.onNext(newRepositories)
//
//                DispatchQueue.main.async {
//                    self?.tableView.reloadData()
//                    self?.refreshControl?.endRefreshing()
//                }
//            })
//            .disposed(by: bag)
//    }
    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        do {
//            return try repositories.value().count
//        } catch {
//            return 0
//        }
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryListCell", for: indexPath) as? RepositoryListCell else { return UITableViewCell() }
//
//        var currentRepo: Repository? {
//            do {
//                return try repositories.value()[indexPath.row]
//            } catch {
//                return nil
//            }
//        }
//
//        cell.repository = currentRepo
//
//        return cell
//    }
}
