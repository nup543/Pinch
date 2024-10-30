//
//  GameDetailView.swift
//  Pinch_Assignment
//
//  Created by Nupur Sharma on 29/10/24.
//

import SwiftUI
import SwiftData

struct GameDetailView: View {
   var item: Item?
   
    var body: some View {
        
        VStack (spacing: 15) {
            ImageView(url: APIClient.shared.getCoverImgURL(for: item?.cover?.imageId),
                                                           frame: (200, 180))
            Text("\(item?.name ?? "")")
                .font(.system(size: 25))
            Spacer()
        }
        .padding()
        .toolbarRole(.editor)
    }
}
#Preview {
    GameDetailView(item: Item.example())
}
