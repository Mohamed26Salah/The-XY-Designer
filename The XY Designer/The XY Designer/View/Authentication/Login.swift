//
//  Login.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 17/03/2023.
//

import SwiftUI
import FirebaseAuth

struct Login: View {
    @StateObject var loginModel: LoginViewModel = .init()
    @State var goToRegister = false
    @Binding var userisNotSignedIn: Bool
    var body: some View {
        NavigationStack{
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 15) {
                        Image(systemName: "triangle")
                            .font(.system(size: 38))
                            .foregroundColor(.indigo)
                        
                        (Text("Welcome,")
                            .foregroundColor(.primary) +
                         Text("\nLogin to continue")
                            .foregroundColor(.gray)
                        )
                        .font(.title)
                        .fontWeight(.semibold)
                        .lineSpacing(10)
                        .padding(.top,20)
                        .padding(.trailing,15)
                        
                        // MARK: Custom TextField
                        CustomTextField(customKeyboardChoice: .email, hint: "salah@gmail.com", text: $loginModel.email)
                            .disabled(loginModel.showVerify)
                            .opacity(loginModel.showVerify ? 0.4 : 1)
                            .padding(.top,50)
                        SecureTextFieldCustom(hint: "**********", text: $loginModel.password)
                            .disabled(loginModel.showVerify)
                            .opacity(loginModel.showVerify ? 0.4 : 1)
                            .padding(.top,30)
                        
                        HStack {
                            Button {
                                if (loginModel.showVerify) {
                                    loginModel.isUserVerified { result in
                                        userisNotSignedIn = false
                                    }
                                } else {
                                    loginModel.SignIn {
                                        userisNotSignedIn = false
                                        
                                    }
                                }
                            } label: {
                                HStack(spacing: 15){
                                    Text(loginModel.showVerify ? "Verify Email" : "Sign In")
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
                            Spacer()
                            NavigationLink(destination: Register(userisNotSignedIn: $userisNotSignedIn)) {
                                HStack(spacing: 15){
                                    Text("Sign Up ?")
                                        .fontWeight(.semibold)
                                        .contentTransition(.identity)
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
                        HStack {
                            Spacer()
                            NavigationLink(destination: ForgetPassword()) {
                                Text("Forgot Password?")
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .padding()
                                    .background(
                                        Color.clear
                                    )
                            }
                            Spacer()
                        }
                        
                    }
                    .padding(.horizontal,30)
                    .padding(.vertical,15)
                    
                }
                .alert(loginModel.errorMessage, isPresented: $loginModel.showError) {
                }
                .onTapGesture {
                    // Resign first responder status to close the keyboard
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                if loginModel.showLoading {
                    ProgressView()
                        .tint(.primary)
                        .foregroundColor(.secondary)
                        .scaleEffect(3)
                    
                }
                
                
            }
            .navigationBarHidden(true)
            .onAppear {
                loginModel.showLoading = false
            }
        }
        
    }
}

