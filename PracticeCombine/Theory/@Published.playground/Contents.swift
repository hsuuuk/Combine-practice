import Combine
import Foundation

class ViewModel {
    @Published var name: String = ""
}

let viewModel = ViewModel()

// name 속성에 변화를 구독하는 Subscriber를 생성합니다.
viewModel.$name
    .sink { newValue in
        print("Name changed to: \(newValue)")
    }

// name 속성을 변경합니다.
viewModel.name = "Alice" // 출력: Name changed to: Alice
viewModel.name = "Bob"   // 출력: Name changed to: Bob
