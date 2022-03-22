//
//  HoneyGridView.swift
//  QuizGame
//
//  Created by Roman Korobskoy on 22.03.2022.
//

import SwiftUI

struct HoneyGridView<Content: View, Item>: View where Item: RandomAccessCollection {
    
    var content: (Item.Element) -> Content
    var items: Item
    
    init(items: Item, @ViewBuilder content: @escaping (Item.Element) -> Content) {
        self.content = content
        self.items = items
    }
    
    @State var width: CGFloat = 0
    
    var body: some View {
        // удаляем верхний отступ шестиугольника
        VStack(spacing: -20) {
            
            ForEach(setupHoneyGrid().indices, id: \.self) { index in
                
                HStack(spacing: 4 ) {
                    
                    ForEach(setupHoneyGrid()[index].indices, id: \.self) { subIndex in
                        content(setupHoneyGrid()[index][subIndex])
                        // настройка ширины
                            .frame(width: (width) / 4)
                            .offset(x: setOffset(index: index))
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .coordinateSpace(name: "HoneyComb")
        .overlay {
            GeometryReader { proxy in
                Color.clear
                    .preference(key: WidthKey.self, value: proxy.frame(in: .named("HoneyComb")).width - proxy.frame(in: .named("HoneyComb")).minX)
                    .onPreferenceChange(WidthKey.self) { width in
                        self.width = width
                    }
            }
        }
    }
    
    // чтобы не ломалась сетка
    func setOffset(index: Int) -> CGFloat {
        let current = setupHoneyGrid()[index].count
        let offset = (width / 4) / 2
        
        if index != 0 {
            let previous = setupHoneyGrid()[index - 1].count
            
            if current == 1 && previous % 2 == 0 {
                return 0
            }
            
            if previous % current == 0 {
                return -offset - 2
            }
        }
        return 0
    }
    
    // генерируем медовую сетку
    // каждый раз будет 4,3,4,3,4,3...
    func setupHoneyGrid() -> [[Item.Element]] {
        var rows: [[Item.Element]] = []
        var itemsAtRow: [Item.Element] = []
        
        var count: Int = 0
        
        items.forEach { item in
            itemsAtRow.append(item)
            count += 1
            
            if itemsAtRow.count >= 3 {
                if rows.isEmpty && itemsAtRow.count == 4 {
                    rows.append(itemsAtRow)
                    itemsAtRow.removeAll()
                }
                else if let last = rows.last, last.count == 4 && itemsAtRow.count == 3 {
                    rows.append(itemsAtRow)
                    itemsAtRow.removeAll()
                }
                else if let last = rows.last, last.count == 3 && itemsAtRow.count == 4 {
                    rows.append(itemsAtRow)
                    itemsAtRow.removeAll()
                }
            }
            
            // проверка лишних элементов
            if count == items.count {
                if let last = rows.last {
                    // проверка порядка и предыдущей строки
                    if rows.count >= 2 {
                        let previos = (rows[rows.count - 2].count == 4 ? 3 : 4)
                        
                        if (last.count + itemsAtRow.count) <= previos {
                            rows[rows.count - 1].append(contentsOf: itemsAtRow)
                            itemsAtRow.removeAll()
                        } else {
                            rows.append(itemsAtRow)
                            itemsAtRow.removeAll()
                        }
                    } else {
                        if (last.count + itemsAtRow.count) <= 4 {
                            rows[rows.count - 1].append(contentsOf: itemsAtRow)
                            itemsAtRow.removeAll()
                        } else {
                            rows.append(itemsAtRow)
                            itemsAtRow.removeAll()
                        }
                    }
                } else {
                    rows.append(itemsAtRow)
                    rows.removeAll()
                }
            }
        }
        
        return rows
    }
}

struct HoneyGridView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: настройка ширины

struct WidthKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
