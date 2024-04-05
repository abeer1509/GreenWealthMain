import Foundation
import Supabase

final class pickupsModel: ObservableObject{
    
    @Published var responseStatus = 404
    @Published var responseMessage = "Something went wrong"
    
    @Published var hasActivePickups = false
    @Published var activePickups = [getPickUp]()
    
    @Published var hasPickups = false
    @Published var Pickups = [getPickUp]()
    
    @Published var currentPickupInfo = [getPickUp]()
    @Published var collectorInfo = [getCollectors]()
    
    let supabase = SupabaseClient(supabaseURL: Secrets.projectURL!, supabaseKey: Secrets.apiKey)
    
    func getPickups(userId:Int) async throws{
        let Pickups: [getPickUp] = try await supabase.database
            .from(Tabel.Pickups)
            .select()
            .eq("userId", value: userId)
            .order("id", ascending: true)
            .execute()
            .value
        DispatchQueue.main.sync {
            
            if(Pickups.isEmpty){
                self.hasPickups = false
                self.responseStatus = 201
                self.responseMessage = "No pickups found"
            }
            else{
                self.hasPickups = true
                self.responseStatus = 200
                self.responseMessage = "Pickups found"
            }
            self.Pickups = Pickups
        }
    }
    
    func getActivePickups(userId:Int) async throws{
        let Pickups: [getPickUp] = try await supabase.database
            .from(Tabel.Pickups)
            .select()
            .eq("userId", value: userId)
            .neq("status", value: "completed")
            .neq("status", value: "canceled")
            .order("endTime", ascending: true)
            .execute()
            .value
        DispatchQueue.main.sync {
            
            if(Pickups.isEmpty){
                self.hasActivePickups = false
                self.responseStatus = 201
                self.responseMessage = "No active pickups found"
            }
            else{
                self.hasActivePickups = true
                self.responseStatus = 200
                self.responseMessage = "Active pickups found"
            }
            self.activePickups = Pickups
        }
    }
    
    func addPickup(userId: Int,categories: String,address: String,lattitude: String,longitude: String,date: Date,startTime: Date,endTime: Date) async throws{
        
        var randomInt = Int.random(in: 111111..<999999)
        
        let newPickup = addPickUp(userId: userId, imageURL: Defaults.imageURL, categories: categories, address: address, lattitude: lattitude, longitude: longitude, date: date, startTime: startTime, endTime: endTime, estimatePrice: 0.0, providerId: 0, collectorId: 0, status: "booked", rating: 0,ecoPoints: 0, otp: String(randomInt), finalPrice: 0.0)
        
        let response = try await supabase.database
            .from(Tabel.Pickups)
            .insert(newPickup)
            .execute()
        print(response.status)
        self.responseStatus = 200
        self.responseMessage = "Pickup scheduled successfully"
        
    }
    
    func cancelPickup(pickupID: Int) async throws{
        try await supabase.database
            .from(Tabel.Pickups)
            .update(["status":"canceled"])
            .eq("id", value: pickupID)
            .execute()
        self.responseStatus = 200
        self.responseMessage = "Order cancled"
    }
    
    func getCurrentPickup(pickupId: Int) async throws{
        
        //self.currentPickupInfo = []
        
        let Pickups: [getPickUp] = try await supabase.database
            .from(Tabel.Pickups)
            .select()
            .eq("id", value: pickupId)
            .order("endTime", ascending: true)
            .execute()
            .value
        DispatchQueue.main.sync {
            
            if(Pickups.isEmpty){
                self.hasActivePickups = false
                self.responseStatus = 201
                self.responseMessage = "No active pickups found"
            }
            else{
                self.hasActivePickups = true
                self.responseStatus = 200
                self.responseMessage = "Active pickups found"
            }
            self.currentPickupInfo = Pickups
            print(self.currentPickupInfo)
        }
    }
    
    func completeOrder(pickupId: Int, rating: Int) async throws{
        try await supabase.database
            .from(Tabel.Pickups)
            .update(["rating":rating])
            .eq("id", value: pickupId)
            .execute()
        try await supabase.database
            .from(Tabel.Pickups)
            .update(["status":"completed"])
            .eq("id", value: pickupId)
            .execute()
        self.responseStatus = 200
        self.responseMessage = "Order completed"
    }
    
    func getCollectorDetails(collectorId: Int) async throws{
        
        self.collectorInfo = []
        
        let Collectors: [getCollectors] = try await supabase.database
            .from(Tabel.Collectors)
            .select()
            .eq("id", value: collectorId)
            .order("fullName",ascending: false)
            .execute()
            .value
        DispatchQueue.main.async {
            
            self.responseStatus = 200
            self.responseMessage = "Found user"
            self.collectorInfo = Collectors
        }
        
    }
    
}
