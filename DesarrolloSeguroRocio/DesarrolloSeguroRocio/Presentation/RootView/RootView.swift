//
//  RootView.swift
//  DesarrolloSeguroRocio
//
//  Created by Rocio Martos on 18/5/24.
//

import SwiftUI

struct RootView: View {

    // MARK: - Properties
    @EnvironmentObject var rootViewModel: RootViewModel

    var body: some View {
        switch (rootViewModel.status) {
        case Status.none:
            PokemonListView(viewModel: PokemonListViewModel())
            
        case Status.loading:
            Text("Loading")
            
        case Status.loaded:
            TabView {
               PokemonListView(viewModel: PokemonListViewModel())
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                VStack {
                    Button("Logout") {
                        KeychainHelper.keychain.deleteUser()
                        KeychainHelper.keychain.deleteToken()
                        KeychainHelper.keychain.deletePassword()
                        rootViewModel.status = .none
                    }
                    Button("Logout without deleting credentials") {
                        rootViewModel.status = .none
                    }
                }
                    .tabItem {
                        Image(systemName: "gearshape.fill")
                        Text("Settings")
                    }
            }
        }
    }
}

#Preview {
    RootView().environmentObject(RootViewModel(repository: RepositoryImpl(remoteDataSource: RemoteDataSource(urlRequestHelper: URLRequestHelperImpl()))))
}

