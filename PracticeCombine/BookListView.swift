import SwiftUI
import Combine

struct Book: Identifiable {
    let id = UUID()
    let title: String
    let author: String
    let category: String
}

class BookListViewModel: ObservableObject {
    @Published var books: [Book] = []
    @Published var sections: [String: [Book]] = [:]
    @Published var searchQuery: String = ""
    @Published var selectedCategory: String? = nil

    private var cancellables = Set<AnyCancellable>()

    init() {
        
        // #1
        
//        $books
//            .map { books in
//                var sections: [String: [Book]] = [:]
//                for book in books {
//                    if sections[book.category] == nil {
//                        sections[book.category] = []
//                    }
//                    sections[book.category]?.append(book)
//                }
//                return sections
//            }
//            .assign(to: \.sections, on: self)
//            .store(in: &cancellables)
        
        // #2
        
//        Publishers.CombineLatest($books, $searchQuery)
//                    .map { (books, searchQuery) in
//                        var filteredBooks = books
//                        if !searchQuery.isEmpty {
//                            filteredBooks = books.filter { $0.title.contains(searchQuery) }
//                        }
//
//                        var sections: [String: [Book]] = [:]
//                        for book in filteredBooks {
//                            if sections[book.category] == nil {
//                                sections[book.category] = []
//                            }
//                            sections[book.category]?.append(book)
//                        }
//                        return sections
//                    }
//                    .assign(to: \.sections, on: self)
//                    .store(in: &cancellables)
        
        // #3
        
        $books
            .combineLatest($searchQuery, $selectedCategory)
        //Publishers.CombineLatest3($books, $searchQuery, $selectedCategory)
            .map { (books, searchQuery, selectedCategory) in
                books.filter { book in
                    let matchesSearch = searchQuery.isEmpty || book.title.contains(searchQuery)
                    let matchesCategory = selectedCategory == nil || book.category == selectedCategory
                    return matchesSearch && matchesCategory
                }
            }
            .map { filteredBooks in
                var sections: [String: [Book]] = [:]
                for book in filteredBooks {
                    if sections[book.category] == nil {
                        sections[book.category] = []
                    }
                    sections[book.category]?.append(book)
                }
                return sections
            }
            .assign(to: \.sections, on: self)
            .store(in: &cancellables)

        books = [
            Book(title: "Book1", author: "Author1", category: "Fiction"),
            Book(title: "Book2", author: "Author2", category: "Non-fiction"),
            Book(title: "Book3", author: "Author3", category: "Fiction"),
            Book(title: "Book4", author: "Author4", category: "Sci-fi"),
            Book(title: "Book5", author: "Author5", category: "Non-fiction")
        ]
    }
    
    func addBook(title: String, author: String, category: String) {
        let newBook = Book(title: title, author: author, category: category)
        books.append(newBook)
    }
    
    func toggleCategory(_ category: String) {
        if selectedCategory == category {
            selectedCategory = nil
        } else {
            selectedCategory = category
        }
    }
}

struct BookListView: View {
    @EnvironmentObject var viewModel: BookListViewModel
    @FocusState var isSearchFocused: Bool

    var body: some View {
        NavigationView {
            
            VStack {
                if !isSearchFocused {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.sections.keys.sorted(), id: \.self) { category in
                                Button {
                                    viewModel.toggleCategory(category)
                                } label: {
                                    Text(category)
                                        .padding([.leading, .trailing], 10)
                                        .padding([.top, .bottom], 5)
                                        .background(viewModel.selectedCategory == category ? Color(.darkGray) : Color(.systemGray6))
                                        .foregroundColor(viewModel.selectedCategory == category ? .white : .black)
                                        .cornerRadius(15)
                                }
                            }
                        }
                    }
                    .padding(.leading, 10)
                }
                
                List {
                    // #1
                    
                    //                ForEach(viewModel.sections.keys.sorted(), id: \.self) { key in
                    //                    Section(header: Text(key)) {
                    //                        ForEach(viewModel.sections[key]!) { book in
                    //                            VStack(alignment: .leading) {
                    //                                Text(book.title).font(.headline)
                    //                                Text(book.author).font(.subheadline)
                    //                            }
                    //                        }
                    //                    }
                    //                }
                    
                    // #2
                    
                    ForEach(viewModel.sections.keys.sorted(), id: \.self) { key in
                        Section {
                            ForEach(viewModel.sections[key]!) { book in
                                VStack(alignment: .leading) {
                                    Text(book.title).font(.headline)
                                    Text(book.author).font(.subheadline)
                                }
                            }
                        } header: {
                            Text(key)
                        }
                    }
                }
                
                .listStyle(GroupedListStyle())
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        NavigationLink(destination: BookInputView()) {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            .navigationTitle("Books")
        }
        //🚫 다른 뷰에 갔다가 돌아오면 사라짐
        //.searchable(text: $viewModel.searchQuery)
        .searchable(text: $viewModel.searchQuery, placement: .navigationBarDrawer(displayMode: .always))
        //🛠️ 해결
        .focused($isSearchFocused)
    }
}

struct BookInputView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: BookListViewModel
    @State private var title = ""
    @State private var author = ""
    @State private var category = ""

    var body: some View {
        VStack {
            TextField("Title", text: $title)
                .padding()
            TextField("Author", text: $author)
                .padding()
            TextField("Category", text: $category)
                .padding()
            
            Button("Complete") {
                viewModel.addBook(title: title, author: author, category: category)
                //presentationMode.wrappedValue.dismiss()
                dismiss()
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle("추가")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct BookListView_Previews: PreviewProvider {
    static var previews: some View {
        BookListView()
            .environmentObject(BookListViewModel())
    }
}
