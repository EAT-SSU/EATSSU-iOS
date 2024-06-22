//
//  MigratedMyReviewViewController.swift
//  EAT-SSU
//
//  Created by Jiwoong CHOI on 6/22/24.
//

import Moya
import SnapKit
import Then
import UIKit

final class MigratedMyReviewViewController: BaseViewController {
  // MARK: - Properties

  private let myProvider = MoyaProvider<MyRouter>(plugins: [MoyaLoggingPlugin()])
  private let reviewProvider = MoyaProvider<ReviewRouter>(plugins: [MoyaLoggingPlugin()])

  private var reviewList = [MyDataList]()
  var nickname: String = .init()
  private var menuName: String = .init()

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

    self.setDelegate()
    self.checkReviewCount()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    self.getMyReview()
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

  // 해당 메소드는 호출된 부분이 없음. 최초 작성자가 확인 후 공유.
  func dataBind(nikcname: String) {
    nickname = nikcname
  }

  private func checkReviewCount() {
    if reviewList.count == 0 {
      myReviewView.myReviewTableView.isHidden = true
      noMyReviewImageView.isHidden = false
    } else {
      myReviewView.myReviewTableView.isHidden = false
      noMyReviewImageView.isHidden = true
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
    return reviewList.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell =
      tableView.dequeueReusableCell(withIdentifier: ReviewTableCell.identifier, for: indexPath)
      as? ReviewTableCell ?? ReviewTableCell()
    cell.myPageDataBind(response: reviewList[indexPath.row], nickname: nickname)
    cell.handler = { [weak self] in
      guard let self else { return }
      menuName = reviewList[indexPath.row].menuName
      self.showFixOrDeleteAlert(
        reviewID: cell.reviewId,
        menuName: menuName)
    }
    cell.selectionStyle = .none
    return cell
  }

  // UITableViewDataSource 메소드에서 호출
  private func showFixOrDeleteAlert(reviewID: Int, menuName: String) {
    let alert = UIAlertController(
      title: "리뷰 수정 혹은 삭제",
      message: "작성하신 리뷰를 수정 또는 삭제하시겠습니까?",
      preferredStyle: UIAlertController.Style.actionSheet)

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
        self.deleteReview(reviewID: reviewID)
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

// MARK: - Server

extension MigratedMyReviewViewController {
  private func getMyReview() {
    myProvider.request(.myReview) { response in
      switch response {
      case .success(let moyaResponse):
        do {
          let responseData = try moyaResponse.map(BaseResponse<MyReviewResponse>.self)
          self.reviewList = responseData.result.dataList
          self.checkReviewCount()
          self.myReviewView.myReviewTableView.reloadData()
        } catch (let err) {
          print(err.localizedDescription)
        }
      case .failure(let err):
        print(err.localizedDescription)
      }
    }
  }

  private func deleteReview(reviewID: Int) {
    reviewProvider.request(.deleteReview(reviewID)) { response in
      switch response {
      case .success:
        self.getMyReview()
        self.view.showToast(message: "삭제되었어요 !")
      case .failure(let err):
        print(err.localizedDescription)
      }
    }
  }
}
