//
//  MigratedProvision.swift
//  EAT-SSU
//
//  Created by Jiwoong CHOI on 6/22/24.
//

import UIKit

final class MigratedProvisionView: BaseUIView, UITextViewDelegate {

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
