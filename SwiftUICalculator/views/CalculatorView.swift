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
    @State var isPortrait = true
    @State var isLeftSide = false
    
    let buttonSpacing: CGFloat = 12
    let buttons: [[CalcButton]] = [
        [.ac, .plusMinus, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .minus],
        [.one, .two, .three, .plus],
        [.zero, .dot, .equals]
    ]
    
    var body: some View {
        ZStack (alignment: isLeftSide ? .bottomTrailing : .bottomLeading) {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: buttonSpacing) {
                HStack {
                    if isPortrait {
                        Spacer(minLength: 0)
                    }
                    if isPortrait || !isPortrait && !isLeftSide {
                        display
                    }
                    if !isPortrait {
                        if !isLeftSide {
                            Spacer(minLength: 0)
                        }
                        VStack(spacing: buttonSpacing) {
                            numericPad
                        }
                        if isLeftSide {
                            Spacer(minLength: 0)
                        }
                        if isLeftSide {
                            display
                        }
                    }
                }
                if isPortrait {
                    numericPad
                }
            }
            .padding([.horizontal, .bottom], isPortrait ? 50 : 0)
            
            if !isPortrait {
                swipePadButton
            }
        }
        .transition(.slide)
        .animation(.easeInOut, value: isPortrait)
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            guard let scene = UIWindow.current?.windowScene else { return }
            withAnimation {
                self.isPortrait = scene.interfaceOrientation.isPortrait
            }
        }
    }
    
    @ViewBuilder
    var display: some View {
        Text(environment.display)
            .modifier(TextDisplayModifier())
    }
    
    @ViewBuilder
    var numericPad: some View {
        ForEach(buttons, id: \.self) { row in
            HStack(spacing: buttonSpacing) {
                ForEach(row, id: \.self) { button in
                    CalcButtonView(isPortrait: $isPortrait, button: button)
                }
            }
        }
    }
    
    @ViewBuilder
    var swipePadButton: some View {
        Button {
            withAnimation {
                isLeftSide = !isLeftSide
            }
        } label: {
            Constants.Images.swipePad
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .padding(6)
                .background(Color(.lightGray))
                .foregroundColor(.white)
                .cornerRadius(25)
                .opacity(0.4)
        }
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
                .modifier(
                    ButtonTextModifier(buttonWidth: buttonWidth(button: button),
                                       buttonHeight: buttonHeight(),
                                       backgroundColor: button.backgroundColor,
                                       isSelected: {
                                           environment.operation == button
                                       }))
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
