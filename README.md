# Picker - iOS 

## 🖥️ Project info 
iOS Picker


`PickerViewController` has 3 has three functions.

- Gallery: Select albums and images.
- Camera: Take image through the device's camera and stored your device 
- PhotoEditor: Crop & Rotate image 


## Usage

### Presenting
`PickerViewController` is UIViewController. You can set limit of the selectable images

```swift
let picker = PickerViewController()
picker.delegate = self
picker.setLimit(5)
present(picker, animated: true)
```

### Delegate

`ImagePickerControllerDelegate` delivers the results of the image picker.

```swift
func picker(_ picker: PickerViewController, didFinishPicking results: [PickerResult])
func pickerDidCancel(_ picker: PickerViewController)
```

### Resolving

The delegate methods give you `PickerResult`, which are just wrappers around `Image`

 
`PickerResult`

```swift
public struct PickerResult {
    public func loadImage(_ completionHandler: @escaping (UIImage?) -> Void)
    public static func loadImages(_ results: [PhotoPicker.PickerResult], _ completionHandler: @escaping ([UIImage?]) -> Void)    
    public func loadImage() async -> UIImage?
    public static func loadImages(_ results: [PhotoPicker.PickerResult]) async -> [UIImage?]
    public func canLoadImage() -> Bool
}

```

### Permission

`PickerViewController` handles permissions for app. Declare usage descriptions in plist files

```xml
<key>NSCameraUsageDescription</key>
<string>A message that tells the user why the app is requesting access to the device’s camera.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>A message that tells the user why the app is requesting access to the user’s photo library.</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>A message that tells the user why the app is requesting add-only access to the user’s photo library.</string>
```


## 📌 Detail


#### PickerViewController
- `Send reulst` through `PickerViewControllerDelegate`
- Get Image from Gallery
- `Set limit` of the selectable image. 


#### Gallery 
- `Gets the image of the device`. 🎆
- Can choose the `album`. 🗂
- Use the `camera` to capture and save images. 📸
- Modify selected image through the `PhotoEditor`  


#### PhotoEditor
- `Crop` the image in `Freestyle`, `1:1`, `4:3`, `3:4` ratio 
- `Rotate` the image. 🔁
