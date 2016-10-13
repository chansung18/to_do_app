//
//  DataDisplayHandler.swift
//  to_do
//
//  Created by chansung on 9/21/16.
//  Copyright © 2016 chansung_eunkyo. All rights reserved.
//

import Foundation

class DataDisplayHandler {
    static let sharedInstance = DataDisplayHandler()
    
    fileprivate init() {}
    
    func searchByTitle(_ doList:[Dolist], title: String) -> [Dolist] {
        var filteredList = [Dolist]()
        
        for item in doList {
            if item.title!.contains(title) {
                filteredList.append(item)
            }
        }
        
        return filteredList
    }
}
