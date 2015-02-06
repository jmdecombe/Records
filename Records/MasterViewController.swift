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
	var objects = NSMutableArray()

	override func awakeFromNib() {
		super.awakeFromNib()

		if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
		    self.clearsSelectionOnViewWillAppear = false
		    self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		self.navigationItem.leftBarButtonItem = self.editButtonItem()
		let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
		self.navigationItem.rightBarButtonItem = addButton
		if let split = self.splitViewController {
		    let controllers = split.viewControllers
		    self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
		}

		Alamofire.request(.GET, "http://private-anon-0f76f54c4-recordsapi.apiary-mock.com/records/").responseJSON() { _, _, data, error in
			if error == nil {
				println(data)
				if let object: AnyObject = data {
					let json = JSON(object)
				}
			} else {
				println("A network request error occurred: \(error)")
			}
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	func insertNewObject(sender: AnyObject) {
		objects.insertObject(NSDate(), atIndex: 0)
		let indexPath = NSIndexPath(forRow: 0, inSection: 0)
		self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
	}

	// MARK: - Segues

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "showDetail" {
		    if let indexPath = self.tableView.indexPathForSelectedRow() {
		        let object = objects[indexPath.row] as NSDate
		        let controller = (segue.destinationViewController as UINavigationController).topViewController as DetailViewController
		        controller.detailItem = object
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
		return objects.count
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
		let object = objects[indexPath.row] as NSDate
		cell.textLabel!.text = object.description
		return cell
	}

	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return false
	}
}