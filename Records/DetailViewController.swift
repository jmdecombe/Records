//
//  DetailViewController.swift
//  Records
//
//  Created by Jean-Michel Decombe on 2/5/15.
//  Copyright (c) 2015 Ludicode. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

	@IBOutlet weak var recordLabel: UILabel!
	@IBOutlet weak var authorLabel: UILabel!

	var record: Record? {
		didSet {
		    self.reloadData()
		}
	}

	func reloadData() {
		if let r = self.record {
			if let title = recordLabel {
				title.text = r.name
			}
			if let subtitle = authorLabel {
				subtitle.text = r.printAuthors()
			}
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		reloadData()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

}