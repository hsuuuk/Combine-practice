//
//  PracticeCombineApp.swift
//  PracticeCombine
//
//  Created by 심현석 on 2023/06/09.
//

import SwiftUI

@main
struct PracticeCombineApp: App {
    @StateObject var bookListviewModel = BookListViewModel()
    
    var body: some Scene {
        WindowGroup {
            BookListView()
                .environmentObject(bookListviewModel)
        }
    }
}
