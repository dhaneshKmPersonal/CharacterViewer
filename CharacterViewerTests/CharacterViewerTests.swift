//
//  CharacterViewerTests.swift
//  CharacterViewerTests
//
//  Created by Dhanesh K M on 05/02/20.
//  Copyright © 2020 Dhanesh K M. All rights reserved.
//

import XCTest
@testable import SimpsonsCharacterViewer

class CharacterViewerTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testCharacterViewModel() {
        let character = Character(characterName: "simpson", characterDescription: "simpsons sample description", url: nil, nameWithDescription: "simpson - simpsons sample description")
        let characterViewModel = CharacterViewModel(character: character)
        XCTAssertEqual(character.characterName, characterViewModel.characterName)
        XCTAssertEqual(character.nameWithDescription, characterViewModel.nameWithDescription)
    }
    
    func testCharacterSearch() {
        let character1 = Character(characterName: "simpson", characterDescription: "simpsons sample description", url: nil, nameWithDescription: "simpson - simpsons sample description")
        let character2 = Character(characterName: "Anna", characterDescription: "Anna test description", url: nil, nameWithDescription: "Anna test description")
        let characterViewModel1 = CharacterViewModel(character: character1)
        let characterViewModel2 = CharacterViewModel(character: character2)
        let characters = [characterViewModel1, characterViewModel2]
        let masterViewController = MasterViewController()
        XCTAssertEqual(masterViewController.searchNameAndDescription(searchText: "simpson", characters: characters).first?.characterName, characterViewModel1.characterName)
        XCTAssertEqual(masterViewController.searchNameAndDescription(searchText: "test", characters: characters).first?.characterName, characterViewModel2.characterName)
    }

}
