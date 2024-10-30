//  ContentView.swift
//  Pinch_Assignment
//  Created by Nupur Sharma on 25/10/24.

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    var apiClient = GameViewModel()
    @Query(sort: \Item.name , order: .forward) private var items: [Item]
    var monitor = Reachability()
   
    var body: some View {
        NavigationView {
            List {
                ForEach(items, id: \.id) { item in
                    NavigationLink(destination: GameDetailView(item: item)){
                        GameListView(item: item)
                            .frame(maxWidth: .infinity)
                    }.listRowSeparator(.hidden)
                }
            }
            .navigationTitle("Games")
            .navigationBarTitleDisplayMode(.large)
            .refreshable {
                do {
                    try await GameViewModel.shared.fetchData(modelContext: modelContext)
                }
                catch {
                    print(error)
                }
            }
            .overlay{
                
                if items.isEmpty {
                    ProgressView()
                }
            }
            
            .task {
                if monitor.connected == .connected {
                    do {
                        try await GameViewModel.shared.fetchData(modelContext: modelContext)
                    }
                    catch {
                        print(error)
                    }
                }
                
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self)
}
