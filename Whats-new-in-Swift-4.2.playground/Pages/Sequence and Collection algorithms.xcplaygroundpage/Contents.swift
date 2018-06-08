/*:
 [目次](Table%20of%20contents) • [前へ](@previous) • [次へ](@next)

 # SequenceとCollectionのアルゴリズム

 ## `allSatisfy`

 [SE-0207](https://github.com/apple/swift-evolution/blob/master/proposals/0207-containsOnly.md "Add an allSatisfy algorithm to Sequence")は`allSatisfy`アルゴリズムを`Sequence`に加えました。`allSatisfy`はすべてのSequence内のすべての要素が与えられた条件を満たすときのみ`true`となります。この機能は関数型言語ではよく`all`と呼ばれているものです。

 `allSatisfy`は`contains(where:)`メソッドで行っていたすべての要素に対して条件が満たされてるか、されてないかを判断するというときなどをうまく補完してくれます。
 */
let digits = 0...9

let areAllSmallerThanTen = digits.allSatisfy { $0 < 10 }
areAllSmallerThanTen

let areAllEven = digits.allSatisfy { $0 % 2 == 0 }
areAllEven

/*:
 ## `last(where:)`と`lastIndex(where:)`と`lastIndex(of:)`

 [SE-0204](https://github.com/apple/swift-evolution/blob/master/proposals/0204-add-last-methods.md "Add last(where:) and lastIndex(where:) Methods")は`last(where:)`メソッドを`Sequence`に、`lastIndex(where:)`と`lastIndex(of:)`メソッドを`Collection`に追加しました。
 */
let lastEvenDigit = digits.last { $0 % 2 == 0 }
lastEvenDigit

let text = "Vamos a la playa"

let lastWordBreak = text.lastIndex(where: { $0 == " " })
let lastWord = lastWordBreak.map { text[text.index(after: $0)...] }
lastWord

text.lastIndex(of: " ") == lastWordBreak

/*:
 ### `index(of:)`と`index(where:)`の`firstIndex(of:)`と`firstIndex(where:)`へのリネーム

上に伴って、SE-0204では`index(of:)`と`index(where:)`が`firstIndex(of:)`と`firstIndex(where:)`に名前が変わりました。

 */
let firstWordBreak = text.firstIndex(where: { $0 == " " })
let firstWord = firstWordBreak.map { text[..<$0] }
firstWord

/*:
 [目次](Table%20of%20contents) • [前へ](@previous) • [次へ](@next)
 */
