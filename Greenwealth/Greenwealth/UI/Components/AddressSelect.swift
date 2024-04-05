import SwiftUI
import MapKit

struct AddressSelect: View {
    
    @ObservedObject var pickUp: pickUp
    @Binding var formState: String
    
    @State private var isCurrentLocaton: Bool = true
    
    @State private var doorNo: String = ""
    @State private var addressOne: String = ""
    @State private var addressTwo: String = ""
    @State private var showMap: Bool = false
    @State private var lattitude: String = ""
    @State private var longitude: String = ""
    
    func reverseGeocoding(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                pickUp.address = "Failed to retrieve address"
            }
            if let placemarks = placemarks, let placemark = placemarks.first {
                pickUp.address = ""
                pickUp.address = pickUp.address + String(placemark.name ?? "") + ", " + String(placemark.locality ?? "") + ", " + String(placemark.country ?? "") + ", " + String(placemark.postalCode ?? "")
                pickUp.lattitude = String(lattitude)
                pickUp.longitude = String(longitude)
                
            }
            else{
                pickUp.address = "Failed to retrieve address"
            }
        })
    }
    
    @StateObject var locationManager = LocationManager()
    @State private var position = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    func useMyLocation(){
        
        pickUp.pickupViewed = true
        isCurrentLocaton = true
        pickUp.address = ""

        var userLatitude = locationManager.lastLocation?.coordinate.latitude ?? 0
        var userLongitude = locationManager.lastLocation?.coordinate.longitude ?? 0
        
        lattitude = String(userLatitude)
        longitude = String(userLongitude)
        
        position = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLatitude, longitude: userLongitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        
        reverseGeocoding(latitude: userLatitude, longitude: userLongitude)
    }
    
    func finisher(){
        pickUp.address = ""
        pickUp.lattitude = ""
        pickUp.longitude = ""
        if(doorNo != "" && addressOne != ""){
            pickUp.pickupViewed = true
            pickUp.address = pickUp.address + doorNo + ", " + addressOne
            pickUp.lattitude = lattitude
            pickUp.longitude = longitude
        }
        if(addressTwo != ""){
            pickUp.address = pickUp.address + ", " + addressTwo
        }
    }
    
    var body: some View {
        VStack{
            if(pickUp.items.isEmpty && !pickUp.pickupViewed){
                Button(action:{
                    withAnimation{
                        if(formState == "addressSelect"){
                            formState = "none"
                        }
                        else{
                            formState = "addressSelect"
                        }
                    }
                }){
                    HStack{
                        HStack{
                            Image(systemName: "location")
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(.black.opacity(0.6))
                                .font(.system(size: 17,weight: .medium))
                            Text("Pickup location")
                                .font(.system(size: 17, weight: .medium))
                        }
                        Spacer()
                        if(formState == "addressSelect"){
                            Image(systemName: "chevron.up")
                                .symbolRenderingMode(.hierarchical)
                                .font(.system(size: 17,weight: .semibold))
                        }
                        else{
                            Image(systemName: "chevron.down")
                                .symbolRenderingMode(.hierarchical)
                                .font(.system(size: 17,weight: .semibold))
                        }
                    }
                }
                .foregroundColor(.black.opacity(0.6))
                .disabled(true)
            }
            else{
                Button(action:{
                    withAnimation{
                        if(formState == "addressSelect"){
                            formState = "none"
                        }
                        else{
                            formState = "addressSelect"
                        }
                    }
                }){
                    HStack{
                        HStack{
                            Image(systemName: "location")
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(Color.primaryGreen)
                                .font(.system(size: 17,weight: .medium))
                            Text("Pickup location")
                                .font(.system(size: 17, weight: .medium))
                        }
                        Spacer()
                        if(formState == "addressSelect"){
                            Image(systemName: "chevron.up")
                                .symbolRenderingMode(.hierarchical)
                                .font(.system(size: 17,weight: .semibold))
                        }
                        else{
                            Image(systemName: "chevron.down")
                                .symbolRenderingMode(.hierarchical)
                                .font(.system(size: 17,weight: .semibold))
                        }
                    }
                }
            }
            
            if(formState != "addressSelect" && !pickUp.address.isEmpty){
                HStack(spacing:10){
                    Text("\(pickUp.address)")
                        .font(.system(size: 13,weight: .regular))
                    Spacer()
                }
                .transition(.opacity)
                .padding(.top,5)
                .padding(.leading,10)
            }

            if(formState == "addressSelect"){
                if(!isCurrentLocaton){
                    VStack(spacing:20){
                        TextField("Door No.", text: $doorNo)
                            .font(.system(size: 17))
                            .onChange(of: doorNo){
                                finisher()
                            }
                        Divider()
                        TextField("Address line 1", text: $addressOne)
                            .font(.system(size: 17))
                            .onChange(of: addressOne){
                                finisher()
                            }
                        Divider()
                        TextField("Address line 2.", text: $addressTwo)
                            .font(.system(size: 17))
                        Divider()
                        Button(action:{ useMyLocation() }){
                            HStack{
                                Text("Use current location")
                                Image(systemName: "mappin")
                                    .symbolRenderingMode(.hierarchical)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.secondaryGreen)
                            .cornerRadius(10)
                            .font(.system(size: 17,weight: .regular))
                        }
                    }
                    .transition(.move(edge: .leading))
                    .padding()
                }
                else{
                    VStack{
                        Map(coordinateRegion: $position)
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                            .cornerRadius(10)
                        Text("\(pickUp.address)")
                            .font(.system(size: 13,weight: .regular))
                            .padding(.vertical,5)
                        Button(action:{ 
                            finisher()
                            isCurrentLocaton = false }){
                            HStack{
                                Text("Enter location")
                                Image(systemName: "pencil")
                                    .symbolRenderingMode(.hierarchical)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.secondaryGreen)
                            .cornerRadius(10)
                            .font(.system(size: 17,weight: .regular))
                        }
                    }
                    .transition(.move(edge: .leading))
                    .padding()
                    .task {
                        useMyLocation()
                    }
                }
            }
        }
        .foregroundColor(.black)
    }
}

struct previewAddressSelect: View {
    
    @State var selectedItems: String = ""
    @State var isItemsSelected: Bool = false
    
    @StateObject var pickupData = pickUp()
    
    var body: some View {
        AddressSelect(pickUp: pickupData,formState: $selectedItems)
    }
}

#Preview {
    previewAddressSelect()
}
