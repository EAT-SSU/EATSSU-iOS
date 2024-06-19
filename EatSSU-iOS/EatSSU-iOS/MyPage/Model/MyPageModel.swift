//
//  MyPageModel.swift
//  EatSSU-iOS
//
//  Created by 최지우 on 2023/07/25.
//

import Foundation

struct MyPageLocalData: AppData {
  let titleLabel: String
}

extension MyPageLocalData {
  static let myPageServiceLabelList = [
    MyPageLocalData(titleLabel: TextLiteral.MyPage.myReview),
    MyPageLocalData(titleLabel: TextLiteral.MyPage.inquiry),
    MyPageLocalData(titleLabel: TextLiteral.MyPage.termsOfUse),
    MyPageLocalData(titleLabel: TextLiteral.MyPage.privacyTermsOfUse),
    MyPageLocalData(titleLabel: TextLiteral.MyPage.logout),
    MyPageLocalData(titleLabel: TextLiteral.MyPage.withdraw),
    MyPageLocalData(titleLabel: TextLiteral.MyPage.appVersion),
  ]
}

struct MyPageRightItemData: AppData {
  let rightArrow: String
  let appVersion: String?

  static var version: String? {
    guard let dictionary = Bundle.main.infoDictionary,
      let version = dictionary["CFBundleShortVersionString"] as? String,
      // build 변수는 사용하지 않는 코드. 최초작성자가 확인 후 공유
      let build = dictionary["CFBundleVersion"] as? String
    else { return nil }

    let versionAndBuild: String = "\(version)"
    return versionAndBuild
  }
}

extension MyPageRightItemData {
  static let myPageRightItemList = [
    MyPageRightItemData(rightArrow: ">", appVersion: MyPageRightItemData.version ?? "")
  ]
}
