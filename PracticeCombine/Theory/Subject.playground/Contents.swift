import Combine
import Foundation

// 1. PassthroughSubject
// PassthroughSubject는 외부에서 값을 받아 Subscriber에게 전달하는 Subject입니다.
// 이를 통해 동적으로 값을 전달할 수 있습니다.
let passthroughSubject = PassthroughSubject<String, Never>()

// PassthroughSubject를 구독하는 Subscriber를 생성합니다.
let passthroughSubscription = passthroughSubject.sink { value in
    print("PassthroughSubject received: \(value)")
}

// 외부에서 값을 전달하여 Subscriber에게 방출합니다.
passthroughSubject.send("Hello from PassthroughSubject")

// 2. CurrentValueSubject
// CurrentValueSubject는 PassthroughSubject와 유사하지만, 현재 값을 가집니다.
// 새로운 Subscriber가 구독을 시작하면, 현재 값을 즉시 받습니다.
let currentValueSubject = CurrentValueSubject<String, Never>("Initial Value")

// CurrentValueSubject를 구독하는 Subscriber를 생성합니다.
let currentValueSubscription = currentValueSubject.sink { value in
    print("CurrentValueSubject received: \(value)")
}

// 외부에서 값을 전달하여 Subscriber에게 방출합니다.
currentValueSubject.send("Hello from CurrentValueSubject")

// CurrentValueSubject의 현재 값을 확인할 수 있습니다.
print("CurrentValueSubject current value: \(currentValueSubject.value)")
