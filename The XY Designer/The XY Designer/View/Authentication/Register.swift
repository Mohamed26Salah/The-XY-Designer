//
//  Register.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 17/03/2023.
//

import SwiftUI

struct Register: View {
    @StateObject var RegisterModel: RegisterViewModel = .init()
    @EnvironmentObject var coordinator: Coordinator
//    @State private var readyToNavigate : Bool = false
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 15) {
                    Image(systemName: "triangle")
                        .font(.system(size: 38))
                        .foregroundColor(.indigo)
                    
                    (Text("Get Started,")
                        .foregroundColor(.primary) +
                     Text("\nRegister to continue")
                        .foregroundColor(.gray)
                    )
                    .font(.title)
                    .fontWeight(.semibold)
                    .lineSpacing(10)
                    .padding(.top,20)
                    .padding(.trailing,15)
                    
                    // MARK: Custom TextField
                    CustomTextField(customKeyboardChoice: .name, hint: "Mohamed Salah", text: $RegisterModel.userName)
                        .disabled(RegisterModel.showVerify)
                        .opacity(RegisterModel.showVerify ? 0.4 : 1)
                        .padding(.top,50)
                    CustomTextField(customKeyboardChoice: .email, hint: "salah@gmail.com", text: $RegisterModel.email)
                        .disabled(RegisterModel.showVerify)
                        .opacity(RegisterModel.showVerify ? 0.4 : 1)
                        .padding(.top,30)
                    SecureTextFieldCustom(hint: "**********", text: $RegisterModel.password)
                        .disabled(RegisterModel.showVerify)
                        .opacity(RegisterModel.showVerify ? 0.4 : 1)
                        .padding(.top,30)
                    SecureTextFieldCustom(hint: "ConfirmPassword", text: $RegisterModel.confirmPassword)
                        .disabled(RegisterModel.showVerify)
                        .opacity(RegisterModel.showVerify ? 0.4 : 1)
                        .padding(.top,30)
                    
                    
                    HStack {
                        Button {
                            if (RegisterModel.showVerify) {
                                RegisterModel.isUserVerified { result in
                                    coordinator.path.append(.mainView)
//                                    readyToNavigate = true
                                }
                            } else {
                                RegisterModel.signUp()
                            }
                        } label: {
                            HStack(spacing: 15){
                                Text(RegisterModel.showVerify ? "Verify Email" : "Sign Up")
                                    .fontWeight(.semibold)
                                    .contentTransition(.identity)
                                
                                Image(systemName: "line.diagonal.arrow")
                                    .font(.title3)
                                    .rotationEffect(.init(degrees: 45))
                            }
                        }
                        .foregroundColor(.primary)
                        .padding(.horizontal,25)
                        .padding(.vertical)
                        .background{
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .foregroundColor(.secondary.opacity(0.3))
                        }
//                        .navigationDestination(isPresented: $readyToNavigate) {
//                            MainView()
//                        }
                        Spacer()
                        Button {
                            coordinator.path.removeLast()
                        } label: {
                            HStack(spacing: 15){
                                Text("Sign In")
                                    .fontWeight(.semibold)
                                    .contentTransition(.identity)
                                
                                Image(systemName: "line.diagonal.arrow")
                                    .font(.title3)
                                    .rotationEffect(.init(degrees: 0))
                            }
                        }
                        .foregroundColor(.primary)
                        .padding(.horizontal,25)
                        .padding(.vertical)
                        .background{
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .foregroundColor(.secondary.opacity(0.3))
                        }
                    }
                    
                }
                .padding(.horizontal,30)
                .padding(.vertical,15)
            }
            .alert(RegisterModel.errorMessage, isPresented: $RegisterModel.showError) {
            }
            if RegisterModel.showLoading {
                ProgressView()
                    .tint(.primary)
                    .foregroundColor(.secondary)
                    .scaleEffect(3)
                
            }
            
        }
        
    }
}



struct Register_Previews: PreviewProvider {
    static var previews: some View {
        Register()
    }
}
