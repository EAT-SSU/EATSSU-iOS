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

  // 디자인 시스템을 반영한 신규 폰트
  class func header1(size: CGFloat) -> UIFont {
    return UIFont(name: AppFontName.boldFont.rawValue, size: size)!
  }

  class func header2(size: CGFloat) -> UIFont {
    return UIFont(name: AppFontName.boldFont.rawValue, size: size)!
  }

  class func subTitle1(size: CGFloat) -> UIFont {
    return UIFont(name: AppFontName.boldFont.rawValue, size: size)!
  }

  class func subTitle2(size: CGFloat) -> UIFont {
    return UIFont(name: AppFontName.semiBoldFont.rawValue, size: size)!
  }

  class func body1(size: CGFloat) -> UIFont {
    return UIFont(name: AppFontName.mediumFont.rawValue, size: size)!
  }

  class func body2(size: CGFloat) -> UIFont {
    return UIFont(name: AppFontName.boldFont.rawValue, size: size)!
  }

  class func body3(size: CGFloat) -> UIFont {
    return UIFont(name: AppFontName.mediumFont.rawValue, size: size)!
  }

  class func caption1(size: CGFloat) -> UIFont {
    return UIFont(name: AppFontName.boldFont.rawValue, size: size)!
  }

  class func caption2(size: CGFloat) -> UIFont {
    return UIFont(name: AppFontName.mediumFont.rawValue, size: size)!
  }

  class func caption3(size: CGFloat) -> UIFont {
    return UIFont(name: AppFontName.mediumFont.rawValue, size: size)!
  }

  class func button1(size: CGFloat) -> UIFont {
    return UIFont(name: AppFontName.boldFont.rawValue, size: size)!
  }

  class func button2(size: CGFloat) -> UIFont {
    return UIFont(name: AppFontName.boldFont.rawValue, size: size)!
  }

  class func stared(size: CGFloat) -> UIFont {
    return UIFont(name: AppFontName.mediumFont.rawValue, size: size)!
  }

}
