//
//  MigratedLoginViewModel.swift
//  EAT-SSU
//
//  Created by Jiwoong CHOI on 6/24/24.
//

import AuthenticationServices
import Combine
import Foundation
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import Moya

class MigratedLoginViewModel: NSObject, ObservableObject {
  // MARK: - Properties

  @Published var nickName: String?
  @Published var error: Error?
  @Published var tokenIsExist: Bool = false

  private let authProvider = MoyaProvider<AuthRouter>(plugins: [MoyaLoggingPlugin()])
  private let myProvider = MoyaProvider<MyRouter>(plugins: [MoyaLoggingPlugin()])

  override init() {
    if RealmService.shared.getToken() == "" {
      self.tokenIsExist = false
    } else {
      self.tokenIsExist = true
    }
  }

  private func addTokenInRealm(accessToken: String, refreshToken: String) {
    RealmService.shared.addToken(accessToken: accessToken, refreshToken: refreshToken)
    debugPrint("⭐️⭐️토큰 저장 성공~⭐️⭐️")
    debugPrint(RealmService.shared.getToken())
    debugPrint(RealmService.shared.getRefreshToken())
  }

  // MARK: - EATSSU Server

  private func getUserInfoFromEATSSUServer() {
    self.myProvider.request(.myInfo) { response in
      switch response {
      case .success(let moyaResponse):
        do {
          let responseData = try moyaResponse.map(BaseResponse<MyInfoResponse>.self)
          self.nickName = responseData.result.nickname
        } catch (let error) {
          self.error = error
        }
      case .failure(let error):
        self.error = error
      }
    }
  }
}

// MARK: - Kakao Authentication

extension MigratedLoginViewModel {
  public func loginWithKakaoSystem() {
    if UserApi.isKakaoTalkLoginAvailable() {
      UserApi.shared.loginWithKakaoTalk { _, error in
        if let error = error {
          debugPrint(error.localizedDescription)
        } else {
          debugPrint("카카오톡 앱을 통한 로그인 성공")
          self.getUserInfoFromKakao()
        }
      }
    } else {
      UserApi.shared.loginWithKakaoAccount { _, error in
        if let error = error {
          debugPrint(error.localizedDescription)
        } else {
          debugPrint("카카오톡 링크를 통한 로그인 성공")
          self.getUserInfoFromKakao()
        }
      }
    }
  }

  private func getUserInfoFromKakao() {
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

  private func postKakaoLoginRequest(email: String, id: String) {
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
            refreshToken: responseData.result.refreshToken
          )
          self.getUserInfoFromEATSSUServer()
        } catch (let error) {
          self.error = error
        }
      case .failure(let error):
        self.error = error
      }
    }
  }
}

// MARK: - Apple Authentication

extension MigratedLoginViewModel: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
  public func loginWithAppleSystem() {
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName, .email]

    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = self
    authorizationController.presentationContextProvider = self
    authorizationController.performRequests()
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
          self.getUserInfoFromEATSSUServer()
        } catch (let error) {
          self.error = error
        }
      case .failure(let error):
        self.error = error
      }
    }
  }

  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return UIApplication.shared.connectedScenes
      .filter { $0.activationState == .foregroundActive }
      .compactMap { $0 as? UIWindowScene }
      .first?.windows
      .first { $0.isKeyWindow } ?? UIWindow()
  }

  func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithAuthorization authorization: ASAuthorization
  ) {
    switch authorization.credential {
    case let appleIDCredential as ASAuthorizationAppleIDCredential:

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

  func authorizationController(
    controller: ASAuthorizationController, didCompleteWithError error: Error
  ) {
    debugPrint("Apple 로그인 실패")
  }
}
