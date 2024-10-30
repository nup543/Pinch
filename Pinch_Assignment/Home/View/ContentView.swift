//  ContentView.swift
//  Pinch_Assignment
//  Created by Nupur Sharma on 25/10/24.

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State var viewModel: GameViewModel!
    @Query(sort: \Item.name , order: .forward) private var items: [Item]
    var monitor = Reachability()
   
    var body: some View {
        NavigationView {
            List {
                ForEach(items, id: \.id) { item in
                    NavigationLink(destination: GameDetailView(item: item, viewModel: viewModel)){
                        GameListView(item: item, viewModel: viewModel)
                            .frame(maxWidth: .infinity)
                    }.listRowSeparator(.hidden)
                }
            }
            .navigationTitle("Games")
            .navigationBarTitleDisplayMode(.large)
            .refreshable {
                do {
                    try await viewModel.fetchData()
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
            .onAppear {
                self.viewModel = GameViewModel(modelContext: modelContext)
            }
            .task {
                if monitor.connected == .connected {
                    do {
                        try await viewModel.fetchData()
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
