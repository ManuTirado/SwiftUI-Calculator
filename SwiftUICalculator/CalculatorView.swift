//
//  ContentView.swift
//  SwiftUICalculator
//
//  Created by manuel.tirado on 2/11/23.
//

import SwiftUI

enum CalcButton {
    
    case zero, one, two, three, four, five, six, seven, eight, nine
    case equals, plus, minus, multiply, divide
    case ac, plusMinus, percent
    case dot
    
    var title: String {
        switch self {
        case .zero: return "0"
        case .one: return "1"
        case .two: return "2"
        case .three: return "3"
        case .four: return "4"
        case .five: return "5"
        case .six: return "6"
        case .seven: return "7"
        case .eight: return "8"
        case .nine: return "9"
        case .equals: return "="
        case .plus: return "+"
        case .minus: return "-"
        case .multiply: return "*"
        case .divide: return "/"
        case .ac: return "AC"
        case .plusMinus: return "+/-"
        case .percent: return "%"
        case .dot: return "."
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .dot :
            return Color(.darkGray)
        case .equals, .plus, .minus, .multiply, .divide:
            return Color(.orange)
        case .ac, .plusMinus, .percent:
            return Color(.lightGray)
        }
    }
}

struct CalculatorView: View {
    
    @EnvironmentObject var environment: GlobalEnviroment
    @State var isPortrait = false
    
    let buttonSpacing: CGFloat = 12
    let buttons: [[CalcButton]] = [
        [.ac, .plusMinus, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .minus],
        [.one, .two, .three, .plus],
        [.zero, .dot, .equals]
    ]
    
    var body: some View {
        ZStack (alignment: .bottom) {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: buttonSpacing) {
                HStack {
                    if isPortrait {
                        Spacer(minLength: 0)
                    }
                    Text(environment.display)
                        .font(.system(size: 54, weight: .bold))
                        .foregroundColor(.white)
                    if !isPortrait {
                        Spacer(minLength: 0)
                        VStack(spacing: buttonSpacing) {
                            ForEach(buttons, id: \.self) { row in
                                HStack(spacing: buttonSpacing) {
                                    ForEach(row, id: \.self) { button in
                                        CalcButtonView(isPortrait: $isPortrait, button: button)
                                    }
                                }
                            }
                        }
                    }
                }
                if isPortrait {
                    ForEach(buttons, id: \.self) { row in
                        HStack(spacing: buttonSpacing) {
                            ForEach(row, id: \.self) { button in
                                CalcButtonView(isPortrait: $isPortrait, button: button)
                            }
                        }
                    }
                }
            }
            .padding([.horizontal, .bottom], isPortrait ? 50 : 0)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            guard let scene = UIWindow.current?.windowScene else { return }
            self.isPortrait = scene.interfaceOrientation.isPortrait
        }
    }
    
    @ViewBuilder
    var content: some View {
        EmptyView()
    }
}

struct CalcButtonView: View {
    
    @EnvironmentObject var environment: GlobalEnviroment
    @Binding var isPortrait: Bool
    
    var button: CalcButton
    
    var body: some View {
        Button(action: {
            environment.receiveInput(button: button)
        }, label: {
            Text(button.title)
                .font(.system(size: 32, weight: .bold))
                .frame(width: buttonWidth(button: button), height: buttonHeight())
                .foregroundColor(.white)
                .background(button.backgroundColor)
                .cornerRadius(buttonWidth(button: button))
                .overlay(
                    Capsule()
                        .stroke(environment.operation == button ? .red : .clear, lineWidth: 5)
                        .frame(width: buttonWidth(button: button), height: buttonHeight())
                )
        })
    }
    
    private func buttonWidth(button: CalcButton) -> CGFloat {
        let base = isPortrait ? (UIScreen.current?.bounds.width ?? 0) : (UIScreen.current?.bounds.height ?? 0)
        switch button {
        case .zero:
            return (base - 4 * 12) / 2
        default:
            return (base - 5 * 12) / 4
        }
    }
    
    private func buttonHeight() -> CGFloat {
        if isPortrait {
            return ((UIScreen.current?.bounds.width ?? 0) - 5 * 12) / 4
        } else {
            return ((UIScreen.current?.bounds.height ?? 0) - 5 * 12) / 6
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView()
            .environmentObject(GlobalEnviroment())
    }
}
