//
//  MigratedMyReview.swift
//  EAT-SSU
//
//  Created by Jiwoong CHOI on 6/22/24.
//

import SnapKit
import Then
import UIKit

final class MigratedMyReview: BaseUIView {

  // MARK: - UI Components

  let myReviewTableView = UITableView()
  let refreshControl = UIRefreshControl()

  // MARK: - Life Cycles
  override init(frame: CGRect) {
    super.init(frame: frame)

    initRefresh()
  }

  // MARK: - Functions

  override func configureUI() {
    self.addSubview(myReviewTableView)

    myReviewTableView.do {
      $0.separatorStyle = .none
      $0.showsVerticalScrollIndicator = false
    }
  }

  override func setLayout() {
    myReviewTableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

  func initRefresh() {
    refreshControl.addTarget(
      self,
      action: #selector(refreshTable(refresh:)),
      for: .valueChanged)

    myReviewTableView.refreshControl = refreshControl
  }

  @objc
  func refreshTable(refresh: UIRefreshControl) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
      self.myReviewTableView.reloadData()
      refresh.endRefreshing()
    }
  }

}
