import Combine
import Foundation

// 1. Just
// Just는 단일 요소를 방출하는 Publisher
// 주로 상수 값을 Publisher로 변환할 때 사용합니다.
let justPublisher = Just("Hello, Combine!")
justPublisher.sink { value in
    print("Just: \(value)")
}

// 2. Sequence
// 시퀀스(예: 배열)로부터 요소들을 방출하는 Publisher
// 각 요소는 시퀀스의 순서대로 방출됩니다.
let sequencePublisher = [1, 2, 3].publisher
sequencePublisher.sink { value in
    print("Sequence: \(value)")
}

// 3. Future
// 비동기 작업의 결과를 나타내는 Publisher로, 한 번만 방출합니다.
// Future 내에서 비동기 작업을 수행하고 결과를 방출할 수 있습니다.
let futurePublisher = Future<Int, Never> { promise in
    DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
        promise(.success(5))
    }
}
futurePublisher.sink { value in
    print("Future: \(value)")
}

// 4. PassthroughSubject
// 외부에서 값을 받아 Subscriber에게 방출하는 Publisher
// 이를 통해 동적으로 값을 방출할 수 있습니다.
let passthroughSubject = PassthroughSubject<String, Never>()
passthroughSubject.sink { value in
    print("PassthroughSubject: \(value)")
}
passthroughSubject.send("Hello from PassthroughSubject")

// 5. CurrentValueSubject
// PassthroughSubject와 유사하지만, 현재 값을 가집니다.
// 새로운 Subscriber가 구독을 시작하면, 현재 값을 즉시 받습니다.
let currentValueSubject = CurrentValueSubject<String, Never>("Initial Value")
currentValueSubject.sink { value in
    print("CurrentValueSubject: \(value)")
}
currentValueSubject.send("Hello from CurrentValueSubject")

// 6. Deferred
// Subscriber가 구독할 때까지 Publisher의 생성을 연기합니다.
// 그 이후에 Publisher가 생성되고 값을 방출하기 시작합니다.
let deferredPublisher = Deferred {
    return Just("Hello from Deferred")
}
deferredPublisher.sink { value in
    print("Deferred: \(value)")
}

// 7. Empty
// 아무 값도 방출하지 않는 Publisher
// 완료 이벤트만을 방출하여 종료됩니다.
let emptyPublisher = Empty<String, Never>()
emptyPublisher.sink(receiveCompletion: { completion in
    print("Empty completed")
}, receiveValue: { value in
    print("Empty: \(value)")
})

// 8. Fail
// 오류를 방출하는 Publisher
// 주로 실패 상황을 시뮬레이션할 때 사용됩니다.
enum MyError: Error {
    case exampleError(String)
}

let failPublisher = Fail<String, Error>(error: MyError.exampleError("Error example"))
failPublisher.sink(receiveCompletion: { completion in
    switch completion {
    case .finished:
        print("Fail completed successfully.")
    case .failure(let error):
        print("Fail completed with error: \(error)")
    }
}, receiveValue: { value in
    print("Fail: \(value)")
})






