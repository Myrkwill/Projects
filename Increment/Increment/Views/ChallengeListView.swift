//
//  ChallengeListView.swift
//  Increment
//
//  Created by Mark Nagibin on 27.05.2021.
//

import SwiftUI

struct ChallengeListView: View {
    
    @StateObject private var viewModel = ChallengeListViewModel()
    
    var mainContentView: some View {
        ScrollView {
            VStack {
                LazyVGrid(columns: [.init(.flexible(), spacing: 20), .init(.flexible())], spacing: 20) {
                    ForEach(viewModel.itemViewModels, id: \.id) { viewModel in
                        ChallengeItemView(viewModel: viewModel)
                    }
                }
                Spacer()
            }
            .padding(10)
        }
        .sheet(isPresented: $viewModel.showingCreateModal) {
            NavigationView {
                CreateView()
            }
        }
        .navigationBarItems(trailing: Button {
            viewModel.send(action: .create)
        } label: {
            Image(systemName: "plus.circle")
                .imageScale(.large)
        })
        .navigationTitle(viewModel.title)
    }
    
    var body: some View {
        if viewModel.isLoading {
            ProgressView()
        } else if let error = viewModel.error {
            VStack {
                Text(error.localizedDescription)
                Button("Retry") {
                    viewModel.send(action: .retry)
                }
                .padding(10)
                .background(
                    Rectangle()
                        .fill(Color.red)
                        .cornerRadius(5)
                )
            }
        } else {
            mainContentView
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.significantTimeChangeNotification)) { _ in
                    viewModel.send(action: .timeChange)
                }
        }
    }
    
}

struct ChallengeListView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeListView()
    }
}
