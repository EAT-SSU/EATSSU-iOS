//
//  File.swift
//  EatSSU-iOS
//
//  Created by 최지우 on 2023/05/22.
//
import FirebaseAnalytics
import Foundation
import Moya
import Realm
import SnapKit
import UIKit

final class MyPageViewController: BaseViewController {
  // MARK: - Properties

  private let myProvider = MoyaProvider<MyRouter>(plugins: [MoyaLoggingPlugin()])
  private var nickName = String()

  // MARK: - UI Components

  let mypageView = MyPageView()

  // MARK: - Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()

    self.setDelegate()
    Analytics.logEvent("MypageViewControllerLoad", parameters: nil)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    self.getMyInfo()
  }

  // MARK: - UI Configuration

  override func customNavigationBar() {
    super.customNavigationBar()
    navigationItem.title = TextLiteral.MyPage.myPage
  }

  override func configureUI() {
    view.addSubviews(mypageView)
  }

  override func setLayout() {
    mypageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

  private func setDelegate() {
    mypageView.myPageTableView.dataSource = self
    mypageView.myPageTableView.delegate = self
  }

  override func setButtonEvent() {
    mypageView.userNicknameButton.addTarget(
      self, action: #selector(didTappedChangeNicknameButton), for: .touchUpInside)
  }

  // MARK: - Button Action

  @objc
  func didTappedChangeNicknameButton() {
    let setNickNameVC = SetNickNameViewController()
    navigationController?.pushViewController(setNickNameVC, animated: true)
  }
}

// MARK: - Server

extension MyPageViewController {
  private func getMyInfo() {
    myProvider.request(.myInfo) { response in
      switch response {
      case .success(let moyaResponse):
        do {
          let responseData = try moyaResponse.map(BaseResponse<MyInfoResponse>.self)
          self.mypageView.dataBind(model: responseData.result)
          self.nickName = responseData.result.nickname ?? ""
        } catch (let err) {
          print(err.localizedDescription)
        }
      case .failure(let err):
        print(err.localizedDescription)
      }
    }
  }
}

// MARK: - TableView DataSource

extension MyPageViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return mypageView.myPageServiceLabelList.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
      let cell = tableView.dequeueReusableCell(
        withIdentifier: MyPageServiceCell.identifier, for: indexPath) as? MyPageServiceCell
    else { return MyPageServiceCell() }

    let titleLabel = mypageView.myPageServiceLabelList[indexPath.row].titleLabel
    cell.serviceLabel.text = titleLabel
    switch titleLabel {
    case TextLiteral.MyPage.myReview, TextLiteral.MyPage.termsOfUse,
      TextLiteral.MyPage.privacyTermsOfUse, TextLiteral.MyPage.inquiry:
      cell.rightItemLabel.text = mypageView.myPageRightItemListDate[0].rightArrow
    case TextLiteral.MyPage.appVersion:
      cell.rightItemLabel.text = mypageView.myPageRightItemListDate[0].appVersion
    default:
      return cell
    }
    return cell
  }
}

// MARK: - TableView Delegate

enum TableRowAction: Int {
  case showMyReview = 0
  case showRequest = 1
  case showTermsOfUse = 2
  case showPrivacyTerms = 3
  case showAlert = 4
  case deleteAccount = 5
}

extension MyPageViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    guard let action = TableRowAction(rawValue: indexPath.row) else { return }

    switch action {
    case .showMyReview:
      let myReviewViewController = MyReviewViewController()
      navigationController?.pushViewController(myReviewViewController, animated: true)
    case .showRequest:
      let requestViewController = RequestViewController()
      navigationController?.pushViewController(requestViewController, animated: true)
    case .showTermsOfUse:
      let provisionViewController = ProvisionViewController()
      provisionViewController.navigationTitle = TextLiteral.MyPage.termsOfUse
      provisionViewController.provisionView.privisionTextView.text =
        TextLiteral.MyPage.termsOfUseText
      navigationController?.pushViewController(provisionViewController, animated: true)
    case .showPrivacyTerms:
      let provisionViewController = ProvisionViewController()
      provisionViewController.navigationTitle = TextLiteral.MyPage.privacyTermsOfUse
      provisionViewController.provisionView.privisionTextView.text =
        TextLiteral.MyPage.privacyTermsOfUseText
      navigationController?.pushViewController(provisionViewController, animated: true)
    case .showAlert:
      self.showAlert()
    case .deleteAccount:
      let deleteAccountViewController = DeleteAccountConfirmationViewController()
      deleteAccountViewController.getUsernickName(nickName: nickName)
      navigationController?.pushViewController(deleteAccountViewController, animated: true)
    }
  }

  private func showAlert() {
    let alert = UIAlertController(
      title: "로그아웃",
      message: "정말 로그아웃 하시겠습니까?",
      preferredStyle: UIAlertController.Style.alert)

    let cancelAction = UIAlertAction(
      title: "취소하기",
      style: .default,
      handler: nil)

    let fixAction = UIAlertAction(
      title: "로그아웃",
      style: .default,
      handler: { _ in
        RealmService.shared.resetDB()

        let loginViewController = LoginViewController()
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow })
        {
          keyWindow.replaceRootViewController(
            UINavigationController(rootViewController: loginViewController), animated: true,
            completion: nil)
        }
      })

    alert.addAction(cancelAction)
    alert.addAction(fixAction)

    present(alert, animated: true, completion: nil)
  }
}
