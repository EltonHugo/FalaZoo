🇧🇷 Versão PT-BR
# 🐾 FalaZoo

**PoC — Proof of Concept**

Uma experiência iOS desenvolvida para explorar Inteligência Artificial e tecnologias multimodais no ecossistema Apple.

<p align="center">
  <img src="readme-assets/result-light.png" width="23%" alt="Resultado do FalaZoo em modo claro">
  &nbsp;&nbsp;&nbsp;
  <img src="readme-assets/result-dark.png" width="23%" alt="Resultado do FalaZoo em modo escuro">
</p>

<p align="center">
  <sub>Experiência nos modos claro e escuro.</sub>
</p>

---

## Sobre o projeto

O **FalaZoo** é uma prova de conceito desenvolvida para investigar como diferentes tecnologias do ecossistema Apple podem ser integradas em uma aplicação iOS.

Para colocar esse estudo em prática, criamos uma experiência voltada ao aprendizado infantil de animais e vocabulário em inglês, combinando **reconhecimento de fala, classificação, tradução, geração de frases, áudio e geração de imagens** em um único fluxo.

A interação não exige que o usuário diga apenas o nome isolado de um animal. O aplicativo também consegue receber **frases completas em português** e identificar o animal presente na transcrição.

Por exemplo:

> **“O gato toma leite.”**

A fala é transcrita, o modelo identifica **“gato”** dentro da frase e utiliza essa categoria para continuar a experiência.

Caso nenhum dos animais suportados seja identificado, a aplicação informa que o reconhecimento não foi possível e permite uma nova tentativa.

---

## 🎥 Demonstração

A demonstração apresenta dois cenários da aplicação:

- **“O gato toma leite”** — o FalaZoo recebe uma frase completa, identifica o animal presente na transcrição e executa o fluxo até apresentar o resultado. Também são demonstrados os recursos de áudio para reprodução da palavra e da frase em inglês.
- **“Grilo”** — como esse animal não pertence às categorias suportadas pelo modelo, a aplicação apresenta o estado de não reconhecimento.


https://github.com/user-attachments/assets/eaea9ce6-ecd9-449f-9eb7-28595e680fa3

---

## Como funciona

A experiência começa pela fala do usuário e percorre diferentes etapas de processamento até que o conteúdo final seja apresentado na interface.

<p align="center">
  <img src="readme-assets/app-flow.png" width="70%" alt="Fluxo de funcionamento do FalaZoo">
</p>

---

## Tecnologias

- **Swift**
- **SwiftUI**
- **Speech** — reconhecimento da fala do usuário e geração da transcrição.
- **AVFoundation** — reprodução da palavra e da frase em áudio.
- **Create ML** — treinamento do modelo de classificação desenvolvido para a POC.
- **Core ML** — integração e execução do modelo responsável por identificar o animal na transcrição.
- **Translation** — tradução do nome do animal e dos conteúdos utilizados na experiência.
- **Foundation Models** — geração de uma frase relacionada ao animal identificado.
- **ImageCreator** — geração programática da representação visual do animal.

---

## Dataset e modelo

Para explorar também o processo de criação e treinamento de modelos, construímos **nosso próprio dataset para fins de estudo**.

Durante sua elaboração, realizamos diferentes testes e refinamos as categorias de acordo com a proposta da aplicação. Priorizamos animais que possuíam **emojis compatíveis com a experiência visual do app** e removemos categorias que não se adequavam ao escopo, como alguns insetos, animais repetidos e animais fantásticos.

O dataset final reuniu **79 animais e 3.680 exemplos**:

- **2.944 exemplos para treinamento — 80%**
- **736 exemplos para teste — 20%**

Os exemplos foram construídos com diferentes frases e variações relacionadas ao mesmo animal, permitindo que o modelo reconhecesse a categoria em diferentes contextos, em vez de depender apenas do nome isolado ou de uma estrutura fixa.

Após a preparação dos dados, o modelo foi treinado com **Create ML** e integrado à aplicação por meio do **Core ML**.

---

## Interface

A interface foi desenvolvida em **SwiftUI**, com foco em uma experiência simples, amigável e coerente com o contexto infantil do projeto.

Também foram considerados diferentes estados da interação, como **pronto para ouvir, escuta ativa, processamento, resultado e erro**.

<p align="center">
  <img src="readme-assets/ready-light.png" width="23%" alt="FalaZoo pronto para receber uma entrada">
  &nbsp;&nbsp;
  <img src="readme-assets/listening-light.png" width="23%" alt="FalaZoo durante o reconhecimento da fala">
  &nbsp;&nbsp;
  <img src="readme-assets/result-light.png" width="23%" alt="Resultado apresentado pelo FalaZoo">
</p>

<p align="center">
  <sub>Entrada por voz → escuta ativa → resultado.</sub>
</p>

A aplicação também possui suporte aos modos **claro e escuro**, mantendo a identidade visual e a legibilidade da experiência nos dois temas.

---

## Desenvolvimento colaborativo

O FalaZoo foi desenvolvido por **Rafaela Arruda** e **Elton Hugo**.

Ambos participaram do estudo das tecnologias utilizadas e da investigação de como elas poderiam ser integradas dentro da aplicação.

Para tornar o desenvolvimento mais organizado, a implementação foi dividida principalmente entre **interface** e **lógica e integrações**.

### Rafaela Arruda — Interface e desenvolvimento em SwiftUI

Responsável principalmente por:

- desenvolvimento das telas e componentes em SwiftUI;
- construção do fluxo visual da aplicação;
- organização e refinamento dos layouts;
- implementação dos diferentes estados da interface;
- adaptação da experiência para os modos claro e escuro.

### Elton Hugo — Lógica e integrações

Responsável principalmente por:

- implementação da lógica da aplicação;
- integração dos frameworks e tecnologias utilizadas;
- desenvolvimento dos serviços responsáveis pelo processamento;
- integração do modelo treinado com Create ML e Core ML;
- conexão entre reconhecimento de fala, classificação, tradução, geração de frases, áudio e geração de imagens.

Apesar dessa divisão, o processo de desenvolvimento foi colaborativo. Durante diferentes etapas de testes e resolução de problemas, **ambos participaram ativamente da investigação das tecnologias e do comportamento da aplicação**, buscando compreender não apenas como implementar cada recurso, mas também os motivos por trás de comportamentos inesperados e as possíveis abordagens para solucioná-los.

---

## Requisitos

- **iOS 26.5 ou superior**
- Interface desenvolvida e testada para **iPhone 16**
- Xcode compatível com o deployment target do projeto

Na primeira execução, a aplicação solicita as permissões necessárias para utilização do **microfone e reconhecimento de fala**.

---

## Executando o projeto

1. Clone este repositório.
2. Abra o projeto no Xcode.
3. Selecione um iPhone 16 ou dispositivo compatível.
4. Compile e execute a aplicação.
5. Autorize o acesso ao microfone e ao reconhecimento de fala quando solicitado.

---

🇺🇸 English Version
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

* **“O gato toma leite” (“The cat drinks milk”)** — FalaZoo receives a complete sentence, identifies the animal within the transcription, and executes the full workflow until the final result is displayed. The demo also shows the audio features used to play both the English word and the generated sentence.
* **“Grilo” (“Cricket”)** — since this animal is not included among the categories supported by the model, the application displays the unrecognized state.

https://github.com/user-attachments/assets/eaea9ce6-ecd9-449f-9eb7-28595e680fa3

---

## How it works

The experience begins with the user's speech and goes through several processing stages before the final content is presented in the interface.

<p align="center">
  <img src="readme-assets/app-flow.png" width="70%" alt="FalaZoo application workflow">
</p>

---

## Technologies

* **Swift**
* **SwiftUI**
* **Speech** — recognizes the user's speech and generates the transcription.
* **AVFoundation** — plays the English word and sentence as audio.
* **Create ML** — used to train the classification model developed for the PoC.
* **Core ML** — integrates and runs the model responsible for identifying the animal within the transcription.
* **Translation** — translates the animal name and other content used throughout the experience.
* **Foundation Models** — generates a sentence related to the identified animal.
* **ImageCreator** — programmatically generates a visual representation of the animal.

---

## Dataset and model

To explore the model creation and training process as part of the project, we built **our own dataset for study purposes**.

During its development, we conducted different tests and refined the categories according to the application's scope. We prioritized animals with **emojis that matched the visual experience of the app** and removed categories that did not fit the project, such as some insects, duplicated animals, and fictional creatures.

The final dataset contained **79 animals and 3,680 examples**:

* **2,944 training examples — 80%**
* **736 testing examples — 20%**

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

* developing screens and components in SwiftUI;
* building the application's visual flow;
* organizing and refining layouts;
* implementing the different interface states;
* adapting the experience for light and dark modes.

### Elton Hugo — Logic and integrations

Main responsibilities:

* implementing the application's logic;
* integrating the frameworks and technologies used in the project;
* developing the services responsible for processing;
* integrating the model trained with Create ML through Core ML;
* connecting speech recognition, classification, translation, sentence generation, audio, and image generation.

Despite this division of responsibilities, development was collaborative. Throughout different stages of testing and problem-solving, **both developers actively participated in investigating the technologies and the application's behavior**, aiming to understand not only how each feature could be implemented, but also the reasons behind unexpected behavior and the possible approaches for solving it.

---

## Requirements

* **iOS 26.5 or later**
* Interface developed and tested for **iPhone 16**
* Xcode version compatible with the project's deployment target

On first launch, the application requests the permissions required to access the **microphone and speech recognition**.

---

## Running the project

1. Clone this repository.
2. Open the project in Xcode.
3. Select an iPhone 16 or another compatible device.
4. Build and run the application.
5. Allow microphone and speech recognition access when prompted.

