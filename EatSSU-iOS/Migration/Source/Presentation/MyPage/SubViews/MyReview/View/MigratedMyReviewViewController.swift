//
//  MigratedMyReviewViewController.swift
//  EAT-SSU
//
//  Created by Jiwoong CHOI on 6/22/24.
//

import SnapKit
import Then
import UIKit

final class MigratedMyReviewViewController: BaseViewController {
  // MARK: - Properties

  private var nickname: String = .init()
  private var menuName: String = .init()
  private var viewModel = MigratedReviewViewModel()

  // MARK: - UI Components

  let myReviewView = MigratedMyReviewView()

  private lazy var noMyReviewImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = ImageLiteral.Review.noMyReview
    imageView.isHidden = true
    return imageView
  }()

  // MARK: - Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
    setDelegate()
    viewModelCheckReviewCount()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.getMyReview {
      self.viewModelCheckReviewCount()
      self.myReviewView.myReviewTableView.reloadData()
    }
  }

  // MARK: - UI Configuration

  override func customNavigationBar() {
    super.customNavigationBar()
    navigationItem.title = TextLiteral.MyPage.myReview
  }

  override func configureUI() {
    view.addSubviews(myReviewView, noMyReviewImageView)
  }

  override func setLayout() {
    myReviewView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    noMyReviewImageView.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }

  private func setDelegate() {
    myReviewView.myReviewTableView.register(
      ReviewTableCell.self, forCellReuseIdentifier: ReviewTableCell.identifier)
    myReviewView.myReviewTableView.delegate = self
    myReviewView.myReviewTableView.dataSource = self
  }

  // MARK: - Some Methods

  private func viewModelCheckReviewCount() {
    viewModel.checkReviewCount { myReviewTableViewStatus, noMyReviewImageViewStatus in
      self.myReviewView.myReviewTableView.isHidden = myReviewTableViewStatus
      self.noMyReviewImageView.isHidden = noMyReviewImageViewStatus
    }
  }
}

// MARK: - UITableView Delegate

extension MigratedMyReviewViewController: UITableViewDelegate {
  //
}

// MARK: - UITableView DataSource

extension MigratedMyReviewViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.reviewList.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell =
      tableView.dequeueReusableCell(withIdentifier: ReviewTableCell.identifier, for: indexPath)
        as? ReviewTableCell ?? ReviewTableCell()
    cell.myPageDataBind(response: viewModel.reviewList[indexPath.row], nickname: nickname)
    cell.handler = { [weak self] in
      guard let self = self else { return }
      menuName = viewModel.reviewList[indexPath.row].menuName
      self.showFixOrDeleteAlert(reviewID: cell.reviewId, menuName: menuName)
    }
    cell.selectionStyle = .none
    return cell
  }

  // UITableViewDataSource 메소드에서 호출
  private func showFixOrDeleteAlert(reviewID: Int, menuName: String) {
    let alert = UIAlertController(
      title: "리뷰 수정 혹은 삭제",
      message: "작성하신 리뷰를 수정 또는 삭제하시겠습니까?",
      preferredStyle: .actionSheet)

    let fixAction = UIAlertAction(
      title: "수정하기",
      style: .default,
      handler: { _ in
        let setRateViewController = SetRateViewController()
        setRateViewController.dataBindForFix(list: [menuName], reivewId: reviewID)
        self.navigationController?.pushViewController(setRateViewController, animated: true)
      })

    let deleteAction = UIAlertAction(
      title: "삭제하기",
      style: .default,
      handler: { _ in
        self.viewModel.deleteReview(reviewID: reviewID) {
          self.viewModel.getMyReview {
            self.viewModelCheckReviewCount()
            self.myReviewView.myReviewTableView.reloadData()
          }
          self.view.showToast(message: "삭제되었어요 !")
        }
      })

    let cancelAction = UIAlertAction(
      title: "취소하기",
      style: .cancel,
      handler: nil)

    alert.addAction(fixAction)
    alert.addAction(deleteAction)
    alert.addAction(cancelAction)
    present(alert, animated: true, completion: nil)
  }
}
