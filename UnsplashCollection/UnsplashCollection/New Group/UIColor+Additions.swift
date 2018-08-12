

import UIKit

extension UIColor {

  @nonobjc class var black: UIColor {
    return UIColor(white: 16.0 / 255.0, alpha: 1.0)
  }

  @nonobjc class var niceBlue: UIColor {
    return UIColor(red: 18.0 / 255.0, green: 114.0 / 255.0, blue: 178.0 / 255.0, alpha: 1.0)
  }

  @nonobjc class var leaf: UIColor {
    return UIColor(red: 126.0 / 255.0, green: 179.0 / 255.0, blue: 56.0 / 255.0, alpha: 1.0)
  }

  @nonobjc class var black87: UIColor {
    return UIColor(white: 3.0 / 255.0, alpha: 0.87)
  }

  @nonobjc class var white: UIColor {
    return UIColor(white: 1.0, alpha: 1.0)
  }

  @nonobjc class var tomato: UIColor {
    return UIColor(red: 238.0 / 255.0, green: 49.0 / 255.0, blue: 36.0 / 255.0, alpha: 1.0)
  }

  @nonobjc class var tomatoTwo: UIColor {
    return UIColor(red: 237.0 / 255.0, green: 90.0 / 255.0, blue: 26.0 / 255.0, alpha: 1.0)
  }

  @nonobjc class var grass: UIColor {
    return UIColor(red: 109.0 / 255.0, green: 168.0 / 255.0, blue: 43.0 / 255.0, alpha: 1.0)
  }

}

extension UIColor {
    
    static func colorWithHexString(hex: String) -> UIColor {
        guard hex.hasPrefix("#") else {
            return UIColor.black
        }
        
        let index = hex.index(hex.startIndex, offsetBy: Int(1))
        guard let hexString: String = String(hex.prefix(upTo: index)),
            var   hexValue:  UInt32 = 0, Scanner(string: hexString).scanHexInt32(&hexValue) else {
                return UIColor.black
        }
        
        guard hexString.characters.count  == 6 else {
            return UIColor.black
        }
        
        let divisor = CGFloat(255)
        let red     = CGFloat((hexValue & 0xFF0000) >> 16) / divisor
        let green   = CGFloat((hexValue & 0x00FF00) >>  8) / divisor
        let blue    = CGFloat( hexValue & 0x0000FF       ) / divisor
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}
