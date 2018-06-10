/*:
 [目次](Table%20of%20contents) • [前へ](@previous) • [次へ](@next)

 # `Hashable`のリデザイン

 コンパイラは`Equatable`と`Hashable`に関してSwift4.1で実装された機能([SE-0185](https://github.com/apple/swift-evolution/blob/master/proposals/0185-synthesize-equatable-hashable.md "Synthesizing Equatable and Hashable conformance"))によって、`Hashable`を手で実装する手間を格段に減らしてきました。

 ですがもし独自の型に`Hashable`を適用する場合、この`Hashable`プロトコルのリデザイン（([SE-0206](https://github.com/apple/swift-evolution/blob/master/proposals/0206-hashable-enhancements.md "Hashable Enhancements"))）はより扱いを簡単にしてくれます。

 新しい`Hashable`の世界では`hashValue`を実装する代わりに`hash(into:)`というメソッドを実装することになります。このメソッドは`Hasher`オブジェクトを生成し、プログラマが実装する必要があるのはハッシュ値に含めたいものを引数にしてこのメソッドの中で`hasher.combine(_:)`を繰り返し呼んであげるだけです。

 古いやり方に比べ優れている点としてハッシュ値を組み合わせるために自分自身のアルゴリズムを用意しなくていいというところがあります。標準ライブラリ（の`Hasher`として実装された）ハッシュ用関数はほとんどの場合私達が自分で実装するよりも確実によく、セキュアのなものになります。

 例えばここに一つのプロパティが計算量の大きい計算のキャッシュとして働くような型があるとします。私達はこの`distanceFromOrigin`の値を`Equatable`や`Hashable`の実装から取り除かなくてはいけません:
 */
struct Point {
    var x: Int { didSet { recomputeDistance() } }
    var y: Int { didSet { recomputeDistance() } }

    /// キャッシュ。EquatableやHashableの対象から外れる必要がある
    private(set) var distanceFromOrigin: Double

    init(x: Int, y: Int) {
        self.x = x
        self.y = y
        self.distanceFromOrigin = Point.distanceFromOrigin(x: x, y: y)
    }

    private mutating func recomputeDistance() {
        distanceFromOrigin = Point.distanceFromOrigin(x: x, y: y)
    }

    private static func distanceFromOrigin(x: Int, y: Int) -> Double {
        return Double(x * x + y * y).squareRoot()
    }
}

extension Point: Equatable {
    static func ==(lhs: Point, rhs: Point) -> Bool {
        // 等価性を判定するときにdistanceFromOriginは無視する
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

/*:
 `hash(into:)`の実装でしなければいけないことは、関連するプロパティをhasherに渡してあげることだけです。

 この実装は自分で考えたハッシュ関数よりも簡単（なおかつ効果的）です。たとえば、愚直な`hashValue`の実装として２つの座標のXORを取るというのが考えられます:`return x^y`。これは`Point(3,4)`と`Point(4,3)`が同じハッシュ値になっているためハッシュ関数より劣っているといえます。
 */
extension Point: Hashable {
    func hash(into hasher: inout Hasher) {
        // distanceFromOriginはハッシュからも無視する
        hasher.combine(x)
        hasher.combine(y)
    }
}

let p1 = Point(x: 3, y: 4)
p1.hashValue
let p2 = Point(x: 4, y: 3)
p2.hashValue
assert(p1.hashValue != p2.hashValue)

/*:
 [目次](Table%20of%20contents) • [前へ](@previous) • [次へ](@next)
 */
