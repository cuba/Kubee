//
//  FilterParser.swift
//  Kubee
//
//  Created by Jacob Sikorski on 2017-04-07.
//  Copyright © 2017 Studio MDE Inc. All rights reserved.
//

import Foundation

class FilterParser {
    enum ParsingError: Error {
        case unexpectedCharacter(Character, at: Int)
        case expectingCharacter(Character, at: Int, received: Character)
        case terminated(at: Int, expected: Character)
    }
    
    let currentString: String
    private var currentIndex: Int
    
    init(string: String) {
        self.currentString = string
        self.currentIndex = 0
    }
    
    static func validateFilter(_ filter: String) -> Bool {
        var valid = true
        var opened = false
        
        for character in filter {
            if (opened && character == "{") || !opened && character == "}" {
                valid = false
                break
            } else if character == "{" {
                opened = true
                valid = false
            } else if character == "}" {
                opened = false
                valid = true
            }
        }
        
        return valid
    }
    
    func parse() throws -> [FilterComponent] {
        var filterComponents: [FilterComponent] = []
        self.currentIndex = 0
        advance(by: 0)
        
        while currentIndex < currentString.count {
            let currentCharacter = currentString[currentIndex]
            
            if currentCharacter == "{" {
                filterComponents.append(try parseSelectorComponent());
            } else {
                filterComponents.append(try parseStaticComponent());
            }
        }
        
        return filterComponents
    }
    
    private func parseStaticComponent() throws -> FilterComponent {
        let startIndex = currentIndex;
        
        // Iterate to get the end
        while currentIndex < currentString.count {
            try checkUnexpectedCharacters(["}"])
            let currentCharacter = currentString[currentIndex]
            
            if currentCharacter == "{" {
                break
            }
            
            advance(by: 1)
        }
        
        let endIndex = currentIndex;
        let range = currentString.range(from: startIndex, to: endIndex)
        let substring = currentString.substring(with: range)
        
        return FilterComponent(range: range, value: substring, type: .text)
    }
    
    private func parseSelectorComponent() throws -> FilterComponent {
        let startIndex = currentIndex
        
        // Iterate to get the end
        while currentIndex < currentString.count {
            advance(by: 1)
            try checkTerminated()
            let currentCharacter = currentString[currentIndex]
            
            if currentCharacter == "}" {
                advance(by: 1)
                break;
            } else {
                try checkUnexpectedCharacters(["{", "/"]);
            }
            
        }
        
        let endIndex = currentIndex
        let range = currentString.range(from: startIndex, to: endIndex)
        let substring = currentString.substring(with: range)
        return FilterComponent(range: range, value: substring, type: .selector);
    }
    
    private func advance(by amount: Int){
        currentIndex += amount
    }
    
    private func checkTerminated() throws {
        guard currentIndex < currentString.count else {
            throw ParsingError.terminated(at: currentIndex, expected: "}")
        }
    }
    
    private func checkUnexpectedCharacters(_ characters: [Character]) throws {
        let currentCharacter = currentString[currentIndex]
        
        guard !characters.contains(currentCharacter) else {
            throw ParsingError.unexpectedCharacter(currentCharacter, at: currentIndex)
        }
    }
}

extension FilterParser.ParsingError: LocalizedError {
    var key: String {
        switch self {
        case .expectingCharacter:   return "ParsingError.ExpectingCharacter"
        case .terminated:           return "ParsingError.Terminated"
        case .unexpectedCharacter:  return "ParsingError.UnexpectedCharacter"
        }
    }
    
    var params: [String: String] {
        switch self {
        case .expectingCharacter(let character, let position, let received):
            return [
                "expectedCharacter": "\(character)",
                "unexpectedCharacter": "\(received)",
                "position": "\(position)"
            ]
        case .terminated(let position, let character):
            return [
                "expectedCharacter": "\(character)",
                "position": "\(position)"
            ]
        case .unexpectedCharacter(let character, let position):
            return [
                "unexpectedCharacter": "\(character)",
                "position": "\(position)"
            ]
        }
    }
    
    var errorDescription: String? {
        return key.localized(params: params)
    }
}
