//
//  Config.swift
//  EatSSU-iOS
//
//  Created by 최지우 on 2023/05/18.
//

import Foundation

enum Config {
  static let baseURL = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as! String
  static let kakaoAPIKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_API_KEY") as! String
}
