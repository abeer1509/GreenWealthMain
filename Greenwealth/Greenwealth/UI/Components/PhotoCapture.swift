import SwiftUI
import PhotosUI

struct PhotoCapture: View {
    
    @ObservedObject var pickUp: pickUp
    
    @State var isExpanded: Bool = false
    @State var isImageSelected: Bool = false
    @State var imageSelected = UIImage()
    
    var body: some View {
        VStack{
            Button(action:{
                withAnimation{
                    isExpanded.toggle()
                    pickUp.image = "Selected"
                }
            }){
                HStack{
                    HStack{
                        Image(systemName: "camera")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(Color.primaryGreen)
                            .font(.system(size: 17,weight: .medium))
                        Text("Click a picture")
                            .font(.system(size: 17, weight: .medium))
                    }
                    Spacer()
                    if(isExpanded){
                        Image(systemName: "chevron.left")
                            .symbolRenderingMode(.hierarchical)
                            .font(.system(size: 17,weight: .semibold))
                    }
                    else{
                        Image(systemName: "chevron.right")
                            .symbolRenderingMode(.hierarchical)
                            .font(.system(size: 17,weight: .semibold))
                    }
                }
            }.fullScreenCover(isPresented: $isExpanded) {
                ImagePicker(selectedImage: $imageSelected, isImageSelected: $isImageSelected, pickUp: pickUp, sourceType: .camera).frame(maxHeight: .infinity).ignoresSafeArea(.all)
            }
            if(!isExpanded && !pickUp.image.isEmpty){
                HStack(spacing:10){
//                    Image(uiImage: imageSelected)
//                        .resizable()
//                        .frame(width: 150,height: 100)
//                        .background(Color.primaryBackground)
//                        .font(.system(size: 13,weight: .regular))
                    Image("demo")
                        .resizable()
                        .frame(width: 150,height: 100)
                        .background(Color.primaryBackground)
                        .font(.system(size: 13,weight: .regular))
                    Spacer()
                }
                .padding(.top,5)
                .padding(.leading,10)
                .transition(.opacity)
            }
        }
        .foregroundColor(.black)
        .frame(maxHeight: .infinity)
        .background(.white)
    }
}

struct previewPhotoCapture: View {
    
    @StateObject var pickupData: pickUp = pickUp()
    
    var body: some View {
        PhotoCapture(pickUp: pickupData)
    }
}

#Preview {
    previewPhotoCapture()
}
