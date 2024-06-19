//
//  HomeRestaurantViewController.swift
//  EatSSU-iOS
//
//  Created by 최지우 on 2023/08/08.
//

import Moya
import SnapKit
import Then
import UIKit

// MARK: - Enumeration

enum DiningSection: Int {
  case dormitory
  case dodam
  case studentRestaurant
  case foodCourt
  case snackCorner
}

// MARK: - Protocols

protocol ReviewMenuTypeInfoDelegate: AnyObject {
  func didDelegateReviewMenuTypeInfo(for menuTypeData: ReviewMenuTypeInfo)
}

protocol RestaurantInfoDelegate: AnyObject {
  func didTappedRestaurantInfo(restaurantName: String)
}

final class HomeRestaurantViewController: BaseViewController {
  // MARK: - let Properties

  private let restaurantTableViewMenuTitleCellCount = 1
  private let headerHeight: CGFloat = 35
  private let fixedDummy = FixedMenuInfoData.Dummy()
  private let menuProvider = MoyaProvider<HomeRouter>(plugins: [MoyaLoggingPlugin()])
  private let sectionHeaderRestaurant = [
    TextLiteral.Restaurant.dormitoryRestaurant,
    TextLiteral.Restaurant.dodamRestaurant,
    TextLiteral.Restaurant.studentRestaurant,
    TextLiteral.Restaurant.foodCourt,
    TextLiteral.Restaurant.snackCorner
  ]
  private let restaurantButtonTitleToName = [
    TextLiteral.Restaurant.dormitoryRestaurant: "DORMITORY",
    TextLiteral.Restaurant.dodamRestaurant: "DODAM",
    TextLiteral.Restaurant.studentRestaurant: "HAKSIK",
    TextLiteral.Restaurant.foodCourt: "FOOD_COURT",
    TextLiteral.Restaurant.snackCorner: "SNACK_CORNER"
  ]

  // MARK: - var Properties

  weak var infoDelegate: RestaurantInfoDelegate?
  var delegate: ReviewMenuTypeInfoDelegate?
  var currentRestaurant = ""
  var isWeekend = false
  var isSelectable = false
  var changeMenuTableViewData: [String: [ChangeMenuTableResponse]] = [:] {
    didSet {
      // 빈 name을 가지지 않은 ChangeMenuTableResponse만 필터링
      changeMenuTableViewData = changeMenuTableViewData.mapValues { menuTableResponses in
        menuTableResponses.filter { response in
          !(response.menusInformationList.first?.name.isEmpty ?? true)
        }
      }

      // 필터링된 데이터로 테이블 뷰 섹션을 새로고침
      if let sectionIndex = getSectionIndex(for: currentRestaurant) {
        restaurantView.restaurantTableView.reloadSections([sectionIndex], with: .automatic)
      }
    }
  }

  var fixMenuTableViewData: [String: [MenuInformation]] = [:] {
    didSet {
      if let sectionIndex = getSectionIndex(for: currentRestaurant) {
        restaurantView.restaurantTableView.reloadSections([sectionIndex], with: .automatic)
      }
    }
  }

  // MARK: - UI Components

  let restaurantView = HomeRestaurantView()

  // MARK: - Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()

    self.setDelegate()
    self.setTableView()
  }

  // MARK: - UI Configuration

  override func configureUI() {
    view.addSubviews(restaurantView)
  }

  override func setLayout() {
    restaurantView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

  private func setDelegate() {
    restaurantView.restaurantTableView.dataSource = self
    restaurantView.restaurantTableView.delegate = self
  }

  private func setTableView() {
    restaurantView.restaurantTableView.register(
      RestaurantTableViewMenuTitleCell.self,
      forCellReuseIdentifier: RestaurantTableViewMenuTitleCell.identifier)
    restaurantView.restaurantTableView.register(
      RestaurantTableViewMenuCell.self,
      forCellReuseIdentifier: RestaurantTableViewMenuCell.identifier)
    restaurantView.restaurantTableView.register(
      RestaurantTableViewHeader.self,
      forHeaderFooterViewReuseIdentifier: "HomeRestaurantTableViewHeader")
  }

  // MARK: - Private Methods

  private func getSectionIndex(for restaurant: String) -> Int? {
    let restaurantRawValue = [
      TextLiteral.Restaurant.dormitoryRawValue,
      TextLiteral.Restaurant.dodamRawValue,
      TextLiteral.Restaurant.studentRestaurantRawValue,
      TextLiteral.Restaurant.foodCourtRawValue,
      TextLiteral.Restaurant.snackCornerRawValue
    ]
    return restaurantRawValue.firstIndex(of: restaurant)
  }

  private func getSectionKey(for section: Int) -> String {
    let restaurantRawValue = [
      TextLiteral.Restaurant.dormitoryRawValue,
      TextLiteral.Restaurant.dodamRawValue,
      TextLiteral.Restaurant.studentRestaurantRawValue,
      TextLiteral.Restaurant.foodCourtRawValue,
      TextLiteral.Restaurant.snackCornerRawValue
    ]
    return restaurantRawValue[section]
  }

  private func changeDateFormat(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyyMMdd"
    return dateFormatter.string(from: date)
  }

  // MARK: - Public Methods

  public func fetchData(date: Date, time: String) {
    let formatDate = self.changeDateFormat(date: date)
    self.getChageMenuData(
      date: formatDate, restaurant: TextLiteral.Restaurant.dormitoryRawValue, time: time)
    self.getChageMenuData(
      date: formatDate, restaurant: TextLiteral.Restaurant.dodamRawValue, time: time)
    self.getChageMenuData(
      date: formatDate, restaurant: TextLiteral.Restaurant.studentRestaurantRawValue, time: time)

    let weekday = Weekday.from(date: date)
    isWeekend = weekday.isWeekend

    if time == TextLiteral.Restaurant.lunchRawValue {
      if !weekday.isWeekend {
        self.getFixMenuData(restaurant: TextLiteral.Restaurant.foodCourtRawValue)
        self.getFixMenuData(restaurant: TextLiteral.Restaurant.snackCornerRawValue)
      } else {
        currentRestaurant = TextLiteral.Restaurant.foodCourtRawValue
        fixMenuTableViewData[TextLiteral.Restaurant.foodCourtRawValue] = [
          MenuInformation(menuId: 0, name: "", mainRating: nil, price: nil)
        ]
        currentRestaurant = TextLiteral.Restaurant.snackCornerRawValue
        fixMenuTableViewData[TextLiteral.Restaurant.snackCornerRawValue] = [
          MenuInformation(menuId: 0, name: "", mainRating: nil, price: nil)
        ]
      }
    }
  }

  // MARK: - Button Action

  @objc
  private func tap(_ sender: UIButton) {
    let restaurantInfoViewController = RestaurantInfoViewController()
    restaurantInfoViewController.modalPresentationStyle = .pageSheet
    restaurantInfoViewController.sheetPresentationController?.prefersGrabberVisible = true

    infoDelegate = restaurantInfoViewController

    let currentTitle = sender.configuration?.title
    present(restaurantInfoViewController, animated: true) {
      self.infoDelegate?.didTappedRestaurantInfo(restaurantName: currentTitle ?? "식당")
      debugPrint(currentTitle!)
    }
  }
}

// MARK: - UITableViewDataSource

extension HomeRestaurantViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return sectionHeaderRestaurant.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let sectionKey = getSectionKey(for: section)

    if [0, 1, 2].contains(section) {
      return (changeMenuTableViewData[sectionKey]?.count ?? 0)
        + restaurantTableViewMenuTitleCellCount
    } else if [3, 4, 5].contains(section) {
      return (fixMenuTableViewData[sectionKey]?.count ?? 0) + restaurantTableViewMenuTitleCellCount
    } else {
      return 0
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    /// Menu Title Cell
    if indexPath.row == 0 {
      let cell = tableView.dequeueReusableCell(
        withIdentifier: RestaurantTableViewMenuTitleCell.identifier, for: indexPath)
      cell.selectionStyle = .none
      return cell
      /// Menu Cell
    } else {
      let cell =
        tableView.dequeueReusableCell(
          withIdentifier: RestaurantTableViewMenuCell.identifier,
          for: indexPath) as! RestaurantTableViewMenuCell

      let diningSection = DiningSection(rawValue: indexPath.section)

      switch diningSection {
      case .dormitory:
        if let data = changeMenuTableViewData[TextLiteral.Restaurant.dormitoryRawValue]?[
          indexPath.row - restaurantTableViewMenuTitleCellCount
        ] {
          cell.model = .change(data)
        }
      case .dodam:
        if let data = changeMenuTableViewData[TextLiteral.Restaurant.dodamRawValue]?[
          indexPath.row - restaurantTableViewMenuTitleCellCount
        ] {
          cell.model = .change(data)
        }
      case .studentRestaurant:
        if let data = changeMenuTableViewData[TextLiteral.Restaurant.studentRestaurantRawValue]?[
          indexPath.row - restaurantTableViewMenuTitleCellCount
        ] {
          cell.model = .change(data)
        }
      case .foodCourt:
        if let data = fixMenuTableViewData[TextLiteral.Restaurant.foodCourtRawValue]?[
          indexPath.row - restaurantTableViewMenuTitleCellCount
        ] {
          if data.price != nil {
            isSelectable = true
            cell.model = .fix(data)
            cell.selectionStyle = .default
          } else {
            isSelectable = false
            cell.selectionStyle = .none
          }
        }
      case .snackCorner:
        if let data = fixMenuTableViewData[TextLiteral.Restaurant.snackCornerRawValue]?[
          indexPath.row - restaurantTableViewMenuTitleCellCount
        ] {
          if data.price != nil {
            isSelectable = true
            cell.selectionStyle = .default
          } else {
            isSelectable = false
            cell.selectionStyle = .none
          }
          cell.model = .fix(data)
        }
      default:
        return cell
      }

      return cell
    }
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard
      let homeRestaurantTableViewHeader = tableView.dequeueReusableHeaderFooterView(
        withIdentifier: "HomeRestaurantTableViewHeader") as? RestaurantTableViewHeader
    else {
      return nil
    }
    /// section header 타이틀 속성 지정
    if let currentConfig = homeRestaurantTableViewHeader.restaurantTitleButton.configuration {
      var updatedConfig = currentConfig
      var titleAttr = AttributedString(sectionHeaderRestaurant[section])
      titleAttr.font = UIFont.bold(size: 18)
      titleAttr.foregroundColor = UIColor.black
      updatedConfig.attributedTitle = titleAttr

      homeRestaurantTableViewHeader.restaurantTitleButton.configuration = updatedConfig
      homeRestaurantTableViewHeader.restaurantTitleButton.addTarget(
        self, action: #selector(tap), for: .touchUpInside)
    }
    return homeRestaurantTableViewHeader
  }
}

// MARK: - UITableViewDelegate

extension HomeRestaurantViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return headerHeight
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    if indexPath.row == 0 {
      return
    }

    let restaurant = getSectionKey(for: indexPath.section)
    /// bind Data
    var reviewMenuTypeInfo = ReviewMenuTypeInfo(menuType: "", menuID: 0)

    if [0, 1, 2].contains(indexPath.section) {
      reviewMenuTypeInfo.menuType = "VARIABLE"
      reviewMenuTypeInfo.menuID =
        changeMenuTableViewData[restaurant]?[indexPath.row - restaurantTableViewMenuTitleCellCount]
        .mealId ?? 100
      if let list = changeMenuTableViewData[restaurant]?[
        indexPath.row - restaurantTableViewMenuTitleCellCount
      ].menusInformationList {
        reviewMenuTypeInfo.changeMenuIDList = list.compactMap { $0.menuId }
      }
    } else if [3, 4, 5].contains(indexPath.section) {
      if !isSelectable {
        return
      }
      reviewMenuTypeInfo.menuType = "FIXED"
      reviewMenuTypeInfo.menuID =
        fixMenuTableViewData[restaurant]?[indexPath.row - restaurantTableViewMenuTitleCellCount]
        .menuId ?? 100
    }

    /// push VC
    let reviewViewController = ReviewViewController()
    delegate = reviewViewController
    navigationController?.pushViewController(reviewViewController, animated: true)

    delegate?.didDelegateReviewMenuTypeInfo(for: reviewMenuTypeInfo)
  }
}

// MARK: - Network

extension HomeRestaurantViewController {
  private func getChageMenuData(date: String, restaurant: String, time: String) {
    menuProvider.request(
      .getChangeMenuTableResponse(date: date, restaurant: restaurant, time: time)
    ) { response in
      switch response {
      case .success(let responseData):
        do {
          self.currentRestaurant = restaurant
          let responseDetailDto = try responseData.map(BaseResponse<[ChangeMenuTableResponse]>.self)
          self.changeMenuTableViewData[restaurant] = responseDetailDto.result
        } catch (let err) {
          print(err.localizedDescription)
        }
      case .failure(let err):
        print(err.localizedDescription)
      }
    }
  }

  private func getFixMenuData(restaurant: String) {
    menuProvider.request(.getFixedMenuTableResponse(restaurant: restaurant)) { response in
      switch response {
      case .success(let responseData):
        do {
          self.currentRestaurant = restaurant
          let responseDetailDto = try responseData.map(BaseResponse<FixedMenuTableResponse>.self)
          let responseResult = responseDetailDto.result

          var allMenuInformations = [MenuInformation]()
          for categoryMenu in responseResult.categoryMenuListCollection {
            allMenuInformations += categoryMenu.menuInformationList
          }
          self.fixMenuTableViewData[restaurant] = allMenuInformations
        } catch (let err) {
          print(err.localizedDescription)
        }
      case .failure(let err):
        print(err.localizedDescription)
      }
    }
  }
}
