//
//  Profile.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 23/03/2023.
//

import SwiftUI

struct Profile: View {
    @StateObject var ProfileModel: ProfileViewModel = .init()
    @Binding var isSignedIn: Bool
    @Binding var selectedTab: Int
    var body: some View {
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("My Profile")
                            .foregroundColor(.black)
                            .font(.title)
                            .fontWeight(.semibold)
                            .lineSpacing(10)
                            .padding(.top,30)
                            .padding(.trailing,15)
                        
                        // MARK: Custom TextField
                        SecureTextFieldCustom(hint: "New Password", text: $ProfileModel.newPassword)
                            .opacity(1)
                            .padding(.top,30)
                            .foregroundColor(.black)
                        SecureTextFieldCustom(hint: "Confirm Password", text: $ProfileModel.confirmNewPassword)
                            .opacity(1)
                            .padding(.top,30)
                            .foregroundColor(.black)
                        
                        //MARK: Stopped Here
                        HStack {
                            Button {
                                ProfileModel.changePassword {
                                    isSignedIn.toggle()
                                }
                            } label: {
                                HStack(spacing: 15){
                                    Text("Change Password")
                                        .fontWeight(.semibold)
                                        .contentTransition(.identity)
                                    
                                    Image(systemName: "pencil")
                                        .font(.title3)
                                }
                                .foregroundColor(.white)
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
                            }
                            Spacer()
                            
                        }
                        
                    }
                    .padding(.horizontal,30)
                    .padding(.vertical,15)
                }
                .alert(ProfileModel.errorMessage, isPresented: $ProfileModel.showError) {
                }
                .onTapGesture {
                    // Resign first responder status to close the keyboard
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                if ProfileModel.showLoading {
                    ProgressView()
                        .tint(.black)
                        .foregroundColor(.secondary)
                        .scaleEffect(3)
                }
            }
            .toolbar {
//                Button("Log Out") {ProfileModel.logOutUser()}
//                    .bold()
//                    .scaleEffect(1.3)
//                    .padding()
//                    .tint(Color(.label))
                Button {
                    selectedTab = 0
                    ProfileModel.logOutUser()
                } label: {
                    Text("Log Out")
                        .bold()
                        .scaleEffect(1.3)
                        .padding()
                        .tint(Color(.label))
                }

                
            }
        }
}

//struct Profile_Previews: PreviewProvider {
//    static var previews: some View {
//        Profile()
//    }
//}
