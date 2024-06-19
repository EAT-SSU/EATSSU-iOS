//
//  NoticeTableViewCell.swift
//  EatSSU-iOS
//
//  Created by 박윤빈 on 2023/05/10.
//

import SnapKit
import UIKit

final class NoticeTableViewCell: UITableViewCell {

  // MARK: - Properties

  static let identifier = "NoticeTableViewCell"

  // MARK: - UI Components

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .medium(size: 18)
    label.textColor = .black
    return label
  }()

  private let dateLabel: UILabel = {
    let label = UILabel()
    label.font = .regular(size: 14)
    label.textColor = .darkGray
    return label
  }()

  private lazy var noticeStacView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      titleLabel,
      dateLabel,
    ])
    stackView.axis = .vertical
    stackView.spacing = 3
    stackView.alignment = .leading
    return stackView
  }()

  // MARK: - Life Cycles

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureUI()
    setLayout()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  // MARK: - Functions

  func configureUI() {
    contentView.addSubview(noticeStacView)
  }

  func setLayout() {
    noticeStacView.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().inset(16)
    }
  }

  func configureCell(_ notice: Notice) {
    titleLabel.text = notice.title
    dateLabel.text = notice.date
  }
}
