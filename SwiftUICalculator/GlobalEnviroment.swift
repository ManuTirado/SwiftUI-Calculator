//
//  CalculatorViewModel.swift
//  SwiftUICalculator
//
//  Created by manuel.tirado on 2/11/23.
//

import Foundation

class GlobalEnviroment: ObservableObject {
    
    @Published var display: String = ""
    
    var num1: Double?
    var num2: Double?
    var previousButton: CalcButton?
    @Published var operation: CalcButton?
    
    func receiveInput(button: CalcButton) {
        switch button {
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
            switch previousButton {
            case .plus, .minus, .multiply, .divide, .percent:
                display = button.title
            default:
                display += button.title
            }
        case .dot:
            if !hasDecimalDot(str: display) {
                display += button.title
            }
        case .plus, .minus, .multiply, .divide, .percent:
            Task {
                await blinkDisplay()
                if !display.isEmpty {
                    num1 = Double(display) ?? 0
                    await MainActor.run {
                        operation = button
                    }
                }
            }
        case .plusMinus:
            if !display.isEmpty, let displayNumber = Double(display) {
                display = String(-displayNumber)
            }
        case .equals:
            if (num1 == nil && !display.isEmpty) || (num1 != nil && operation == nil) {
                num1 = Double(display)
            } else if num1 != nil && operation != nil && !display.isEmpty {
                num2 = Double(display)
            }
            let res: Double? = resolveOperation()
            display = res?.clean ?? ""
            operation = nil
            if let res = res {
                num1 = res
            }
            num2 = nil
        case .ac:
            allClear()
        }
        previousButton = button
    }
    
    private func resolveOperation() -> Double? {
        guard let num1 = num1 else { return nil }
        guard let num2 = num2 else { return num1 }
        
        switch operation {
        case .plus:
            return Double(num1) + Double(num2)
        case .minus:
            return Double(num1) - Double(num2)
        case .multiply:
            return Double(num1) * Double(num2)
        case .divide:
            return Double(num1) / Double(num2)
        case .percent:
            return Double(num1).truncatingRemainder(dividingBy: Double(num2))
        default:
            return 0
        }
    }
    
    private func allClear() {
        num1 = nil
        num2 = nil
        operation = nil
        display = ""
    }
    
    private func blinkDisplay() async {
        do {
            let aux = display
            await MainActor.run {
                display = ""
            }
            try await Task.sleep(nanoseconds: 100_000_000)
            await MainActor.run {
                display = aux
            }
        } catch {
            print("Errorcico en el sleep")
        }
    }
    
    private func hasDecimalDot(str: String) -> Bool {
        str.contains(".")
    }
}
