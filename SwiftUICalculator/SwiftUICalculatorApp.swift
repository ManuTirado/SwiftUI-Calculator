//
//  SwiftUICalculatorApp.swift
//  SwiftUICalculator
//
//  Created by manuel.tirado on 2/11/23.
//

import SwiftUI

@main
struct SwiftUICalculatorApp: App {
    var body: some Scene {
        WindowGroup {
            CalculatorView()
                .environmentObject(GlobalEnviroment())
        }
    }
}
