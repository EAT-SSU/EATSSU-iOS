//
//  MigratedRequestViewModel.swift
//  EAT-SSU
//
//  Created by Jiwoong CHOI on 6/29/24.
//

import Foundation
import Moya

class MigratedRequestViewModel {
  private let myProvider = MoyaProvider<MyRouter>(plugins: [MoyaLoggingPlugin()])

  public func postInquiry(email: String, content: String, completion : @escaping () -> Void) {
    let param = InquiryRequest(email, content)
    self.myProvider.request(.inquiry(param: param)) { response in
      switch response {
      case .success(let moyaResponse):
        do {
          let responseData = try moyaResponse.map(BaseResponse<Bool>.self)
          debugPrint(responseData)
          completion()
        } catch (let err) {
          debugPrint(err.localizedDescription)
          completion()
        }
      case .failure(let err):
        print(err.localizedDescription)
      }
    }
  }
}
