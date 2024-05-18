//
//  PokemonRowView.swift
//  DesarrolloSeguroRocio
//
//  Created by Rocio Martos on 18/5/24.
//

import SwiftUI

struct PokemonRowView: View {
    let pokemon: Pokemon
    
    var body: some View {
        VStack{
            Text(pokemon.name.capitalized)
                .font(.title)
                .foregroundStyle(.orange)
                .bold()
        }
    }
}

/* Para la vista previa
#Preview{
    PokemonRowView(pokemon: Pokemon())
}
 /**/*/
