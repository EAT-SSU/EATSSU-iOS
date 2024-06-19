//
//  ChoiceMenuViewController.swift
//  EatSSU-iOS
//
//  Created by 박윤빈 on 2023/06/29.
//

import SnapKit
import Then
import UIKit

final class ChoiceMenuViewController: BaseViewController {
  // MARK: - Properties

  var menuNameList: [String] = []
  var menuIDList: [Int] = []
  var isMenuSelected: [Bool] = [] {
    didSet {
      self.choiceMenuTabelView.reloadData()
      print(isMenuSelected)
    }
  }

  private lazy var selectedList: [String] = []
  private var selectedIDList: [Int] = []

  // MARK: - UI Component

  private let enjoyLabel = UILabel()
  private let whichFoodLabel = UILabel()
  private lazy var choiceMenuTabelView = UITableView(frame: .zero, style: .plain)
  private lazy var nextButton = MainButton()

  // MARK: - Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setTableViewConfig()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    /// pop한 후, 다시 메뉴를 선택할 경우를 방지하기 위하여 선택한 리스트를 초기화합니다
    selectedList = []
    selectedIDList = []
  }

  // MARK: - UI Configuration

  override func configureUI() {
    whichFoodLabel.do {
      $0.text = "어떤 음식에 대한 리뷰인가요?"
      $0.font = .bold(size: 16)
      $0.textColor = .black
    }

    enjoyLabel.do {
      $0.text = "식사는 맛있게 하셨나요?"
      $0.font = .medium(size: 16)
      $0.textColor = .gray700
    }

    choiceMenuTabelView.do {
      $0.separatorStyle = .none
    }

    nextButton.do {
      $0.setTitle("다음 단계로", for: .normal)
    }

    self.view.addSubviews(
      enjoyLabel,
      whichFoodLabel,
      choiceMenuTabelView,
      nextButton)
  }

  override func setLayout() {
    whichFoodLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).inset(25)
      $0.centerX.equalToSuperview()
    }

    enjoyLabel.snp.makeConstraints {
      $0.top.equalTo(whichFoodLabel.snp.bottom).offset(15)
      $0.centerX.equalToSuperview()
    }

    choiceMenuTabelView.snp.makeConstraints {
      $0.top.equalTo(enjoyLabel.snp.bottom).offset(40)
      $0.leading.trailing.bottom.equalToSuperview()
    }

    nextButton.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview().inset(16)
      $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(17)
    }
  }

  override func setButtonEvent() {
    nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
  }

  override func customNavigationBar() {
    super.customNavigationBar()
    navigationItem.title = "리뷰 남기기"
  }

  private func setTableViewConfig() {
    self.choiceMenuTabelView.delegate = self
    self.choiceMenuTabelView.dataSource = self
    self.choiceMenuTabelView.register(
      ChoiceMenuTableViewCell.self,
      forCellReuseIdentifier: ChoiceMenuTableViewCell.identifier)
  }

  // MARK: - Button Action Methods

  @objc private func nextButtonTapped() {
    makeList(menuList: menuNameList, selectedList: isMenuSelected)
    if selectedList.count == 0 {
      view.showToast(message: "리뷰를 작성할 메뉴를 선택해주세요!")
    } else {
      let setRateVC = SetRateViewController()
      setRateVC.dataBind(list: self.selectedList, idList: selectedIDList)
      self.navigationController?.pushViewController(setRateVC, animated: true)
    }
  }

  // MARK: - Some Public Methods

  public func menuDataBind(menuList: [String], idList: [Int]) {
    menuNameList = menuList
    menuIDList = idList
    for _ in 0..<menuNameList.count {
      isMenuSelected.append(false)
    }
  }

  // MARK: - Some Private Methods

  private func makeList(menuList: [String], selectedList: [Bool]) {
    for i in 0..<menuList.count {
      if selectedList[i] {
        self.selectedList.append(menuList[i])
        self.selectedIDList.append(menuIDList[i])
      }
    }
  }
}
// MARK: - UITableView Delegate

extension ChoiceMenuViewController: UITableViewDelegate {
  //
}
// MARK: - UITableView DataSource

extension ChoiceMenuViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return menuNameList.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
      let cell = tableView.dequeueReusableCell(withIdentifier: ChoiceMenuTableViewCell.identifier)
        as? ChoiceMenuTableViewCell
    else { return UITableViewCell() }
    cell.selectionStyle = .none
    cell.dataBind(menu: menuNameList[indexPath.row], isTapped: isMenuSelected[indexPath.row])
    cell.handler = { [weak self] in
      guard let self else { return }
      cell.isChecked.toggle()
      self.isMenuSelected[indexPath.row].toggle()
    }

    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
}
