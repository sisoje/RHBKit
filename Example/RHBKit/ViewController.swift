//
//  ViewController.swift
//  RHBKit
//
//  Created by redhotbits@gmail.com on 05/08/2017.
//  Copyright (c) 2017 redhotbits@gmail.com. All rights reserved.
//

import UIKit
import RHBKit


class ViewController: UIViewController {

    var counter:Int = 0
    @IBOutlet weak var butonche: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func buttonPress(_ sender: Any) {
        
        UIApplication.shared.openApplicationSettings { [unowned self] in
            
            self.counter += 1;
            self.butonche.setTitle(String(self.counter), for: UIControlState.normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)

        self.counter += 1;
        self.butonche.setTitle(String(self.counter), for: UIControlState.normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

