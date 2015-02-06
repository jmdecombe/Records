//
//  Artist.swift
//  Records
//
//  Created by Jean-Michel Decombe on 2/5/15.
//  Copyright (c) 2015 Ludicode. All rights reserved.
//

import Foundation

func ==(artist1: Artist, artist2: Artist) -> Bool {
	return artist1.hashValue == artist2.hashValue
}

class Artist: Hashable {

	var id: String
	var name: String

	var hashValue: Int {
		get {
			return id.hashValue
		}
	}

	init(_ id: String, name: String) {
		self.id = id
		self.name = name
	}

}