import SwiftUI

struct LeaderboardPage: View {
    
    @ObservedObject var userModel: usersModel
    @Binding var pageState: String
    
    @State private var isLogged: Bool = UserDefaults.standard.bool(forKey: "LoginState")
    @State private var loggedUserID: String = UserDefaults.standard.string(forKey: "LoggedUserID") ?? ""
    @State private var loggedUserName: String = UserDefaults.standard.string(forKey: "LoggedUserName") ?? "Preview"
    @State private var loggedUserEmail: String = UserDefaults.standard.string(forKey: "LoggedUserEmail") ?? ""
    
    var body: some View {
        VStack{
//            HStack{
//                Button(action:{
//                    withAnimation{
//                        pageState = "ProfilePage"
//                    }
//                }){
//                    Image(systemName: "chevron.left")
//                        .symbolRenderingMode(.hierarchical)
//                        .foregroundColor(Color.primaryGreen)
//                        .font(.system(size: 17,weight: .semibold))
//                }
//                Spacer()
//                Text("Leaderboard")
//                    .font(.system(size: 17,weight: .bold))
//                    .padding(.vertical,20)
//                Spacer()
//            }
//            VStack{
//                Text("Leaderboard")
//                    .font(.system(size: 17,weight: .bold))
//                    .padding(.vertical,20)
//            }
//            .padding(.horizontal,40)
            if(isLogged){
                VStack(alignment:.leading){
                    Text("Top Recycler of the month!")
                        .font(.system(size: 17,weight: .bold))
                        .offset(y:20)
                    HStack{
                        HStack{
                            Text("01")
                                .font(.system(size: 20,weight: .bold))
                            AsyncImage(url: URL(string: userModel.usersRanking.first!.profileImage)) { image in
                                image.resizable()
                                    .clipShape(Circle())
                            } placeholder: {
                            ProgressView()
                        }
                                .frame(width: 40,height: 40)
                            VStack(alignment:.leading){
                                Text("\(userModel.usersRanking.first!.fullName)")
                                    .font(.system(size: 17,weight: .bold))
                                Text("\(userModel.usersRanking.first!.ecoPoints!)"+" Points")
                                    .font(.system(size: 17,weight: .regular))
                            }
                        }
                        Spacer()
                        Image("Trophy")
                    }
                }
                .padding(.horizontal,20)
                .foregroundColor(.white)
                .background(Color.primaryGreen)
                .cornerRadius(10)
                .padding(.horizontal,20)
                ScrollView{
                    VStack{
                        ForEach(1..<userModel.usersRanking.count){ i in
                            if(userModel.usersRanking[i].id == Int(loggedUserID)!){
                                HStack{
                                    HStack{
                                        if(i<9){
                                            Text("0\(i+1)")
                                                .font(.system(size: 20,weight: .bold))
                                        }
                                        else{
                                            Text("\(i+1)")
                                                .font(.system(size: 20,weight: .bold))
                                        }
                                        Image("Profile")
                                            .resizable()
                                            .frame(width: 40,height: 40)
                                        VStack(alignment:.leading){
                                            Text("You")
                                                .font(.system(size: 17,weight: .bold))
                                            Text("\(userModel.usersRanking[i].ecoPoints!)"+" Points")
                                                .font(.system(size: 17,weight: .regular))
                                        }
                                    }
                                    Spacer()
                                }
                                .padding()
                                .background(Color.primaryGreen)
                                .cornerRadius(10)

                            }
                            else if( i < 10){
                                HStack{
                                    HStack{
                                        if(i<9){
                                            Text("0\(i+1)")
                                                .font(.system(size: 20,weight: .bold))
                                        }
                                        else{
                                            Text("\(i+1)")
                                                .font(.system(size: 20,weight: .bold))
                                        }
                                        AsyncImage(url: URL(string: userModel.usersRanking[i].profileImage)) { image in
                                            image.resizable()
                                                .clipShape(Circle())
                                        } placeholder: {
                                        ProgressView()
                                    }
                                            .frame(width: 40,height: 40)
                                        VStack(alignment:.leading){
                                            Text("\(userModel.usersRanking[i].fullName)")
                                                .font(.system(size: 17,weight: .bold))
                                            Text("\(userModel.usersRanking[i].ecoPoints!)"+" Points")
                                                .font(.system(size: 17,weight: .regular))
                                        }
                                    }
                                    Spacer()
                                }
                                .padding()
                                .background(.white)
                                .cornerRadius(10)
                            }
                        }
    //                    HStack{
    //                        HStack{
    //                            Text("10")
    //                                .font(.system(size: 20,weight: .bold))
    //                            Image("Profile")
    //                                .resizable()
    //                                .frame(width: 40,height: 40)
    //                            VStack(alignment:.leading){
    //                                Text("You")
    //                                    .font(.system(size: 17,weight: .bold))
    //                                Text("1,000 Points")
    //                                    .font(.system(size: 17,weight: .regular))
    //                            }
    //                        }
    //                        Spacer()
    //                    }
    //                    .padding()
    //                    .background(Color.primaryGreen)
    //                    .cornerRadius(10)
                    }
                    .foregroundColor(.black)
                    .padding(.horizontal,20)
                }
            }
        }
        .background(Color.primaryBackground)
//        .transition(.move(edge: .bottom))
        .animation(.easeInOut(duration: 0.5))
    }
}

struct previewLeaderPage: View {
    
    @StateObject private var userModel = usersModel()
    @State var selectedItems: String = ""
    
    var body: some View {
        LeaderboardPage(userModel: userModel, pageState: $selectedItems)
    }
}

#Preview {
    previewLeaderPage()
}
