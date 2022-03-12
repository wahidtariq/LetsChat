//
//  ContentView.swift
//  LetsChat
//
//  Created by wahid tariq on 12/03/22.
//

import SwiftUI

struct LoginPage: View {
    @State var isLoginPage = false
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        NavigationView{
            ScrollView{
                //MARK: - picker and image view textfields create account button
                VStack(spacing: 12){
                    picker
                        .pickerStyle(SegmentedPickerStyle())
                    Spacer()
                    
                    if !isLoginPage{
                        imageView
                    }
                    
                    Spacer()
                    textFields
                        .padding(12)
                        .background(.white)
                    Spacer()
                    createAccountButton
                }
                .padding()
            }
            
            .navigationTitle(isLoginPage ? "Login" : "Create Account" )
            .background(Color.init(white: 0, opacity: 0.05).ignoresSafeArea())
        }
    }
    
    
    
    
    var picker : some View {
        Picker("", selection: $isLoginPage) {
            Text("Login")
                .tag(true)
            Text("Create Account.")
                .tag(false)
        }
    }
    var imageView : some View{
        Button{
            
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
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
            SecureField("Password", text: $password)
        }
    }
    
    var createAccountButton: some View{
        Button{
            handleAction()
        }label: {
            HStack{
                Spacer()
                Text(isLoginPage ? "Login" : "Create Account")
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .font(.title3)
                Spacer()
            }
            .background(.blue.opacity(0.9))
            .cornerRadius(6)
        }
    }
    
    
    private func handleAction(){
        if isLoginPage{
            print("login to the firebase with existing credentials")
        }else{
            print("create new account")
        }
    }
}
struct ContentView_Previews1: PreviewProvider {
    static var previews: some View {
        LoginPage()
    }
}
