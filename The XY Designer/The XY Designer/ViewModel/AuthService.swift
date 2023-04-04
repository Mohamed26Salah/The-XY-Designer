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
        if (isEmailVerified) {
            return true
        }else {
            return false
        }
    }
    func isUserVerified(completion: @escaping (Result<Bool, Error>)->Void) {
        
        Auth.auth().currentUser?.reload(completion: { (error) in
            
            if let error = error {
                print(error)
            } else {
                if Auth.auth().currentUser != nil && Auth.auth().currentUser!.isEmailVerified {
                    completion(.success(true))
                } else {
                    DispatchQueue.main.async {
                        self.errorMessage = "Email is Not Verified Yet, check your email please"
                        self.showError.toggle()
                    }
                }
            }
        })
    }
//    func isUserVerified(completion: @escaping (Result<Bool, Error>)->Void){
//        if (checkIfEmailIsVerified()) {
//            completion(.success(true))
//        } else {
//            DispatchQueue.main.async {
//                self.errorMessage = "Email is Not Verified Yet, check your email please"
//                self.showError.toggle()
//            }
//        }
//    }

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
