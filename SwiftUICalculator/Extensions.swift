//
//  Extensions.swift
//  SwiftUICalculator
//
//  Created by manuel.tirado on 2/11/23.
//

import Foundation
import SwiftUI

extension UIWindow {
    
    static var current: UIWindow? {
        UIApplication
            .shared
            .connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .last
    }
}


extension UIScreen {
    
    static var current: UIScreen? {
        UIWindow.current?.screen
    }
}


extension String {
    
    func hasDecimalDot() -> Bool {
        self.contains(".")
    }
}
