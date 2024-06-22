//
//  MigratedLoginView.swift
//  EAT-SSU
//
//  Created by Jiwoong CHOI on 6/22/24.
//

import SnapKit
import Then
import UIKit

final class MigratedLoginView: BaseUIView {

  // MARK: - UI Components

  private let logoImage = UIImageView().then { $0.image = ImageLiteral.Auth.signInImage }

  let appleLoginButton = UIButton().then {
    $0.setImage(ImageLiteral.Auth.appleLoginButton, for: .normal)
  }

  let kakaoLoginButton = UIButton().then {
    $0.setImage(ImageLiteral.Auth.kakaoLoginButton, for: .normal)
  }

  let lookingWithNoSignInButton = UIButton().then {
    $0.setImage(ImageLiteral.Auth.lookingButton, for: .normal)
  }

  override func configureUI() {
    self.addSubviews(
      logoImage,
      appleLoginButton,
      kakaoLoginButton,
      lookingWithNoSignInButton)
  }

  override func setLayout() {
    logoImage.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.horizontalEdges.equalToSuperview().inset(90)
      $0.height.equalTo(194)
    }
    appleLoginButton.snp.makeConstraints {
      $0.bottom.equalTo(safeAreaLayoutGuide).inset(100)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.height.equalTo(60)
    }
    kakaoLoginButton.snp.makeConstraints {
      $0.top.equalTo(appleLoginButton.snp.bottom)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.height.equalTo(60)
    }
    lookingWithNoSignInButton.snp.makeConstraints {
      $0.top.equalTo(kakaoLoginButton.snp.bottom).offset(10)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.height.equalTo(45)
    }
  }
}
