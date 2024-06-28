//
//  MigratedDeleteConfirmationViewModel.swift
//  EAT-SSU
//
//  Created by Jiwoong CHOI on 6/28/24.
//

import Foundation
import Moya

class MigratedDeleteConfirmationViewModel {
  private let myProvider = MoyaProvider<MyRouter>(plugins: [MoyaLoggingPlugin()])
  
  public func deleteUser(completion: @escaping () -> Void) {
    self.myProvider.request(.signOut) { result in
      switch result {
      case .success(let moyaResponse):
        do {
          let responseData = try moyaResponse.map(BaseResponse<Bool>.self)
          if responseData.result {
            RealmService.shared.resetDB()
            completion()
          }
        } catch(let error) {
          debugPrint(error.localizedDescription)
        }
      case .failure(let error):
        debugPrint(error.localizedDescription)
      }
    }
  }
}
