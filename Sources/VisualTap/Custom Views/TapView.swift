//
//  TapView.swift
//  VisualTap
//
//  Created by Stoyan Stoyanov on 29/03/21.
//

#if os(iOS)

import UIKit
import Combine


// MARK: - Class Definition

/// The view that gets drawn at the place where touch occurs.
final class TapView: UIImageView {
    
    /// The touch object that this tap view visualizes.
    weak var touch: UITouch?
    
    
    /// The label that counts the duration from when the touch occurred.
    private var timerLabel: UILabel? { viewWithTag(0xBADF00D) as? UILabel }
    
    /// Memory hook for the ui update subscriptions.
    private var cancellable: Set<AnyCancellable> = []
    
    /// Memory hook for the touch duration timer subscription.
    private var timerCancellable: AnyCancellable?
     
    
    /// Creates a new instance of `TapView`.
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        loadConfiguration(VisualTap.shared.configuration)
        putTimerLabel()
        
        VisualTap.shared.$configuration
            .sink { [weak self] in self?.loadConfiguration($0) }
            .store(in: &cancellable)
        
        VisualTap.shared.configuration.$image
            .removeDuplicates()
            .sink { [weak self] in self?.image = $0 }
            .store(in: &cancellable)
        
        VisualTap.shared.configuration.$tintColor
            .removeDuplicates()
            .sink { [weak self] color in
                self?.tintColor = color
                self?.timerLabel?.textColor = color
            }
            .store(in: &cancellable)
        
        VisualTap.shared.configuration.$size
            .removeDuplicates()
            .sink { [weak self] in self?.frame = CGRect(origin: .zero, size: $0) }
            .store(in: &cancellable)
        
        VisualTap.shared.configuration.$showsTimer
            .removeDuplicates()
            .sink { [weak self] showTimer in
                self?.timerLabel?.alpha = showTimer ? 1 : 0
            }
            .store(in: &cancellable)
    }
}

// MARK: - Interface

extension TapView {
    
    /// Invoke this when touch just began.
    func begin(_ touch: UITouch) {
        guard let topWindow = UIWindow.topMostWindow else { return }
        self.touch = touch
        self.center = touch.location(in: topWindow)
        topWindow.addSubview(self)
        
        frame = CGRect(origin: frame.origin, size: VisualTap.shared.configuration.size)
        setupCountdownTimerSubscription()
    }
    
    /// Moves this `TapView` to a new location.
    ///
    /// - Parameter center: Pass here the new center you want this tap view to be moved to.
    func moveTo(_ touch: UITouch) {
        guard let topWindow = UIWindow.topMostWindow else { return }
        center = touch.location(in: topWindow)
    }
    
    /// Invoke this when touch just ended.
    func end() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .allowUserInteraction, animations: { [weak self] in
            self?.alpha = 0.0
            self?.timerCancellable?.cancel()
        }) { [weak self] _ in
            self?.removeFromSuperview()
        }
    }
}

// MARK: - Helpers

extension TapView {
    
    /// Loads a given `VisualTap.Configuration` configuration
    /// in this `TapView` instance.
    ///
    /// - Parameter configuration: The configuration you want loaded.
    private func loadConfiguration(_ configuration: VisualTap.Configuration) {
        image = configuration.image
        contentMode = .scaleAspectFill
        tintColor = configuration.tintColor
        timerLabel?.textColor = configuration.tintColor
        timerLabel?.alpha = configuration.showsTimer ? 1 : 0
        frame = CGRect(origin: .zero, size: configuration.size)
    }
    
    /// Puts the countdown timer label, when the `TapView` gets initialized.
    private func putTimerLabel() {
        let timerLabel = UILabel(frame: .zero)
        timerLabel.tag = 0xBADF00D
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.textAlignment = .center
        timerLabel.font = .monospacedDigitSystemFont(ofSize: UIFont.systemFontSize, weight: .regular)
        addSubview(timerLabel)
        
        let xCenter = NSLayoutConstraint(item: timerLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: timerLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 8)
        let width = NSLayoutConstraint(item: timerLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)
        let height = NSLayoutConstraint(item: timerLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 44)
        
        addConstraints([xCenter, bottom, width, height])
    }
    
    /// Sets up a timer that updates the passed time in the `timerLabel`.
    private func setupCountdownTimerSubscription() {
        let startDate = Date()
        timerCancellable = Timer
            .publish(every: 1 / 60, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] now in
                let interval = now.timeIntervalSince(startDate)
                self?.timerLabel?.text = String(format: "%.02f", interval)
            }
    }
}

#endif
