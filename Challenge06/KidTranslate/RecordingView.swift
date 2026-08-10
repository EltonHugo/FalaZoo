//
//  RecordingScreen.swift
//  Challenge06
//
//  Created by Rafaela Cruz Arruda on 05/08/26.
//

import SwiftUI

struct RecordingView: View {
    var body: some View {
        ZStack{
            Color("light_yellow")
                .ignoresSafeArea()
            VStack(spacing: 25){
                Button{
                    print("Botão para ouvir o usuário apertado")
                } label: {
                    Image(systemName: "microphone")
                        .font(.system(size: 44, weight: .medium))
                        .foregroundStyle(Color("light_brown"))
                        .frame(width: 128, height: 128)
                        .background{
                            Circle()
                                .fill(Color("beige"))
                                .shadow(radius: 5, y: 3)
                        }
                    
                }
                
                Text("Toque no microfone\ne diga um animal")
                    .font(Font.system(.title, design: .rounded))
                    .multilineTextAlignment(.center)
                    

            }
        }
    }
}

#Preview {
    RecordingView()
}
