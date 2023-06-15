//
//  SecureTextField.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 17/03/2023.
//

import SwiftUI

struct SecureTextFieldCustom: View {
    var hint: String
    @Binding var text: String
    
    //MARK: ViewProperties
    @FocusState var isEnabled: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            SecureField("", text: $text)
                .placeholder(when: text.isEmpty) {
                    Text(hint).foregroundColor(.gray)
                }
                .keyboardType(.default)
                .textContentType(.password)
                .focused($isEnabled)
            
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

