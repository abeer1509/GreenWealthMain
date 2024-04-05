import SwiftUI

struct SuccessPage: View {
    
    @Binding var pageState: String
    @Binding var isOrdered: Bool
    @ObservedObject var pickUp: pickUp
    @ObservedObject var pickupModel: pickupsModel
    
    @State var isPageLoading: Bool = true
    
    @State private var isLogged: Bool = UserDefaults.standard.bool(forKey: "LoginState")
    @State private var loggedUserID: String = UserDefaults.standard.string(forKey: "LoggedUserID") ?? ""
    @State private var loggedUserName: String = UserDefaults.standard.string(forKey: "LoggedUserName") ?? ""
    @State private var loggedUserEmail: String = UserDefaults.standard.string(forKey: "LoggedUserEmail") ?? ""
    
    func addPickup() async{
        
        if(pickUp.items != ""){
            try? await pickupModel.addPickup(userId: Int(loggedUserID)!, categories: pickUp.items, address: pickUp.address, lattitude: pickUp.lattitude, longitude: pickUp.longitude, date: pickUp.date, startTime: pickUp.fromTime, endTime: pickUp.toTime)

            if(pickupModel.responseStatus == 200){
                
                pickUp.image = ""
                pickUp.items = ""
                pickUp.address = ""
                pickUp.date = Date.now
                pickUp.fromTime = Date.now
                pickUp.toTime = Calendar.current.date(byAdding: .hour, value: 2, to: Date.now)!
                pickUp.estimatedPrice = 0.0
                pickUp.pickupViewed = false
                
                try? await pickupModel.getActivePickups(userId: Int(loggedUserID)!)
                try? await pickupModel.getPickups(userId: Int(loggedUserID)!)
                
                print("Active Pickups:",pickupModel.activePickups)
                print("Active Pickups Status:",pickupModel.hasActivePickups)

                isPageLoading.toggle()
            }
        }
        else{
            isPageLoading.toggle()
        }
    }
    
    var body: some View {
        ZStack{
            if(isPageLoading){
                LoadingPage()
            }
            else{
                VStack(spacing:40){
                    Spacer()
                    VStack(spacing:20){
                        Image(systemName: "checkmark.circle")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(Color.primaryGreen)
                            .font(.system(size: 37,weight: .medium))
                        Text("Pickup scheduled successfully")
                            .font(.system(size: 17,weight: .medium))
                    }
                    .padding(30)
                    .background(.white)
                    .cornerRadius(10)
                    Spacer()
                    Button(action:{
                        withAnimation{
                            isOrdered = true
                            pageState = "DashboardPage"
                        }}){
                        Text("Close")
                            .font(.system(size: 17,weight: .bold))
                            .foregroundColor(.white)
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background(Color.primaryGreen)
                            .cornerRadius(10)
                    }
                }
            }
        }
        .animation(.easeInOut(duration: 0.7))
        .padding(.horizontal, 20)
        .background(Color.primaryBackground)
        .task {
            do{
                try await addPickup()
            }
            catch{
                print(error)
            }
        }
    }
}

struct previewSuccessPage: View {
    
    @State var selectedItems: String = ""
    @State var isOrdered: Bool = false
    @StateObject var pickupData = pickUp()
    @StateObject private var pickupModel = pickupsModel()
    
    var body: some View {
        SuccessPage(pageState: $selectedItems, isOrdered: $isOrdered,pickUp: pickupData, pickupModel: pickupModel)
    }
}

#Preview {
    previewSuccessPage()
}
