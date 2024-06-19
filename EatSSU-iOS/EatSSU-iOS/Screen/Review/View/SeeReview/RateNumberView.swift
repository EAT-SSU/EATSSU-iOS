//
//  RateNumberView.swift
//  EatSSU-iOS
//
//  Created by 박윤빈 on 2023/06/29.
//

import SnapKit
import Then
import UIKit

final class RateNumberView: BaseUIView {

  // MARK: - UI Components

  let starImageView = UIImageView()
  lazy var rateNumberLabel = UILabel()
  private lazy var rateNumberStackView = UIStackView(arrangedSubviews: [
    starImageView,
    rateNumberLabel,
  ])

  // MARK: - init

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }

  // MARK: - Functions

  override func configureUI() {
    self.addSubviews(rateNumberStackView)
    starImageView.do {
      $0.image = UIImage(named: "starFilled.svg")
    }

    rateNumberLabel.do {
      $0.text = "5"
      $0.font = .semiBold(size: 14)
      $0.textColor = .primary
    }

    rateNumberStackView.do {
      $0.axis = .horizontal
      $0.spacing = 3
      $0.alignment = .top
    }
  }

  override func setLayout() {
    starImageView.snp.makeConstraints {
      $0.height.equalTo(12)
      $0.width.equalTo(11.5)
    }

    rateNumberStackView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}
