//
//  PokemonListView.swift
//  DesarrolloSeguroRocio
//
//  Created by Rocio Martos on 18/5/24.
//

import SwiftUI

struct PokemonListView: View {
    @State private var loadedPokemonCompuestos: [PokemonCompuesto] = []
    @State private var filter: String = ""
    @StateObject private var viewModel: PokemonViewModel
        
        init() {
           
            let remoteDataSource = RemoteDataSource(urlRequestHelper: URLRequestHelperImpl(obfuscatedURL: "\(Endpoints().baseURL)\(Endpoints().pokemonEndpoint)"))
            _viewModel = StateObject(wrappedValue: PokemonViewModel(remoteDataSource: remoteDataSource))
        }
        
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading && loadedPokemonCompuestos.isEmpty {
                    ProgressView("Loading Pokémon...")
                        .scaleEffect(1.5, anchor: .center)
                } else {
                    List(loadedPokemonCompuestos) { pokemonCompuesto in
                        NavigationLink(destination: PokemonDetailView(pokemonDetail: pokemonCompuesto.pokemonDetail)) {
                            PokemonRowView(pokemonCompuesto: pokemonCompuesto)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Pokémon List")
            .onAppear {
                Task {
                     viewModel.fetchPokemonList()
                }
            }
        }
        .searchable(text: $filter, prompt: Text("Buscar por nombre"))
        .onChange(of: viewModel.pokemonCompuestoList) { newPokemonCompuestos in
            loadedPokemonCompuestos = newPokemonCompuestos
        }
    }
}
struct PokemonListView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListView()
    }
}
