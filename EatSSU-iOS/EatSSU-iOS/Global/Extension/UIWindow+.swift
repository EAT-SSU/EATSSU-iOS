//
//  UIWindow+.swift
//  EatSSU-iOS
//
//  Created by 최지우 on 2023/10/04.
//

import UIKit

extension UIWindow {
  func replaceRootViewController(
    _ replacementController: UIViewController,
    animated: Bool,
    completion: (() -> Void)?
  ) {

    let snapshotImageView = UIImageView(image: self.snapshot())

    self.addSubview(snapshotImageView)

    // dismiss all modal view controllers
    let dismissCompletion = { () -> Void in
      self.rootViewController = replacementController

      self.bringSubviewToFront(snapshotImageView)
      if animated {
        UIView.animate(
          withDuration: 0.4,
          animations: { () -> Void in
            snapshotImageView.alpha = 0
          },
          completion: { _ in
            snapshotImageView.removeFromSuperview()
            completion?()
          })
      } else {
        snapshotImageView.removeFromSuperview()
        completion?()
      }
    }

    if self.rootViewController!.presentedViewController != nil {
      self.rootViewController!.dismiss(animated: false, completion: dismissCompletion)
    } else {
      dismissCompletion()
    }
  }

  func snapshot() -> UIImage {
    UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
    drawHierarchy(in: bounds, afterScreenUpdates: true)
    guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage.init() }
    UIGraphicsEndImageContext()
    return result
  }
}
