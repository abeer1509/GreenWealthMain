//
//  ItemSelect.swift
//  Greenwealth
//
//  Created by user1 on 10/01/24.
//

import SwiftUI

struct ItemSelect: View {
    
    @ObservedObject var pickUp: pickUp
    @Binding var formState: String
    
    @State var selectedItems: [String] = []
    @State var customItem: String = ""
    
    func finisher(){
        pickUp.items = ""
        pickUp.estimatedPrice = 0.0
        for i in 0..<selectedItems.count{
            if( i == selectedItems.count-1){
                pickUp.items += selectedItems[i]
            }
            else{
                pickUp.items += selectedItems[i]
                pickUp.items += ","
            }
        }
    }
    var itemsList: [String] = ["Paper","Plastic","Metal","Furniture","Electronics","Clothes"]
    
    var body: some View {
        VStack{
            if(pickUp.image.isEmpty  && !pickUp.pickupViewed){
                Button(action:{
                    withAnimation{
                        if(formState == "itemsSelect"){
                            formState = "none"
                        }
                        else{
                            formState = "itemsSelect"
                        }
                    }
                }){
                    HStack{
                        HStack{
                            Image(systemName: "trash")
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(.black.opacity(0.6))
                                .font(.system(size: 17,weight: .medium))
                            Text("Select waste categories")
                                .font(.system(size: 17, weight: .medium))
                        }
                        Spacer()
                        if(formState == "itemsSelect"){
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
                .animation(.easeInOut(duration: 1.0))
                .foregroundColor(.black.opacity(0.6))
                .disabled(true)
            }
            else{
                Button(action:{
                    withAnimation{
                        if(formState == "itemsSelect"){
                            formState = "none"
                        }
                        else{
                            formState = "itemsSelect"
                        }
                    }
                }){
                    HStack{
                        HStack{
                            Image(systemName: "trash")
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(Color.primaryGreen)
                                .font(.system(size: 17,weight: .medium))
                            Text("Select waste categories")
                                .font(.system(size: 17, weight: .medium))
                        }
                        Spacer()
                        if(formState == "itemsSelect"){
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
                    .animation(.easeInOut(duration: 1.0))
                }
            }
            if( formState != "itemsSelect" && !pickUp.items.isEmpty){
                HStack(spacing:10){
                    Text("\(pickUp.items)")
                        .font(.system(size: 13,weight: .regular))
                    Spacer()
                }
                .padding(.top,5)
                .padding(.leading,10)
                .transition(.opacity)
            }
            if(formState == "itemsSelect"){
                VStack{
                    ForEach(0..<itemsList.count){ i in
                        if(selectedItems.contains(itemsList[i])){
                            Button(action:{
                                selectedItems.remove(at: selectedItems.firstIndex(of: itemsList[i])!)
                                finisher()
                            }){
                                HStack{
                                    Text(itemsList[i])
                                        .font(.system(size: 17,weight: .medium))
                                    Spacer()
                                    Image(systemName: "checkmark.circle")
                                        .symbolRenderingMode(.hierarchical)
                                        .font(.system(size: 17,weight: .semibold))
                                        .foregroundColor(Color.primaryGreen)
                                }
                            }
                            .padding(.vertical,10)
                        }
                        else{
                            Button(action:{ selectedItems.append(itemsList[i])
                                finisher()
                            }){
                                HStack{
                                    Text(itemsList[i])
                                        .font(.system(size: 17,weight: .medium))
                                    Spacer()
                                    Image(systemName: "checkmark.circle")
                                        .symbolRenderingMode(.hierarchical)
                                        .font(.system(size: 17,weight: .semibold))
                                }
                            }
                            .padding(.vertical,10)
                        }
                        Divider()
                    }
                    if(selectedItems.contains(customItem)){
                        Button(action:{
                            selectedItems.remove(at: selectedItems.firstIndex(of: customItem)!)
                            finisher()
                        }){
                            HStack{
                                Text(customItem)
                                    .font(.system(size: 17,weight: .medium))
                                Spacer()
                                Button(action:{}){
                                    Image(systemName: "checkmark.circle")
                                        .symbolRenderingMode(.hierarchical)
                                        .font(.system(size: 17,weight: .semibold))
                                        .foregroundColor(Color.primaryGreen)
                                }
                            }
                        }
                        .padding(.vertical,10)
                    }
                    else{
                        HStack{
                            TextField("Enter custom item", text: $customItem)
                                .font(.system(size: 17,weight: .medium))
                                .autocorrectionDisabled(true)
                            Spacer()
                            Button(action:{
                                if(customItem != ""){
                                    selectedItems.append(customItem)
                                    finisher()
                                }}){
                                Image(systemName: "plus.circle")
                                    .symbolRenderingMode(.hierarchical)
                                    .font(.system(size: 17,weight: .semibold))
                            }
                        }
                        .padding(.vertical,10)
                    }
                }
                .transition(.move(edge: .leading))
                .padding()
            }
        }
        .foregroundColor(.black)
    }
}

struct previewItemSelect: View {
    
    @State var selectedItems: String = ""
    @State var isItemsSelected: Bool = false
    
    @StateObject var pickupData = pickUp()
    
    var body: some View {
        ItemSelect(pickUp: pickupData,formState:$selectedItems)
    }
}

#Preview {
    previewItemSelect()
}
