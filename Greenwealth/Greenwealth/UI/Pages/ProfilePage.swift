//
//  ProfilePage.swift
//  Greenwealth
//
//  Created by user1 on 10/01/24.
//

import SwiftUI

struct ProfilePage: View {
    
    @Binding var pageState: String
    @Binding var previousPageState: String
    @ObservedObject var userModel: usersModel
    @ObservedObject var pickupModel: pickupsModel
    
    @State private var toggleDemo: Bool = true
    @State private var isPageLoading: Bool = false
    @State private var userImage: String = ""
    
    @State private var isLogged: Bool = UserDefaults.standard.bool(forKey: "LoginState")
    @State private var loggedUserID: String = UserDefaults.standard.string(forKey: "LoggedUserID") ?? ""
    @State private var loggedUserName: String = UserDefaults.standard.string(forKey: "LoggedUserName") ?? "Preview"
    @State private var loggedUserEmail: String = UserDefaults.standard.string(forKey: "LoggedUserEmail") ?? ""
    
    func getUser() async{

        if(isLogged){
            try? await userModel.getUser(emailAddress: loggedUserEmail)
            isPageLoading.toggle()
            userImage = userModel.users.first!.profileImage
        }
        else{
            isPageLoading.toggle()
        }
    }
    
    func logoutFunction(){
        
        UserDefaults.standard.set(false,forKey: "LoginState")
        UserDefaults.standard.set("",forKey: "LoggedUserID")
        UserDefaults.standard.set("",forKey: "LoggedUserName")
        UserDefaults.standard.set("",forKey: "LoggedUserEmail")
        pickupModel.hasActivePickups = false
        
        pageState = "DashboardPage"
    }
    
    var body: some View {
        ZStack{
            if(isPageLoading){
                LoadingPage()
            }
            else{
                VStack{
                    VStack{
                        if(isLogged){
                            AsyncImage(url: URL(string: userModel.users.first!.profileImage)) { image in
                                image.resizable()
                                    .clipShape(Circle())
                            } placeholder: {
                            ProgressView()
                        }
                                .frame(width: 150,height: 150)
                            Text("\(loggedUserName)")
                                .font(.system(size: 17,weight: .bold))
                        }
                        else{
                            Image("Profile")
                                .resizable()
                                .frame(width: 150,height: 150)
                            Text("PreviewUser")
                                .font(.system(size: 17,weight: .bold))
                        }
//                        Text("1,000 Points")
//                            .font(.system(size: 17,weight: .medium))
                    }
                    .padding(.horizontal,20)
                    .foregroundColor(.black)
                    
                    ScrollView{
                        VStack(spacing:20){
                            Button(action:{}){
                                HStack(spacing:10){
                                    Image(systemName: "person")
                                        .symbolRenderingMode(.hierarchical)
                                        .font(.system(size: 17,weight: .semibold))
                                        .foregroundColor(Color.primaryGreen)
                                    Text("Account Settings")
                                        .font(.system(size: 17,weight: .medium))
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .symbolRenderingMode(.hierarchical)
                                        .font(.system(size: 17,weight: .bold))
                                        .foregroundColor(.black.opacity(0.3))
                                }
                            }
                            Divider()
                            Button(action:{}){
                                HStack(spacing:10){
                                    Image(systemName: "character.bubble")
                                        .symbolRenderingMode(.hierarchical)
                                        .font(.system(size: 17,weight: .black))
                                        .foregroundColor(Color.primaryGreen)
                                    Text("Account Settings")
                                        .font(.system(size: 17,weight: .medium))
                                    Spacer()
                                    Text("English")
                                        .font(.system(size: 17,weight: .medium))
                                        .foregroundColor(.black.opacity(0.3))
                                }
                            }
                        }
                        .padding(.horizontal,20)
                        .padding(.vertical,30)
                        .foregroundColor(.black)
                        .background(.white)
                        .cornerRadius(10)
                        .padding(.horizontal,20)

//                        VStack(spacing:20){
//                            Button(action:{
//                                withAnimation{
//                                    pageState = "HistoryPage"
//                                }
//                            }){
//                                HStack(spacing:10){
//                                    Image(systemName: "clock")
//                                        .symbolRenderingMode(.hierarchical)
//                                        .font(.system(size: 17,weight: .black))
//                                        .foregroundColor(Color.primaryGreen)
//                                    Text("Previous Orders")
//                                        .font(.system(size: 17,weight: .medium))
//                                    Spacer()
//                                    Image(systemName: "chevron.right")
//                                        .symbolRenderingMode(.hierarchical)
//                                        .font(.system(size: 17,weight: .bold))
//                                        .foregroundColor(.black.opacity(0.3))
//                                }
//                            }
//                            Divider()
//                            Button(action:{
//                                withAnimation{
//                                pageState = "LeaderboardPage"
//                                }
//                            }){
//                                HStack(spacing:10){
//                                    Image(systemName: "trophy")
//                                        .symbolRenderingMode(.hierarchical)
//                                        .font(.system(size: 17,weight: .regular))
//                                        .foregroundColor(Color.primaryGreen)
//                                    Text("Leaderboard")
//                                        .font(.system(size: 17,weight: .medium))
//                                    Spacer()
//                                    Image(systemName: "chevron.right")
//                                        .symbolRenderingMode(.hierarchical)
//                                        .font(.system(size: 17,weight: .bold))
//                                        .foregroundColor(.black.opacity(0.3))
//                                }
//                            }
//                        }
//                        .padding(.horizontal,20)
//                        .padding(.vertical,30)
//                        .foregroundColor(.black)
//                        .background(.white)
//                        .cornerRadius(10)
//                        .padding(.horizontal,20)
                        
                        VStack(spacing:20){
                            HStack(spacing:10){
                                Image(systemName: "bell")
                                    .symbolRenderingMode(.hierarchical)
                                    .font(.system(size: 17,weight: .semibold))
                                    .foregroundColor(Color.primaryGreen)
                                Text("Notifications")
                                    .font(.system(size: 17,weight: .medium))
                                Spacer()
                                Toggle("",isOn: $toggleDemo)
                                    .toggleStyle(SwitchToggleStyle(tint: Color.primaryGreen))
                            }
                            Divider()
                            Button(action:{}){
                                HStack(spacing:10){
                                    Image(systemName: "hand.raised")
                                        .symbolRenderingMode(.hierarchical)
                                        .font(.system(size: 17,weight: .semibold))
                                        .foregroundColor(Color.primaryGreen)
                                    Text("Permissions")
                                        .font(.system(size: 17,weight: .medium))
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .symbolRenderingMode(.hierarchical)
                                        .font(.system(size: 17,weight: .bold))
                                        .foregroundColor(.black.opacity(0.3))
                                }
                            }
                        }
                        .padding(.horizontal,20)
                        .padding(.vertical,30)
                        .foregroundColor(.black)
                        .background(.white)
                        .cornerRadius(10)
                        .padding(.horizontal,20)
                        
                        VStack(spacing:20){
                            HStack(spacing:10){
                                Image(systemName: "questionmark.circle")
                                    .symbolRenderingMode(.hierarchical)
                                    .font(.system(size: 17,weight: .semibold))
                                    .foregroundColor(Color.primaryGreen)
                                Text("FAQs")
                                    .font(.system(size: 17,weight: .medium))
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .symbolRenderingMode(.hierarchical)
                                    .font(.system(size: 17,weight: .bold))
                                    .foregroundColor(.black.opacity(0.3))
                            }
                            Divider()
                            Button(action:{}){
                                HStack(spacing:10){
                                    Image(systemName: "bubble")
                                        .symbolRenderingMode(.hierarchical)
                                        .font(.system(size: 17,weight: .semibold))
                                        .foregroundColor(Color.primaryGreen)
                                    Text("Help and Support")
                                        .font(.system(size: 17,weight: .medium))
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .symbolRenderingMode(.hierarchical)
                                        .font(.system(size: 17,weight: .bold))
                                        .foregroundColor(.black.opacity(0.3))
                                }
                            }
                        }
                        .padding(.horizontal,20)
                        .padding(.vertical,30)
                        .foregroundColor(.black)
                        .background(.white)
                        .cornerRadius(10)
                        .padding(.horizontal,20)
                        
                        Button(action:{
                            withAnimation{
                                logoutFunction()
                            }
                        }){
                            Text("Log Out")
                                .font(.system(size: 17,weight: .bold))
                                .foregroundColor(.red)
                        }
                        .padding(20)
                    }
                }
            }
        }
        .background(Color.primaryBackground)
//        .transition(.move(edge: .bottom))
        .animation(.easeInOut(duration: 0.5))
        .task{
            previousPageState = "ProfilePage"
        }
//        .task{
//            do{
//                try await getUser()
//            }
//            catch{
//                print(error)
//            }
//        }
    }
}

struct previewProfilePage: View {
    
    @State var selectedItems: String = ""
    @StateObject private var userModel = usersModel()
    @StateObject private var pickupModel = pickupsModel()
    
    var body: some View {
        ProfilePage(pageState: $selectedItems, previousPageState: $selectedItems, userModel: userModel, pickupModel: pickupModel)
    }
}

#Preview {
    previewProfilePage()
}
