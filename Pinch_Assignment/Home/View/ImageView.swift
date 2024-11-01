//
//  ImageView.swift
//  Pinch_Assignment
//
//  Created by Nupur Sharma on 30/10/24.
//
import SwiftUI
import SwiftData

struct ImageView: View {
    var url: String?
    var frame: (width: CGFloat,height:  CGFloat)?
    
    var body: some View {
        
        AsyncImage(url: URL(string: url ?? "")) {  phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFill()
                    .padding(0.0)
                    .clipped()
                   
                    //.background(Color.red)
            } else if phase.error != nil {
                Image(systemName: "questionmark.diamond")
                    .imageScale(.large)
            } else {
                ProgressView()
            }
        }
        .frame(width: frame?.width ?? 0, height: frame?.height ?? 0, alignment: .center)
        .border(Color.gray)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        
    }
}
