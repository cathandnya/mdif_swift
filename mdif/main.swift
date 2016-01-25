//
//  main.swift
//  mdif
//
//  Created by nya on 1/25/16.
//  Copyright © 2016 CatHand. All rights reserved.
//

import Foundation

var res: NSURLResponse?
do {
    let data = try NSURLSession.sendSynchronousDataTaskWithRequest(NSURLRequest(URL: NSURL(string: "http://zavoloklom.github.io/material-design-iconic-font/cheatsheet.html")!), returningResponse: &res)
    let string = String(data: data, encoding: NSUTF8StringEncoding)
    let parser = try HTMLParser(string: string)
    let body = parser.body()
    if let match = body.findChildrenWithAttribute("data-code", matchingName: "", allowPartial: true) as? [HTMLNode] {
        var header = String()
        header.appendContentsOf("import Foundation\n")
        header.appendContentsOf("\n")
        header.appendContentsOf("class MaterialFont {\n")
        header.appendContentsOf("\n")
        
        for node in match {
            if let name = node.getAttributeNamed("data-name"), code = node.getAttributeNamed("data-code") {
                var name = name.stringByReplacingOccurrencesOfString("-", withString: "_")
                if name.isMatchedByRegex("^[\\d]") || name == "case" || name == "repeat" {
                    name = "_" + name
                }
                header.appendContentsOf("    static let " + name + " = \"\\u{" + code + "}\"\n")
            }
        }
        header.appendContentsOf("}\n")
        
        header.dataUsingEncoding(NSUTF8StringEncoding)?.writeToFile("MaterialFont.swift", atomically: true)
        print(header)
    }
} catch let err as NSError {
    print("failed: \(err)")
}

