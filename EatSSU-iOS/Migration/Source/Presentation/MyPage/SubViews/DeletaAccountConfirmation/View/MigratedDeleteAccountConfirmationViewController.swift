//
//  MigratedDeleteAccountConfirmationViewController.swift
//  EAT-SSU
//
//  Created by Jiwoong CHOI on 6/22/24.
//

import Realm
import SnapKit
import Then
import UIKit

final class MigratedDeleteAccountConfirmationViewController: BaseViewController {
  // MARK: - Properties

  private var viewModel = MigratedDeleteConfirmationViewModel()
  private var nickName = String()
  private var currentKeyboardHeight: CGFloat = 0.0

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
    self.viewModel.deleteUser {
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
    deleteAccountView.completeSignOutButton.frame.origin.y += currentKeyboardHeight
    currentKeyboardHeight = 0.0
  }
}
