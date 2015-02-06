//
//  DetailViewController.swift
//  Records
//
//  Created by Jean-Michel Decombe on 2/5/15.
//  Copyright (c) 2015 Ludicode. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

	@IBOutlet weak var detailDescriptionLabel: UILabel!

	var detailItem: AnyObject? {
		didSet {
		    self.configureView()
		}
	}

	func configureView() {
		if let detail: AnyObject = self.detailItem {
		    if let label = self.detailDescriptionLabel {
		        label.text = detail.description
		    }
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.configureView()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
}

