//
//  ViewController.swift
//  VisualTapExample
//
//  Created by Stoyan Stoyanov on 29/03/21.
//

import UIKit
import VisualTap


// MARK: - Class Definition

final class ViewController: UIViewController {

}

// MARK: - User Actions

extension ViewController {
    
    @IBAction private func startTapped(_ sender: UIButton) {
        VisualTap.shared.start()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            VisualTap.shared.configuration.tintColor = .cyan
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                VisualTap.shared.configuration.image = UIImage(systemName: "folder.circle.fill")
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    VisualTap.shared.configuration.showsTimer = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        VisualTap.shared.configuration.size = CGSize(width: 100, height: 100)
                    }
                }
            }
        }
    }
    
    @IBAction private func stopTapped(_ sender: UIButton) {
        VisualTap.shared.stop()
    }
}
