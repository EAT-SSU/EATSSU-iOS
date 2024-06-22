//
//  MyPageServiceCell.swift
//  EAT-SSU
//
//  Created by Jiwoong CHOI on 6/22/24.
//

import UIKit

final class MigratedMyPageServiceCell: UITableViewCell {

  // MARK: - Properties

  static let identifier = "MyPageServiceCell"

  // MARK: - UI Components

  var serviceLabel = UILabel().then {
    $0.font = .medium(size: 16)
    $0.textColor = .black
  }

  var rightItemLabel = UILabel().then {
    $0.font = .regular(size: 16)
    $0.textColor = .gray700
  }

  // MARK: - init

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    configureUI()
    setLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Functions

  func configureUI() {
    self.addSubviews(
      serviceLabel,
      rightItemLabel)
  }

  func setLayout() {
    serviceLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(16)
      $0.centerY.equalToSuperview()
    }
    rightItemLabel.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(16)
      $0.centerY.equalToSuperview()
    }
  }
}
