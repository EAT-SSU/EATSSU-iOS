//
//  MigratedMyPageRightItemData.swift
//  EAT-SSU
//
//  Created by Jiwoong CHOI on 6/22/24.
//

import Foundation

struct MigratedMyPageRightItemData: AppData {
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

extension MigratedMyPageRightItemData {
  static let myPageRightItemList = [
    MigratedMyPageRightItemData(rightArrow: ">", appVersion: MigratedMyPageRightItemData.version ?? "")
  ]
}
