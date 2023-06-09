import Combine
import Foundation

// 1. map
// 각 요소에 변환을 적용합니다.
let numbers = [1, 2, 3, 4].publisher
numbers
    .map { $0 * 2 }
    .sink { print("map: \($0)") }

// 2. filter
// 조건에 맞는 요소만을 방출합니다.
numbers
    .filter { $0 % 2 == 0 }
    .sink { print("filter: \($0)") }

// 3. merge
// 여러 Publisher들의 출력을 하나로 합칩니다.
let publisher1 = PassthroughSubject<Int, Never>()
let publisher2 = PassthroughSubject<Int, Never>()

publisher1
    .merge(with: publisher2)
    .sink { print("merge: \($0)") }

publisher1.send(1)
publisher2.send(2)

// 4. combineLatest
// 여러 Publisher들의 최신 값들을 결합합니다.
let publisher3 = PassthroughSubject<Int, Never>()
let publisher4 = PassthroughSubject<String, Never>()

publisher3
    .combineLatest(publisher4)
    .sink { print("combineLatest: \($0), \($1)") }

publisher3.send(3)
publisher4.send("A")

// 5. zip
// 여러 Publisher들의 요소들을 쌍으로 묶습니다.
let publisher5 = [1, 2, 3].publisher
let publisher6 = ["A", "B", "C"].publisher

publisher5
    .zip(publisher6)
    .sink { print("zip: \($0), \($1)") }

// 6. scan
// 이전 상태와 새로운 요소를 사용하여 값을 누적합니다.
numbers
    .scan(0, { sum, newValue in sum + newValue })
    .sink { print("scan: \($0)") }

// 7. collect
// 여러 요소를 배열로 수집합니다.
let numbers2 = [1, 2, 3, 4, 5].publisher
numbers2
    .collect()
    .sink { print("collect: \($0)") }

// 8. delay
// 요소의 방출을 지연시킵니다.
numbers2
    .delay(for: .seconds(1), scheduler: DispatchQueue.main)
    .sink { print("delay: \($0)") }

// 9. debounce
// 일정 시간 동안의 요소 방출을 무시하고 가장 최근의 요소만 방출합니다.
let publisher7 = PassthroughSubject<Int, Never>()
publisher7
    .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
    .sink { print("debounce: \($0)") }

publisher7.send(1)
publisher7.send(2)
publisher7.send(3)

// 10. catch
// 오류를 처리하고 대체 요소를 제공합니다.
let publisher8 = PassthroughSubject<Int, Error>()
publisher8
    .catch { _ in Just(-1) }
    .sink(receiveCompletion: { print("catch completed: \($0)") }, receiveValue: { print("catch: \($0)") })

publisher8.send(1)
publisher8.send(completion: .failure(NSError())) // 플레이그라운드라서 발생하는 에러
