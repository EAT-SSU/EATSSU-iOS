//
//  MigratedMyPageLocalData.swift
//  EAT-SSU
//
//  Created by Jiwoong CHOI on 6/22/24.
//

import Foundation

struct MigratedMyPageLocalData: AppData {
  let titleLabel: String
}

extension MigratedMyPageLocalData {
  static let myPageServiceLabelList = [
    MigratedMyPageLocalData(titleLabel: TextLiteral.MyPage.myReview),
    MigratedMyPageLocalData(titleLabel: TextLiteral.MyPage.inquiry),
    MigratedMyPageLocalData(titleLabel: TextLiteral.MyPage.termsOfUse),
    MigratedMyPageLocalData(titleLabel: TextLiteral.MyPage.privacyTermsOfUse),
    MigratedMyPageLocalData(titleLabel: TextLiteral.MyPage.logout),
    MigratedMyPageLocalData(titleLabel: TextLiteral.MyPage.withdraw),
    MigratedMyPageLocalData(titleLabel: TextLiteral.MyPage.appVersion),
  ]
}
