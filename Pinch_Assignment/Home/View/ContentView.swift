//  ContentView.swift
//  Pinch_Assignment
//  Created by Nupur Sharma on 25/10/24.

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    var apiClient = APIClient()
    @Query(sort: \Item.name , order: .forward) private var items: [Item]
    var monitor = Reachability()
   
    var body: some View {
        NavigationView {
            List {
                ForEach(items, id: \.id) { item in
                    Text("\(item.name)")
                }
            }
            .navigationTitle("Games")
            .navigationBarTitleDisplayMode(.large)
            .overlay{
                
                if items.isEmpty {
                    ProgressView()
                }
                
//                if items.isEmpty {
//                    ContentUnavailableView {
//                        Label("No game available", systemImage: "list.bullet.rectangle.portrait")
//                    }
//                    .offset(y: -60)

              //  }
            }
//            .onAppear {
//              //  let _ = Reachability()
//            }
            .task {
                            
                if monitor.connected == .connected {
                        do {
                            try await APIClient.shared.fetchData(modelContext: modelContext)
                        }
                        catch {
                            print(error)
                        }
                    
                    } else {
                        
                        let fetchDescriptor = FetchDescriptor<Item>()
                        do {
                           let val = try modelContext.fetch(fetchDescriptor)
                            print("val \n \(val)")
                        } catch {
                            print("Error")
                        }
                    }
                
            }
        }
    }
}

#Preview {
    //    ContentView()
    //        .modelContainer(for: [Item.self,Cover.self], inMemory: false)
//    do {
//        let config = ModelConfiguration(isStoredInMemoryOnly: true)
//        let container = try ModelContainer(for: Item.self, configurations: config)
//        let sampleObject = Item(
//            albumId: 1,
//            id: 1,
//            title: "accusamus beatae ad facilis cum similique qui sunt",
//            url: "https://via.placeholder.com/600/92c952",
//            thumbnailUrl: "https://via.placeholder.com/150/92c952"
//        )
//        container.mainContext.insert(sampleObject)
//        
//        ContentView().modelContainer(container)
//    } catch {
//        fatalError("Failed to create model container")
//    }
}
