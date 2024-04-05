import SwiftUI
import MapKit

struct CurrentPickup: View {
    
    @Binding var pageState: String
    @Binding var pickupId: Int
    @ObservedObject var pickupModel: pickupsModel
    
    @State private var isPageLoading: Bool = true
    @State var isToastPresented: Bool = false
    @State var toastMessage: String = ""
    
    @State var rating: Int = 0
    
    @State private var region: MKCoordinateRegion = MKCoordinateRegion()
    
    @State private var isLogged: Bool = UserDefaults.standard.bool(forKey: "LoginState")
    @State private var loggedUserID: String = UserDefaults.standard.string(forKey: "LoggedUserID") ?? ""
    @State private var loggedUserName: String = UserDefaults.standard.string(forKey: "LoggedUserName") ?? ""
    @State private var loggedUserEmail: String = UserDefaults.standard.string(forKey: "LoggedUserEmail") ?? ""
    
    func completeOrder() async{
        if(rating == 0){
            isToastPresented = true
            toastMessage = "Fill feedback"
            try? await Task.sleep(nanoseconds: 2_000_000_000)
                withAnimation{
                    isToastPresented.toggle()
                }
        }
        else{
            isPageLoading = true
            try? await pickupModel.completeOrder(pickupId: pickupId, rating: rating)
            if(pickupModel.responseStatus == 200){
                try? await pickupModel.getActivePickups(userId: Int(loggedUserID)!)
                try? await pickupModel.getPickups(userId: Int(loggedUserID)!)
                pageState = "DashboardPage"
                isPageLoading.toggle()
            }
        }
    }
    
    func getPageData() async{
        print("Called")
        if(isLogged){
            try? await pickupModel.getCurrentPickup(pickupId: pickupId)
            if(pickupModel.currentPickupInfo.first!.status != "booked"){
                
                let collectorId = pickupModel.currentPickupInfo.first!.collectorId
                
                try? await pickupModel.getCollectorDetails(collectorId: collectorId)
            }
        }
    }
    
    func loader()async{
        
        if(isLogged){
            
            try? await pickupModel.getCurrentPickup(pickupId: pickupId)
            
            if(pickupModel.currentPickupInfo.first!.status != "booked"){
                
                let collectorId = pickupModel.currentPickupInfo.first!.collectorId
                
                try? await pickupModel.getCollectorDetails(collectorId: collectorId)
            }
            
            let latitude = Double((pickupModel.currentPickupInfo.first!.lattitude as NSString).doubleValue)
            let longitude = Double((pickupModel.currentPickupInfo.first!.longitude as NSString).doubleValue)
            
            region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
            
            isPageLoading.toggle()
        }
        else{
            
            try? await pickupModel.getCurrentPickup(pickupId: pickupId)
            
            region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
            
            isPageLoading.toggle()
        }
        
    }
    
    func cancelOrder() async{
        
        isPageLoading.toggle()
        
        try! await pickupModel.cancelPickup(pickupID: pickupModel.activePickups.first!.id!)
        
        if(pickupModel.responseStatus == 200){
            try! await pickupModel.getActivePickups(userId: Int(loggedUserID)!)
            try! await pickupModel.getPickups(userId: Int(loggedUserID)!)
            if(pickupModel.responseStatus == 200){
                pageState = "DashboardPage"
            }
            else{
                isPageLoading.toggle()
                isToastPresented.toggle()
                toastMessage = pickupModel.responseMessage
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                    withAnimation{
                        isToastPresented.toggle()
                    }
            }
        }
        else{
            isPageLoading.toggle()
            isToastPresented.toggle()
            toastMessage = pickupModel.responseMessage
            try? await Task.sleep(nanoseconds: 2_000_000_000)
                withAnimation{
                    isToastPresented.toggle()
                }
        }
        
    }
    
    var body: some View {
        VStack{
            if(isPageLoading){
                LoadingPage()
            }
            else{
                ZStack{
                    if(isToastPresented){
                        VStack{
                            Text("\(toastMessage)")
                                .font(.system(size: 14,weight: .regular))
                                .foregroundColor(.white)
                        }
                        .padding(.vertical,5)
                        .padding(.horizontal,20)
                        .background(.red.opacity(0.8))
                        .cornerRadius(100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 100)
                                .stroke(.red.opacity(0.8),lineWidth:4)
                        )
                        .padding(.horizontal,20)
                        .zIndex(1)
                        .offset(y:-360)
                    }
                    if(pickupModel.currentPickupInfo.first!.status == "collected"){
                        VStack{
                            VStack(spacing:50){
                                Text("Feedback")
                                    .font(.system(size: 17, weight: .semibold))
                                Text("Your rating helps us better understand how we can improve our pickup service")
                                    .font(.system(size: 17, weight: .regular))
                                HStack{
                                    if(rating >= 1){
                                        Button(action:{
                                            rating = 1
                                        }){
                                            Image(systemName: "star.fill")
                                                .symbolRenderingMode(.hierarchical)
                                                .font(.system(size: 28, weight: .regular))
                                                .foregroundColor(Color.primaryGreen)
                                        }
                                    }
                                    else{
                                        Button(action:{
                                            rating = 1
                                        }){
                                            Image(systemName: "star")
                                                .symbolRenderingMode(.hierarchical)
                                                .font(.system(size: 28, weight: .regular))
                                                .foregroundColor(.black)
                                        }
                                    }
                                    if(rating >= 2){
                                        Button(action:{
                                            rating = 2
                                        }){
                                            Image(systemName: "star.fill")
                                                .symbolRenderingMode(.hierarchical)
                                                .font(.system(size: 28, weight: .regular))
                                                .foregroundColor(Color.primaryGreen)
                                        }
                                    }
                                    else{
                                        Button(action:{
                                            rating = 2
                                        }){
                                            Image(systemName: "star")
                                                .symbolRenderingMode(.hierarchical)
                                                .font(.system(size: 28, weight: .regular))
                                                .foregroundColor(.black)
                                        }
                                    }
                                    if(rating >= 3){
                                        Button(action:{
                                            rating = 3
                                        }){
                                            Image(systemName: "star.fill")
                                                .symbolRenderingMode(.hierarchical)
                                                .font(.system(size: 28, weight: .regular))
                                                .foregroundColor(Color.primaryGreen)
                                        }
                                    }
                                    else{
                                        Button(action:{
                                            rating = 3
                                        }){
                                            Image(systemName: "star")
                                                .symbolRenderingMode(.hierarchical)
                                                .font(.system(size: 28, weight: .regular))
                                                .foregroundColor(.black)
                                        }
                                    }
                                    if(rating >= 4){
                                        Button(action:{
                                            rating = 4
                                        }){
                                            Image(systemName: "star.fill")
                                                .symbolRenderingMode(.hierarchical)
                                                .font(.system(size: 28, weight: .regular))
                                                .foregroundColor(Color.primaryGreen)
                                        }
                                    }
                                    else{
                                        Button(action:{
                                            rating = 4
                                        }){
                                            Image(systemName: "star")
                                                .symbolRenderingMode(.hierarchical)
                                                .font(.system(size: 28, weight: .regular))
                                                .foregroundColor(.black)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal,20)
                            Spacer()
                            VStack{
                                AsyncImage(url: URL(string: pickupModel.currentPickupInfo.first!.imageURL)) { image in
                                    image.resizable()
                                } placeholder: {
                                ProgressView()
                            }
                                    .frame(width: 323,height: 180)
                                    .cornerRadius(10)
                                Text("Order Completed!")
                                    .font(.system(size: 17, weight: .medium))
                                    .padding(.bottom,10)
                                HStack{
                                    Text("Received:")
                                        .font(.system(size: 17, weight: .regular))
                                    HStack(spacing:0){
                                        Image(systemName: "indianrupeesign")
                                            .symbolRenderingMode(.hierarchical)
                                            .font(.system(size: 17, weight: .bold))
                                        Text("\(Int(pickupModel.currentPickupInfo.first!.finalPrice))")
                                            .font(.system(size: 17, weight: .bold))
                                    }
                                }
                            }
                            .padding()
                            .background(.white)
                            .cornerRadius(10)
                            Spacer()
                            Button(action:{
                                Task{
                                    await completeOrder()
                                }
                            }){
                                Text("Submit")
                                    .font(.system(size: 17, weight: .bold))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(Color.primaryGreen)
                                    .cornerRadius(10)
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    else{
                        VStack{
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
                                Text("Your ongoing order")
                                    .font(.system(size: 17,weight: .bold))
                                    .padding(.vertical,10)
                                Spacer()
                            }
                            .padding(.horizontal,40)
                            VStack{
                                ZStack{
                                    VStack{
                                        Map(coordinateRegion: $region)
                                                    .frame(height: 220)
                                    }
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color("PrimaryGreen"),lineWidth:2)
                                    )
                                    Button(action:{}){
                                        VStack(spacing:5){
                                            Text("\(pickupModel.currentPickupInfo.first!.otp)")
                                                .font(.system(size: 14,weight: .bold))
                                            Text("OTP")
                                                .font(.system(size: 12,weight: .regular))
                                        }
                                        .foregroundColor(.black)
                                    }
                                    .frame(width: 88,height: 54)
                                    .background(.white)
                                    .cornerRadius(5)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color("PrimaryGreen"),lineWidth:2)
                                    )
                                    .offset(x:-123,y:65)
                                }
                                .padding(.horizontal,20)
                                .padding(.vertical,10)
                                VStack{
                                    if(isLogged){
                                        Text("\(pickupModel.currentPickupInfo.first!.status.capitalized)")
                                            .font(.system(size: 17, weight: .medium))
                                    }
                                    else{
                                        Text("Booked")
                                            .font(.system(size: 17, weight: .medium))
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.primaryGreen)
                                .cornerRadius(10)
                                .padding(.horizontal,20)
                                .padding(.bottom,10)
                                ScrollView{
                                    HStack{
                                        Button(action:{}){
                                            VStack(spacing:5){
                                                Image(systemName: "phone")
                                                    .symbolRenderingMode(.hierarchical)
                                                    .font(.system(size: 17, weight: .semibold))
                                                    .foregroundColor(Color.primaryGreen)
                                                Text("Call")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 17, weight: .regular))
                                            }
                                            .frame(width: 85, height: 70)
                                            .background(.white)
                                            .cornerRadius(10)
                                        }
                                        Button(action:{}){
                                            VStack(spacing:5){
                                                Image(systemName: "pencil")
                                                    .symbolRenderingMode(.hierarchical)
                                                    .font(.system(size: 17, weight: .semibold))
                                                    .foregroundColor(Color.primaryGreen)
                                                Text("Modify")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 17, weight: .regular))
                                            }
                                            .frame(width: 85, height: 70)
                                            .background(.white)
                                            .cornerRadius(10)
                                        }
                                        Button(action:{
                                            withAnimation{
                                                pageState = "HelpPage"
                                            }
                                        }){
                                            VStack(spacing:5){
                                                Image(systemName: "bubble")
                                                    .symbolRenderingMode(.hierarchical)
                                                    .font(.system(size: 17, weight: .semibold))
                                                    .foregroundColor(Color.primaryGreen)
                                                Text("Help")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 17, weight: .regular))
                                            }
                                            .frame(width: 85, height: 70)
                                            .background(.white)
                                            .cornerRadius(10)
                                        }
                                        Button(action:{
                                            Task{
                                                await cancelOrder()
                                            }
                                            
                                        }){
                                            VStack(spacing:5){
                                                Image(systemName: "x.circle")
                                                    .symbolRenderingMode(.hierarchical)
                                                    .font(.system(size: 17, weight: .semibold))
                                                    .foregroundColor(Color.primaryGreen)
                                                Text("Cancel")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 17, weight: .regular))
                                            }
                                            .frame(width: 85, height: 70)
                                            .background(.white)
                                            .cornerRadius(10)
                                        }
                                    }
                                    .padding(.horizontal,20)
                                    if(pickupModel.currentPickupInfo.first!.status != "booked"){
                                        VStack{
                                            HStack{
                                                Text("Pickup Person Details")
                                                    .font(.system(size: 13, weight: .regular))
                                                Spacer()
                                            }
                                            Divider()
                                            HStack{
                                                AsyncImage(url: URL(string: pickupModel.collectorInfo.first!.profileImage)) { image in
                                                    image.resizable()
                                                } placeholder: {
                                                ProgressView()
                                            }
                                                    .frame(width: 50,height: 50)
                                                    .cornerRadius(5)
                                                VStack{
                                                    Text("\(pickupModel.collectorInfo.first!.fullName)")
                                                        .font(.system(size: 17, weight: .medium))
                                                    Text("\(pickupModel.collectorInfo.first!.mobileNumber)")
                                                        .font(.system(size: 17, weight: .medium))
                                                }
                                                Spacer()
                                            }
                                        }
                                        .padding()
                                        .background(.white)
                                        .cornerRadius(10)
                                        .padding(.horizontal, 20)
                                    }
                                    VStack(spacing:20){
                                        HStack{
                                            Image(systemName: "camera")
                                                .symbolRenderingMode(.hierarchical)
                                                .foregroundColor(Color.primaryGreen)
                                                .font(.system(size: 17,weight: .medium))
                                            Text("Approx 5 kgs")
                                                .font(.system(size: 17, weight: .medium))
                                            Spacer()
                                            if(isLogged){
                                                AsyncImage(url: URL(string: pickupModel.currentPickupInfo.first!.imageURL)) { image in
                                                    image.resizable()
                                                } placeholder: {
                                                ProgressView()
                                            }
                                                    .frame(width: 50,height: 50)
                                                    .cornerRadius(5)
                                            }
                                            else{
                                                Image("demo")
                                                    .frame(width: 50,height: 50)
                                                    .cornerRadius(5)
                                            }
                                        }
                                        Divider()
                                        HStack{
                                            Image(systemName: "trash")
                                                .symbolRenderingMode(.hierarchical)
                                                .foregroundColor(Color.primaryGreen)
                                                .font(.system(size: 17,weight: .medium))
                                            if(isLogged){
                                                Text("\(pickupModel.currentPickupInfo.first!.categories)")
                                                    .font(.system(size: 17, weight: .medium))
                                            }
                                            else{
                                                Text("Paper,Plastic")
                                                    .font(.system(size: 17, weight: .medium))
                                            }
                                            Spacer()
                                        }
                                        Divider()
                                        HStack{
                                            Image(systemName: "location")
                                                .symbolRenderingMode(.hierarchical)
                                                .foregroundColor(Color.primaryGreen)
                                                .font(.system(size: 17,weight: .medium))
                                            if(isLogged){
                                                Text("\(pickupModel.currentPickupInfo.first!.address)")
                                                    .font(.system(size: 17, weight: .medium))
                                            }
                                            else{
                                                Text("SRM University")
                                                    .font(.system(size: 17, weight: .medium))
                                            }
                                            Spacer()
                                        }
                                        Divider()
                                        HStack{
                                            Image(systemName: "calendar")
                                                .symbolRenderingMode(.hierarchical)
                                                .foregroundColor(Color.primaryGreen)
                                                .font(.system(size: 17,weight: .medium))
                                            HStack(spacing:5){
                                                if(isLogged){
                                                    Text(pickupModel.currentPickupInfo.first!.date.formatted(date: .abbreviated,time: .omitted))
                                                    Text(",")
                                                    Text(pickupModel.currentPickupInfo.first!.startTime.formatted(date:.omitted,time: .shortened))
                                                    Text("to")
                                                    Text(pickupModel.currentPickupInfo.first!.endTime.formatted(date:.omitted,time: .shortened))
                                                }
                                                else{
                                                    Text(Date.now.formatted(date: .abbreviated,time: .omitted))
                                                    Text(",")
                                                    Text(Date.now.formatted(date:.omitted,time: .shortened))
                                                    Text("to")
                                                    Text(Date.now.formatted(date:.omitted,time: .shortened))
                                                }
                //                                Spacer()
                                            }
                                            .font(.system(size: 17, weight: .medium))
                //                            Text("Jan 23, 9:40am to 11:40am")
                //                                .font(.system(size: 17, weight: .medium))
                                            Spacer()
                                        }
                                    }
                                    .padding()
                                    .background(.white)
                                    .cornerRadius(10)
                                    .padding(.horizontal,20)
                                    HStack{
                                        Text("Estimated price you receive")
                                        Spacer()
                                        HStack{
                                            Image(systemName: "indianrupeesign")
                                                .symbolRenderingMode(.hierarchical)
                                            Text("200")
                                        }
                                    }
                                    .padding()
                                    .background(.white)
                                    .cornerRadius(10)
                                    .padding(.horizontal,20)
                                }
                                Spacer()
                            }
                        }
                    }
                }
            }
        }
        .task {
            await loader()
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

struct previewCurrentPickup: View {
    
    @State var selectedItems: String = ""
    @State var pickupId: Int = 14
    
    @StateObject var pickupData = pickUp()
    @StateObject var pickupModel = pickupsModel()
    
    var body: some View {
        CurrentPickup(pageState: $selectedItems, pickupId: $pickupId, pickupModel: pickupModel)
    }
}

#Preview {
    previewCurrentPickup()
}
