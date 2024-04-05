import SwiftUI

struct HomePage: View {
    
    @Binding var pageState: String
    @Binding var previousPageState: String
    @Binding var isOrdered: Bool
    @ObservedObject var pickUp: pickUp
    @ObservedObject var pickupModel: pickupsModel
    
    @State var formState: String = "none"
    @State var isAlerting: Bool = false
    
    @State var hasActivePickup: Bool = false
    @State var isPageLoading: Bool = false
    
    @State private var isLogged: Bool = UserDefaults.standard.bool(forKey: "LoginState")
    @State private var loggedUserID: String = UserDefaults.standard.string(forKey: "LoggedUserID") ?? ""
    @State private var loggedUserName: String = UserDefaults.standard.string(forKey: "LoggedUserName") ?? ""
    @State private var loggedUserEmail: String = UserDefaults.standard.string(forKey: "LoggedUserEmail") ?? ""
    
    func getPickup() async{
        
        if(isLogged){
            if(pickupModel.responseStatus == 200){
                hasActivePickup = true
            }
        }
        
        isPageLoading.toggle()
        
    }
    
    var body: some View {
        
        ZStack{
            if(isPageLoading){
                LoadingPage()
            }
            
            else{
                VStack{
//                    if(pickupModel.hasActivePickups){
//                        VStack{
//                            HStack{
//                                Text("Ongoing order")
//                                    .font(.system(size: 13,weight: .regular))
//                                Spacer()
//                                Image(systemName: "arrow.right")
//                                    .symbolRenderingMode(.hierarchical)
//                                    .foregroundColor(.black.opacity(0.6))
//                                    .font(.system(size: 13,weight: .regular))
//                            }
//                            .padding(.horizontal,20)
//                            Button(action:{
//                                withAnimation{
//                                    pageState = "CurrentPage"
//                                }
//                            }){
//                                HStack{
//                                    VStack(alignment:.leading,spacing:10){
//                                        Text("\(pickupModel.activePickups.first!.categories)")
//                                        Text("Approximately 5 kgs")
//                                    }
//                                    .font(.system(size: 13,weight: .regular))
//                                    Spacer()
//                                    VStack{
//                                        Image(systemName: "truck.box")
//                                            .symbolRenderingMode(.hierarchical)
//                                            .foregroundColor(Color.primaryGreen)
//                                            .font(.system(size: 17,weight: .medium))
//                                    }
//                                }
//                                .padding()
//                                .foregroundColor(.black)
//                                .background(Color.primaryGreen.opacity(0.10))
//                                .cornerRadius(10)
//                            }
//                        }
//                        .padding(.vertical,10)
//                        .padding(.horizontal,20)
//                        .transition(.move(edge: .leading))
//                    }
                    HStack{
                        Button(action:{
                            withAnimation{
                                pageState = "DashboardPage"
                            }
                        }){
                            Image(systemName: "chevron.left")
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(Color.primaryGreen)
                                .font(.system(size: 17,weight: .semibold))
                        }
                        Spacer()
                        Text("New Pickup")
                            .font(.system(size: 17,weight: .bold))
                            .padding(.vertical,10)
                        Spacer()
                    }
                    .padding(.horizontal,40)
                    ScrollView{
                        VStack( spacing:20 ){
                            PhotoCapture(pickUp: pickUp)
                            Divider()
                            ItemSelect(pickUp: pickUp,formState: $formState)
                            Divider()
                            AddressSelect(pickUp: pickUp,formState: $formState)
                            Divider()
                            SlotSelect(pickUp: pickUp,formState: $formState)
                            
                        }
                        .padding()
                        .background(.white)
                        .cornerRadius(10)
                        .padding(.horizontal,20)
                        if(pickUp.image != "" && pickUp.items != "" && (pickUp.address != "" || pickUp.address == "Failed to retrieve address") && pickUp.estimatedPrice == 0.0){
                            Button(action:{
                                pickUp.estimatedPrice = 200.0
                                isAlerting = true
                                formState = "none"
                            }){
                                Text("Estimate price")
                                    .font(.system(size: 17,weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(height: 50)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.primaryGreen)
                                    .cornerRadius(10)
                            }
                            .padding(.top,10)
                            .padding(.horizontal,20)
                            .transition(.move(edge: .leading))
                        }
                        if(pickUp.image != "" && pickUp.items != "" && (pickUp.address != "" || pickUp.address == "Failed to retrieve address") && pickUp.estimatedPrice != 0.0){
                            HStack{
                                Text("Estimated price you recieve")
                                Spacer()
                                HStack{
                                    Image(systemName: "indianrupeesign")
                                        .symbolRenderingMode(.hierarchical)
                                    Text("200")
                                }
                            }
                            .font(.system(size: 17,weight: .regular))
                            .padding()
                            .background(.white)
                            .cornerRadius(10)
                            .padding(.vertical,10)
                            .padding(.horizontal,20)
                            .transition(.move(edge: .leading))
                        }
                    }
                    Spacer()
                    VStack{
                        if(pickUp.image != "" && pickUp.items != "" && pickUp.address != "" && pickUp.estimatedPrice != 0.0){
                            Button(action:{
                                withAnimation{
                                    if(isLogged){
                                        print(pickUp.lattitude)
                                        pageState = "SuccessPage"
                                    }
                                    else{
                                        print(pickUp.lattitude)
                                        pageState = "SigninPage"
                                    }
//                                    pickUp.image = ""
//                                    pickUp.items = ""
//                                    pickUp.address = ""
//                                    pickUp.date = Date.now
//                                    pickUp.fromTime = Date.now
//                                    pickUp.toTime = Calendar.current.date(byAdding: .hour, value: 2, to: Date.now)!
//                                    pickUp.estimatedPrice = 0.0
//                                    pickUp.pickupViewed = false
                                }
                            }){
                                Text("Book Pickup")
                                    .font(.system(size: 17,weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(height: 50)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.primaryGreen)
                                    .cornerRadius(10)
                            }
                        }
                        else{
                            Button(action:{}){
                                Text("Book Pickup")
                                    .font(.system(size: 17,weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(height: 50)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.secondaryGreen)
                                    .cornerRadius(10)
                            }
                            .disabled(true)
                        }
                    }
                    .padding(.horizontal,20)
                    .alert("Estimate price is Rs:200", isPresented: $isAlerting) {
                                Button("OK", role: .cancel) { }
                            }
                }
            }
        }
        .background(Color.primaryBackground)
//        .transition(.move(edge: .leading))
        .animation(.easeInOut(duration: 0.5))
        .task {
            previousPageState = "HomePage"
        }
//        .task {
//            do{
//                try await getPickup()
//            }
//            catch{
//                print(error)
//            }
//        }
    }
}

struct previewHomePage: View {
    
    @State var selectedItems: String = ""
    @State var isOrdered: Bool = true
    
    @StateObject var pickupData = pickUp()
    @StateObject private var pickupModel = pickupsModel()
    
    var body: some View {
        HomePage(pageState: $selectedItems, previousPageState: $selectedItems, isOrdered: $isOrdered,pickUp: pickupData, pickupModel: pickupModel)
    }
}

#Preview {
    previewHomePage()
}
