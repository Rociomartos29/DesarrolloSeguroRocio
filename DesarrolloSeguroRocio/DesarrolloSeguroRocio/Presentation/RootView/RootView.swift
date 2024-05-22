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
      @State private var isAuthenticated = false // Estado para controlar si la autenticación es exitosa
      @State private var isNavigationActive = false // Estado para controlar la navegación
      
      var body: some View {
          NavigationView {
              ZStack {
                  // Fondo de la imagen
                  Image("Fondo")
                      .resizable()
                      .aspectRatio(contentMode: .fill)
                      .edgesIgnoringSafeArea(.all)
                      .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
              }
              .onAppear {
                  // Realiza la autenticación del usuario al aparecer la vista
                  rootViewModel.authenticateUser { success in
                      if success {
                          // Si la autenticación es exitosa, establece el estado como cargado
                          rootViewModel.status = .loaded
                          
                          // Navegar a PokemonListView
                          isNavigationActive = true
                      } else {
                          // Si la autenticación falla, vuelvo al estado de ninguno
                          rootViewModel.status = .none
                      }
                  }
              }
              .navigationBarHidden(true) // Oculta la barra de navegación
              .navigationTitle("") // Elimina el título de la barra de navegación
              .navigationBarItems(trailing:
                  Button(action: {
                      // Aquí pones la lógica para el logout
                  }) {
                      Text("Logout")
                  }
              )
              .background(
                  NavigationLink(
                      destination: PokemonListView(), 
                      isActive: $isNavigationActive,
                      label: EmptyView.init
                  )
              )
          }
      }
  }
   struct RootView_Previews: PreviewProvider {
       static var previews: some View {
           RootView().environmentObject(RootViewModel(repository: RepositoryImpl(remoteDataSource: RemoteDataSource(urlRequestHelper: URLRequestHelperImpl(obfuscatedURL: "\(Endpoints().baseURL)\(Endpoints().pokemonEndpoint)")))))
       }
   }

  
