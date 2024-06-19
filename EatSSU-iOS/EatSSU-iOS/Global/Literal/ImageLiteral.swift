//
//  ImageLiteral.swift
//  EatSSU-iOS
//
//  Created by 최지우 on 2023/04/07.
//

import UIKit

/// Assets에서 이미지를 불러오는 리터럴
/// # 아래의 항목들을 하위 enum으로 가지고 있습니다.
/// - Logo
/// - Auth
/// - Icon
/// - My
/// - Review
enum ImageLiteral {
  // MARK: - Logo

  /// 잇슈의 로고 이미지들을 가지고 있는 이미지 리터럴 입니다.
  /// # 아래의 항목들을 가지고 있습니다
  /// - splashLogo
  /// - EatSSULogo
  enum Logo {
    static var splashLogo: UIImage { .load(name: "splashLogo") }
    static var EatSSULogo: UIImage { .load(name: "EatSSULogo") }
  }

  // MARK: - Auth

  /// 사용자인증 관련 이미지들을 가지고 있는 이미지 리터럴 입니다.
  /// # 아래의 항목들을 가지고 있습니다
  /// - appleLoginButton
  /// - kakaoLoginButton
  /// - signInImage
  /// - lookingButton
  enum Auth {
    static var appleLoginButton: UIImage { .load(name: "appleLoginButton") }
    static var kakaoLoginButton: UIImage { .load(name: "kakaoLoginButton") }
    static var signInImage: UIImage { .load(name: "signInImage") }
    static var lookingButton: UIImage { .load(name: "lookingButton") }
  }

  // MARK: - Icon

  /// 잇슈 앱 내부에서 사용하는 아이콘들의 이미지들을 가지고 있는 이미지 리터럴 입니다.
  /// # 아래의 항목들을 가지고 있습니다
  /// - menuIcon
  /// - checkedIcon
  /// - uncheckedIcon
  /// - coordinate
  /// - myPageIcon
  /// - profileIcon
  /// - signInWithKakao
  /// - signInWithApple
  enum Icon {
    static var menuIcon: UIImage { .load(name: "menuIcon") }
    static var checkedIcon: UIImage { .load(name: "checkedIcon") }
    static var uncheckedIcon: UIImage { .load(name: "uncheckedIcon") }
    static var coordinate: UIImage { .load(name: "coordinate") }
    static var myPageIcon: UIImage { .load(name: "myPageIcon") }
    static var profileIcon: UIImage { .load(name: "profileIcon") }
    static var signInWithKakao: UIImage { .load(name: "signInWithKakao") }
    static var signInWithApple: UIImage { .load(name: "signInWithApple") }
  }

  // MARK: - My

  /// 마이페이지와 연관된 설정 버튼 이미지를 가지고 있는 이미지 리터릴 입니다.
  /// # 보완사항
  /// - greySideButton은 피처에 입각해서 분류한 것 같긴한데, 더 개선할 수 있다고 생각합니다.
  /// # 아래의 항목을 enum으로 가지고 있습니다.
  /// - greySideButton
  enum My {
    static var greySideButton: UIImage { .load(name: "greySideButton") }
  }

  // MARK: - Review

  /// 리뷰페이지에서 사용되는 이미지 리터럴을 가지고 있습니다.
  /// # 아래의 항목들을 가지고 있습니다
  /// - noReview
  /// - noMyReview
  /// - pleaseLogin
  enum Review {
    static var noReview: UIImage { .load(name: "noReview") }
    static var noMyReview: UIImage { .load(name: "noMyReview") }
    static var pleaseLogin: UIImage { .load(name: "pleaseLogin") }
  }
}
