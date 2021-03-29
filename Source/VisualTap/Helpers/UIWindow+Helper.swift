//
//  UIWindow+Helper.swift
//  VisualTap
//
//  Created by Stoyan Stoyanov on 29/03/21.
//

import UIKit


// MARK: - Method Swizzling

fileprivate var isSwizzled = false

extension UIWindow {
    
    /// Swizzles the implementation of the `UIApplication.sendEvent` for `UIWindow` classes with another implementation,
    /// that presents the `TapView`s in the location of the event.
    func swizzle() {
        guard isSwizzled == false,
              let sendEvent = class_getInstanceMethod(object_getClass(self), #selector(UIApplication.sendEvent(_:))),
              let swizzledSendEvent = class_getInstanceMethod(object_getClass(self), #selector(UIWindow.swizzledSendEvent(_:))) else { return }
        
        method_exchangeImplementations(sendEvent, swizzledSendEvent)
        isSwizzled = true
    }

    @objc private func swizzledSendEvent(_ event: UIEvent) {
        VisualTap.instance?.handleEvent(event)
        swizzledSendEvent(event)
    }
}

// MARK: - Window Reference

extension UIWindow {
    
    /// Reference to the window on which we will draw the `TapView` instances to indicate touches.
    static var topMostWindow: UIWindow? {
        UIApplication.shared.windows
            .filter { $0.isHidden == false && $0.isKeyWindow }
            .sorted { $0.windowLevel < $1.windowLevel }
            .last
    }
}
