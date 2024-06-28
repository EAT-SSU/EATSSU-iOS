//
//  MigratedSetNickNameView.swift
//  EAT-SSU
//
//  Created by Jiwoong CHOI on 6/22/24.
//

import SnapKit
import Then
import UIKit

final class MigratedSetNickNameView: BaseUIView {

  // MARK: - Properties

  private var userNickname: String = ""

  // MARK: - UI Components

  private let nickNameLabel = UILabel().then {
    $0.text = TextLiteral.Auth.inputNickNameLabel
    $0.font = .bold(size: 16)
  }

  let inputNickNameTextField = UITextField().then {
    $0.placeholder = TextLiteral.Auth.inputNickName
    $0.font = .regular(size: 12)
    $0.textColor = .black
    $0.setRoundBorder()
    $0.addLeftPadding()
    $0.clearButtonMode = .whileEditing
  }

  var nicknameDoubleCheckButton = PostUIButton().then {
    $0.setRoundBorder(borderColor: .gray300, borderWidth: 0, cornerRadius: 10)
    $0.addTitleAttribute(title: "중복 확인", titleColor: .white, fontName: .bold(size: 14))
    $0.isEnabled = false
  }

  var nicknameValidationMessageLabel = UILabel().then {
    $0.text = TextLiteral.Auth.hintInputNickName
    $0.textColor = .gray700
    $0.font = .semiBold(size: 12)
  }

  private lazy var setNickNameStackView: UIStackView = UIStackView(arrangedSubviews: [
    inputNickNameTextField,
    nicknameValidationMessageLabel,
  ]).then {
    $0.axis = .vertical
    $0.spacing = 8.0
  }

  var completeSettingNickNameButton = PostUIButton().then {
    $0.addTitleAttribute(
      title: TextLiteral.Auth.completeLabel, titleColor: .white, fontName: .semiBold(size: 18))
    $0.setRoundBorder(borderColor: .gray300, borderWidth: 0, cornerRadius: 10)
    $0.isEnabled = false
  }

  // MARK: - init

  override init(frame: CGRect) {
    super.init(frame: frame)
    setTextFieldDelegate()
  }

  // MARK: Functions

  override func configureUI() {
    self.addSubviews(
      nickNameLabel,
      setNickNameStackView,
      completeSettingNickNameButton,
      nicknameDoubleCheckButton)
  }

  override func setLayout() {
    nickNameLabel.snp.makeConstraints {
      $0.top.equalTo(safeAreaLayoutGuide).offset(20)
      $0.leading.equalToSuperview().inset(16)
    }
    setNickNameStackView.snp.makeConstraints {
      $0.top.equalTo(nickNameLabel.snp.bottom).offset(16)
      $0.leading.equalToSuperview().inset(16)
      $0.trailing.equalTo(nicknameDoubleCheckButton.snp.leading).offset(-5)
    }
    nicknameDoubleCheckButton.snp.makeConstraints {
      $0.top.equalTo(inputNickNameTextField)
      $0.width.equalTo(75)
      $0.height.equalTo(48)
      $0.trailing.equalToSuperview().inset(16)
    }
    inputNickNameTextField.snp.makeConstraints {
      $0.height.equalTo(48)
    }
    completeSettingNickNameButton.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview().inset(16)
      $0.bottom.equalToSuperview().inset(24)
      $0.height.equalTo(50)
    }
  }

  func setTextFieldDelegate() {
    inputNickNameTextField.delegate = self
  }

}

// MARK: - UITextFieldDelegate

extension MigratedSetNickNameView: UITextFieldDelegate {

  /// return 클릭 시, 키보드 내려감
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }

  /// textField 유효성 검사
  func textFieldDidChangeSelection(_ textField: UITextField) {

    guard let inputValue = textField.text?.trimmingCharacters(in: .whitespaces) else { return }

    if inputValue.isEmpty {
      self.textFieldSettingWhenEmpty(textField)
      return
    }
    self.checkNicknameValidation(textField)
  }

  /// clearButton delegate
  func textFieldShouldClear(_ textField: UITextField) -> Bool {
    nicknameDoubleCheckButton.isEnabled = false
    completeSettingNickNameButton.isEnabled = false
    return true
  }

}

// MARK: - Validation User Information

extension MigratedSetNickNameView {

  /// 입력 없는 경우
  fileprivate func textFieldSettingWhenEmpty(_ textField: UITextField) {

    nicknameValidationMessageLabel.text = NicknameTextFieldResultType.textFieldEmpty.hintMessage
    nicknameValidationMessageLabel.textColor = NicknameTextFieldResultType.textFieldEmpty.textColor
  }

  /// 닉네임 형식 검사
  fileprivate func checkNicknameValidation(_ textField: UITextField) {

    if let userNickname = textField.text {
      if nicknameInputChanged(nickname: userNickname) {
        nicknameValidationMessageLabel.text =
          NicknameTextFieldResultType.nicknameTextFieldDoubleCheck.hintMessage
        nicknameValidationMessageLabel.textColor =
          NicknameTextFieldResultType.nicknameTextFieldDoubleCheck.textColor
      } else {
        nicknameValidationMessageLabel.text =
          NicknameTextFieldResultType.nicknameTextFieldOver.hintMessage
        nicknameValidationMessageLabel.textColor =
          NicknameTextFieldResultType.nicknameTextFieldOver.textColor
      }
    }
  }

  /// Input 변경 시
  fileprivate func nicknameInputChanged(nickname: String) -> Bool {

    /// 텍스트 변경 시, 완료하기 버튼 false 처리
    completeSettingNickNameButton.isEnabled = false

    if nickname.count > 1 && nickname.count < 9 {
      nicknameDoubleCheckButton.isEnabled = true
      return true
    } else {
      nicknameDoubleCheckButton.isEnabled = false
      return false
    }
  }

}
