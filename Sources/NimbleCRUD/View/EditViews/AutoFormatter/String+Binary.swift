//
//  String+Binary.swift
//  
//
//  Created by Braden Ackerman on 2022-06-07.
//

import Foundation

public extension String {
    
    /// Get the numeric only value from the string
    /// - Parameter seperatorPerByte: If `true` then a separator will be inserted every two characters (hex byte)
    /// - Returns: Only binary on/off characters (1 || 0).  If non-binary values were interspersed `1z0&` then the result will be `10`.
    func binaryStringRepresentation(seperatorPerByte: Bool) -> String {
        
        let charSetBinary : CharacterSet = CharacterSet(charactersIn: "01")
        
        let filteredForAllowedCharacters = String(self.unicodeScalars.filter { charSetBinary.contains($0) })
        
        if(seperatorPerByte) {
           return filteredForAllowedCharacters.unfoldSubSequences(limitedTo: 8).joined(separator: " ")
        }
        
        return filteredForAllowedCharacters
    }
}
