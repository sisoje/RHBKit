//
//  DataLoadViewController.swift
//  RHBKit_Example
//
//  Created by Lazar Otasevic on 27.02.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import RHBKit
import CoreData

class DataLoadViewController: UIViewController {

    @IBOutlet weak var progressView: FakeProgressView!
    public let container = NSPersistentContainer(name: "Model")

    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.startProgress()
        container.loadStoresAsync { [weak self] _, errors in
            self?.progressView.endProgess(errors.isEmpty)
            if errors.isEmpty {
                self?.performSegue(withIdentifier: "ZOLA", sender: self)
            }
        }
    }
}
