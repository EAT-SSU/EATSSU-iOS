//
//  MigratedSetNicknameViewModel.swift
//  EAT-SSU
//
//  Created by Jiwoong CHOI on 6/28/24.
//

import Foundation
import Moya

class MigratedSetNicknameViewModel : ObservableObject {
  // MARK: - Properties
  private let nicknameProvider = MoyaProvider<UserNicknameRouter>(plugins: [MoyaLoggingPlugin()])

  // MARK: - Public Methods

  public func setUserNickname(nickname: String, completion: @escaping (Result<Response, MoyaError>) -> Void) {
    nicknameProvider.request(.setNickname(nickname: nickname)) { result in
      completion(result)
    }
  }
  
  public func checkUniqueUserNickname(nickname: String, completion: @escaping (Result<Response, MoyaError>) -> Void) {
    nicknameProvider.request(.checkNickname(nickname: nickname)) { result in
      completion(result)
    }
  }
}
