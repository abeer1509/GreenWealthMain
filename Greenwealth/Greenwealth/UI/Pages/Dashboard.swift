import SwiftUI

struct Dashboard: View {
    
    @Binding var pageState: String
    @Binding var pickupId: Int
    @ObservedObject var pickUp: pickUp
    @ObservedObject var userModel: usersModel
    @ObservedObject var pickupModel: pickupsModel
    
    @State private var isLogged: Bool = UserDefaults.standard.bool(forKey: "LoginState")
    @State private var loggedUserID: String = UserDefaults.standard.string(forKey: "LoggedUserID") ?? ""
    @State private var loggedUserName: String = UserDefaults.standard.string(forKey: "LoggedUserName") ?? ""
    @State private var loggedUserEmail: String = UserDefaults.standard.string(forKey: "LoggedUserEmail") ?? ""
    
    func getPageData() async{
        print("Called")
        if(isLogged){
            try? await userModel.getUser(emailAddress: loggedUserEmail)
            try? await userModel.getStats()
            try? await userModel.getGlobalRank(userID: Int(loggedUserID)!)
            try? await pickupModel.getActivePickups(userId: Int(loggedUserID)!)
            try? await pickupModel.getPickups(userId: Int(loggedUserID)!)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing:20){
            HStack{
                Image("Profile")
                    .resizable()
                    .frame(width: 90, height: 90)
                VStack(alignment: .leading){
                    Text("Welcome Back!")
                        .font(.system(size: 15, weight: .regular))
                    if(isLogged){
                        Text("\(loggedUserName)")
                            .font(.system(size: 28, weight: .bold))
                    }
                    else{
                        Text("Guest")
                            .font(.system(size: 28, weight: .bold))
                    }
                }
                Spacer()
            }
            .padding(.horizontal,20)
            ScrollView{
                VStack(spacing:20){
                    VStack{
                        HStack{
                            Text("Total Amount Earned")
                                .font(.system(size: 17, weight: .regular))
                            Spacer()
                            HStack(alignment:.bottom, spacing:0){
                                Image(systemName: "indianrupeesign")
                                if(isLogged){
                                    if(userModel.users[0].totalAmount! == 0.0){
                                        Text("0")
                                    }
                                    else{
                                        Text("\(Int(userModel.users[0].totalAmount!))")
                                    }
                                }
                                else{
                                    Text("0")
                                }
                            }
                            .font(.system(size: 22, weight: .bold))
                        }
                        Divider()
                        HStack{
                            Text("Eco-points")
                                .font(.system(size: 17, weight: .regular))
                            Spacer()
                            HStack{
                                if(isLogged){
                                    Text("\(userModel.users[0].ecoPoints!)")
                                }
                                else{
                                    Text("0")
                                }
                            }
                            .font(.system(size: 22, weight: .bold))
                        }
                    }
                    .padding()
                    .background(.white)
                    .cornerRadius(10)
                    .padding(.horizontal,20)
                    HStack{
                        Button(action:{
                            withAnimation{
                                if(isLogged){
                                    pageState = "HistoryPage"
                                }
                                else{
                                    pageState = "SigninPage"
                                }
                            }
                        }){
                            VStack(spacing:10){
                                Image(systemName: "clock.arrow.circlepath")
                                    .symbolRenderingMode(.hierarchical)
                                    .font(.system(size: 17, weight: .medium))
                                    .foregroundColor(Color.primaryGreen)
                                Text("Order History")
                                    .font(.system(size: 13, weight: .bold))
                            }
                            .frame(width: 171.5, height: 95)
                            .background(.white)
                            .cornerRadius(10)
                        }
                        Button(action:{
                            withAnimation{
                                pageState = "HomePage"
                            }
                        }){
                            VStack(spacing:10){
                                Image(systemName: "plus.circle")
                                    .symbolRenderingMode(.hierarchical)
                                    .font(.system(size: 17, weight: .medium))
                                    .foregroundColor(Color.primaryGreen)
                                Text("Place a New Order")
                                    .font(.system(size: 13, weight: .bold))
                            }
                            .frame(width: 171.5, height: 95)
                            .background(.white)
                            .cornerRadius(10)
                        }
                    }
                    .foregroundColor(Color.primaryGreen)
                    .padding(.horizontal,20)
                    VStack(alignment: .center, spacing: 10){
                        Text("Current position on leaderboard")
                            .font(.system(size: 17, weight: .regular))
                        if(isLogged){
                            Text("#\(userModel.userGlobalRank)")
                                .font(.system(size: 22, weight: .bold))
                        }
                        else{
                            Text("#0")
                                .font(.system(size: 22, weight: .bold))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.white)
                    .cornerRadius(10)
                    .padding(.horizontal,20)
                }
            }
            if(isLogged){
                if(pickupModel.activePickups.count != 0){
                    Button(action:{
                        withAnimation{
                            pickupId = pickupModel.activePickups[0].id!
                            pageState = "CurrentPage"
                        }
                    }){
                        HStack(spacing:10){
                            Image(systemName: "truck.box")
                                .symbolRenderingMode(.hierarchical)
                                .font(.system(size: 17, weight: .medium))
                            VStack(alignment:.leading, spacing:05){
                                Text("Ongoing order Status")
                                    .font(.system(size: 13, weight: .regular))
                                if(pickupModel.activePickups[0].status == "booked"){
                                    Text("Request Placed")
                                        .font(.system(size: 13, weight: .bold))
                                }
                                else if(pickupModel.activePickups[0].status == "accepted"){
                                    Text("Request Accepted")
                                        .font(.system(size: 13, weight: .bold))
                                }
                                else if(pickupModel.activePickups[0].status == "started"){
                                    Text("Collector is arriving")
                                        .font(.system(size: 13, weight: .bold))
                                }
                                else if(pickupModel.activePickups[0].status == "collected"){
                                    Text("Collected")
                                        .font(.system(size: 13, weight: .bold))
                                }
                            }
                            Spacer()
                            VStack{
                                Image(systemName: "location")
                                    .symbolRenderingMode(.hierarchical)
                                    .font(.system(size: 20, weight: .regular))
                            }
                            .padding()
                            .cornerRadius(100)
                            .overlay(
                              RoundedRectangle(cornerRadius: 100)
                                .stroke(.black.opacity(0.25), lineWidth: 1)
                            )
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal,20)
                    .foregroundColor(.black)
                    .background(.white)
                    .cornerRadius(10)
                    .padding(.horizontal,20)
                }
            }
        }
//        .transition(.move(edge: .bottom))
        .animation(.easeInOut(duration: 0.5))
        .task {
            await getPageData()
        }
        .onAppear(
            perform: {
                Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { time in
                    Task{
                        await getPageData()
                    }
                }
            }
        )
    }
}

struct previewDashboard: View {
    
    @State var pageState: String = "LaunchPage"
    @State var pickupId: Int = 4
    @StateObject private var userModel = usersModel()
    @StateObject private var pickupModel = pickupsModel()
    @StateObject var pickupData = pickUp()
    
    var body: some View {
        Dashboard(pageState: $pageState, pickupId: $pickupId, pickUp: pickupData, userModel: userModel, pickupModel: pickupModel)
    }
}

#Preview {
    previewDashboard()
}
