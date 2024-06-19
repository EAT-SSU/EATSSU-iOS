//
//  BaseViewController.swift
//  EatSSU-iOS
//
//  Created by 박윤빈 on 2023/03/15.
//

import Moya
import SnapKit
import UIKit

class BaseViewController: UIViewController {

  // MARK: - Properties

  lazy private(set) var className: String = {
    return type(of: self).description().components(separatedBy: ".").last ?? ""
  }()

  // MARK: - Initializing

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    print("DEINIT: \(className)")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    customNavigationBar()
    configureUI()
    setLayout()
    setButtonEvent()
    view.backgroundColor = .systemBackground

  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    if !NetworkMonitor.shared.isConnected {
      print("네트워크오류")
      self.showAlert(title: "오류", text: "네트워크를 확인해주세요", style: .destructive)

    }
  }

  //MARK: - Functions

  func configureUI() {
    //override Point

  }

  func setLayout() {
    //override Point
  }

  func setButtonEvent() {
    //override Point
  }

  func customNavigationBar() {
    navigationController?.navigationBar.tintColor = .primary
    navigationController?.navigationBar.titleTextAttributes = [
      .foregroundColor: UIColor.primary, NSAttributedString.Key.font: UIFont.bold(size: 18),
    ]
    let backButton: UIBarButtonItem = UIBarButtonItem()
    navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
  }
}
