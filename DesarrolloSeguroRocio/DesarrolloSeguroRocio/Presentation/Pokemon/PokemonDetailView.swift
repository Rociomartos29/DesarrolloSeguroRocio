//
//  PokemonDetailView.swift
//  DesarrolloSeguroRocio
//
//  Created by Rocio Martos on 18/5/24.
//

import SwiftUI

struct PokemonDetailView: View {
    let pokemon: Pokemon
    
    var body: some View {
        Text("Details for \(pokemon.name.capitalized)")
            .navigationTitle(pokemon.name.capitalized)
    }
}
