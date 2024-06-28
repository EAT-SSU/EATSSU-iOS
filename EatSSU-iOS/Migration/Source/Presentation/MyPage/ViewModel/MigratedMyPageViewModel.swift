//
//  MigratedMyPageViewModel.swift
//  EAT-SSU
//
//  Created by Jiwoong CHOI on 6/28/24.
//

import Foundation
import Moya

class MigratedMyPageViewModel {
  private let myProvider = MoyaProvider<MyRouter>(plugins: [MoyaLoggingPlugin()])

  public func getMyInfo(completion: @escaping (_ result: MyInfoResponse, _ nickName: String) -> Void) {
    myProvider.request(.myInfo) { response in
      switch response {
      case .success(let moyaResponse):
        do {
          let responseData = try moyaResponse.map(BaseResponse<MyInfoResponse>.self)
          completion(responseData.result, responseData.result.nickname ?? "")
        } catch (let error) {
          debugPrint(error.localizedDescription)
        }
      case .failure(let error):
        debugPrint(error.localizedDescription)
      }
    }
  }
}
