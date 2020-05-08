# AsyncViewController

### Contents

- ✍️ [Description](#-description)
- 🖥 [Examples](#-examples)
- 💻 [How to use](#-how-to-use)
- ⚠️ [Requirements](#-requirements)
- 💪 [Contribute](#-contribute)

### ✍️ Description

The `AsyncViewController` works as a bridge between loading your data for a specific view and presenting the view controller

### 🖥 Examples

```swift
struct Book {
    var id: Int
    var title: String
}
```

```swift
func presentBookViewController(bookId: Int) {
    let viewController = AsyncViewController(load: { callback in
        MyBackend.loadBook(id: bookId, handler: callback)
    }, success: { book -> BookViewController in
        return .init(book: book)
    }) { error -> AsyncViewController<BookViewController, String, Error>.FailureResolution in
        return .showViewController(ErrorViewController(error))
    }
    viewController.overridesNavigationItem = true
    present(viewController, animated: true)
}
```

You can provide a custom action when the loading fails. The `FailureResolution` enum provides a case that you can use to pass a callback.

```swift
return .custom({ asyncViewController in
    asyncViewController.dismiss(animated: true)
})
```

### 💻 How to use

`AsyncViewController` is available on Cocoapods. Just put following line in your `Podfile`:
```ruby
pod 'AsyncViewController'
```

### ⚠️ Requirements

- Swift 5+
- iOS 9+
- Xcode 9+

### 💪 Contribute

Issues and pull requests are welcome.
