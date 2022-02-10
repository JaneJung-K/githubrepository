//
//  RepositoryListView.swift
//  GitHubRepositoryApp
//
//  Created by imac on 2022/02/09.
//

import RxSwift
import RxCocoa
import UIKit

class RepositoryListView: UITableView {
    let disposeBag = DisposeBag()
    
    var cellData = PublishSubject<[RopositoryData]>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        bind()
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func refresh() {
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            self.refreshControl?.endRefreshing()
            //network 타기
        }
    }
    
    private func bind() {
        cellData
            .asDriver(onErrorJustReturn: [])
            .drive(self.rx.items) { tv, row, data in
                let index = IndexPath(row: row, section: 0)
                let cell = tv.dequeueReusableCell(withIdentifier: "BlogListCell", for: index) as! RepositoryListCell
                cell.setData(data)
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        self.backgroundColor = .white
        self.register(RepositoryListCell.self, forCellReuseIdentifier: "BlogListCell")
        self.separatorStyle = .singleLine
        self.backgroundColor = .white
        self.rowHeight = 100
        
        self.refreshControl = UIRefreshControl()
        let refreshControl = self.refreshControl!
        refreshControl.backgroundColor = .white
        refreshControl.tintColor = .darkGray
        refreshControl.attributedTitle = NSAttributedString(string: "당겨서 새로고침")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
}

