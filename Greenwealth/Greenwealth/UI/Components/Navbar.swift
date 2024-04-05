//
//  Navbar.swift
//  Greenwealth
//
//  Created by user1 on 10/01/24.
//

import SwiftUI

struct Navbar: View {
    
    @Binding var pageState: String
    @Binding var previousPageState: String
    @State var isOrdered: Bool = true
    
    @State private var isLogged: Bool = UserDefaults.standard.bool(forKey: "LoginState")
    @State private var loggedUserID: String = UserDefaults.standard.string(forKey: "LoggedUserID") ?? ""
    @State private var loggedUserName: String = UserDefaults.standard.string(forKey: "LoggedUserName") ?? ""
    @State private var loggedUserEmail: String = UserDefaults.standard.string(forKey: "LoggedUserEmail") ?? ""
    
    var body: some View {
        HStack{
            HStack{
                Image("Logo")
                    .resizable()
                    .frame(width: 22,height: 22)
                Text("Greenwealth")
                    .font(.system(size: 17,weight: .bold))
            }
//            Button(action:{
//                withAnimation{
//                    pageState = "HomePage"
//                    previousPageState = "HomePage"
//                }
//            }){
//                HStack{
//                    Image("Logo")
//                        .resizable()
//                        .frame(width: 22,height: 22)
//                    Text("Greenwealth")
//                        .font(.system(size: 17,weight: .bold))
//                }
//            }
//            Spacer()
//            Button(action:{
//                withAnimation{
//                    if(isLogged){
//                        pageState = "ProfilePage"
//                        previousPageState = "ProfilePage"
//                    }
//                    else{
//                        pageState = "SigninPage"
//                        previousPageState = "ProfilePage"
//                    }
//                }
//            }){
//                Image(systemName: "person")
//                    .resizable()
//                    .frame(width: 18,height: 19)
//            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical,15)
        .padding(.horizontal,30)
        .foregroundColor(.black)
        .background(.white)
        .overlay(
            Rectangle()
                .frame(height: 1, alignment: .bottom)
                .foregroundColor(.black.opacity(0.25)),
            alignment: .bottom
        )
    }
}

struct previewNavbar: View {
    
    @State var pageState: String = "HomePage"
    
    var body: some View {
        Navbar(pageState: $pageState, previousPageState: $pageState)
    }
}

#Preview {
    previewNavbar()
}
