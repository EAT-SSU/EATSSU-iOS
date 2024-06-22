//
//  MigratedRequestViewController.swift
//  EAT-SSU
//
//  Created by Jiwoong CHOI on 6/22/24.
//

import Moya
import SnapKit
import Then
import UIKit

final class MigratedRequestViewController: BaseViewController {
  // MARK: - Properties

  private let myProvider = MoyaProvider<MyRouter>(plugins: [MoyaLoggingPlugin()])

  // MARK: - UI Component

  private let requestView = RequestView()

  // MARK: - Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setDelegate()

    dismissKeyboard()
  }

  // MARK: - UI Configuration

  override func configureUI() {
    self.view.addSubview(requestView)
  }

  override func setLayout() {
    requestView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

  override func setButtonEvent() {
    requestView.sendButton.addTarget(self, action: #selector(sendButtonDidTap), for: .touchUpInside)
  }

  private func setDelegate() {
    requestView.contentTextView.delegate = self
  }

  // MARK: - Button Action Methods

  @objc
  private func sendButtonDidTap() {
    if requestView.contentTextView.text == "여기에 내용을 작성해주세요." {
      view.showToast(message: "문의 내용을 작성해주세요!")
    } else if requestView.contentTextView.text?.count ?? 0 < 5 {
      view.showToast(message: "문의 내용을 5글자 이상 작성해주세요!")
    } else if requestView.emailTextField.text == "답변받을 이메일 주소를 남겨주세요."
      || self.isTextFieldEmpty(email: requestView.emailTextField.text ?? "")
    {
      view.showToast(message: "이메일 주소를 남겨주세요!")
    } else {
      postInquiry(
        email: requestView.emailTextField.text ?? "",
        content: requestView.contentTextView.text)
    }
  }

  // MARK: - Some Methods

  private func isTextFieldEmpty(email: String) -> Bool {
    guard let inputValue = requestView.emailTextField.text?.trimmingCharacters(in: .whitespaces)
    else { return true }

    if inputValue.isEmpty {
      return true
    } else {
      return false
    }
  }

  private func showSuccessAlert() {
    let alert = UIAlertController(
      title: "문의 완료",
      message: "문의 내용이 성공적으로 접수되었어요!",
      preferredStyle: UIAlertController.Style.alert)

    let okAction = UIAlertAction(
      title: "마이페이지로 돌아가기",
      style: .default,
      handler: { _ in
        self.navigationController?.popViewController(animated: true)
      })

    alert.addAction(okAction)
    present(alert, animated: true, completion: nil)
  }
}

// MARK: - UITextView Delegate

extension MigratedRequestViewController: UITextViewDelegate {
  func textView(
    _ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String
  ) -> Bool {
    let newLength = requestView.contentTextView.text.count - range.length + text.count
    requestView.maximumTextCountLabel.text = "\(requestView.contentTextView.text.count) / 500"
    if newLength > 500 {
      return false
    }
    return true
  }

  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.text == "여기에 내용을 작성해주세요." {
      textView.text = ""
      textView.textColor = .black
    }
  }

  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      textView.text = "여기에 내용을 작성해주세요."
      textView.textColor = .gray500
    }
  }
}

// MARK: - Server

extension MigratedRequestViewController {
  private func postInquiry(email: String, content: String) {
    let param = InquiryRequest(email, content)
    self.myProvider.request(.inquiry(param: param)) { response in
      switch response {
      case .success(let moyaResponse):
        do {
          let responseData = try moyaResponse.map(BaseResponse<Bool>.self)
          print(responseData)
          self.showSuccessAlert()
        } catch (let err) {
          print(err.localizedDescription)
          self.showSuccessAlert()
        }
      case .failure(let err):
        print(err.localizedDescription)
      }
    }
  }
}
