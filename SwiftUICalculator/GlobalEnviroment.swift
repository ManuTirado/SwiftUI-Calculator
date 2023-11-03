//
//  CalculatorViewModel.swift
//  SwiftUICalculator
//
//  Created by manuel.tirado on 2/11/23.
//

import Foundation

class GlobalEnviroment: ObservableObject {
    
    @Published var display: String = ""
    @Published var operation: CalcButton?
    
    private let undefinedTitle: String = "undefined"
    private var num1: NSDecimalNumber?
    private var num2: NSDecimalNumber?
    private var previousButton: CalcButton?
    
    func receiveInput(button: CalcButton) {
        if display == undefinedTitle {
            display = ""
        }
        switch button {
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
            switch previousButton {
            case .plus, .minus, .multiply, .divide, .percent:
                display = button.title
            default:
                display += button.title
            }
        case .dot:
            if !display.hasDecimalDot() {
                display += button.title
            }
        case .plus, .minus, .multiply, .divide, .percent:
            Task {
                await blinkDisplay()
                if !display.isEmpty {
                    num1 = NSDecimalNumber(string: display)
                    await MainActor.run {
                        operation = button
                    }
                }
            }
        case .plusMinus:
            if !display.isEmpty {
                display = NSDecimalNumber(string: display).multiplying(by: -1).stringValue
            }
        case .equals:
            if (num1 == nil && !display.isEmpty) || (num1 != nil && operation == nil) {
                num1 = NSDecimalNumber(string: display)
            } else if num1 != nil && operation != nil && !display.isEmpty {
                num2 = NSDecimalNumber(string: display)
            }
            let res: NSDecimalNumber? = resolveOperation()
            display = res?.stringValue ?? undefinedTitle
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
    
    private func resolveOperation() -> NSDecimalNumber? {
        guard let num1 = num1 else { return nil }
        guard let num2 = num2 else { return num1 }
        
        switch operation {
        case .plus:
            return num1.adding(num2)
        case .minus:
            return num1.subtracting(num2)
        case .multiply:
            return num1.multiplying(by: num2)
        case .divide:
            if num2 != 0 {
                return num1.dividing(by: num2)
            } else {
                return nil
            }
        case .percent:
            let quotient = num1.dividing(by: num2, withBehavior: NSDecimalNumberHandler(roundingMode: .down, scale: 0, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false))
            let subtractAmount = quotient.multiplying(by: num2)
            let remainder = num1.subtracting(subtractAmount)
            return remainder
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
            print("Error: \(error.localizedDescription)")
        }
    }
}
