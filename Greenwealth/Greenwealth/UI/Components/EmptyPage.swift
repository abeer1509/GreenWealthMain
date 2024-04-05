//
//  EmptyPage.swift
//  Greenwealth
//
//  Created by user1 on 05/02/24.
//

import SwiftUI

struct EmptyPage: View {
    var body: some View {
        ZStack{
            Text("No Records Found")
        }
        .frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity)
    }
}

#Preview {
    EmptyPage()
}
