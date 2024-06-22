//
//  MigratedProvisionViewController.swift
//  EAT-SSU
//
//  Created by Jiwoong CHOI on 6/22/24.
//

import UIKit

final class MigratedProvisionViewController: BaseViewController {
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
