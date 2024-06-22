//
//  UIFont+.swift
//  EatSSU-iOS
//
//  Created by 박윤빈 on 2023/03/15.
//

import UIKit

extension UIFont {
  // 임의로 지정한 기존 폰트
  class func regular(size: CGFloat) -> UIFont {
    return UIFont(name: AppFontName.regularFont.rawValue, size: size)!
  }

  class func medium(size: CGFloat) -> UIFont {
    return UIFont(name: AppFontName.mediumFont.rawValue, size: size)!
  }

  class func semiBold(size: CGFloat) -> UIFont {
    return UIFont(name: AppFontName.semiBoldFont.rawValue, size: size)!
  }

  class func bold(size: CGFloat) -> UIFont {
    return UIFont(name: AppFontName.boldFont.rawValue, size: size)!
  }

  class func extraBold(size: CGFloat) -> UIFont {
    return UIFont(name: AppFontName.extraBoldFont.rawValue, size: size)!
  }

}
