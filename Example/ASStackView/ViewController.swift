//
//  ViewController.swift
//  ASStackView
//
//  Created by Ali Seymen on 12/06/2018.
//  Copyright (c) 2018 Ali Seymen. All rights reserved.
//

import UIKit
import ASStackView

class ViewController: UIViewController {

    @IBOutlet weak var stackView: ASStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        var arr : [ExampleView] = []
        for index in 0...10
        {
            let v = ExampleView()
            v.title = "View \(index)"
            arr.append(v)
        }
        
        stackView.views = arr
        stackView.pageChanged = { index in
            print("\(index)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

