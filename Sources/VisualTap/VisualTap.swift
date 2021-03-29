//
//  VisualTap.swift
//  VisualTap
//
//  Created by Stoyan Stoyanov on 29/03/21.
//

#if os(iOS)

import UIKit
import Combine


// MARK: - Shared Instance

extension VisualTap {
    
    /// The shared singleton instance of VisualTap, the framework for visualizing screen taps.
    static public var shared: VisualTap {
        if let instance = instance {
            return instance
        } else {
            let newInstance = VisualTap()
            instance = newInstance
            return newInstance
        }
    }
    
    /// Memory location where the library is kept allocated when it is in use.
    ///
    /// All of the objects from the library are deallocated when it is stopped.
    static private(set) var instance: VisualTap?
}

// MARK: - Class Definition

/// Library that allows you to visualize the screen taps of the user,
/// by drawing images on the place of the touches.
final public class VisualTap {
    
    /// Holds the current configuration of the `VisualTap` library.
    ///
    /// Default value is: `VisualTap.Configuration.default`.
    @Published public var configuration: VisualTap.Configuration = .default
    
    /// Gives info if the VisualTap framework for visualizing the screen taps is currently enabled or not.
    public private(set) var isEnabled = false

    
    /// Container holding the tap views, so that when moving happens, we can find and move the added views.
    private var tapViews: [UITouch: TapView] = [:]
    private var cancellable: Set<AnyCancellable> = []
    
    
    private init() {
        
        NotificationCenter.default
            .publisher(for: UIDevice.orientationDidChangeNotification)
            .sink { [weak self] _ in self?.clearAllTapViews() }
            .store(in: &cancellable)

        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
    }
    
    deinit {
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }
}

// MARK: - Public Interface

extension VisualTap {
    
    /// Starts the visual markings of touches on screen.
    ///
    /// - Parameter configuration: The library configuration that you want applied.
    /// You can pick marker image, tint color, marker size and
    /// whether or not tap duration timer should be shown above the touch mark.
    public func start(_ config: VisualTap.Configuration = .default) {
        UIWindow.topMostWindow?.swizzle()
        isEnabled = true
        self.configuration = config
        clearAllTapViews()
    }
    
    /// Stops the visual markings of touches on screen.
    public func stop() {
        isEnabled = false
        clearAllTapViews()
        VisualTap.instance = nil
    }
}

// MARK: - Helpers

extension VisualTap {
    
    func handleEvent(_ event: UIEvent) {
        guard isEnabled,
              event.type == .touches else { return }
        
        event.allTouches?.forEach { touch in
            switch touch.phase {
            case .began:
                let tapView = TapView()
                tapViews[touch] = tapView
                tapView.begin(touch)
                
            case .moved:
                let tapView = tapViews[touch]
                tapView?.moveTo(touch)
                                
            case .ended, .cancelled:
                let tapView = tapViews[touch]
                tapView?.end()
                tapViews[touch] = nil
                
            case .stationary, .regionEntered, .regionMoved, .regionExited: fallthrough
            @unknown default:
                break
            }
        }
    }
    
    /// Removes all initialized tap views from their superviews and
    /// also releases their references from within `tapViews` dictionary.
    private func clearAllTapViews() {
        tapViews.values.forEach { $0.removeFromSuperview() }
        tapViews.removeAll()
    }
}

#endif
