//
//  ReviewEmptyViewCell.swift
//  EatSSU-iOS
//
//  Created by 박윤빈 on 2023/11/26.
//

import SnapKit
import UIKit

final class ReviewEmptyViewCell: UITableViewCell {

  // MARK: - Properties

  static let identifier = "ReviewEmptyViewCell"

  // MARK: - UI Components

  private lazy var noReviewImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = ImageLiteral.Review.noReview
    return imageView
  }()

  // MARK: - Functions

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.contentView.addSubview(noReviewImageView)
    setLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setLayout() {
    noReviewImageView.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }

  func configure(isTokenExist: Bool) {
    if isTokenExist {
      noReviewImageView.image = ImageLiteral.Review.noReview
    } else {
      noReviewImageView.image = ImageLiteral.Review.pleaseLogin
    }
  }
}
