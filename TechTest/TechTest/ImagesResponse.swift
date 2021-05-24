//
//  UserResponse.swift
//  BrainTest
//
//  Created by Narek on 11/17/20.
//

import Foundation

struct ImagesResponse: Decodable {
    var hits: [Image]
}

struct Image: Decodable {
    var previewURL: String
}
