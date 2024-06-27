//
//  MigratedLoginViewController.swift
//  EAT-SSU
//
//  Created by Jiwoong CHOI on 6/22/24.
//

import AuthenticationServices
import Combine
import Firebase
import KakaoSDKUser
import Moya
import RealmSwift
import SnapKit
import Then
import UIKit

final class MigratedLoginViewController: BaseViewController {
  // MARK: - Properties

  private var viewModel = MigratedLoginViewModel()
  private var cancellables = Set<AnyCancellable>()

  // MARK: - UI Components

  private let loginView = MigratedLoginView()

  // MARK: - Life Cycles

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.bindViewModel()
    Analytics.logEvent("LoginViewControllerLoad", parameters: nil)
  }

  // MARK: - UI Configuration

  override func configureUI() {
    view.addSubviews(loginView)
  }

  override func setLayout() {
    loginView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(UIScreen.main.bounds.height / 4.0)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).inset(50)
    }
  }

  override func setButtonEvent() {
    loginView.kakaoLoginButton.addTarget(
      self, action: #selector(kakaoLoginButtonDidTapped), for: .touchUpInside)
    loginView.appleLoginButton.addTarget(
      self, action: #selector(appleLoginButtonDidTapped), for: .touchUpInside)
    loginView.lookingWithNoSignInButton.addTarget(
      self, action: #selector(lookingWithNoSignInButtonDidTapped), for: .touchUpInside)
  }

  private func bindViewModel() {
    viewModel.$tokenIsExist
      .receive(on: RunLoop.main)
      .sink { tokenIsExist in      
        if tokenIsExist {
          self.changeRootVCIntoHomeVC()
        }
      }
      .store(in: &cancellables)
    
    viewModel.$nickName
      .receive(on: RunLoop.main)
      .sink { nickName in
        switch nickName {
        case nil:
          self.pushToNicknameVC()
        default:
          self.changeRootVCIntoHomeVC()
        }
      }
      .store(in: &cancellables)

    viewModel.$error
      .receive(on: RunLoop.main)
      .sink { error in
        if let error = error {
          self.presentBottomAlert(error.localizedDescription)
        } else {
          self.presentBottomAlert("기본 에러 메시지")
        }
      }
      .store(in: &cancellables)
  }

  // MARK: - Controller Methods

  private func changeRootVCIntoHomeVC() {
    let homeVC = HomeViewController()

    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow })
    {
      keyWindow.replaceRootViewController(
        UINavigationController(rootViewController: homeVC), animated: true, completion: nil)
    }
  }

  private func pushToNicknameVC() {
    let setNicknameViewController = SetNickNameViewController()
    navigationController?.pushViewController(setNicknameViewController, animated: true)
  }

  // MARK: - Button Action Methods

  @objc
  func kakaoLoginButtonDidTapped() {
    viewModel.loginWithKakaoSystem()
  }

  @objc
  private func appleLoginButtonDidTapped() {
    viewModel.loginWithAppleSystem()
  }

  @objc
  private func lookingWithNoSignInButtonDidTapped() {
    self.changeRootVCIntoHomeVC()
  }
}
