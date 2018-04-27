# PagingView
PagingView is a UI control using a swiping gesture to control the display of paged information.

## Demo
![PagingView](https://github.com/rallyhealth/PagingView/blob/master/PagingView.gif)

## Usage

```swift
let pagingView = PagingView(frame: view.frame)
pagingView.delegate = self

// Add your pagingSubviews (instantiated somewhere else):
pagingView.addPagingSubview(customView1)
pagingView.addPagingSubview(customView2)
pagingView.addPagingSubview(customView3)
```

## License

MIT
