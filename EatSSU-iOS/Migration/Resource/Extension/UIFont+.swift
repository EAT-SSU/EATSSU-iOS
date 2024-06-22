//
//  UIFont+.swift
//  EAT-SSU
//
//  Created by 최지우 on 6/22/24.
//
import UIKit

enum AppFontName: String {
  case regularFont = "AppleSDGothicNeo-Regular"
  case mediumFont = "AppleSDGothicNeo-Medium"
  case semiBoldFont = "AppleSDGothicNeo-SemiBold"
  case boldFont = "AppleSDGothicNeo-Bold"
  case extraBoldFont = "AppleSDGothicNeo-ExtraBold"
}

extension UIFont {

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
