//
//  CustomTextField.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 17/03/2023.
//

import SwiftUI
enum keyboardTypeEnum {
    case email
    case name
    case num
    case scale
}
struct CustomTextField: View {
    var customKeyboardChoice : keyboardTypeEnum
    private var keyboardContentType: UITextContentType {
        switch customKeyboardChoice {
        case .email:
            return .emailAddress
        case .num:
            return .telephoneNumber
        case .name:
            return .username
        case .scale:
            return .telephoneNumber
        }
        
    }
    private var keyboardType: UIKeyboardType {
        switch customKeyboardChoice {
        case .email:
            return .emailAddress
        case .num:
            return .numberPad
        case .scale:
            return .decimalPad
        case .name:
            return .default
        }
    }
    
    var hint: String
    @Binding var text: String
    
    //MARK: ViewProperties
    @FocusState var isEnabled: Bool
//    var contentType: UITextContentType = keyboardType
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            TextField(hint, text: $text)
                .keyboardType(keyboardType)
                .textContentType(keyboardContentType)
                .focused($isEnabled)
                .padding(.horizontal,10)
                .padding(.top,10)
                
            
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.primary.opacity(0.2))
                Rectangle()
                    .fill(.primary)
                    .frame(width: isEnabled ? nil : 0, alignment: .leading)
                    .animation(.easeInOut(duration: 0.3), value: isEnabled)
            }
            .frame(height: 2)
        }
    }
}

//struct CustomTextField_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomTextField()
//    }
//}
