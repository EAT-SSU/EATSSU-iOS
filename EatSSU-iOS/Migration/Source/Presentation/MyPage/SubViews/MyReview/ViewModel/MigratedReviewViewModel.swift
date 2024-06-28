//
//  MigratedReviewViewModel.swift
//  EAT-SSU
//
//  Created by Jiwoong CHOI on 6/28/24.
//

import Foundation
import Moya

class MigratedReviewViewModel: ObservableObject {
  // MARK: - Private Properties

  private let myProvider = MoyaProvider<MyRouter>(plugins: [MoyaLoggingPlugin()])
  private let reviewProvider = MoyaProvider<ReviewRouter>(plugins: [MoyaLoggingPlugin()])

  // MARK: - Public Properties

  public var reviewList = [MyDataList]()

  // MARK: - Public Methods

  public func checkReviewCount(completion: @escaping (_ myReviewTableViewStatus: Bool, _ noMyReviewImageViewStatus: Bool) -> Void) {
    if self.reviewList.count == 0 {
      completion(true, false)
    } else {
      completion(false, true)
    }
  }

  public func getMyReview(completion: @escaping () -> Void) {
    self.myProvider.request(.myReview) { result in
      switch result {
      case .success(let moyaResponse):
        do {
          let responseData = try moyaResponse.map(BaseResponse<MyReviewResponse>.self)
          self.reviewList = responseData.result.dataList
        } catch (let error) {
          debugPrint(error.localizedDescription)
        }
      case .failure(let error):
        debugPrint(error.localizedDescription)
      }
    }
  }

  public func deleteReview(reviewID: Int, completion: @escaping () -> Void) {
    self.reviewProvider.request(.deleteReview(reviewID)) { result in
      switch result {
      case .success:
        completion()
      case .failure(let error):
        debugPrint(error.localizedDescription)
      }
    }
  }
}
