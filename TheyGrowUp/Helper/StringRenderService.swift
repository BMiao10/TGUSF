//
//  StringRenderService
//  TheyGrowUp
//
//  Created by Jared Shenson on 10/8/18.
//  Copyright © 2018 Brenda Miao. All rights reserved.
//

import Foundation
import Regex //CrossroadsRegex

public enum StringRenderError: Error {
    case ChildMissing
    case UndefinedTag(tag: String)
}

public struct StringRenderService {
    
    /**
     Renders a templated string with data. Simplified version of Mustache templating language.
     Template tags are of type {{ variableName }}
     - parameter string: The templated string to render
     - parameter data: A data mapping dictionary to convert Key<String> to Value<String>
     - Returns: New string with templates replaced.
     */
    public static func render(_ string: String, data: Dictionary<String, String>) throws -> String {
        // Matches {{text}} following Mustache templating convention
        let regex = try! Regex(pattern: "\\{\\{(.+?)\\}\\}")
        
        var undefinedTags: [String] = []
        let replaced = regex.replaceAll(in: string) { (match) -> String? in
            //print( match.group(at: 1) )
            let replacement = data[ match.group(at: 1)! ]
            if replacement == nil {
                undefinedTags.append(match.group(at: 1)!)
            }
            return replacement
        }
        
        // Check if any undefined tags were encountered
        guard undefinedTags.count == 0 else {
            throw StringRenderError.UndefinedTag(tag: undefinedTags.first! )
        }
        
        return replaced
    }
    
    /**
     Renders a templated string with data. Simplified version of Mustache templating language.
     Template tags are of type {{ variableName }}
     Convenience method that sets data dictionary to Child's properties
     - TODO: Eliminate this unsafe and poorly encapsulated method.
     - parameter string: The templated string to render
     - Returns: New string with templates replaced.
     */
    public static func render(_ string: String) throws -> String {
        guard let child = Parent.shared.child else {
            throw StringRenderError.ChildMissing
        }
        
        let dict = [
            "Child.name": child.name,
            "Child.gender": child.gender.diminutive,
            "Child.pronoun.he": child.gender.pronoun(.he),
            "Child.pronoun.him": child.gender.pronoun(.him),
            "Child.pronoun.his": child.gender.pronoun(.his),
            "Child.pronoun.He": child.gender.pronoun(.He),
            "Child.pronoun.Him": child.gender.pronoun(.Him),
            "Child.pronoun.His": child.gender.pronoun(.His)
        ]
        
        return try render(string, data: dict)
    }
    
}

// TODO: Make it possible to pass an object to the render function, transforming the object into a dictionary using the asDictionary() method below
extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
