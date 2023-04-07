//
//  Profile.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 23/03/2023.
//

import SwiftUI

struct Profile: View {
    @StateObject var ProfileModel: ProfileViewModel = .init()
    @EnvironmentObject var coordinator: Coordinator
//    @State var logOut: Bool = false
    var body: some View {
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("My Profile")
                            .foregroundColor(.primary)
                            .font(.title)
                            .fontWeight(.semibold)
                            .lineSpacing(10)
                            .padding(.top,30)
                            .padding(.trailing,15)
                        
                        // MARK: Custom TextField
                        SecureTextFieldCustom(hint: "New Password", text: $ProfileModel.newPassword)
                            .opacity(1)
                            .padding(.top,30)
                        SecureTextFieldCustom(hint: "Confirm Password", text: $ProfileModel.confirmNewPassword)
                            .opacity(1)
                            .padding(.top,30)
                        
                        //MARK: Stopped Here
                        HStack {
                            //                        Spacer()
                            Button(action: ProfileModel.changePassword) {
                                HStack(spacing: 15){
                                    Text("Change Password")
                                        .fontWeight(.semibold)
                                        .contentTransition(.identity)
                                    
                                    Image(systemName: "pencil")
                                        .font(.title3)
                                    //                                .rotationEffect(.init(degrees: 45))
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
                            Button("LogOut") {
                                ProfileModel.logOutUser()
//                                logOut = true
                                coordinator.path = [.login]
//                                coordinator.reset()
                            }
                            
                        }
                        
                    }
                    .padding(.horizontal,30)
                    .padding(.vertical,15)
                }
                .alert(ProfileModel.errorMessage, isPresented: $ProfileModel.showError) {
                }
                if ProfileModel.showLoading {
                    ProgressView()
                        .tint(.primary)
                        .foregroundColor(.secondary)
                        .scaleEffect(3)
                }
            }
//            .fullScreenCover(isPresented: $logOut) {
//                Login()
//            }
            .toolbar {
                Button("Log Out") {ProfileModel.logOutUser()}
                    .bold()
                    .scaleEffect(1.3)
                    .padding()
                    .tint(Color(.label))
                
            }
        }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}
