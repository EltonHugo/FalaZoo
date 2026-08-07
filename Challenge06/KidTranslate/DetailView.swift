//
//  RecordingScreen.swift
//  Challenge06
//
//  Created by Rafaela Cruz Arruda on 05/08/26.
//

import SwiftUI

struct DetailView: View {
    @Environment(AppCoordinator.self) var coordinator
    
    var body: some View {
        Text("Outra tela")
            .navigationTitle("Detalhes")
        Button{
            coordinator.pop()
        }label:{
            Text("Voltar")
        }
    }
    
    
}

#Preview {
    DetailView()
        .environment(AppCoordinator())
}
