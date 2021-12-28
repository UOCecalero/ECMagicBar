//
//  UIView+Extension.swift
//  Pods
//
//  Created by Eduard Calero on 28/12/21.
//

import Foundation

public extension UIView {
  func viewFromNIB(bundle: Bundle, nameXib: String) -> UIView? {
   if let view: UIView = bundle.loadNibNamed(nameXib, owner: self, options: nil)?.first as? UIView {
     self.addSubview(view)
     view.frame = self.bounds
     return view
   }
     return nil
 }
}
