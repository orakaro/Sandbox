//
//  ViewController.swift
//  UIKitSandbox
//
//  Created by DTVD on 2021/02/07.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadScreens()
    }

    func loadScreens() {
        let vc = ComponentDemoViewController.make()
        embed(vc, to: view)
    }
}

