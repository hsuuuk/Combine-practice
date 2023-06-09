import Combine
import Foundation

// PassthroughSubject를 생성합니다.
let passthroughSubject = PassthroughSubject<String, Never>()

// 1. DispatchQueue를 사용하는 Scheduler 예제
// 메인 큐에서 작업을 예약하고 실행합니다.
let cancellable1 = passthroughSubject
    .receive(on: DispatchQueue.main)
    .sink { value in
        print("Received on main DispatchQueue: \(value)")
    }

// 2. RunLoop를 사용하는 Scheduler 예제
// 현재 RunLoop에서 작업을 예약하고 실행합니다.
let cancellable2 = passthroughSubject
    .receive(on: RunLoop.current)
    .sink { value in
        print("Received on current RunLoop: \(value)")
    }

// 3. ImmediateScheduler를 사용하는 Scheduler 예제
// 즉시 현재 스레드에서 작업을 실행합니다.
let cancellable3 = passthroughSubject
    .receive(on: ImmediateScheduler.shared)
    .sink { value in
        print("Received immediately on current thread: \(value)")
    }

// 값을 방출합니다.
passthroughSubject.send("Hello, Scheduler!")
