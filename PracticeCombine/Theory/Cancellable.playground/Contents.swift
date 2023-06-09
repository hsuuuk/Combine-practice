import Combine
import Foundation

// Publisher를 생성합니다.
let numbersPublisher = [1, 2, 3, 4, 5].publisher

// Cancellables 배열을 만들어 둡니다. 이 배열에 Cancellable 인스턴스들을 보관할 수 있습니다.
var cancellables: Set<AnyCancellable> = []

// 1. Cancellables 콜렉션에 Cancellable 인스턴스(구독을 시작하면 생성)를 모아두고 한번에 모든 구독을 취소하는 방법
numbersPublisher
    .sink { number in
        print("Subscriber 1 received: \(number)")
    }
    .store(in: &cancellables) // 반환된 Cancellable을 배열에 추가합니다.

// 2. Cancellable 인스턴스(구독을 시작하면 생성)를 원하는 시점에 구독 취소하는 방법
let secondCancellable = numbersPublisher
    .filter { $0 % 2 == 0 }
    .sink { number in
        print("Subscriber 2 (even numbers only) received: \(number)")
    }

// 필요에 따라 두 번째 구독을 취소할 수 있습니다.
secondCancellable.cancel()

// 이 시점에서 첫 번째 구독은 계속 활성 상태이며, 두 번째 구독은 취소되었습니다.

// 모든 구독을 취소하려면 cancellables 배열을 비웁니다.
cancellables.removeAll()
