/*:
 [目次](Table%20of%20contents) • [前へ](@previous) • [次へ](@next)

 # enumのcaseの列挙

 [SE-0194 — Derived Collection of Enum Cases](https://github.com/apple/swift-evolution/blob/master/proposals/0194-derived-collection-of-enum-cases.md "Derived Collection of Enum Cases"): コンパイラは`allCases`プロパティを自動生成し、enumのcaseの完全な列挙をプログラマに常に最新の状態で提供することが可能になりました。これは`CaseIterable`プロトコルを適用するだけで行なえます。
 */
enum Terrain: CaseIterable {
    case water
    case forest
    case desert
    case road
}

Terrain.allCases
Terrain.allCases.count

/*:
 自動実装の機能はassociated valuesをもったenumには使えないことに注意してください。これはassociated valuesをもつ場合、enumは潜在的に無限個の値を持っていることになってしまうからです。

 もしこのようなenumに`allCases`プロパティを付ける場合は、有限個のあり得る値のリストをプロトコルに手で書く必要があります。たとえばこの例ではOptionalに対して`CaseIterable`プロトコルが適用された型のものだけ`allCases`を実装しています。
 */
extension Optional: CaseIterable where Wrapped: CaseIterable {
    public typealias AllCases = [Wrapped?]
    public static var allCases: AllCases {
        return Wrapped.allCases.map { $0 } + [nil]
    }
}

// 注意: これはオプショナルチェインニングではありません！
// ここではOptional<Terrain>型のプロパティにアクセスしています。
Terrain?.allCases
Terrain?.allCases.count

/*:
 (これは面白い実験ですが、私はこの実装が実際にとても役立つかということには疑念を抱いています。扱いには注意が必要です。)
 */
/*:
 [目次](Table%20of%20contents) • [前へ](@previous) • [次へ](@next)
 */
