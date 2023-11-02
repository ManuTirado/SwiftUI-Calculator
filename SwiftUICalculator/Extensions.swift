//
//  Extensions.swift
//  SwiftUICalculator
//
//  Created by manuel.tirado on 2/11/23.
//

import Foundation
import SwiftUI

// MARK: - extension Double

extension Double {
    
    var clean: String {
        // TODO: -En números grandes se inventa la mitad
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

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
