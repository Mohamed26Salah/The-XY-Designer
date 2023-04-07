//
//  ForgetPasswordViewModel.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 23/03/2023.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore


class ForgetPasswordViewModel: AuthService {
    @Published var email: String = ""
    
    func resetPassword(){
        showLoading = true
        auth.sendPasswordReset(withEmail: email) { error in
            guard error == nil else {
                DispatchQueue.main.async {
                    self.showLoading = false
                    self.errorMessage = error?.localizedDescription ?? "Something went wrong"
                    self.showError.toggle()
                }
                return
            }
            self.showLoading = false
            self.errorMessage = "An Email has been sent, to recover your password"
            self.showError.toggle()
        }
//        if (email != "") {
//            errorMessage = "An Email has been sent, to recover your password"
//            showError.toggle()
//        } else {
//            errorMessage = "Please enter an email to reset"
//            showError.toggle()
//        }
    }
   
}
