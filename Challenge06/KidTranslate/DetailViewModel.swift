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
    private let animalClassifier = AnimalClassifierViewModel()
//    private let trasnslator = TranslatorViewModel()
//    private let
    private(set) var animal = ""
    private(set) var englishAnimal = ""
    private(set) var text = ""
    private(set) var englishText = ""
    
    func setUp(inputText: String) {
        animalClassifier.inputText = inputText
        animalClassifier.identifyAnimal()
        animal = animalClassifier.prediction?.animal ?? ""
    }
}
