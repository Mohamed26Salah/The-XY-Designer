//
//  ProfileViewModel.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 23/03/2023.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class ProfileViewModel: AuthService {
    @Published var newPassword: String = ""
    @Published var confirmNewPassword: String = ""
    
    func changePassword(completion: @escaping ()->Void) {
        self.showLoading = true
        if !passwordConfirmation(first: newPassword, secound: confirmNewPassword) {
            return
        }
        guard let user = Auth.auth().currentUser else { return }
        user.updatePassword(to: newPassword) { error in
            guard error == nil else {
                DispatchQueue.main.async {
                    self.errorMessage = error?.localizedDescription ?? "Something went wrong"
                    self.showError.toggle()
                    self.showLoading = false
                }
                return
            }
            self.showLoading = false
            completion()
           
        }
    }
    func logOutUser() {
        do {
            showLoading = true
            try auth.signOut()
          //MARK: Navigate to Home()
        } catch {
            DispatchQueue.main.async {
                self.showLoading = false
                self.errorMessage = "Something went wrong"
                self.showError.toggle()
            }
            return
        }
    }
}
