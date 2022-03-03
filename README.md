<p align="center">
    <img src="https://raw.githubusercontent.com/lukaswuerzburger/AsyncViewKit/develop/readme-images/async.png" alt="Flow Diagram" title="Flow Diagram" width="128"  height="128"/><br/>
    <b>AsyncViewKit</b><br/>
    <br/>
    <img src="https://img.shields.io/badge/Swift-5-orange" alt="Swift Version" title="Swift Version"/>
    <a href="https://travis-ci.org/lukaswuerzburger/AsyncViewKit"><img src="https://travis-ci.org/lukaswuerzburger/AsyncViewKit.svg?branch=develop" alt="Build Status" title="Build Status"/></a>
    <a href="https://cocoapods.org/pods/AsyncViewKit"><img src="https://img.shields.io/cocoapods/v/AsyncViewKit.svg?style=flat-square" alt="CocoaPods Compatible" title="CocoaPods Compatible"/></a>
    <img src="https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square" alt="License MIT" title="License MIT"/>
</p>


## Contents

- ✍️ [Description](#%EF%B8%8F-description)
- 🖥 [Example](#-example)
- 🎟 [Demo](#-demo)
- 🔨 [Customization](#-customization)
- 💻 [How to use](#-how-to-use)
- ⚠️ [Requirements](#%EF%B8%8F-requirements)
- 💆 [Inspiration](#-inspiration)
- 💪 [Contribute](#-contribute)

## ✍️ Description

The `AsyncViewController` works as a bridge between loading your data for a specific view and presenting the view controller. It presents a loading screen as long as you're waiting for a response and you can provide the destination view controllers (either for success or error) beforehand without having to put all this logic into your final view controller.

<img src="https://raw.githubusercontent.com/lukaswuerzburger/AsyncViewKit/develop/readme-images/flow-diagram.png" alt="Flow Diagram" title="Flow Diagram"/>

## 🖥 Example

**The old way:**

The initial motivation was to get rid of the optional object property inside of a detail view controller and also remove the logic from the detail view controller including the data loading and displaying a loading view. 

Imagine a *BookViewController*:
```swift
class BookViewController: UIViewController {

    var book: Book?
    // Having the represented object for this view controller as an optional is inconvenient.
    
    var loadingView: LoadingView?
    // Also having the loading view in here is inconvenient since we only need it once in the beginning.
    
    init(bookId: Int) {
        super.init(...)
        
        // Load the book here
        MyLibrary.loadBook(id: bookId) { result in
            // Refresh UI
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Then you initialize your UI, first without data but after loading again with data.
    }
}
```

**The new way:**

The `AsyncViewController` burries the boiler plate code and provides you a handy initializer to define your asynchronous call, the view controller when it was successful, and a resolution action when it fails.

Imagine calling this from a *BookShelfViewController*:
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

## 🎟 Demo

<img src="https://raw.githubusercontent.com/lukaswuerzburger/AsyncViewKit/develop/readme-images/async-view-controller-demo.gif" alt="Async View Kit Demo" title="Async View Kit Demo" width="320"/>

You can find this demo app in this repository.

## 🔨 Customization

**Error Handling:**

You can provide a custom action when the loading fails. The `FailureResolution` enum provides a case that you can use to pass a callback.  
Maybe you want to dismiss the view controller, or pop it from the navigation stack. 

```swift
return .custom({ asyncViewController in
    asyncViewController.dismiss(animated: true)
})
```

**Custom Loading View:**

If you want to show your own loading view you can use any `UIViewController` conforming to the `LoadingAnimatable` protocol described [here](AsyncViewKit/Sources/LoadingAnimatable.swift).

```swift
asyncViewController.loadingViewController = MyLoadingViewController()
```

Check out the Demo 

## 💻 How to use

**Swift Package Manager**:  
Add the following to your `Package.swift` file:
```swift
dependencies: [
    .package(url: "https://github.com/lukaswuerzburger/AsyncViewKit.git", from: "3.0.0")
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
