import SwiftUI

struct SigninPage: View {
    
    @ObservedObject var userModel: usersModel
    @ObservedObject var pickupModel: pickupsModel
    @Binding var pageState: String
    @Binding var previousPageState: String
    
    @State var userName: String = ""
    @State var passWord: String = ""
    @State var isPasswordVissible: Bool = false
    
    @State var formErrors: [String] = ["",""]
    
    @State var isToastPresented: Bool = false
    @State var toastMessage: String = ""
    
    @State var isPageLoading: Bool = false
    
    func formValidation()->Bool{
        
        var isFormValid: Bool = true
        
        if(userName == ""){
            isFormValid = false
            formErrors[0] = "Email ID is required"
        }
        else if( !userName.contains("@") || !userName.contains(".com")){
            isFormValid = false
            formErrors[0] = "Enter a valid Email ID"
        }
        
        if(passWord == ""){
            isFormValid = false
            formErrors[1] = "Password is required"
        }
        
        return isFormValid
        
    }
    
    func loginUser() async{
        
        if(formValidation()){
            
            isPageLoading.toggle()
            
            try? await userModel.loginUser(emailAddress: userName, password: passWord)
            
            if(userModel.isLogged){
                UserDefaults.standard.set(true,forKey: "LoginState")
                UserDefaults.standard.set(userModel.users.first!.id,forKey: "LoggedUserID")
                UserDefaults.standard.set(userModel.users.first!.fullName,forKey: "LoggedUserName")
                UserDefaults.standard.set(userModel.users.first!.emailAddress,forKey: "LoggedUserEmail")
                
                try? await userModel.getUser(emailAddress: userModel.users.first!.emailAddress)
                try? await userModel.getStats()
                try? await pickupModel.getActivePickups(userId: userModel.users.first!.id!)
                try? await pickupModel.getPickups(userId: userModel.users.first!.id!)
                
                pageState = "DashboardPage"
            }
            else{
                
                isPageLoading.toggle()
                
                UserDefaults.standard.set(false,forKey: "LoginState")
                UserDefaults.standard.set("",forKey: "LoggedUserID")
                UserDefaults.standard.set("",forKey: "LoggedUserName")
                UserDefaults.standard.set("",forKey: "LoggedUserEmail")
                
                toastMessage = "Invalid Credentials"
                isToastPresented.toggle()
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                    withAnimation{
                        isToastPresented.toggle()
                    }
                
            }
        }
        
    }
    
    var body: some View {
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
            VStack{
                VStack{
                    HStack{
                        Button(action:{
                            withAnimation{
                                pageState = "DashboardPage"
                            }
                        }){
                            Image(systemName: "chevron.left")
                                .symbolRenderingMode(.hierarchical)
                        }
                        Spacer()
                    }
                    .font(.system(size: 17,weight: .medium))
                    .foregroundColor(.black)
                    Spacer()
                    Image(systemName: "arrow.3.trianglepath")
                        .symbolRenderingMode(.hierarchical)
                        .font(.system(size: 60,weight: .black))
                        .foregroundColor(Color.primaryGreen)
                        .padding(.vertical,40)
                    Button(action:{}){
                        Text("Sign in with Apple")
                            .padding()
                            .font(.system(size: 17,weight: .bold))
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .background(.black)
                            .cornerRadius(10)
                    }
                    HStack{
                        VStack{
                            Divider()
                        }
                        Text("or")
                            .font(.system(size: 14))
                            .padding(.horizontal,10)
                        VStack{
                            Divider()
                        }
                    }
                    .padding(.vertical,20)
                    VStack(spacing:20){
                        VStack(alignment:.leading){
                            if(formErrors[0] != ""){
                                Text("\(formErrors[0])")
                                    .font(.system(size: 13,weight: .medium))
                                    .foregroundColor(.red)
                            }
                            VStack{
                                TextField("Enter your email",text: $userName)
                                    .autocapitalization(.none)
                                    .autocorrectionDisabled(true)
                                    .onChange(of: userName){
                                        formErrors[0] = ""
                                    }
                            }
                            .padding()
                            .background(Color.primaryBackground)
                            .cornerRadius(10)
                        }
                        VStack(alignment:.leading){
                            if(formErrors[1] != ""){
                                Text("\(formErrors[1])")
                                    .font(.system(size: 13,weight: .medium))
                                    .foregroundColor(.red)
                            }
                            HStack{
                                if(isPasswordVissible){
                                    TextField("Enter your password",text: $passWord)
                                        .autocapitalization(.none)
                                        .autocorrectionDisabled(true)
                                        .onChange(of: passWord){
                                            formErrors[1] = ""
                                        }
                                    Button(action:{
                                        withAnimation{
                                            isPasswordVissible.toggle()
                                        }
                                    }){
                                        Image(systemName: "eye")
                                            .symbolRenderingMode(.hierarchical)
                                    }
                                }
                                else{
                                    SecureField("Enter your password",text: $passWord)
                                        .autocapitalization(.none)
                                        .autocorrectionDisabled(true)
                                        .onChange(of: passWord){
                                            formErrors[1] = ""
                                        }
                                    Button(action:{
                                        withAnimation{
                                            isPasswordVissible.toggle()
                                        }
                                    }){
                                        Image(systemName: "eye.slash")
                                            .symbolRenderingMode(.hierarchical)
                                    }
                                }
                            }
                            .padding()
                            .foregroundColor(.black)
                            .background(Color.primaryBackground)
                            .cornerRadius(10)
                        }
                        if(isPageLoading){
                            Button(action:{}){
                                Text("Loading...")
                                    .padding()
                                    .font(.system(size: 17,weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.primaryGreen.opacity(0.5))
                                    .cornerRadius(10)
                            }
                            .disabled(true)
                        }
                        else{
                            Button(action:{
                                Task{
                                    do{
                                        try? await loginUser()
                                    }
                                    catch{
                                        print("Cathc Error: ")
                                        print(error)
                                    }
                                }
                            }){
                                Text("Sign in")
                                    .padding()
                                    .font(.system(size: 17,weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.primaryGreen)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    VStack{
                        Button(action:{}){
                            Text("Forgot password?")
                                .padding()
                                .font(.system(size: 17,weight: .regular))
                                .foregroundColor(.black)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.vertical,20)
                }
                .padding(.horizontal,20)
                Spacer()
                VStack{
                    HStack(spacing:5){
                        Text("Don't have an account?")
                        Button(action:{
                            withAnimation{
                                pageState = "SignupPage"
                            }
                        }){
                            Text("Signup")
                                .font(.system(size: 17,weight: .bold))
                                .foregroundColor(.black)
                                .cornerRadius(10)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top)
                .overlay(
                    Rectangle()
                        .frame(height: 1, alignment: .bottom)
                        .foregroundColor(.black.opacity(0.25)),
                    alignment: .top
                )
            }
        }
        .animation(.easeInOut(duration: 0.7))
    }
}

struct SigninPreview: View {
    
    @State var pageState: String = "loginPage"
    @StateObject private var userModel = usersModel()
    @StateObject private var pickupModel = pickupsModel()
    
    var body: some View {
        SigninPage(userModel: userModel, pickupModel: pickupModel,pageState: $pageState, previousPageState: $pageState)
    }
}

#Preview {
    SigninPreview()
}
