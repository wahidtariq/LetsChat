//
//  ContentView.swift
//  LetsChat
//
//  Created by wahid tariq on 12/03/22.
//

import SwiftUI

struct LoginPage: View {
    
    @StateObject var loginVM = LoginViewModel()
    
    var body: some View {
        NavigationView{
            ScrollView{
                
                //MARK: - picker and image view textfields create account button
                VStack(spacing: 12){
                    picker
                        .pickerStyle(SegmentedPickerStyle())
                    Spacer()
                    
                    if !loginVM.isLoginPage{
                        imageView
                    }
                    
                    Spacer()
                    textFields
                        .padding(12)
                        .background(.white)
                    Spacer()
                    createAccountButton
//                    error or success message field.
                    Text(loginVM.loginStatusMessage)
                        .foregroundColor(.red)
                }
                .padding()
            }
            
            .navigationTitle(loginVM.isLoginPage ? "Login" : "Create Account" )
            .background(Color.init(white: 0, opacity: 0.05).ignoresSafeArea())
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    
    
    
    var picker : some View {
        Picker("", selection: $loginVM.isLoginPage) {
            Text("Login")
                .tag(true)
            Text("Create Account.")
                .tag(false)
        }
    }
    var imageView : some View{
        Button{
            
            //getImageFromGallery()
            
        }label: {
            Image(systemName: "person.crop.circle.badge.plus")
                .resizable()
                .foregroundColor(.black.opacity(0.8))
                .frame(width: 100, height: 100)
                .padding()
        }
    }
    
    var textFields: some View{
        Group{
            TextField("Email", text: $loginVM.email)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
            SecureField("Password", text: $loginVM.password)
        }
    }
    
    var createAccountButton: some View{
        Button{
            loginVM.handleAction()
        }label: {
            HStack{
                Spacer()
                Text(loginVM.isLoginPage ? "Login" : "Create Account")
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .font(.title3)
                Spacer()
            }
            .background(.blue.opacity(0.9))
            .cornerRadius(6)
        }
    }
    
    
    
    
    
    
    
    
    
}
struct ContentView_Previews1: PreviewProvider {
    static var previews: some View {
        LoginPage()
    }
}
