//
//  ForgetPassword.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 23/03/2023.
//

import SwiftUI

struct ForgetPassword: View {
    @StateObject var forgetModel: ForgetPasswordViewModel = .init()
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center, spacing: 15) {
                    Image(systemName: "triangle")
                        .font(.system(size: 38))
                        .foregroundColor(.indigo)
                    
                    (Text("Forgot Password")
                        .foregroundColor(.primary) +
                     Text("\nReset your password")
                        .foregroundColor(.gray)
                        .font(.title3)
                    )
                    .font(.title)
                    .fontWeight(.semibold)
                    .lineSpacing(15)
                    .padding(.top,20)
                    .multilineTextAlignment(.center)
//                    .padding(.trailing,15)
                    
                    // MARK: Custom TextField
                    CustomTextField(customKeyboardChoice: .email, hint: "salah@gmail.com", text: $forgetModel.email)
//                        .disabled(loginModel.showVerify)
                        .opacity(1)
                        .padding(.top,50)
                        .padding(.bottom,30)
                    
                    //MARK: Stopped Here
                    HStack {
                        Spacer()
                        Button(action: forgetModel.resetPassword) {
                            HStack(spacing: 15){
                                Text("Recover password")
                                    .fontWeight(.semibold)
                                    .contentTransition(.identity)
                                
                                Image(systemName: "arrow.clockwise")
                                    .font(.title3)
                                    .rotationEffect(.init(degrees: 45))
                            }
                            .foregroundColor(.primary)
                            .padding(.horizontal,25)
                            .padding(.vertical)
                            .background{
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .foregroundColor(.secondary.opacity(0.3))
                            }
                        }
                        Spacer()
                    }
                    
                }
                .padding(.horizontal,30)
                .padding(.vertical,15)
            }
            .alert(forgetModel.errorMessage, isPresented: $forgetModel.showError) {
            }
            .onTapGesture {
                // Resign first responder status to close the keyboard
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            if forgetModel.showLoading {
                ProgressView()
                    .tint(.primary)
                    .foregroundColor(.secondary)
                    .scaleEffect(3)
                
            }
        }
    }
}

struct ForgetPassword_Previews: PreviewProvider {
    static var previews: some View {
        ForgetPassword()
    }
}
