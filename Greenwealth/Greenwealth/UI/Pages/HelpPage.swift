import SwiftUI
import MessageUI

struct HelpPage: View {
    
    @ObservedObject var requestModel: requestsModel
    
    @State private var category: String = ""
    @State private var detail: String = ""
    
    @State private var isLogged: Bool = UserDefaults.standard.bool(forKey: "LoginState")
    @State private var loggedUserID: String = UserDefaults.standard.string(forKey: "LoggedUserID") ?? ""
    @State private var loggedUserName: String = UserDefaults.standard.string(forKey: "LoggedUserName") ?? ""
    @State private var loggedUserEmail: String = UserDefaults.standard.string(forKey: "LoggedUserEmail") ?? ""
    
    func addRequest() async{
        try! await requestModel.addNewRequest(userID: Int(loggedUserID)!, userEmail: loggedUserEmail, category: category, detail: detail)
        print(requestModel.responseStatus)
        print(requestModel.responseMessage)
    }
    
    var body: some View {
        VStack{
            TextField("Enter Complaint...", text: $category)
            TextField("Enter Complaint...", text: $detail)
            Button(action:{
                Task{
                    await addRequest()
                }
            }){
                Text("Send")
            }
        }
    }
}

struct previewHelpPage: View {
    
    @State var selectedItems: String = ""
    @State var isOrdered: Bool = true
    
    @StateObject var pickupData = pickUp()
    @StateObject private var requestModel = requestsModel()
    
    var body: some View {
        HelpPage(requestModel: requestModel)
    }
}

#Preview {
    previewHelpPage()
}
