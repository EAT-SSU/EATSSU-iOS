//
//  PostUIButton.swift
//  EatSSU-iOS
//
//  Created by 최지우 on 2023/07/04.
//

import SnapKit
import UIKit

class PostUIButton: UIButton {

  override var isEnabled: Bool {
    didSet {
      isEnabled ? setEnableButton() : setDisableButton()
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupButton()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setEnableButton() {
    isUserInteractionEnabled = true
    backgroundColor = .primary
  }

  private func setDisableButton() {
    isUserInteractionEnabled = false
    backgroundColor = .gray300
  }

  func setupButton() {
    self.backgroundColor = .gray300
    self.setTitleColor(.white, for: .normal)
    self.titleLabel?.font = .semiBold(size: 18)
    self.layer.cornerRadius = 10
    // contentEdgeInsets method is deprected. 최초작성자가 확인 후 공유.
    self.contentEdgeInsets = UIEdgeInsets(top: 9, left: 0, bottom: 9, right: 0)
    self.contentHorizontalAlignment = .center
    self.isEnabled = false
  }
}
