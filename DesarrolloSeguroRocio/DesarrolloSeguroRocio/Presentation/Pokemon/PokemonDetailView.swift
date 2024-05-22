//
//  PokemonDetailView.swift
//  DesarrolloSeguroRocio
//
//  Created by Rocio Martos on 18/5/24.
//

import SwiftUI

struct PokemonDetailView: View {
    let pokemonDetail: PokemonDetail

        var body: some View {
            VStack {
                if let frontImageURLString = pokemonDetail.sprites.front_default,
                   let frontImageURL = URL(string: frontImageURLString) {
                    AsyncImage(url: frontImageURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                    } placeholder: {
                        ProgressView()
                    }
                } else {
                    Image(systemName: "questionmark.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                }
                
                Text(pokemonDetail.name.capitalized)
                    .font(.largeTitle)
                    .padding()
                
                Text("Height: \(pokemonDetail.height)")
                    .font(.subheadline)
                    .padding(.top, 2)
                
                Text("Weight: \(pokemonDetail.weight)")
                    .font(.subheadline)
                    .padding(.top, 2)
                
                if !pokemonDetail.abilities.isEmpty {
                    Text("Abilities")
                        .font(.headline)
                        .padding(.top, 10)
                    
                    ForEach(pokemonDetail.abilities, id: \.slot) { ability in
                        Text(ability.ability.name.capitalized)
                    }
                }
            }
            .padding()
        }
    }

    struct PokemonDetailView_Previews: PreviewProvider {
        static var previews: some View {
            let sprites = Sprites(front_default: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png")
            let abilities = [Ability(ability: AbilityDetail(name: "Static", url: "https://pokeapi.co/api/v2/ability/9/"), is_hidden: false, slot: 1)]
            let pokemonDetail = PokemonDetail(id: 25, name: "Pikachu", height: 4, weight: 60, sprites: sprites, abilities: abilities)

            return PokemonDetailView(pokemonDetail: pokemonDetail)
        }
    }
