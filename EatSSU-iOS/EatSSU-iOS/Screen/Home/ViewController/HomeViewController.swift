import FirebaseAnalytics
import Moya
import SnapKit
//
//  HomeViewController.swift
//  EatSSU-iOS
//
//  Created by 최지우 on 2023/08/08.
//
import UIKit

final class HomeViewController: BaseViewController {
  // MARK: - Properties

  private var currentDate: Date = .init() {
    didSet {
      print("Changed Date: \(currentDate)")
    }
  }

  // MARK: - UI Components

  private let tabmanController = HomeTimeTabmanController()
  private let homeCalendarView = HomeCalendarView()

  // MARK: - Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
    homeCalendarView.delegate = tabmanController

    self.registerTabman()
    self.setnavigation()
    self.configureUI()
    self.setLayout()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    self.setFirebaseTask()
  }

  // MARK: - UI Configuration

  override func configureUI() {
    view.addSubviews(homeCalendarView)
  }

  override func setLayout() {
    homeCalendarView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.horizontalEdges.equalToSuperview()
      $0.height.equalTo(80)
    }
  }

  // MARK: - Navigation Setup

  private func setnavigation() {
    navigationItem.titleView = UIImageView(image: ImageLiteral.Logo.EatSSULogo)
    navigationController?.isNavigationBarHidden = false
    let rightButton = UIBarButtonItem(
      image: ImageLiteral.Icon.myPageIcon,
      style: .plain, target: self,
      action: #selector(didTappedRightBarButton))
    navigationItem.rightBarButtonItem = rightButton
  }

  // MARK: - Firebase

  private func setFirebaseTask() {
    FirebaseRemoteConfig.shared.fetchRestaurantInfo()
    Analytics.logEvent("HomeViewControllerLoad", parameters: nil)
  }

  // MARK: - Tabman

  private func registerTabman() {
    // 자식 뷰 컨트롤러로 추가
    addChild(tabmanController)

    // 자식 뷰를 부모 뷰에 추가
    view.addSubview(tabmanController.view)

    // tabman 레이아웃 설정
    tabmanController.view.snp.makeConstraints {
      $0.top.equalTo(homeCalendarView.snp.bottom)
      $0.horizontalEdges.equalToSuperview()
      $0.bottom.equalToSuperview()
    }

    // 자식 뷰 컨트롤러로서의 위치를 확정
    tabmanController.didMove(toParent: self)
  }

  // MARK: - Button Action

  @objc
  private func didTappedRightBarButton() {
    if RealmService.shared.isAccessTokenPresent() {
      let nextVC = MyPageViewController()
      navigationController?.pushViewController(nextVC, animated: true)
    } else {
      showAlertWithCancel(title: "로그인이 필요한 서비스입니다", text: "로그인 하시겠습니까?", confirmStyle: .default) {
        self.pushToLoginVC()
      }
    }
  }

  private func pushToLoginVC() {
    let loginVC = LoginViewController()
    navigationController?.pushViewController(loginVC, animated: true)
  }
}

// MARK: Calendar Selection
// 아래의 코드는 불필요해보인다. CalendarSelectionDelegate를 채택해서 어떻게 사용되고 있는지?
extension HomeViewController: CalendarSeletionDelegate {

  // 해당 함수는 호출되는 부분이 보이지 않는다. 정확한 명세가 필요.
  func didSelectCalendar(date: Date) {
    currentDate = date
  }
}
