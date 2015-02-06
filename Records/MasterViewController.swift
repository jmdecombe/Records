//
//  MasterViewController.swift
//  Records
//
//  Created by Jean-Michel Decombe on 2/5/15.
//  Copyright (c) 2015 Ludicode. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON

class MasterViewController: UITableViewController {

	var detailViewController: DetailViewController? = nil
	var artists = Dictionary<String, Artist>()
	var records = Array<Record>()

	override func awakeFromNib() {
		super.awakeFromNib()

		if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
		    self.clearsSelectionOnViewWillAppear = false
		    self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		Alamofire.request(.GET, "http://private-anon-0f76f54c4-recordsapi.apiary-mock.com/records/").responseJSON() { _, _, data, error in
			if error == nil {
				if let object: AnyObject = data {
					let json = JSON(object)
					for artist in json["linked"]["artists"].arrayValue {
						if let id = artist["id"].string {
							if let name = artist["name"].string {
								self.artists[id] = Artist(id, name: name)
							}
						}
					}
					for record in json["records"].arrayValue {
						if let id = record["id"].string {
							if let name = record["name"].string {
								let r = Record(id, name: name)
								for (type, link) in record["links"].dictionaryValue {
									if type == "artist" {
										if let author = self.artists[link.stringValue] {
											r.addAuthor(author)
										}
									}
								}
								self.records.append(r)
							}
						}
					}
					self.tableView.reloadData()
				} else {
					println("The network request succeeded, but returned no data.")
				}
			} else {
				println("A network request error occurred: \(error)")
			}
		}

		if let split = self.splitViewController {
		    let controllers = split.viewControllers
		    self.detailViewController = controllers[controllers.count - 1].topViewController as? DetailViewController
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	// MARK: - Segues

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "displayRecord" {
		    if let indexPath = self.tableView.indexPathForSelectedRow() {
		        let controller = (segue.destinationViewController as UINavigationController).topViewController as DetailViewController
		        controller.record = records[indexPath.row]
		        controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
		        controller.navigationItem.leftItemsSupplementBackButton = true
		    }
		}
	}

	// MARK: - Table View

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return records.count
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Record", forIndexPath: indexPath) as UITableViewCell
		let record = records[indexPath.row]
		if let title = cell.textLabel {
			title.text = record.name
		}
		if let subtitle = cell.detailTextLabel {
			subtitle.text = record.printAuthors()
		}
		return cell
	}

	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return false
	}

}