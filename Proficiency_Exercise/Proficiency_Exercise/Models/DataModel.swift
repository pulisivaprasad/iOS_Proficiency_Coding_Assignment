//
//  DataModel.swift
//  Proficiency_Exercise
//
//  Created by sivaprasad reddy on 21/08/19.
//  Copyright © 2019 Siva. All rights reserved.
//

import Foundation
public class DataModel {
    public var title : String?
    public var description : String?
    public var imageHref : String?
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [DataModel]
    {
        var models:[DataModel] = []
        for item in array
        {
            models.append(DataModel(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    required public init?(dictionary: NSDictionary) {
        
        title = dictionary["title"] as? String
        description = dictionary["description"] as? String
        imageHref = dictionary["imageHref"] as? String
        
    }
    
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.title, forKey: "title")
        dictionary.setValue(self.description, forKey: "description")
        dictionary.setValue(self.imageHref, forKey: "imageHref")
        
        return dictionary
    }
}
