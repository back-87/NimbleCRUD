//
//  String+Hexidecimal.swift
//  
//
//  Created by Braden Ackerman on 2022-06-07.
//

import Foundation

public extension String {
    /// Get the numeric only value from the string
    /// - Parameter seperatorPerByte: If `true` then a separator will be inserted every two characters (hex byte)
    /// - Returns: Only hexidecimal characters (0-9, A-F).  If non-hex values were interspersed `1zF&` then the result will be `1F`.
    func hexidecimalStringRepresentation(seperatorPerByte: Bool) -> String {
        
        let charSetHex : CharacterSet = CharacterSet(charactersIn: "ABCDEFabcdef0123456789")
        
        let filteredForAllowedCharacters = String(self.unicodeScalars.filter { charSetHex.contains($0) }).uppercased()
    
        if(seperatorPerByte) {
           return filteredForAllowedCharacters.unfoldSubSequences(limitedTo: 2).joined(separator: ":")
        }
        
        return filteredForAllowedCharacters
    }
}

extension Collection {

    func unfoldSubSequences(limitedTo maxLength: Int) -> UnfoldSequence<SubSequence,Index> {
        sequence(state: startIndex) { start in
            guard start < endIndex else { return nil }
            let end = index(start, offsetBy: maxLength, limitedBy: endIndex) ?? endIndex
            defer { start = end }
            return self[start..<end]
        }
    }

    func every(n: Int) -> UnfoldSequence<Element,Index> {
        sequence(state: startIndex) { index in
            guard index < endIndex else { return nil }
            defer { let _ = formIndex(&index, offsetBy: n, limitedBy: endIndex) }
            return self[index]
        }
    }

    var pairs: [SubSequence] { .init(unfoldSubSequences(limitedTo: 2)) }
}

extension StringProtocol where Self: RangeReplaceableCollection {

    mutating func insert<S: StringProtocol>(separator: S, every n: Int) {
        for index in indices.every(n: n).dropFirst().reversed() {
            insert(contentsOf: separator, at: index)
        }
    }

    func inserting<S: StringProtocol>(separator: S, every n: Int) -> Self {
        .init(unfoldSubSequences(limitedTo: n).joined(separator: separator))
    }
}
