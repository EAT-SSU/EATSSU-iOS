//
//  HomeTimeTabmanController.swift
//  EatSSU-iOS
//
//  Created by 최지우 on 2023/08/08.
//

import Pageboy
import SnapKit
import Tabman
import UIKit

final class HomeTimeTabmanController: TabmanViewController {
  // MARK: - Properties

  var todayDate: Date = .init()
  var shouldScrollToTop = true

  // MARK: - UI Components

  let bar = TMBar.ButtonBar()
  lazy var morningViewController = HomeRestaurantViewController()
  lazy var lunchViewController = HomeRestaurantViewController()
  lazy var dinnerViewController = HomeRestaurantViewController()
  private lazy var viewControllers = [
    morningViewController,
    lunchViewController,
    dinnerViewController,
  ]

  // MARK: - Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()

    self.registerTabBar()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    self.dateFetchData(for: todayDate)
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)

    shouldScrollToTop = false
  }

  // MARK: - Tabman Methods

  private func registerTabBar() {
    dataSource = self

    self.setLayoutTabBar(ctBar: bar)
    self.adjustTabBar()

    addBar(bar, dataSource: self, at: .top)
  }

  private func adjustTabBar() {
    let currentHour = Calendar.current.component(.hour, from: Date())
    let selectedIndex: PageboyViewController.PageIndex

    switch currentHour {
    case 0..<10:
      selectedIndex = 0
    case 10..<16:
      selectedIndex = 1
    case 16..<24:
      selectedIndex = 2
    default:
      selectedIndex = 1
    }

    scrollToPage(.at(index: selectedIndex), animated: true)
  }

  private func dateFetchData(for date: Date) {
    // formatDate 상수는 코드에서 사용되지 않았다고 함. 제거해도 문제가 없는지 최초 작성자가 확인 후 공유
    let formatDate = changeDateFormat(date: date)

    morningViewController.fetchData(date: date, time: "MORNING")
    lunchViewController.fetchData(date: date, time: "LUNCH")
    dinnerViewController.fetchData(date: date, time: "DINNER")

    /// 스크롤 최상단 이동
    if shouldScrollToTop {
      for item in [morningViewController, lunchViewController, dinnerViewController] {
        item.view.layoutIfNeeded()
      }
      UIView.animate(withDuration: 0.2) { [self] in
        for item in [morningViewController, lunchViewController, dinnerViewController] {
          item.restaurantView.restaurantTableView.setContentOffset(
            CGPoint(x: 0.0, y: 0.0), animated: true)
        }
      }
    }
    shouldScrollToTop = true
  }

  private func changeDateFormat(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyyMMdd"
    return dateFormatter.string(from: date)
  }
}

// MARK: - PageBoy Extension

extension HomeTimeTabmanController: PageboyViewControllerDataSource, TMBarDataSource {
  func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
    return viewControllers.count
  }

  func viewController(
    for pageboyViewController: Pageboy.PageboyViewController,
    at index: Pageboy.PageboyViewController.PageIndex
  ) -> UIViewController? {
    return viewControllers[index]
  }

  func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy
    .PageboyViewController.Page?
  {
    return nil
  }

  func barItem(for bar: Tabman.TMBar, at index: Int) -> Tabman.TMBarItemable {
    switch index {
    case 0:
      return TMBarItem(title: "아침")
    case 1:
      return TMBarItem(title: "점심")
    case 2:
      return TMBarItem(title: "저녁")
    default:
      let title = "Page \(index)"
      return TMBarItem(title: title)
    }
  }

  private func setLayoutTabBar(ctBar: TMBar.ButtonBar) {
    ctBar.backgroundColor = .white
    ctBar.backgroundView.style = .blur(style: .regular)
    ctBar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    ctBar.buttons.customize { button in
      button.tintColor = .gray700  // 선택 안되어 있을 때
      button.selectedTintColor = .primary  // 선택 되어 있을 때
      button.font = .semiBold(size: 16)
    }

    // 인디케이터 조정
    ctBar.indicator.weight = .custom(value: 2)
    ctBar.indicator.tintColor = .primary
    ctBar.indicator.overscrollBehavior = .compress
    ctBar.layout.contentMode = .fit
    ctBar.layout.transitionStyle = .snap
  }
}

extension HomeTimeTabmanController: CalendarSeletionDelegate {
  func didSelectCalendar(date: Date) {
    debugPrint("🐯\(date)")
    todayDate = date
    dateFetchData(for: date)
  }
}
