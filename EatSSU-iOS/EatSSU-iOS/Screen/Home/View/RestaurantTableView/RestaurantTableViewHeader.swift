//
//  RestaurantTableViewHeader.swift
//  EatSSU-iOS
//
//  Created by 최지우 on 2023/08/09.
//

import SnapKit
import UIKit

class RestaurantTableViewHeader: BaseTableViewHeaderView {

  let restaurantTitleButton = UIButton().then {
    var config = UIButton.Configuration.plain()
    config.image = ImageLiteral.Icon.coordinate
    config.titlePadding = 7
    config.imagePadding = 7
    $0.configuration = config
  }

  //MARK: - Functions

  override func configure() {
    super.configure()

    configureUI()
    setLayout()
  }

  func configureUI() {
    contentView.addSubview(restaurantTitleButton)
  }

  func setLayout() {
    restaurantTitleButton.snp.makeConstraints {
      $0.leading.equalToSuperview()
    }
  }
}
