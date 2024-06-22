//
//  MigratedDeleteAccountConfirmationViewController.swift
//  EAT-SSU
//
//  Created by Jiwoong CHOI on 6/22/24.
//

import Moya
import Realm
import SnapKit
import Then
import UIKit

final class MigratedDeleteAccountConfirmationViewController: BaseViewController {
  // MARK: - Properties

  private var nickName = String()
  var currentKeyboardHeight: CGFloat = 0.0
  private let myProvider = MoyaProvider<MyRouter>(plugins: [MoyaLoggingPlugin()])

  // MARK: - UI Components

  private lazy var deleteAccountView = MigratedDeleteAccountConfirmationView(nickName: nickName)

  // MARK: - Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()

    dismissKeyboard()
  }

  override func viewWillAppear(_ animated: Bool) {
    self.addKeyboardNotifications()
  }

  override func viewWillDisappear(_ animated: Bool) {
    self.removeKeyboardNotifications()
  }

  // MARK: - UI Configuration

  override func configureUI() {
    view.addSubviews(deleteAccountView)
  }

  override func setLayout() {
    deleteAccountView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

  override func customNavigationBar() {
    super.customNavigationBar()
    navigationItem.title = "탈퇴하기"
  }

  override func setButtonEvent() {
    deleteAccountView.completeSignOutButton.addTarget(
      self, action: #selector(tappedCompleteNickNameButton), for: .touchUpInside)
  }

  // MARK: - Button Action Methods

  @objc private func tappedCompleteNickNameButton() {
    deleteUser()
  }

  // MARK: - Some Methods

  public func getUsernickName(nickName: String) {
    self.nickName = nickName
  }

  // MARK: - KeyBoard Methods

  private func addKeyboardNotifications() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.keyboardWillShow),
      name: UIResponder.keyboardWillShowNotification,
      object: nil)
    NotificationCenter.default.addObserver(
      self, selector: #selector(self.keyboardWillHide),
      name: UIResponder.keyboardWillHideNotification,
      object: nil)
  }

  private func removeKeyboardNotifications() {
    NotificationCenter.default.removeObserver(
      self,
      name: UIResponder.keyboardWillShowNotification,
      object: nil)
    NotificationCenter.default.removeObserver(
      self,
      name: UIResponder.keyboardWillHideNotification,
      object: nil)
  }

  @objc private func keyboardWillShow(_ notification: Notification) {
    if let keyboardSize =
      (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
    {
      let updateKeyboardHeight = keyboardSize.height
      let difference = updateKeyboardHeight - currentKeyboardHeight

      deleteAccountView.completeSignOutButton.frame.origin.y -= difference
      currentKeyboardHeight = updateKeyboardHeight
    }
  }

  @objc private func keyboardWillHide(_ notification: Notification) {
    // 옵셔널 바인딩으로 생성된 keyboardSize 변수를 제거할 필요. 최초 작성자가 개선 후 공유.
    if let keyboardSize =
      (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
    {
      deleteAccountView.completeSignOutButton.frame.origin.y += currentKeyboardHeight
      currentKeyboardHeight = 0.0
    }
  }
}

// MARK: - Server

extension MigratedDeleteAccountConfirmationViewController {
  private func deleteUser() {
    self.myProvider.request(.signOut) { response in
      switch response {
      case .success(let moyaResponse):
        do {
          let responseData = try moyaResponse.map(BaseResponse<Bool>.self)
          if responseData.result {
            RealmService.shared.resetDB()
            let loginViewController = LoginViewController()
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow })
            {
              keyWindow.replaceRootViewController(
                UINavigationController(rootViewController: loginViewController),
                animated: true,
                completion: nil)
            }
          }
        } catch (let err) {
          print(err.localizedDescription)
        }
      case .failure(let err):
        print(err.localizedDescription)
      }
    }
  }
}
