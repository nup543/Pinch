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
            ImageView(url: GameViewModel.shared.getCoverImgURL(for: item?.cover?.imageId),frame: (200, 180))
            Text("\(item?.name ?? "")")
                .font(.system(size: 25))
            HStack {
                Text("Since \((item?.createdAt ?? 0).getDateStringFromUnixTime())")
                    .font(.system(size: 14))
                Spacer()
                Link(destination: URL(string: item?.websiteURL ?? "www.google.com")!) {
                    Label("Webpage", systemImage: "link")
                        .font(.footnote)
                        .foregroundColor(.blue)
                }
            }
            .padding(.bottom, 20)
            Text("\(item?.summary ?? "-")")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.pink)
            Spacer()
        }
        .padding()
        .toolbarRole(.editor)
    }
}
#Preview {
    GameDetailView(item: Item.example())
}
