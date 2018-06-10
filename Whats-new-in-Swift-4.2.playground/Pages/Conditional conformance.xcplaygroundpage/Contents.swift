/*:
 [目次](Table%20of%20contents) • [前へ](@previous) • [次へ](@next)

 # Conditional Conformanceに関する改善

 ## Dynamicキャスト

 Conditional ConformanceはSwift4.1の目玉機能([SE-0143](https://github.com/apple/swift-evolution/blob/master/proposals/0143-conditional-conformances.md "Conditional conformances"))でした。そしてこのプロポーザルの最後にランタイムのクエリに適用する機能はSwift4.2でリリースされると書かれていました。つまりプロトコル型に対してのDynamicキャスト（`is`や`as?`を使うこと）が値がConditional Conformanceを満たしていれば可能になりました。
 （訳注：Conditional Conformanceの訳が難しいので詳しくは https://qiita.com/koher/items/4ae98d71b8eb06ab1b79 を参考にしてみてください）

 例:
 */
func isEncodable(_ value: Any) -> Bool {
    return value is Encodable
}

// これはSwift4.1ではfalseを返していました。
let encodableArray = [1, 2, 3]
isEncodable(encodableArray)

// Conditional Conformanceの原理が満たされていない場合動的なチェックは成功しないことが確認できます。
struct NonEncodable {}
let nonEncodableArray = [NonEncodable(), NonEncodable()]
assert(isEncodable(nonEncodableArray) == false)

/*:
 ## Extensionにおける適用の合成

 小さいですが重要なコンパイラのプロトコル適用の合成機能として[SE-0185](https://github.com/apple/swift-evolution/blob/master/proposals/0185-synthesize-equatable-hashable.md "Synthesizing Equatable and Hashable conformance")で紹介された`Equatable`と`Hashable`の自動適用があります。

 プロトコル適用は型の定義の時だけでなく、extensionにおいても合成できるようになりました（型の定義とそのextensionが同じファイルである必要はあります）。これは見かけよりもさらに変更が加えられていて、`Equatable`、`Hashable`、`Encodable`、`Decodable`のConditional Conformanceも自動合成してくれます。

 この例は[What’s New in Swift session at WWDC 2018](https://developer.apple.com/videos/play/wwdc2018/401/)のセッションから持ってきたものです。私達は`Either`のConditional Comformanceを`Equatable`と`Hashable`に対して使えています:
 */
enum Either<Left, Right> {
    case left(Left)
    case right(Right)
}

// これ以上のコードは必要ありません
extension Either: Equatable where Left: Equatable, Right: Equatable {}
extension Either: Hashable where Left: Hashable, Right: Hashable {}

Either<Int, String>.left(42) == Either<Int, String>.left(42)

/*:
 [目次](Table%20of%20contents) • [前へ](@previous) • [次へ](@next)
 */
