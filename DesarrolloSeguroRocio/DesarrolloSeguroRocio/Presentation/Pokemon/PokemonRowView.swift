//
//  PokemonRowView.swift
//  DesarrolloSeguroRocio
//
//  Created by Rocio Martos on 18/5/24.
//

import SwiftUI
struct PokemonRowView: View {
    let pokemonCompuesto: PokemonCompuesto

        var body: some View {
            HStack {
                if let frontImageURLString = pokemonCompuesto.pokemonDetail.sprites.front_default,
                   let frontImageURL = URL(string: frontImageURLString) {
                    AsyncImage(url: frontImageURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                    } placeholder: {
                        ProgressView()
                    }
                } else {
                    Image(systemName: "questionmark.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                }
                
                Text(pokemonCompuesto.pokemon.name.capitalized)
                    .font(.headline)
            }
        }
    }

    struct PokemonRowView_Previews: PreviewProvider {
        static var previews: some View {
            let pokemon = Pokemon(name: "Pikachu", url: "https://pokeapi.co/api/v2/pokemon/25/")
            let pokemonDetail = PokemonDetail(id: 25, name: "Pikachu", height: 4, weight: 60, sprites: Sprites(front_default: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png"), abilities: [])
            let pokemonCompuesto = PokemonCompuesto(pokemon: pokemon, pokemonDetail: pokemonDetail)

            return PokemonRowView(pokemonCompuesto: pokemonCompuesto)
        }
    }

