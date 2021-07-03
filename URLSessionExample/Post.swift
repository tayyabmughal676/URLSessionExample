//
//  Post.swift
//  URLSessionExample
//
//  Created by Thor on 03/07/2021.
//

import Foundation

struct Post : Decodable, Encodable {
    let id: Int
    let title: String
    let body: String
}
