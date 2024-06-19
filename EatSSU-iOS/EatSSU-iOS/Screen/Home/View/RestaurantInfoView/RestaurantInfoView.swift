//
//  RestaurantInfoView.swift
//  EatSSU-iOS
//
//  Created by 최지우 on 2023/07/23.
//

import MapKit
import SnapKit
import Then
import UIKit

final class RestaurantInfoView: BaseUIView {

  // MARK: - Properties

  static let tableViewCellHeight = 10.0
  var restaurantInfoInputData: RestaurantInfoResponse? {
    didSet {
      //            configureRestaurantInfo()
    }
  }

  // MARK: - UI Components

  let mapView = MKMapView()

  var restaurantNameLabel = UILabel().then {
    $0.font = .bold(size: 20)
  }
  private let lineView = UIView().then {
    $0.backgroundColor = .primary
  }
  private let locationTitleLabel = UILabel().then {
    $0.text = "식당 위치"
    $0.font = .bold(size: 18)
  }
  private var locationLabel = UILabel().then {
    $0.text = "숭실대학교"
    $0.font = .medium(size: 16)
  }
  private let lineView1 = UIView().then {
    $0.backgroundColor = .gray300
  }
  private let openingTimeTitleLabel = UILabel().then {
    $0.text = "영업 시간"
    $0.font = .bold(size: 18)
  }
  private let openingTimeLabel = UILabel().then {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 10
    let attributedString = NSAttributedString(
      string: "08:00~09:30\n11:00~14:00\n17:00~18:30",
      attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    $0.attributedText = attributedString
    $0.numberOfLines = 0
    $0.textAlignment = .right
    $0.font = .medium(size: 16)
  }
  private let ectTitleLabel = UILabel().then {
    $0.text = "비고"
    $0.font = .bold(size: 18)
  }
  private let ectLabel = UILabel().then {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 10
    let attributedString = NSAttributedString(
      string: "아시안푸드, 돈까스, 샐러드, 국밥 등\n카페",
      attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    $0.attributedText = attributedString
    $0.numberOfLines = 0
    $0.textAlignment = .right
    $0.font = .medium(size: 16)
  }

  //MARK: - Functions

  override func configureUI() {
    self.addSubviews(
      restaurantNameLabel,
      lineView,
      locationTitleLabel,
      locationLabel,
      mapView,
      openingTimeTitleLabel,
      openingTimeLabel,
      lineView1,
      ectTitleLabel,
      ectLabel)
  }

  override func setLayout() {
    restaurantNameLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(25)
      $0.centerX.equalToSuperview()
    }
    lineView.snp.makeConstraints {
      $0.top.equalTo(restaurantNameLabel.snp.bottom).offset(15)
      $0.horizontalEdges.equalToSuperview().inset(28)
      $0.height.equalTo(1)
    }
    locationTitleLabel.snp.makeConstraints {
      $0.top.equalTo(lineView.snp.bottom).offset(15)
      $0.leading.equalToSuperview().offset(24)
    }
    locationLabel.snp.makeConstraints {
      $0.top.equalTo(locationTitleLabel)
      $0.trailing.equalToSuperview().offset(-26)
    }
    mapView.snp.makeConstraints {
      $0.top.equalTo(locationTitleLabel.snp.bottom).offset(12)
      $0.horizontalEdges.equalToSuperview().inset(16)
      $0.height.equalTo(256)
    }
    openingTimeTitleLabel.snp.makeConstraints {
      $0.top.equalTo(mapView.snp.bottom).offset(15)
      $0.leading.equalToSuperview().offset(24)
    }
    openingTimeLabel.snp.makeConstraints {
      $0.top.equalTo(openingTimeTitleLabel)
      $0.trailing.equalToSuperview().offset(-26)
    }
    lineView1.snp.makeConstraints {
      $0.top.equalTo(openingTimeLabel.snp.bottom).offset(16)
      $0.horizontalEdges.equalToSuperview().inset(28)
      $0.height.equalTo(1)
    }
    ectTitleLabel.snp.makeConstraints {
      $0.top.equalTo(lineView1).offset(21)
      $0.leading.equalToSuperview().offset(24)
    }
    ectLabel.snp.makeConstraints {
      $0.top.equalTo(ectTitleLabel)
      $0.trailing.equalToSuperview().offset(-26)

    }
  }

  func bind(data: RestaurantInfoData) {
    restaurantNameLabel.text = data.name
    locationLabel.text = data.location
    openingTimeLabel.text = data.time
    ectLabel.text = data.etc
  }

  //    func configureRestaurantInfo() {
  //        self.locationLabel.text = restaurantInfoInputData?.location
  //
  //
  //        restaurantInfoInputData?.openHours.forEach {
  //            if ($0).dayType == "주중" {
  //                weekdayTimes.append(TimeData(timepart: $0.timepart, time: $0.time))
  //        }}
  //        weekdayTimeTableView.reloadData()
  //
  //        restaurantInfoInputData?.openHours.forEach {
  //            if ($0).dayType == "주말, 공휴일" {
  //                weekendTimes.append(TimeData(timepart: $0.timepart, time: $0.time))
  //        }}
  //        weekendTimeTableView.reloadData()
  //    }
}
