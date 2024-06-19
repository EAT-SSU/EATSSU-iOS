//
//  ProvisionView.swift
//  EatSSU-iOS
//
//  Created by 최지우 on 11/19/23.
//

import UIKit

final class ProvisionView: BaseUIView, UITextViewDelegate {

  // MARK: - UI Components

  var privisionTextView = UITextView().then {
    $0.text = TextLiteral.MyPage.termsOfUseText
    $0.isEditable = false
  }

  // MARK: - Functions

  override func configureUI() {
    self.addSubview(privisionTextView)
  }

  override func setLayout() {
    privisionTextView.snp.makeConstraints {
      $0.verticalEdges.equalToSuperview()
      $0.horizontalEdges.equalToSuperview().inset(10)
    }
  }

}
