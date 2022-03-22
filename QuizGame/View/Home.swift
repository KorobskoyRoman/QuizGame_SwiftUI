//
//  Home.swift
//  QuizGame
//
//  Created by Roman Korobskoy on 22.03.2022.
//

import SwiftUI

struct Home: View {
    // MARK: текущий пазл
    @State var currentPuzzle: Puzzle = puzzles[0]
    @State var selectedLetters: [Letter] = []
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Button {
                        
                    } label: {
                        Image(systemName: "arrowtriangle.backward.square.fill")
                            .font(.title)
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.title3)
                            .padding(10)
                            .background(Color("blue"), in: Circle())
                            .foregroundColor(.black)
                    }
                }
                .overlay {
                    Text("Level 1")
                        .fontWeight(.bold)
                }
                // MARK: картинка
                Image(currentPuzzle.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: currentPuzzle.imageName == "justin" ? 200 : 0))
                    .padding(.vertical)
                
                // MARK: поле заполнения
                HStack(spacing: 10) {
                    ForEach(0..<currentPuzzle.answer.count, id: \.self) { index in
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("blue").opacity(selectedLetters.count > index ? 1 : 0.2))
                                .frame(height: 60)
                            
                            // отображение символов
                            if selectedLetters.count > index {
                                Text(selectedLetters[index].value)
                                    .font(.title)
                                    .fontWeight(.black)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
            }
            .padding()
            .background(.white, in: RoundedRectangle(cornerRadius: 15))
            
            // MARK: Honey Grid view
            
            HoneyGridView(items: currentPuzzle.letters) { item in
                // MARK: настройка шестиугольника для символов
                ZStack {
                    
                    HexagonShape()
                        .fill(isSelected(letter: item) ? Color("gold") : .white)
                        .aspectRatio(contentMode: .fit)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 10, y: 5)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: -5, y: 8)
                    
                    Text(item.value)
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundColor(isSelected(letter: item) ? .white : .gray.opacity(0.5))
                }
                .contentShape(HexagonShape())
                .onTapGesture {
                    // добавляем выбранный символ
                    addLetter(letter: item)
                }
            }
            
            // MARK: Кнопка Next
            Button {
                // смена на следующий паззл
                selectedLetters.removeAll()
                currentPuzzle = puzzles[1]
                // генерируем новые символы
                generateLetters()
            } label: {
                Text("Next")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                    .background(Color("gold"), in: RoundedRectangle(cornerRadius: 15))
            }
            .disabled(selectedLetters.count != currentPuzzle.answer.count)
            .opacity(selectedLetters.count != currentPuzzle.answer.count ? 0.6 : 1)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color("bg"))
        .onAppear {
            // генерируем символы
            generateLetters()
        }
    }
    
    func addLetter(letter: Letter) {
        
        withAnimation {
            if isSelected(letter: letter) {
                // удаляем символ
                selectedLetters.removeAll() { currentLetter in
                    return currentLetter.id == letter.id
                }
            } else {
                selectedLetters.append(letter)
            }
        }
    }
    
    // проверка наличия символа в массиве
    
    func isSelected(letter: Letter) -> Bool {
        return selectedLetters.contains { currentLetter in
            return currentLetter.id == letter.id
        }
    }
    
    func generateLetters() {
        currentPuzzle.jumbbledWord.forEach { character in
            currentPuzzle.letters.append(Letter(value: String(character)))
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
