# Mozart

Mozart is a very lightweight image loader for iOS. It was inspired by [Picasso](http://square.github.io/picasso/), which was created by the people at [Square](http://square.github.io/). If you like the project, feel free to star it or watch it for updates. If you end up using it in one of your apps or need help of some sort, don't hesitate to let me know on Twitter [@jackcook36](https://twitter.com/jackcook36).

## Features

- Asynchronous image loading with one line of code
- Loading the image into an imageview/button in that same line of code
- Retrieve the image upon completion, in the same line of code

---
## Implementation

### Loading Directly into a View
If you want to load an image directly into a view, without retrieving it afterwards, it's pretty simple.

```swift
Mozart.load("http://placehold.it/100").into(imageView)
```

### Basic Image Retrieval
If you don't want to load an image directly into a view, you can retrieve it in a completion block.

```swift
Mozart.load("http://placehold.it/100").completion() { (image) -> Void in
    self.image = image
}
```

### Image Loading and Retrieval
If you want to load an image directly into a view and retrieve it afterwards, it's just an easy combination of both.

```swift
Mozart.load("http://placehold.it/100").into(imageView).completion() { (image) -> Void in
    self.image = image
}
```

---
## License

Mozart is available under the MIT license. See the LICENSE file for details.
