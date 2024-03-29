//
//  Result.swift
//  BucketList
//
//  Created by Andrei Korikov on 15.09.2021.
//

import Foundation

struct Result: Codable {
  let query: Query
}

struct Query: Codable {
  let pages: [String: Page]
}

struct Page: Codable, Comparable {
  let pageid: Int
  let title: String
  let terms: Terms?
  
  var description: String {
    terms?.termsDescription.first ?? "No further information"
  }
  
  static func < (lhs: Page, rhs: Page) -> Bool {
    lhs.title < rhs.title
  }
  
  static func == (lhs: Page, rhs: Page) -> Bool {
    lhs.title == rhs.title
  }
}

struct Terms: Codable {
  let termsDescription: [String]
  
  enum CodingKeys: String, CodingKey {
    case termsDescription = "description"
  }
}
