//
//  DetailViewModel.swift
//  Challenge06
//
//  Created by Elton Hugo Ferreira da Silva on 07/08/26.
//

import Foundation
import Observation

@MainActor
@Observable
class DetailViewModel {
    let animalClassifier = AnimalClassifierViewModel()
    let translator = TranslateService()
    let foundation = FoundationService()
    private(set) var animal = ""
    private(set) var emojiAnimal = ""
    private(set) var englishAnimal = ""
    private(set) var text = ""
    private(set) var englishText = ""
    
    func setUp(inputText: String) async{
        animalClassifier.inputText = inputText
        animalClassifier.identifyAnimal()
        animal = animalClassifier.prediction?.animal ?? ""
        emojiAnimal = animalClassifier.prediction?.emoji ?? "🐦"
        englishAnimal = await translator.translate(animal)
        text = await foundation.sendMessage(inputText: animal)
        englishText = await translator.translate(englishText)
    }
}
