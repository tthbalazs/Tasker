//
//  String+Extensions.swift
//
//
//  Created by MaTooSens on 23/10/2023.
//

import Foundation

extension String {
    public var isNotEmpty: Bool {
        !self.isEmpty
    }
    
    public var containsWhitespaceAndNewLines: Bool {
        self.rangeOfCharacter(from: .whitespacesAndNewlines) != nil
    }
    
    public var doesNotContainWhitespaceAndNewLines: Bool {
        !self.containsWhitespaceAndNewLines
    }
}
