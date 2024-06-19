//
//  NoticeViewController.swift
//  EatSSU-iOS
//
//  Created by 박윤빈 on 2023/05/10.
//

import SnapKit
import UIKit

final class NoticeViewController: BaseViewController {

  // MARK: - Properties

  private let noticeDummy = Notice.dummy()

  // MARK: - UI Components

  private let noticeTableView: UITableView = {
    let tableView = UITableView()
    tableView.register(
      NoticeTableViewCell.self, forCellReuseIdentifier: NoticeTableViewCell.identifier)
    tableView.rowHeight = 80
    return tableView
  }()

  // MARK: - Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
    setTableView()
    customNavigationBar()
  }

  // MARK: - Functions

  override func configureUI() {
    view.addSubviews(
      noticeTableView)
  }

  override func setLayout() {
    noticeTableView.snp.makeConstraints { make in
      make.leading.top.trailing.bottom.equalToSuperview()
    }
  }

  func setTableView() {
    noticeTableView.delegate = self
    noticeTableView.dataSource = self
  }

  override func customNavigationBar() {
    navigationController?.navigationBar.tintColor = .primary
    navigationController?.navigationBar.barTintColor = .white
    let backButton: UIBarButtonItem = UIBarButtonItem()
    backButton.title = ""
    navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    navigationItem.title = "공지사항"
    navigationController?.navigationBar.titleTextAttributes = [
      .foregroundColor: UIColor.primary,
      NSAttributedString.Key.font: UIFont.bold(size: 22),
    ]
  }
}

extension NoticeViewController: UITableViewDelegate {}

extension NoticeViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return noticeDummy.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
      let cell = tableView.dequeueReusableCell(
        withIdentifier: NoticeTableViewCell.identifier,
        for: indexPath) as? NoticeTableViewCell
    else { return UITableViewCell() }

    cell.configureCell(noticeDummy[indexPath.row])
    return cell
  }
}
