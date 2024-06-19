//
//  ReviewRateViewCell.swift
//  EatSSU-iOS
//
//  Created by 박윤빈 on 2023/11/26.
//

//
//  ReviewRateView.swift
//  EatSSU-iOS
//
//  Created by 박윤빈 on 2023/03/15.
//

import SnapKit
import UIKit

final class ReviewRateViewCell: UITableViewCell {

  // MARK: - Properties

  static let identifier = "ReviewRateViewCell"
  var handler: (() -> (Void))?
  var totalRate: Double = 0
  var reviewData: ReviewRateResponse?

  // MARK: - UI Components

  private var menuLabel: UILabel = {
    let label = UILabel()
    label.text = "김치볶음밥 & 계란국"
    label.font = .bold(size: 18)
    label.textColor = .black
    label.numberOfLines = 0
    label.textAlignment = .center
    return label
  }()

  private let bigStarImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "starFilledBig.svg")
    return imageView
  }()

  private let rateNumLabel: UILabel = {
    let label = UILabel()
    label.text = "4.3"
    label.font = .bold(size: 36)
    label.textColor = .black
    return label
  }()

  private let tasteStarImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "starFilled.svg")
    return imageView
  }()

  private let quantityStarImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "starFilled.svg")
    return imageView
  }()

  private let tasteLabel: UILabel = {
    let label = UILabel()
    label.text = "맛"
    label.font = .bold(size: 14)
    label.textColor = .black
    return label
  }()

  private let tasteRateLabel: UILabel = {
    let label = UILabel()
    label.text = "5"
    label.font = .bold(size: 14)
    label.textColor = .primary
    return label
  }()

  private let quantityLabel: UILabel = {
    let label = UILabel()
    label.text = "양"
    label.font = .bold(size: 14)
    label.textColor = .black
    return label
  }()

  private let quantityRateLabel: UILabel = {
    let label = UILabel()
    label.text = "5"
    label.font = .bold(size: 14)
    label.textColor = .primary
    return label
  }()

  private let totalReviewLabel: UILabel = {
    let label = UILabel()
    label.text = "총 리뷰 수"
    label.font = .bold(size: 14)
    label.textColor = .black
    return label
  }()

  private let totalReviewCount: UILabel = {
    let label = UILabel()
    label.text = "15"
    label.font = .bold(size: 14)
    label.textColor = .primary
    return label
  }()

  private let fivePointLabel: UILabel = {
    let label = UILabel()
    label.text = "5점"
    label.font = .medium(size: 12)
    label.textColor = .black
    return label
  }()

  private let fourPointLabel: UILabel = {
    let label = UILabel()
    label.text = "4점"
    label.font = .medium(size: 12)
    label.textColor = .black
    return label
  }()

  private let threePointLabel: UILabel = {
    let label = UILabel()
    label.text = "3점"
    label.font = .medium(size: 12)
    label.textColor = .black
    return label
  }()

  private let twoPointLabel: UILabel = {
    let label = UILabel()
    label.text = "2점"
    label.font = .medium(size: 12)
    label.textColor = .black
    return label
  }()

  private let onePointLabel: UILabel = {
    let label = UILabel()
    label.text = "1점"
    label.font = .medium(size: 12)
    label.textColor = .black
    return label
  }()

  var oneChartBar: UIView = {
    let view = UIView()
    view.backgroundColor = .gray300
    view.roundCorners(corners: [.topRight, .bottomRight], radius: 15)
    return view
  }()

  var twoChartBar: UIView = {
    let view = UIView()
    view.backgroundColor = .gray300
    view.roundCorners(corners: [.topRight, .bottomRight], radius: 15)
    return view
  }()

  var threeChartBar: UIView = {
    let view = UIView()
    view.backgroundColor = .gray300
    view.roundCorners(corners: [.topRight, .bottomRight], radius: 15)
    return view
  }()

  var fourChartBar: UIView = {
    let view = UIView()
    view.backgroundColor = .gray300
    view.roundCorners(corners: [.topRight, .bottomRight], radius: 15)
    return view
  }()

  var fiveChartBar: UIView = {
    let view = UIView()
    view.backgroundColor = .gray300
    return view
  }()

  lazy var yAxisStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      fivePointLabel,
      fourPointLabel,
      threePointLabel,
      twoPointLabel,
      onePointLabel,
    ])
    stackView.axis = .vertical
    stackView.spacing = 2
    stackView.alignment = .trailing
    return stackView
  }()

  lazy var totalLabelStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      totalReviewLabel,
      totalReviewCount,
    ])
    stackView.axis = .horizontal
    stackView.spacing = 7
    return stackView
  }()

  lazy var totalRateStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [bigStarImageView, rateNumLabel])
    stackView.axis = .horizontal
    stackView.spacing = 3
    stackView.alignment = .top
    return stackView
  }()

  lazy var tasteStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      tasteLabel,
      tasteStarImageView,
      tasteRateLabel,
    ])
    stackView.axis = .horizontal
    stackView.spacing = 5
    stackView.alignment = .center
    return stackView
  }()

  lazy var quantityStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      quantityLabel,
      quantityStarImageView,
      quantityRateLabel,
    ])
    stackView.axis = .horizontal
    stackView.spacing = 5
    stackView.alignment = .center
    return stackView
  }()

  private var addReviewButton: UIButton = {
    let button = UIButton()
    button.setTitle("리뷰 작성하기", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = .bold(size: 14)
    button.backgroundColor = .primary
    button.layer.cornerRadius = 10
    button.layer.masksToBounds = false
    return button
  }()

  // MARK: FIX ME - charts 추가 나중에 하기

  override func layoutSubviews() {
    super.layoutSubviews()
    [oneChartBar, twoChartBar, threeChartBar, fourChartBar, fiveChartBar].forEach {
      $0.roundCorners(corners: [.topRight, .bottomRight], radius: 15)
    }
  }

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    configureUI()
    setLayout()
    addTarget()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Functions

  func configureUI() {
    self.contentView.addSubviews(
      menuLabel,
      totalRateStackView,
      addReviewButton,
      totalLabelStackView,
      yAxisStackView,
      oneChartBar,
      twoChartBar,
      threeChartBar,
      fourChartBar,
      fiveChartBar,
      tasteStackView,
      quantityStackView)
  }

  func setLayout() {
    self.backgroundColor = .white

    menuLabel.snp.makeConstraints { make in
      make.top.equalTo(safeAreaLayoutGuide.snp.topMargin).offset(10)
      make.centerX.equalToSuperview()
      make.width.equalTo(290)
    }

    totalRateStackView.snp.makeConstraints { make in
      make.top.equalTo(menuLabel.snp.bottom).offset(40)
      make.leading.equalToSuperview().inset(60)
    }

    tasteStackView.snp.makeConstraints { make in
      make.top.equalTo(totalRateStackView.snp.bottom).offset(8)
      make.leading.equalTo(totalRateStackView).offset(-5)
    }

    quantityStackView.snp.makeConstraints { make in
      make.top.equalTo(tasteStackView)
      make.leading.equalTo(tasteStackView.snp.trailing).offset(5)
    }

    yAxisStackView.snp.makeConstraints { make in
      make.top.equalTo(totalReviewLabel.snp.bottom).offset(8)
      make.leading.equalTo(totalReviewLabel)
    }

    oneChartBar.snp.makeConstraints { make in
      make.centerY.equalTo(onePointLabel)
      make.leading.equalTo(onePointLabel.snp.trailing).offset(7)
      make.height.equalTo(10)
      make.width.equalTo(0)
    }

    twoChartBar.snp.makeConstraints { make in
      make.centerY.equalTo(twoPointLabel)
      make.leading.equalTo(twoPointLabel.snp.trailing).offset(7)
      make.height.equalTo(10)
      make.width.equalTo(0)
    }

    threeChartBar.snp.makeConstraints { make in
      make.centerY.equalTo(threePointLabel)
      make.leading.equalTo(threePointLabel.snp.trailing).offset(7)
      make.height.equalTo(10)
      make.width.equalTo(0)
    }

    fourChartBar.snp.makeConstraints { make in
      make.centerY.equalTo(fourPointLabel)
      make.leading.equalTo(fourPointLabel.snp.trailing).offset(7)
      make.height.equalTo(10)
      make.width.equalTo(0)
    }

    fiveChartBar.snp.makeConstraints { make in
      make.centerY.equalTo(fivePointLabel)
      make.leading.equalTo(fivePointLabel.snp.trailing).offset(7)
      make.height.equalTo(10)
      make.width.equalTo(0)
    }

    addReviewButton.snp.makeConstraints { make in
      make.top.equalTo(tasteStackView.snp.bottom).offset(35)
      make.horizontalEdges.equalToSuperview().inset(60)
      make.height.equalTo(36)
    }

    totalLabelStackView.snp.makeConstraints { make in
      make.top.equalTo(menuLabel.snp.bottom).offset(15)
      make.leading.equalTo(quantityStackView.snp.trailing).offset(44)
    }

    tasteStarImageView.snp.makeConstraints { make in
      make.height.equalTo(11.19)
      make.width.equalTo(11.71)
    }

    quantityStarImageView.snp.makeConstraints { make in
      make.height.equalTo(11.19)
      make.width.equalTo(11.71)
    }
  }

  func addTarget() {
    addReviewButton.addTarget(
      self,
      action: #selector(touchAddReviewButton),
      for: .touchUpInside)
  }

  @objc
  func touchAddReviewButton() {
    handler?()
  }
}

extension ReviewRateViewCell {
  func fixMenuDataBind(data: FixedReviewRateResponse) {
    let total = String(format: "%.1f", data.mainRating ?? 0)
    let taste = String(format: "%.1f", data.tasteRating ?? 0)
    let amount = String(format: "%.1f", data.amountRating ?? 0)
    menuLabel.text = data.menuName
    totalReviewCount.text = "\(data.totalReviewCount)"
    rateNumLabel.text = "\(total)"
    totalRate = data.mainRating ?? 0
    tasteRateLabel.text = "\(taste)"
    quantityRateLabel.text = "\(amount)"
    fiveChartBar.snp.updateConstraints {
      if data.reviewRatingCount.fiveStarCount == 0 {
        $0.width.equalTo(0)
      } else {
        $0.width.equalTo(126 / data.totalReviewCount * data.reviewRatingCount.fiveStarCount)
      }
    }
    fourChartBar.snp.updateConstraints {
      if data.reviewRatingCount.fourStarCount == 0 {
        $0.width.equalTo(0)
      } else {
        $0.width.equalTo(126 / data.totalReviewCount * data.reviewRatingCount.fourStarCount)
      }
    }
    threeChartBar.snp.updateConstraints {
      if data.reviewRatingCount.threeStarCount == 0 {
        $0.width.equalTo(0)
      } else {
        $0.width.equalTo(126 / data.totalReviewCount * data.reviewRatingCount.threeStarCount)
      }
    }
    twoChartBar.snp.updateConstraints {
      if data.reviewRatingCount.twoStarCount == 0 {
        $0.width.equalTo(0)
      } else {
        $0.width.equalTo(126 / data.totalReviewCount * data.reviewRatingCount.twoStarCount)
      }
    }
    oneChartBar.snp.updateConstraints {
      if data.reviewRatingCount.oneStarCount == 0 {
        $0.width.equalTo(0)
      } else {
        $0.width.equalTo(126 / data.totalReviewCount * data.reviewRatingCount.oneStarCount)
      }
    }
  }
  func dataBind(data: ReviewRateResponse) {
    let total = String(format: "%.1f", data.mainRating ?? 0)
    let taste = String(format: "%.1f", data.tasteRating ?? 0)
    let amount = String(format: "%.1f", data.amountRating ?? 0)
    menuLabel.text = data.menuNames.joined(separator: ", ")
    totalReviewCount.text = "\(data.totalReviewCount)"
    rateNumLabel.text = "\(total)"
    totalRate = data.mainRating ?? 0
    tasteRateLabel.text = "\(taste)"
    quantityRateLabel.text = "\(amount)"
    fiveChartBar.snp.updateConstraints {
      if data.reviewRatingCount.fiveStarCount == 0 {
        $0.width.equalTo(0)
      } else {
        $0.width.equalTo(126 / data.totalReviewCount * data.reviewRatingCount.fiveStarCount)
      }
    }
    fourChartBar.snp.updateConstraints {
      if data.reviewRatingCount.fourStarCount == 0 {
        $0.width.equalTo(0)
      } else {
        $0.width.equalTo(126 / data.totalReviewCount * data.reviewRatingCount.fourStarCount)
      }
    }
    threeChartBar.snp.updateConstraints {
      if data.reviewRatingCount.threeStarCount == 0 {
        $0.width.equalTo(0)
      } else {
        $0.width.equalTo(126 / data.totalReviewCount * data.reviewRatingCount.threeStarCount)
      }
    }
    twoChartBar.snp.updateConstraints {
      if data.reviewRatingCount.twoStarCount == 0 {
        $0.width.equalTo(0)
      } else {
        $0.width.equalTo(126 / data.totalReviewCount * data.reviewRatingCount.twoStarCount)
      }
    }
    oneChartBar.snp.updateConstraints {
      if data.reviewRatingCount.oneStarCount == 0 {
        $0.width.equalTo(0)
      } else {
        $0.width.equalTo(126 / data.totalReviewCount * data.reviewRatingCount.oneStarCount)
      }
    }
  }
}
