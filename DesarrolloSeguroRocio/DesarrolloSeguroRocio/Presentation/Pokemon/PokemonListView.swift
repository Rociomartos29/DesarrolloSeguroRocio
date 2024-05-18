//
//  PokemonListView.swift
//  DesarrolloSeguroRocio
//
//  Created by Rocio Martos on 18/5/24.
//

import SwiftUI

struct PokemonListView: View {
    @ObservedObject var viewModel: PokemonListViewModel
    
    var body: some View {
            NavigationView {
                ZStack {
                    // Imagen de fondo
                    Image("Fondo")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                        .opacity(0.2) // Ajusta la opacidad según tu
                    
                    // Contenido de la vista (lista de Pokémon)
                    VStack {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .padding()
                        } else {
                            List(viewModel.pokemonList) { pokemon in
                                NavigationLink(destination: PokemonDetailView(pokemon: pokemon)) {
                                    PokemonRowView(pokemon: pokemon)
                                }
                            }
                        }
                    }
                    .navigationTitle("Pokémon List")
                }
                .onAppear {
                    viewModel.fetchPokemonList()
                }
            }
        }
    }
#Preview{
    PokemonListView(viewModel: PokemonListViewModel())
}
