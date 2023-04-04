//
//  RegisterViewModel.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 18/03/2023.
//


import SwiftUI
import FirebaseAuth
import FirebaseFirestore


class RegisterViewModel: AuthService {
    @Published var userName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""

    func addUserToDataBase(_ resultUser: User) {
        dp.collection("users")
            .document(resultUser.uid)
            .setData([
                "username": self.userName,
                "email": self.email,
                "rank": "user"
            ]) { error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.errorMessage = error.localizedDescription
                        self.showError.toggle()
                        self.showLoading = false
                    }
                    return
                }
            }
       
    }
    func signUp() {
        showLoading = true
        UIApplication.shared.closeKeyboard()
        if !Validator.isValidUsername(for: userName) {
            DispatchQueue.main.async {
                self.errorMessage = "Name is invalid"
                self.showError.toggle()
                self.showLoading = false
            }
            return
        }
        if !passwordConfirmation(first: password, secound: confirmPassword) {
            return
        }
        auth.createUser(withEmail: email, password: password) { result, error in
            guard let resultUser = result?.user, error == nil else {
                DispatchQueue.main.async {
                    self.errorMessage = error?.localizedDescription ?? "Something went wrong"
                    self.showError.toggle()
                    self.showLoading = false
                }
                return
            }
            self.addUserToDataBase(resultUser)
            self.showVerify = true
            self.auth.signIn(withEmail: self.email, password: self.password)
            self.sendVerificationEmail()
            DispatchQueue.main.async {
                self.errorMessage = "A veification email has been sent to your email!"
                self.showError.toggle()
                self.showLoading = false
            }
        }
    }
    
    
}
