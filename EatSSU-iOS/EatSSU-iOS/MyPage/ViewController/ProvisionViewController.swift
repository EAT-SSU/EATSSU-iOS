//
//  ProvisionViewController.swift
//  EatSSU-iOS
//
//  Created by 최지우 on 11/19/23.
//

import UIKit

final class ProvisionViewController: BaseViewController {
  // MARK: - Properties

  var navigationTitle = TextLiteral.MyPage.defaultTerms

  // MARK: - UI Components

  let provisionView = ProvisionView()

  // MARK: - UI Configuration

  override func customNavigationBar() {
    super.customNavigationBar()
    navigationItem.title = navigationTitle
  }

  override func configureUI() {
    view.addSubviews(provisionView)
  }

  override func setLayout() {
    provisionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}
