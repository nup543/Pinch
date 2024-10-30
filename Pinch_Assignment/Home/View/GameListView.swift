//
//  GameListView.swift
//  Pinch_Assignment
//
//  Created by Nupur Sharma on 30/10/24.
//

import SwiftUI
import SwiftData

struct GameListView: View {
    var item: Item?
    
    var body: some View {
        VStack (alignment: .center, spacing: 10) {
            ImageView(url: APIClient.shared.getCoverImgURL(for: item?.cover?.imageId), frame: (60, 60))
            Text("\(item?.name ?? "")")
                .font(.system(size: 15))
        }
    }
}
#Preview {
    GameListView(item: Item.example())
}
