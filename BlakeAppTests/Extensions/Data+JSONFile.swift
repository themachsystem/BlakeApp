//
//  Data+JSONFile.swift
//  BlakeAppTests
//
//  Created by suitecontrol on 29/7/20.
//  Copyright © 2020 alvis. All rights reserved.
//

import Foundation
import XCTest

extension Data {
  
  public static func fromJSON(fileName: String,
                              file: StaticString = #file,
                              line: UInt = #line) throws -> Data {
    
    let bundle = Bundle(for: TestBundleClass.self)
    let url = try XCTUnwrap(bundle.url(forResource: fileName, withExtension: "json"),
                            "Unable to find \(fileName).json.",
      file: file, line: line)
    return try Data(contentsOf: url)
  }
}

private class TestBundleClass { }
