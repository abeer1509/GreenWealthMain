//
//  SlotSelect.swift
//  Greenwealth
//
//  Created by user1 on 10/01/24.
//

import SwiftUI

struct SlotSelect: View {
    
    @ObservedObject var pickUp: pickUp
    @Binding var formState: String
    
    @State var pickupDate: Date = Date.now
    @State var pickupFromTime: Date = Date.now
    @State var pickupToTime: Date = Date.now
    
    var body: some View {
        VStack{
            if(pickUp.address.isEmpty && !pickUp.pickupViewed){
                Button(action:{
                    withAnimation{
                        if(formState == "slotSelect"){
                            formState = "none"
                        }
                        else{
                            formState = "slotSelect"
                        }
                    }
                }){
                    HStack{
                        HStack{
                            Image(systemName: "calendar")
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(.black.opacity(0.6))
                                .font(.system(size: 17,weight: .medium))
                            Text("Pickup slot")
                                .font(.system(size: 17, weight: .medium))
                        }
                        Spacer()
                        if(formState == "slotSelect"){
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
                        if(formState == "slotSelect"){
                            formState = "none"
                        }
                        else{
                            formState = "slotSelect"
                        }
                    }
                }){
                    HStack{
                        HStack{
                            Image(systemName: "calendar")
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(Color.primaryGreen)
                                .font(.system(size: 17,weight: .medium))
                            Text("Pickup slot")
                                .font(.system(size: 17, weight: .medium))
                        }
                        Spacer()
                        if(formState == "slotSelect"){
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
            if(formState != "slotSelect" && ( !pickUp.address.isEmpty || pickUp.pickupViewed )){
                HStack(spacing:5){
                    Text("On")
                        .font(.system(size: 10,weight: .regular))
                    Text(pickUp.date.formatted(date: .abbreviated,time: .omitted))
                        .font(.system(size: 13,weight: .medium))
                    Text("Between")
                        .font(.system(size: 10,weight: .regular))
                    Text(pickUp.fromTime.formatted(date:.omitted,time: .shortened))
                        .font(.system(size: 13,weight: .medium))
                    Text("&")
                        .font(.system(size: 10,weight: .regular))
                    Text(pickUp.toTime.formatted(date:.omitted,time: .shortened))
                        .font(.system(size: 13,weight: .medium))
                    Spacer()
                }
                .padding(.top,5)
                .padding(.leading,10)
                .transition(.opacity)
            }
            if(formState == "slotSelect"){
                HStack{
                    DatePicker("",selection: $pickupDate, in: Calendar.current.date(byAdding: .day, value: 0, to: Date.now)! ... Calendar.current.date(byAdding: .day, value: 5, to: Date.now)!)
                        .labelsHidden()
                        .datePickerStyle(.wheel)
                        .transition(.move(edge: .leading))
                        .onChange(of: pickupDate){
                            pickUp.date = pickupDate
                            pickUp.fromTime = pickupDate
                            pickUp.toTime = Calendar.current.date(byAdding: .hour, value: 2, to: pickupDate)!
                        }
                }
            }
        }
        .foregroundColor(.black)
    }
}

struct previewSlotSelect: View {
    
    @State var formState: String = ""
    @StateObject var pickupData: pickUp = pickUp()
    
    var body: some View {
        SlotSelect(pickUp: pickupData,formState: $formState)
    }
}

#Preview {
    previewSlotSelect()
}
