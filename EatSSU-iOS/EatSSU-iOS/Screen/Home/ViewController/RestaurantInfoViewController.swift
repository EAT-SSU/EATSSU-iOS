//
//  RestaurantInfoViewController.swift
//  EatSSU-iOS
//
//  Created by 최지우 on 2023/08/29.
//

import Moya
import SnapKit

final class RestaurantInfoViewController: BaseViewController {

  // MARK: - UI Components
  private let restaurantInfoView = RestaurantInfoView()

  // MARK: - Functions
  override func configureUI() {
    view.addSubview(restaurantInfoView)
  }

  override func setLayout() {
    restaurantInfoView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}

// MARK: - RestaurantInfoDelegate

extension RestaurantInfoViewController: RestaurantInfoDelegate {
  func didTappedRestaurantInfo(restaurantName: String) {
    restaurantInfoView.restaurantNameLabel.text = restaurantName
    let restaurantInfo = RestaurantInfoData.restaurantInfoData.first(where: {
      $0.name == restaurantName
    })

    switch restaurantName {
    case TextLiteral.Restaurant.dormitoryRestaurant:
      setMapView(mapView: restaurantInfoView.mapView, for: .dormitory)
      restaurantInfoView.bind(data: restaurantInfo!)

    case TextLiteral.Restaurant.dodamRestaurant:
      setMapView(mapView: restaurantInfoView.mapView, for: .dodam)
      restaurantInfoView.bind(data: restaurantInfo!)

    case TextLiteral.Restaurant.studentRestaurant:
      setMapView(mapView: restaurantInfoView.mapView, for: .studentRestaurant)
      restaurantInfoView.bind(data: restaurantInfo!)

    case TextLiteral.Restaurant.foodCourt:
      setMapView(mapView: restaurantInfoView.mapView, for: .foodCourt)
      restaurantInfoView.bind(data: restaurantInfo!)

    case TextLiteral.Restaurant.snackCorner:
      setMapView(mapView: restaurantInfoView.mapView, for: .snackCorner)
      restaurantInfoView.bind(data: restaurantInfo!)

    default:
      setMapView(mapView: restaurantInfoView.mapView, for: .soongsil)
    }
  }
}
