# AsyncViewController

## Contents

- ✍️ [Description](#%EF%B8%8F-description)
- 🖥 [Examples](#-examples)
- 🔨 [Customization](#-customization)
- 💻 [How to use](#-how-to-use)
- ⚠️ [Requirements](#-requirements)
- 💆 [Inspiration](#%EF%B8%8F-inspiration)
- 💪 [Contribute](#-contribute)

## ✍️ Description

The `AsyncViewController` works as a bridge between loading your data for a specific view and presenting the view controller. It presents a loading screen as long as you're waiting for a response and you can provide the destination view controllers (either for success or error) beforehand without having to put all this logic into your final view controller.

## 🖥 Example

### **The old way**

The initial motivation was to get rid of the optional object property inside of a detail view controller and also remove the logic from the detail view controller including the data loading and displaying a loading view. 

Imagine a **BookViewController**
```swift
class BookViewController: UIViewController {

    var book: Book?
    var loadingView: LoadingView?
    
    init(bookId: Int) {
        super.init(...)
        
        // Load the book here
        MyLibrary.loadBook(id: bookId) { result in
            ...
        }
    }
}
```

### **The new way**

The `AsyncViewController` burries the boiler plate code and provides you a handy initializer to define your asynchronous call, the view controller when it was successful, and a resolution action when it fails.

Imagine calling this from a **BookShelfViewController**:
```swift
func presentBookViewController(bookId: Int) {
    let asyncViewController = AsyncViewController(load: { callback in
        MyLibrary.loadBook(id: bookId, handler: callback)
    }, success: { book -> BookViewController in
        return BookViewController(book: book)
    }) { error -> AsyncViewController<BookViewController, String, Error>.FailureResolution in
        return .showViewController(ErrorViewController(error))
    }
    asyncViewController.overridesNavigationItem = true
    present(asyncViewController, animated: true)
}
```

## 🔨 Customization

### **Error Handling**

You can provide a custom action when the loading fails. The `FailureResolution` enum provides a case that you can use to pass a callback.  
Maybe you want to dismiss the view controller, or pop it from the navigation stack. 

```swift
return .custom({ asyncViewController in
    asyncViewController.dismiss(animated: true)
})
```

### **Custom Loading View**

If you want to show your own loading view you can use any `UIViewController` conforming to the `LoadingAnimatable` protocol described [here](AsyncViewController/Sources/LoadingAnimatable.swift).

```swift
asyncViewController.loadingViewController = MyLoadingViewController()
```

## 💻 How to use

**Cocoapods**:  
`AsyncViewController` is available on Cocoapods. Just put following line in your `Podfile`:
```ruby
pod 'AsyncViewController'
```

**Swift Package Manager**:  
Add the following to your `Package.swift` file:
```swift
dependencies: [
    .package(url: "https://github.com/lukaswuerzburger/AsyncViewController.git", from: "1.0.1")
]
```

## ⚠️ Requirements

- Swift 5+
- iOS 9+
- Xcode 9+

## 💆 Inspiration

- [Swift Talk: Loading View Controllers](http://talk.objc.io/episodes/S01E3-loading-view-controllers)
- [Swift & Fika 2018 – John Sundell: The Lost Art of System Design](https://www.youtube.com/watch?v=ujOc3a7Hav0)

## 💪 Contribute

Issues and pull requests are welcome.
