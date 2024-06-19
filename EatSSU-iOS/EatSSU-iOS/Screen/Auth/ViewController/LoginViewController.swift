//
//  LoginViewController.swift
//  EatSSU-iOS
//
//  Created by 최지우 on 2023/06/26.
//

import AuthenticationServices
import Firebase
import KakaoSDKUser
import Moya
import RealmSwift
import SnapKit
import Then
import UIKit

final class LoginViewController: BaseViewController {
  // MARK: - Properties

  var loginAfterlooking = true

  // MARK: - UI Components

  private let loginView = LoginView()
  private let authProvider = MoyaProvider<AuthRouter>(plugins: [MoyaLoggingPlugin()])
  private let myProvider = MoyaProvider<MyRouter>(plugins: [MoyaLoggingPlugin()])

  // MARK: - Life Cycles

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    self.checkUser()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

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

  // MARK: - Some Methods

  private func getUserInfo() {
    UserApi.shared.me { user, error in
      if let error = error {
        debugPrint("🎃", error.localizedDescription)
      } else {
        guard let email = user?.kakaoAccount?.email else { return }
        guard let id = user?.id else { return }
        self.postKakaoLoginRequest(email: email, id: String(id))
      }
    }
  }

  private func addTokenInRealm(accessToken: String, refreshToken: String) {
    RealmService.shared.addToken(accessToken: accessToken, refreshToken: refreshToken)
    debugPrint("⭐️⭐️토큰 저장 성공~⭐️⭐️")
    debugPrint(RealmService.shared.getToken())
    debugPrint(RealmService.shared.getRefreshToken())
  }

  private func pushToHomeVC() {
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

  private func checkRealmToken() -> Bool {
    if RealmService.shared.getToken() == "" {
      return false
    } else {
      return true
    }
  }

  private func checkUser() {
    /// 자동 로그인 풀고 싶을 때 한번 실행시켜주기
    //        self.realm.resetDB()

    /// 자동 로그인
    if self.checkRealmToken() {
      debugPrint(RealmService.shared.getToken())
      self.pushToHomeVC()
    }
  }

  /// 요청으로 얻을 수 있는 값들: 이름, 이메일로 설정
  private func appleLoginRequest() {
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName, .email]

    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = self
    authorizationController.presentationContextProvider = self
    authorizationController.performRequests()
  }

  private func checkUserNickname(info: MyInfoResponse) {
    switch info.nickname {
    case nil:
      self.pushToNicknameVC()
    default:
      self.pushToHomeVC()
    }
  }

  // MARK: - Button Action Methods

  @objc
  func kakaoLoginButtonDidTapped() {
    // 카카오톡 앱이 설치되어 있는지 확인
    if UserApi.isKakaoTalkLoginAvailable() {
      // 카카오톡 앱을 통한 로그인 시도
      UserApi.shared.loginWithKakaoTalk { oauthToken, error in
        if let error = error {
          debugPrint(error)
        } else {
          debugPrint("loginWithKakaoTalk() success.")
          self.getUserInfo()
          _ = oauthToken
        }
      }
    } else {
      // 카카오 계정을 통한 웹 로그인 시도
      UserApi.shared.loginWithKakaoAccount { oauthToken, error in
        if let error = error {
          debugPrint(error)
        } else {
          self.getUserInfo()
          _ = oauthToken
        }
      }
    }
  }

  @objc
  private func appleLoginButtonDidTapped() {
    appleLoginRequest()
  }

  @objc
  func lookingWithNoSignInButtonDidTapped() {
    pushToHomeVC()
  }
}

// MARK: - Network

extension LoginViewController {
  func postKakaoLoginRequest(email: String, id: String) {
    self.authProvider.request(
      .kakaoLogin(
        param: KakaoLoginRequest(
          email: email,
          providerId: id
        )
      )
    ) { response in
      switch response {
      case .success(let moyaResponse):
        do {
          debugPrint(moyaResponse.statusCode)
          let responseData = try moyaResponse.map(BaseResponse<SignResponse>.self)
          self.addTokenInRealm(
            accessToken: responseData.result.accessToken,
            refreshToken: responseData.result.refreshToken)
          self.getMyInfo()
        } catch (let err) {
          self.presentBottomAlert(err.localizedDescription)
          debugPrint(err.localizedDescription)
        }
      case .failure(let err):
        self.presentBottomAlert(err.localizedDescription)
        debugPrint(err.localizedDescription)
      }
    }
  }

  private func getMyInfo() {
    self.myProvider.request(.myInfo) { response in
      switch response {
      case .success(let moyaResponse):
        do {
          let responseData = try moyaResponse.map(BaseResponse<MyInfoResponse>.self)
          self.checkUserNickname(info: responseData.result)
        } catch (let err) {
          debugPrint(err.localizedDescription)
        }
      case .failure(let err):
        debugPrint(err.localizedDescription)
      }
    }
  }

  private func postAppleLoginRequest(token: String) {
    self.authProvider.request(.appleLogin(param: AppleLoginRequest(identityToken: token))) {
      response in
      switch response {
      case .success(let moyaResponse):
        do {
          debugPrint(moyaResponse.statusCode)
          let responseData = try moyaResponse.map(BaseResponse<SignResponse>.self)
          self.addTokenInRealm(
            accessToken: responseData.result.accessToken,
            refreshToken: responseData.result.refreshToken
          )
          self.getMyInfo()
        } catch (let err) {
          self.presentBottomAlert(err.localizedDescription)
          debugPrint(err.localizedDescription)
        }
      case .failure(let err):
        self.presentBottomAlert(err.localizedDescription)
        debugPrint(err.localizedDescription)
      }
    }
  }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding,
  ASAuthorizationControllerDelegate
{
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return self.view.window!
  }

  // Apple ID 연동 성공 시
  func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithAuthorization authorization: ASAuthorization
  ) {
    switch authorization.credential {
    // Apple ID
    case let appleIDCredential as ASAuthorizationAppleIDCredential:

      // 계정 정보 가져오기
      let userIdentifier = appleIDCredential.user
      let fullName = appleIDCredential.fullName
      let email = appleIDCredential.email
      let idToken = appleIDCredential.identityToken!
      let tokeStr = String(data: idToken, encoding: .utf8)

      self.postAppleLoginRequest(token: tokeStr ?? "")
      debugPrint("User ID : \(userIdentifier)")
      debugPrint("User Email : \(email ?? "")")
      debugPrint("User Name : \((fullName?.givenName ?? "") + (fullName?.familyName ?? ""))")
      debugPrint("token : \(String(describing: tokeStr))")

    default:
      break
    }
  }

  // Apple ID 연동 실패 시
  func authorizationController(
    controller: ASAuthorizationController, didCompleteWithError error: Error
  ) {
    debugPrint("Login in Fail.")
  }
}
