//
//  BaseUINavigationBar.swift
//  EAT-SSU
//
//  Created by Jiwoong CHOI on 6/12/24.
//

import Foundation
import UIKit

/// 잇슈 앱에서 사용하는 NavigationBar의 기본 뼈대입니다.
class BaseUINavigationBar: UINavigationBar {
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setup()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setup() {
    self.tintColor = .primary
    self.titleTextAttributes = [
      .foregroundColor: UIColor.primary, NSAttributedString.Key.font: UIFont.bold(size: 18),
    ]
    self.topItem?.backBarButtonItem = UIBarButtonItem()
  }
}
