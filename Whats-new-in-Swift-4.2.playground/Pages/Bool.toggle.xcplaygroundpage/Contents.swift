/*:
 [目次](Table%20of%20contents) • [前へ](@previous) • [次へ](@next)

 # Bool.toggle

 [SE-0199](https://github.com/apple/swift-evolution/blob/master/proposals/0199-bool-toggle.md "Adding toggle to Bool")によりmutatingな`toggle`メソッドが`Bool`に追加されました。

 これは特にネストされたデータ構造の中の真偽値を切り替えたいときなど、代入文の左右に長い式を書かなくても済むといった点で役立ちます。
 */
struct Layer {
    var isHidden = false
}

struct View {
    var layer = Layer()
}

var view = View()

// Swift4.1以前:
view.layer.isHidden = !view.layer.isHidden
view.layer.isHidden

// Swift4.2:
view.layer.isHidden.toggle()
