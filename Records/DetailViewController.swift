//
//  DetailViewController.swift
//  Records
//
//  Created by Jean-Michel Decombe on 2/5/15.
//  Copyright (c) 2015 Ludicode. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON

class DetailViewController: UIViewController {

	@IBOutlet weak var recordCover: UIImageView!
	@IBOutlet weak var recordLabel: UILabel!
	@IBOutlet weak var authorLabel: UILabel!

	var record: Record? {
		didSet {
		    self.reloadData()
		}
	}

	func reloadData() {
		if let r = self.record {

			if recordLabel != nil {
				recordLabel.text = r.name
			}

			if authorLabel != nil {
				authorLabel.text = r.printAuthors()
			}

			if recordCover != nil {
				if let appleiTunesStoreSearchURL = NSBundle.mainBundle().objectForInfoDictionaryKey("AppleiTunesStoreSearchURL") as? String {
					let parameters = r.name + " " + r.printAuthors()
					let encodedParameters = String(map(parameters.generate()) {
						$0 == " " ? "+" : $0
						})

					Alamofire.request(.GET, appleiTunesStoreSearchURL + encodedParameters).responseJSON() { _, _, data, error in
						var cover: UIImage?
						if error == nil {

							if let object: AnyObject = data {
								let json = JSON(object)

								if let resultURL = json["results"][0]["artworkUrl100"].string {
									if let coverURL = NSURL(string: resultURL) {
										if let data = NSData(contentsOfURL: coverURL) {
											cover = UIImage(data: data)
										}
									}
								}
							}
						}
						self.recordCover.image = cover
					}
				} else {
					recordCover.image = nil
				}
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