# VisualTap
![](https://img.shields.io/badge/version-1.0.0-brightgreen.svg)

VisualTap is a micro iOS Dynamic Framework that can visualise the user's screen taps. It is a more modern, Swifty version of [TouchVisualizer](https://github.com/morizotter/TouchVisualizer).

Build using Swift 5.3, UIKit, Combine, Xcode 12.4, supports iOS 13.0+

# Preview
![](visual-tap-example.gif)

# Usage

The library functionality is accessed from the shared instance - `VisualTap.shared`.

On this instance, you can invoke:

```swift

// MARK: - Public Interface

extension VisualTap {

    /// Starts the visual markings of touches on screen.
    ///
    /// - Parameter configuration: The library configuration that you want applied.
    /// You can pick marker image, tint color, marker size and
    /// whether or not tap duration timer should be shown above the touch mark.
    public func start(_ config: VisualTap.Configuration = .default)

    /// Stops the visual markings of touches on screen.
    public func stop()
}

```

And you should see the screen touches being marked.

# Customisation

Additionally, you can customise the appearance of the markers, by invoking the `start()` function with custom `VisualTap.Configuration`. You can also access the live config by `VisualTap.shared.configuration` and alter its values directly.

```swift

// MARK: - Configuration Container

extension VisualTap {

    /// Container holding the whole configuration for the visual tap library.
    public class Configuration {

        /// Tint color of touch marker, in case the marker is template image.
        ///
        /// Default value is: _.systemFill_
        public var tintColor: UIColor { get set }

        /// Sets the touch marker.
        ///
        /// Default value is: _system image named: "smallcircle.fill.circle"_
        public var image: UIImage? { get set }

        /// Controls the visual marker size.
        ///
        /// Default value is: _60 x 60_
        public var size: CGSize { get set }

        /// Shows touch duration.
        ///
        /// Default value is: _false_
        public var showsTimer: Bool { get set }

        /// Creates a new configuration container with default values.
        public init()
    }
}

```

In regards to memory managment, the library is designed to have 0 retained objects when you call the `stop()` method. The same is also true if you have never referenced it in your code, but just have it linked in. When the taps are visualised, the number of allocated `UIImageView` instaces are equal to the number of taps on the screen - the moment the tap is gone - the `UIImageView` instance for it is released. There are two more instances allocated when the visualisation is turned on - `VisualTap` and its configuration, that you control the library from, but they get deallocated when you invoke `stop()` as said above, to keep the memory tidy.

# Installation

### Swift Package Manager

1. Navigate to `XCode project` > `ProjectName` > `Swift Packages` > `+ (add)`
2. Paste the url `https://github.com/stoqn4opm/VisualTap.git`
3. Select the needed targets.

### Carthage Installation

1. In your `Cartfile` add `github "stoqn4opm/VisualTap"`
2. Link the build framework with the target in your XCode project

For detailed instructions check the official Carthage guides [here](https://github.com/Carthage/Carthage)

### Manual Installation

1. Download the project and build the shared target called `VisualTap`
2. Add the product in the list of "embed frameworks" list inside your project's target or create a work space with VisualTap and your project and link directly the product of VisualTap's target to your target "embed frameworks" list
