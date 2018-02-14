# PagingView
PagingView is a UI control used in the iOS Care app. A swiping gesture controls the display of paged information.

## Demo



## Usage

```swift
let pagingView = PagingView(frame: view.frame)
pagingView.delegate = self

// Add your pagingSubviews (instantiated somewhere else):
pagingView.addPagingSubview(customView1)
pagingView.addPagingSubview(customView2)
pagingView.addPagingSubview(customView3)
```

## Installation

### CocoaPods

Add this to your Podfile.

```ogdl
pod 'PagingView'
```

## License

MIT
