/*:
 [目次](Table%20of%20contents) • [前へ](@previous) • [次へ](@next)

 # 乱数

 今まで乱数をSwiftで扱うことは微妙な点が２つありました。一つはCのAPIを直接呼び出す必要があったこと、もう一つはいいクロスプラットフォームの乱数APIが存在しなかったことです。

 [SE-0202](https://github.com/apple/swift-evolution/blob/master/proposals/0202-random-unification.md "Random Unification")は乱数命令を標準ライブラリに追加しました。

 ## 乱数を生成する

 全ての数値型は与えられた範囲の乱数を返す`random(in:)`メソッドを持つようになりました（なおかつそれらは標準で偏りがないものになっています）:
 */
Int.random(in: 1...1000)
UInt8.random(in: .min ... .max)
Double.random(in: 0..<1)

/*:
このAPIは[modulo bias](https://www.quora.com/What-is-modulo-bias)という乱数生成に関するよくあるエラーをしっかりと防いでくれます。

 `Bool.random`も同じく実装されています:
 */
func coinToss(count tossCount: Int) -> (heads: Int, tails: Int) {
    var result = (heads: 0, tails: 0)
    for _ in 0..<tossCount {
        let toss = Bool.random()
        if toss {
            result.heads += 1
        } else {
            result.tails += 1
        }
    }
    return result
}

let (heads, tails) = coinToss(count: 100)
print("100 coin tosses — heads: \(heads), tails: \(tails)")

/*:
 ## ランダムなコレクションの要素

 コレクションには`randomElement`メソッドが実装されました（このメソッドはコレクションが空の場合に備えて`min`や`max`と同じようにオプショナルな値を返します）:
 */
let emotions = "😀😂😊😍🤪😎😩😭😡"
let randomEmotion = emotions.randomElement()!

/*:
 コレクションをシャッフルするには`shuffles`メソッドが使用できます：
 */
let numbers = 1...10
let shuffled = numbers.shuffled()

/*:
 ## カスタムできる乱数ジェネレーター

 標準ライブラリには`Random.default`という単純な用途にはとてもいい乱数ジェネレーターがデフォルトで実装されます。

 もし特別な用途がある場合、自分自身で乱数ジェネレーターを`RandomNumberGenerator`プロトコルを適用することで実装することができます。乱数生成の全てのAPIはユーザーに好きな乱数ジェネレーターでオーバーロードできる機能を提供しています:
 */
/// たとえば`Random.default`を中で使っているだけの乱数ジェネレーターを次のように書きます
struct MyRandomNumberGenerator: RandomNumberGenerator {
    var base = Random.default
    mutating func next() -> UInt64 {
        return base.next()
    }
}

var customRNG = MyRandomNumberGenerator()
Int.random(in: 0...100, using: &customRNG)

/*:
 ## 自作の型に拡張する

 もちろん同じように自作の型に対して次のようにランダムに関するAPIを実装することもできます:
 */
enum Suit: String, CaseIterable {
    case diamonds = "♦"
    case clubs = "♣"
    case hearts = "♥"
    case spades = "♠"

    static func random<T: RandomNumberGenerator>(using generator: inout T) -> Suit {
        // Using CaseIterable for the implementation
        return allCases.randomElement(using: &generator)!

    }

    static func random() -> Suit {
        return Suit.random(using: &Random.default)
    }
}

let randomSuit = Suit.random()
randomSuit.rawValue

/*:
 [目次](Table%20of%20contents) • [前へ](@previous) • [次へ](@next)
 */
