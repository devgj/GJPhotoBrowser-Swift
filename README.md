## GJPhotoBrowser-Swift

![show](https://github.com/devgj/GJPhotoBrowser-Swift/blob/master/GJPhotoBrowser-Swift/show.gif)

## Requirements
- iOS 8.0+
- Xcode 7.2+

## Installation
### CocoaPods
```ruby
pod 'GJPhotoBrowser-Swift', '~> 1.0'
```
## Usage

```swift
let photoBrowser = GJPhotoBrowser()
photoBrowser.dataSource = self
photoBrowser.showWith(currentIndex: index)

// MARK: - GJPhotoBrowserDataSource
func numberOfPhotosInPhotoBrowser(photoBrowser: GJPhotoBrowser) -> Int {
    return urls.count
}

func photoBrowser(photoBrowser: GJPhotoBrowser, viewForIndex index: Int) -> GJPhotoView {
    let photoView = photoBrowser.dequeueReusablePhotoView()
    let urlStr = urls[index]
    photoView.setImageWithURL(NSURL(string: urlStr)!, fromImageView: imageViews[index])
    return photoView
}
```

