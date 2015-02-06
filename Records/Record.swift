//
//  Record.swift
//  Records
//
//  Created by Jean-Michel Decombe on 2/5/15.
//  Copyright (c) 2015 Ludicode. All rights reserved.
//

import Foundation

import SwiftSets

class Record {

	var id: String
	var name: String
	var authors: Set<Artist> = []

	init(_ id: String, name: String) {
		self.id = id
		self.name = name
	}

	func addAuthor(artist: Artist) {
		authors.add(artist)
	}

	func removeAuthor(artist: Artist) {
		authors.remove(artist)
	}

	func printAuthors() -> String {
		var string: String = ""
		for author in authors {
			if countElements(string) > 0 {
				string += ", "
			}
			string += author.name
		}
		return string
	}
}