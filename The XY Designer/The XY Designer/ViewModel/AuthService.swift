//
//  AuthService.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 23/03/2023.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
class AuthService: ObservableObject {
    let auth = Auth.auth()
    let dp = Firestore.firestore()
//    static var isUserSignerIn = false
    var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    @Published var goToHomeAuth = false
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    @Published var showLoading: Bool = false
    @Published var showVerify: Bool = false

    
    func passwordConfirmation(first firstPassword: String, secound secoundPassword: String) -> Bool{
        if firstPassword != secoundPassword {
            DispatchQueue.main.async {
                self.errorMessage = "Password does not match"
                self.showError.toggle()
                self.showLoading = false
            }
            return false
        }
        return true
    }
    
    func checkIfEmailIsVerified()->Bool{
        guard let user = Auth.auth().currentUser else {
            print("Error: User is not signed in")
            return false
        }
        let isEmailVerified = user.isEmailVerified
        if (!isEmailVerified) {
            return false
        }else {
            return true
        }
    }
    func isUserVerified(){
        if (!checkIfEmailIsVerified()) {
            DispatchQueue.main.async {
                //till here
                self.errorMessage = "Email is Not Verified Yet, check your email please"
                self.showError.toggle()
            }
        } else {
            //MARK: Send to Home
            print("User is Verified")
        }
    }

    func sendVerificationEmail() {
        guard let user = Auth.auth().currentUser else {
            print("Error: User is not signed in")
            return
        }
        // Send the verification email
        user.sendEmailVerification(completion: { (error) in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.showError.toggle()
                }
            } else {
                print("Verification email sent successfully")
            }
        })
    }
}
//MARK: Extensions
extension UIApplication {
    func closeKeyboard(){
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
