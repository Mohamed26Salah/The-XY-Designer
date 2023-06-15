//
//  Register.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 17/03/2023.
//

import SwiftUI

struct Register: View {
    @StateObject var RegisterModel: RegisterViewModel = .init()
    @Binding var userisNotSignedIn: Bool
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea(.all)
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 15) {
                    Image("XYB-removebg-preview")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 90, height: 70)
                    
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
                        .foregroundColor(.black)
                    CustomTextField(customKeyboardChoice: .email, hint: "salah@gmail.com", text: $RegisterModel.email)
                        .disabled(RegisterModel.showVerify)
                        .opacity(RegisterModel.showVerify ? 0.4 : 1)
                        .padding(.top,30)
                        .foregroundColor(.black)
                    SecureTextFieldCustom(hint: "**********", text: $RegisterModel.password)
                        .disabled(RegisterModel.showVerify)
                        .opacity(RegisterModel.showVerify ? 0.4 : 1)
                        .padding(.top,30)
                        .foregroundColor(.black)
                    SecureTextFieldCustom(hint: "ConfirmPassword", text: $RegisterModel.confirmPassword)
                        .disabled(RegisterModel.showVerify)
                        .opacity(RegisterModel.showVerify ? 0.4 : 1)
                        .padding(.top,30)
                        .foregroundColor(.black)
                    
                    
                    HStack {
                        Button {
                            if (RegisterModel.showVerify) {
                                RegisterModel.isUserVerified { result in
//                                    coordinator.path.append(.mainView)
//                                    readyToNavigate = true
                                    userisNotSignedIn = false
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
                        .background(
                            LinearGradient(
                                gradient: Gradient(
                                    colors: [Color(hex: "#42C2FF"), Color(hex: "#00B4D8")]
                                ),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(15)
                        Spacer()

                    }
                    
                }
                .padding(.horizontal,30)
                .padding(.vertical,15)
            }
            .alert(RegisterModel.errorMessage, isPresented: $RegisterModel.showError) {
            }
            .onTapGesture {
                // Resign first responder status to close the keyboard
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            if RegisterModel.showLoading {
                ProgressView()
                    .tint(.black)
                    .foregroundColor(.secondary)
                    .scaleEffect(3)
                
            }
            
        }
        
    }
}


//
//struct Register_Previews: PreviewProvider {
//    static var previews: some View {
//        Register(userisNotSignedIn: true)
//    }
//}
