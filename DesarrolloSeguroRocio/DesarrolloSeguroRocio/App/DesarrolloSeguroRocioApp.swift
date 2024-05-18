//
//  DesarrolloSeguroRocioApp.swift
//  DesarrolloSeguroRocio
//
//  Created by Rocio Martos on 18/5/24.
//

import SwiftUI

@main
struct DesarrolloSeguroRocioApp: App {
    @StateObject private var rootViewModel = RootViewModel(repository: RepositoryImpl(remoteDataSource: RemoteDataSource(urlRequestHelper: URLRequestHelperImpl())))
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(rootViewModel)
        }
    }
}
