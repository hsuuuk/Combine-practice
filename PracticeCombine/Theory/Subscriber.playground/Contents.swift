import Combine
import Foundation

class User {
    var name: String = ""
}

// Publisher를 생성합니다. Just는 단일 요소를 방출하는 Publisher입니다.
let namePublisher = Just("Alice")

// 1. sink
// sink는 값을 받아 처리하는 가장 기본적인 Subscriber입니다.
// receiveValue 클로저 내에서 방출된 값을 사용할 수 있습니다.
let sinkSubscriber = namePublisher.sink { receivedName in
    print("sink received: \(receivedName)")
}

// 2. assign
// assign은 값을 직접 객체의 속성에 할당하는데 사용됩니다.
// 이 예제에서는 User 객체의 name 속성에 값을 할당합니다.
let user = User()
let assignSubscriber = namePublisher.assign(to: \.name, on: user)

// assign을 사용하면, User 객체의 name 속성이 Publisher로부터 받은 값으로 자동 업데이트됩니다.
print("User's name after assign: \(user.name)")
