//
//  MainButton.swift
//  EatSSU-iOS
//
//  Created by 최지우 on 2023/04/03.
//

import SnapKit
import Then
import UIKit

class MainButton: UIButton {

  private enum Size {
    static let height: CGFloat = 50.0
  }

  // MARK: - property

  var title: String? {
    didSet {
      setupTitleAttribute()
    }
  }

  // MARK: - init

  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
    setLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - func

  func configureUI() {
    titleLabel?.font = UIFont.semiBold(size: 18.0)
    titleLabel?.textColor = .white
    backgroundColor = .primary
    layer.cornerRadius = 10
  }

  func setLayout() {
    self.snp.makeConstraints {
      $0.height.equalTo(Size.height)
    }
  }

  func setupTitleAttribute() {
    if let buttonTitle = title {
      setTitle(buttonTitle, for: .normal)
    }
  }
}
