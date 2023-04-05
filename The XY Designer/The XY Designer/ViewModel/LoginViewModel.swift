//
//  LoginViewModel.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 17/03/2023.
//

import SwiftUI
import FirebaseAuth

class LoginViewModel: AuthService {
    @Published var email: String = ""
    @Published var password: String = ""
   func SignIn(completion: @escaping ()->Void) {
//    func SignIn() {
        self.showLoading = true
        UIApplication.shared.closeKeyboard()
        auth.signIn(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                DispatchQueue.main.async {
                    self.errorMessage = error?.localizedDescription ?? "Something went wrong"
                    self.showError.toggle()
                    self.showLoading = false
                }
                return
            }
            if (self.checkIfEmailIsVerified()) {
                completion()
            }
            else {
                self.showVerify = true
                self.sendVerificationEmail()
                self.errorMessage = "A veification email has been sent to your email!"
                self.showError.toggle()
                self.showLoading = false
            }
            
        }
    }
}




