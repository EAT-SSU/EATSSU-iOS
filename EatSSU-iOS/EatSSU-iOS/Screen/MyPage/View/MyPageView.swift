//
//  MyPageView.swift
//  EatSSU-iOS
//
//  Created by 최지우 on 2023/07/25.
//

import SnapKit
import Then
import UIKit

final class MyPageView: BaseUIView {

  // MARK: - Properties

  let myPageServiceLabelList = MyPageLocalData.myPageServiceLabelList
  let myPageRightItemListDate = MyPageRightItemData.myPageRightItemList
  private var dataModel: MyInfoResponse? {
    didSet {
      if let nickname = dataModel?.nickname {
        userNicknameButton.addTitleAttribute(
          title: "\(nickname)  >",
          titleColor: .black,
          fontName: .semiBold(size: 20)
        )
      }

      switch dataModel?.provider {
      case "KAKAO":
        accountLabel.text = "카카오"
        accountImage.image = ImageLiteral.Icon.signInWithKakao
      case "APPLE":
        accountLabel.text = "APPLE"
        accountImage.image = ImageLiteral.Icon.signInWithApple
      default:
        return
      }
    }
  }

  // MARK: - UI Components

  var userImage = UIImageView().then {
    $0.image = ImageLiteral.Icon.profileIcon
  }
  var userNicknameButton = UIButton().then {
    $0.addTitleAttribute(title: "다시 시도해주세요", titleColor: .black, fontName: .bold(size: 16))

  }

  let accountTitleLabel = UILabel().then {
    $0.text = TextLiteral.MyPage.linkedAccount
    $0.font = .regular(size: 14)
  }

  var accountLabel = UILabel().then {
    $0.text = "없음"
    $0.font = .bold(size: 14)
  }

  var accountImage = UIImageView()

  lazy var totalAccountStackView = UIStackView(arrangedSubviews: [
    accountTitleLabel,
    accountStackView,
  ]).then {
    $0.alignment = .bottom
    $0.axis = .horizontal
    $0.spacing = 20
  }

  lazy var accountStackView = UIStackView(arrangedSubviews: [
    accountLabel,
    accountImage,
  ]).then {
    $0.alignment = .bottom
    $0.axis = .horizontal
    $0.spacing = 5
  }

  let myPageTableView = UITableView().then {
    $0.separatorStyle = .none
    $0.rowHeight = 55
  }

  // MARK: - init

  override init(frame: CGRect) {
    super.init(frame: frame)

    register()
  }

  // MARK: - Functions

  override func configureUI() {
    self.addSubviews(
      userImage,
      userNicknameButton,
      totalAccountStackView,
      myPageTableView)
  }
  override func setLayout() {
    userImage.snp.makeConstraints {
      $0.top.equalToSuperview().offset(127)
      $0.centerX.equalToSuperview()
      $0.height.width.equalTo(100)
    }
    userNicknameButton.snp.makeConstraints {
      $0.top.equalTo(userImage.snp.bottom).offset(6)
      $0.centerX.equalTo(userImage)
      $0.height.equalTo(40)
    }

    totalAccountStackView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(userNicknameButton.snp.bottom).offset(10)
    }
    myPageTableView.snp.makeConstraints {
      $0.top.equalTo(accountTitleLabel.snp.bottom).offset(24)
      $0.horizontalEdges.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
  }

  func register() {
    myPageTableView.register(
      MyPageServiceCell.self, forCellReuseIdentifier: MyPageServiceCell.identifier)
  }

  func dataBind(model: MyInfoResponse) {
    dataModel = model
  }
}
