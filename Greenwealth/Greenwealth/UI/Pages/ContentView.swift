import SwiftUI

struct ContentView: View {
    
    @StateObject var pickupData = pickUp()
    @StateObject private var userModel = usersModel()
    @StateObject private var pickupModel = pickupsModel()
    @StateObject private var requestModel = requestsModel()
    
    @State private var isBoarded: Bool = UserDefaults.standard.bool(forKey: "BoardingState")
    
    @State var pageState = ""
    @State var previousPageState = "LaunchPage"
    @State var isOrdered = false
    @State var presentOnBoarding: Bool = false
    @State var pickupId: Int = 0
    
    var body: some View {
        VStack{
            if(pageState == "LaunchPage"){
                LaunchPage(userModel: userModel, pickupModel: pickupModel, pickUp: pickupData, pageState: $pageState)
            }
            else if(pageState == "SigninPage"){
                SigninPage(userModel: userModel, pickupModel: pickupModel,pageState: $pageState, previousPageState: $previousPageState)
            }
            else if(pageState == "SignupPage"){
                SignupPage(userModel: userModel, pickupModel: pickupModel,pageState: $pageState, previousPageState: $previousPageState)
            }
            else if(pageState == "SuccessPage"){
                SuccessPage(pageState: $pageState, isOrdered: $isOrdered,pickUp: pickupData, pickupModel: pickupModel)
            }
            else{
                ZStack{
                    VStack{
                        Navbar(pageState: $pageState, previousPageState: $previousPageState)
                        Spacer()
                        if(pageState == "DashboardPage"){
                            Dashboard(pageState: $pageState, pickupId: $pickupId, pickUp: pickupData, userModel: userModel, pickupModel: pickupModel)
                        }
                        else if(pageState == "HomePage"){
                            HomePage(pageState: $pageState, previousPageState: $previousPageState,isOrdered: $isOrdered,pickUp: pickupData, pickupModel: pickupModel)
                        }
                        else if(pageState == "ProfilePage"){
                            ProfilePage(pageState: $pageState, previousPageState: $previousPageState, userModel: userModel, pickupModel: pickupModel)
                        }
                        else if(pageState == "LeaderboardPage"){
                            LeaderboardPage(userModel: userModel, pageState: $pageState)
                        }
                        else if(pageState == "CurrentPage"){
                            CurrentPickup(pageState: $pageState, pickupId: $pickupId, pickupModel: pickupModel)
                        }
                        else if(pageState == "HistoryPage"){
                            PastOrders(pageState: $pageState, pickupModel: pickupModel)
                        }
                        else if(pageState == "HelpPage"){
                            HelpPage(requestModel: requestModel)
                        }
                        Spacer()
                        Tabbar(pageState: $pageState, previousPageState: $previousPageState)
                    }
                }
                .background(Color.primaryBackground)
            }
        }
        .sheet(isPresented: $presentOnBoarding){
            VStack{
                HStack{
                    Text("Welcome")
                        .font(.system(size: 20, weight: .semibold))
                    Spacer()
                }
                .padding(.vertical)
                Spacer()
                VStack{
                    Image(systemName: "arrow.3.trianglepath")
                        .symbolRenderingMode(.hierarchical)
                        .font(.system(size: 60, weight: .black))
                        .foregroundColor(Color.primaryGreen)
                    Text("Greenwealth")
                        .font(.system(size: 32, weight: .black))
                }
                .padding(.bottom,80)
                VStack(spacing:30){
                    HStack{
                        VStack{
                            Image(systemName: "truck.box")
                                .symbolRenderingMode(.hierarchical)
                                .font(.system(size: 17, weight: .regular))
                                .foregroundColor(.white)
                        }
                        .frame(width: 38, height: 38)
                        .background(Color.primaryGreen)
                        .cornerRadius(10)
                        Text("Sell your old goods in 4 steps!")
                            .font(.system(size: 17, weight: .regular))
                        Spacer()
                    }
                    HStack{
                        VStack{
                            Image(systemName: "star")
                                .symbolRenderingMode(.hierarchical)
                                .font(.system(size: 17, weight: .regular))
                                .foregroundColor(.white)
                        }
                        .frame(width: 38, height: 38)
                        .background(.yellow)
                        .cornerRadius(10)
                        Text("Earn eco-points, redeem rewards!")
                            .font(.system(size: 17, weight: .regular))
                        Spacer()
                    }
                    HStack{
                        VStack{
                            Image(systemName: "chart.line.uptrend.xyaxis")
                                .symbolRenderingMode(.hierarchical)
                                .font(.system(size: 17, weight: .regular))
                                .foregroundColor(.white)
                        }
                        .frame(width: 38, height: 38)
                        .background(.red)
                        .cornerRadius(10)
                        Text("Accumulate statistics such as carbon footprint, and trees saved!")
                            .font(.system(size: 17, weight: .regular))
                        Spacer()
                    }
                    HStack{
                        VStack{
                            Image(systemName: "trophy")
                                .symbolRenderingMode(.hierarchical)
                                .font(.system(size: 17, weight: .regular))
                                .foregroundColor(.white)
                        }
                        .frame(width: 38, height: 38)
                        .background(.blue)
                        .cornerRadius(10)
                        Text("Compete on the leaderboard!")
                            .font(.system(size: 17, weight: .regular))
                        Spacer()
                    }
                }
                .padding(.horizontal,20)
                Spacer()
                Button(action:{
                    UserDefaults.standard.set(true,forKey: "BoardingState")
                    pageState = "LaunchPage"
                    presentOnBoarding = false
                }){
                    HStack{
                        Text("Get Started")
                        Image(systemName: "arrow.right")
                            .symbolRenderingMode(.hierarchical)
                    }
                    .frame(maxWidth: .infinity)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .padding()
                    .background(.black)
                    .cornerRadius(10)
                }
            }
            .padding(.horizontal, 20)
        }
        .task {
            if(isBoarded){
                pageState = "LaunchPage"
                presentOnBoarding = false
            }
            else{
                pageState = ""
                presentOnBoarding = true
            }
        }
    }
}
//y4XBfwltwpH6eyyL
#Preview {
    ContentView()
}
