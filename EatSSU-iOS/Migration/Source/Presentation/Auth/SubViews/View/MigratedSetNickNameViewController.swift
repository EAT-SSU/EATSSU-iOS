//
//  MigratedSetNickNameViewController.swift
//  EAT-SSU
//
//  Created by Jiwoong CHOI on 6/22/24.
//

import Moya
import Realm
import SnapKit
import Then
import UIKit

final class MigratedSetNickNameViewController: BaseViewController {
  // MARK: - Properties

  var currentKeyboardHeight: CGFloat = 0.0
  private let nicknameProvider = MoyaProvider<UserNicknameRouter>(plugins: [MoyaLoggingPlugin()])

  // MARK: - UI Components

  private let setNickNameView = MigratedSetNickNameView()

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

  // MARK: - UI Configurations

  override func configureUI() {
    view.addSubviews(setNickNameView)
  }

  override func setLayout() {
    setNickNameView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

  override func customNavigationBar() {
    super.customNavigationBar()
    navigationItem.title = TextLiteral.Auth.setNickName
  }

  override func setButtonEvent() {
    setNickNameView.completeSettingNickNameButton.addTarget(
      self, action: #selector(tappedCompleteNickNameButton), for: .touchUpInside)
    setNickNameView.nicknameDoubleCheckButton.addTarget(
      self, action: #selector(tappedCheckButton), for: .touchUpInside)
  }

  // MARK: - Button Action Methods

  @objc
  private func tappedCompleteNickNameButton() {
    self.setUserNickname(nickname: self.setNickNameView.inputNickNameTextField.text ?? "")
  }

  @objc
  private func tappedCheckButton() {
    self.checkNickname(nickname: self.setNickNameView.inputNickNameTextField.text ?? "")
  }

  // MARK: - KeyBoard Methods

  private func addKeyboardNotifications() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.keyboardWillShow(_:)),
      name: UIResponder.keyboardWillShowNotification,
      object: nil)
    NotificationCenter.default.addObserver(
      self, selector: #selector(self.keyboardWillHide(_:)),
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

  @objc
  private func keyboardWillShow(_ notification: Notification) {
    if let keyboardSize =
      (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
    {
      let updateKeyboardHeight = keyboardSize.height
      let difference = updateKeyboardHeight - currentKeyboardHeight

      setNickNameView.completeSettingNickNameButton.frame.origin.y -= difference
      currentKeyboardHeight = updateKeyboardHeight
    }
  }

  @objc
  private func keyboardWillHide(_ notification: Notification) {
    // 옵셔널 바인딩으로 인한 keyboardSize 상수는 사용되지 않아 경고 발생. 최초 작성자가 확인 후 공유.
    if let keyboardSize =
      (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
    {
      setNickNameView.completeSettingNickNameButton.frame.origin.y += currentKeyboardHeight
      currentKeyboardHeight = 0.0
    }
  }
}

// MARK: - Network

extension MigratedSetNickNameViewController {
  private func setUserNickname(nickname: String) {
    self.nicknameProvider.request(.setNickname(nickname: nickname)) { response in
      switch response {
      case .success(let moyaResponse):
        do {
          self.showAlert(title: "완료", text: "닉네임 설정이 완료되었습니다.", style: .cancel) {
            if let myPageViewController = self.navigationController?.viewControllers.first(
              where: { $0 is MyPageViewController }
            ) {
              self.navigationController?.popToViewController(myPageViewController, animated: true)
            } else {
              let homeViewController = HomeViewController()
              if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow })
              {
                keyWindow.replaceRootViewController(
                  UINavigationController(rootViewController: homeViewController), animated: true,
                  completion: nil)
              }
            }
          }
          debugPrint(moyaResponse.statusCode)
        }
      case .failure(let error):
        debugPrint(error.localizedDescription)
      }
    }
  }

  private func checkNickname(nickname: String) {
    self.nicknameProvider.request(.checkNickname(nickname: nickname)) { response in
      switch response {
      case .success(let moyaResponse):
        do {
          let responseData = try moyaResponse.map(BaseResponse<Bool>.self)
          let isSuccess = responseData.result
          if isSuccess {
            self.view.showToast(message: "사용 가능한 닉네임이에요")
            self.setNickNameView.completeSettingNickNameButton.isEnabled = isSuccess
            self.setNickNameView.nicknameValidationMessageLabel.text =
              NicknameTextFieldResultType.nicknameTextFieldValid.hintMessage
            self.setNickNameView.nicknameValidationMessageLabel.textColor =
              NicknameTextFieldResultType.nicknameTextFieldValid.textColor
          } else {
            self.view.showToast(message: "이미 사용 중인 닉네임이에요")
            self.setNickNameView.completeSettingNickNameButton.isEnabled = isSuccess
            self.setNickNameView.nicknameValidationMessageLabel.text =
              NicknameTextFieldResultType.nicknameTextFieldDuplicated.hintMessage
            self.setNickNameView.nicknameValidationMessageLabel.textColor =
              NicknameTextFieldResultType.nicknameTextFieldDuplicated.textColor
          }
        } catch (let error) {
          debugPrint(error.localizedDescription)
        }
      case .failure(let error):
        debugPrint(error.localizedDescription)
      }
    }
  }
}
