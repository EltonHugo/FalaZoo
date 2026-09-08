[🇧🇷 Português](README.md) | [🇺🇸 English](README_EN.md)

# 🐾 FalaZoo

**PoC — Proof of Concept**

An iOS experience developed to explore Artificial Intelligence and multimodal technologies within the Apple ecosystem.

<p align="center">
  <img src="readme-assets/result-light.png" width="23%" alt="FalaZoo result in light mode">
  &nbsp;&nbsp;&nbsp;
  <img src="readme-assets/result-dark.png" width="23%" alt="FalaZoo result in dark mode">
</p>

<p align="center">
  <sub>Experience in light and dark modes.</sub>
</p>

---

## About the project

**FalaZoo** is a proof of concept developed to investigate how different technologies from the Apple ecosystem can be integrated into an iOS application.

To put this exploration into practice, we created an experience focused on helping children learn about animals and English vocabulary by combining **speech recognition, classification, translation, sentence generation, audio, and image generation** into a single workflow.

The interaction does not require the user to say only the name of an animal. The app can also process **complete sentences in Portuguese** and identify the animal mentioned in the transcription.

For example:

> **“O gato toma leite.”**  
> *“The cat drinks milk.”*

The speech is transcribed, the model identifies **“gato” (cat)** within the sentence, and that category is used to continue the experience.

If none of the supported animals are identified, the application displays a recognition failure state and allows the user to try again.

---

## 🎥 Demo

The demo presents two application scenarios:

- **“O gato toma leite” (“The cat drinks milk”)** — FalaZoo receives a complete sentence, identifies the animal within the transcription, and executes the full workflow until the final result is displayed. The demo also shows the audio features used to play both the English word and the generated sentence.
- **“Grilo” (“Cricket”)** — since this animal is not included among the categories supported by the model, the application displays the unrecognized state.

https://github.com/user-attachments/assets/eaea9ce6-ecd9-449f-9eb7-28595e680fa3

---

## How it works

The experience begins with the user's speech and goes through several processing stages before the final content is presented in the interface.

<p align="center">
  <img src="readme-assets/app-flow.png" width="70%" alt="FalaZoo application workflow">
</p>

---

## Technologies

- **Swift**
- **SwiftUI**
- **Speech** — recognizes the user's speech and generates the transcription.
- **AVFoundation** — plays the English word and sentence as audio.
- **Create ML** — used to train the classification model developed for the PoC.
- **Core ML** — integrates and runs the model responsible for identifying the animal within the transcription.
- **Translation** — translates the animal name and other content used throughout the experience.
- **Foundation Models** — generates a sentence related to the identified animal.
- **ImageCreator** — programmatically generates a visual representation of the animal.

---

## Dataset and model

To explore the model creation and training process as part of the project, we built **our own dataset for study purposes**.

During its development, we conducted different tests and refined the categories according to the application's scope. We prioritized animals with **emojis that matched the visual experience of the app** and removed categories that did not fit the project, such as some insects, duplicated animals, and fictional creatures.

The final dataset contained **79 animals and 3,680 examples**:

- **2,944 training examples — 80%**
- **736 testing examples — 20%**

The examples included different sentences and variations associated with the same animal, allowing the model to recognize a category in different contexts rather than depending only on an isolated animal name or a fixed sentence structure.

After preparing the data, the model was trained using **Create ML** and integrated into the application through **Core ML**.

---

## Interface

The interface was developed in **SwiftUI**, with a focus on creating a simple, friendly experience suitable for the project's child-oriented context.

Different interaction states were also considered, including **ready to listen, active listening, processing, result, and error states**.

<p align="center">
  <img src="readme-assets/ready-light.png" width="23%" alt="FalaZoo ready to receive voice input">
  &nbsp;&nbsp;
  <img src="readme-assets/listening-light.png" width="23%" alt="FalaZoo during speech recognition">
  &nbsp;&nbsp;
  <img src="readme-assets/result-light.png" width="23%" alt="Result displayed by FalaZoo">
</p>

<p align="center">
  <sub>Voice input → active listening → result.</sub>
</p>

The application also supports both **light and dark modes**, maintaining its visual identity and readability across both appearances.

---

## Collaborative development

FalaZoo was developed by **Rafaela Arruda** and **Elton Hugo**.

Both contributed to researching the technologies used in the project and investigating how they could be integrated within the application.

To keep development organized, the implementation was primarily divided between **interface development** and **application logic and integrations**.

### Rafaela Arruda — Interface and SwiftUI development

Main responsibilities:

- developing screens and components in SwiftUI;
- building the application's visual flow;
- organizing and refining layouts;
- implementing the different interface states;
- adapting the experience for light and dark modes.

### Elton Hugo — Logic and integrations

Main responsibilities:

- implementing the application's logic;
- integrating the frameworks and technologies used in the project;
- developing the services responsible for processing;
- integrating the model trained with Create ML through Core ML;
- connecting speech recognition, classification, translation, sentence generation, audio, and image generation.

Despite this division of responsibilities, development was collaborative. Throughout different stages of testing and problem-solving, **both developers actively participated in investigating the technologies and the application's behavior**, aiming to understand not only how each feature could be implemented, but also the reasons behind unexpected behavior and the possible approaches for solving it.

---

## Requirements

- **iOS 26.5 or later**
- Interface developed and tested for **iPhone 16**
- Xcode version compatible with the project's deployment target

On first launch, the application requests the permissions required to access the **microphone and speech recognition**.

---

## Running the project

1. Clone this repository.
2. Open the project in Xcode.
3. Select an iPhone 16 or another compatible device.
4. Build and run the application.
5. Allow microphone and speech recognition access when prompted.
