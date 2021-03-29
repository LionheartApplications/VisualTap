//
//  VisualTap+Configuration.swift
//  VisualTap
//
//  Created by Stoyan Stoyanov on 29/03/21.
//

#if os(iOS)

import UIKit
import Combine


// MARK: - Default Configuration

extension VisualTap.Configuration {
    
    /// The default configuration for VisualTap library.
    public static var `default`: VisualTap.Configuration { .init() }
}

// MARK: - Configuration Container

extension VisualTap {
    
    /// Container holding the whole configuration for the visual tap library.
    public class Configuration {

        /// Tint color of touch marker, in case the marker is template image.
        ///
        /// Default value is: _.systemFill_
        @Published public var tintColor: UIColor = .systemFill
        
        /// Sets the touch marker.
        ///
        /// Default value is: _system image named: "smallcircle.fill.circle"_
        @Published public var image: UIImage? = UIImage(systemName: "smallcircle.fill.circle")
        
        /// Controls the visual marker size.
        @Published public var size = CGSize(width: 60.0, height: 60.0)
        
        /// Shows touch duration.
        @Published public var showsTimer = false
        
        
        /// Creates a new configuration container.
        public init() { }
    }
}

#endif
