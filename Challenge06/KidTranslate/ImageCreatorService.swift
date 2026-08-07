//
//  SwiftUIView.swift
//  Challenge06
//
//  Created by Rafaela Cruz Arruda on 07/08/26.
//

import SwiftUI
import ImagePlayground
import Observation

@Observable

class DetailViewModel {
    
    var generatedImage: CGImage?
    var isLoading = false
    var errorMesage: String?
    
    @MainActor
    
    func generateImage(animalName: String) async {
        
        isLoading = true
        generatedImage = nil
        errorMesage = nil
        
        let prompt = """
        Um único \(animalName) em stilo desenho infantil 
        """
    }
    
    
}




