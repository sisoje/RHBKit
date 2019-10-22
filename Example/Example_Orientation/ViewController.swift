//
//  ViewController.swift
//  Example_Orientation
//
//  Created by Lazar Otasevic on 07.02.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import RHBKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    let orientationTracker = OrientationTracker()

    override func viewDidLoad() {

        super.viewDidLoad()

        orientationTracker.startTracking { [weak self] tracker in

            UIView.animate(withDuration: 0.3) {

                self?.imageView.transform = CGAffineTransform(rotationAngle: -CGFloat(tracker.deviceRotation))
            }
        }
    }
}

