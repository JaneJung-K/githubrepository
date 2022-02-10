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
    
    let cellData = PublishSubject<[RopositoryData]>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        bind()
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        self.backgroundColor = .red
        self.rowHeight = 100
    }
}

