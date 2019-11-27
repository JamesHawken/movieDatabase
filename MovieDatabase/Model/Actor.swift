//
//  Actor.swift
//  MovieDatabase
//
//  Created by James Hawken on 27/11/2019.
//  Copyright © 2019 Gil Nakache. All rights reserved.
//
import UIKit
import Foundation
struct Actor {
    var name:String
    var character:String
    var castId:Int
}


struct ActorResponse {
    var cast: [Actor]
}
extension Actor: Codable {}
extension ActorResponse: Codable {}
