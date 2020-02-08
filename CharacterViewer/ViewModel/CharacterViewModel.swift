//
//  CharacterViewModel.swift
//  CharacterViewer
//
//  Created by Dhanesh K M on 07/02/20.
//  Copyright © 2020 Dhanesh K M. All rights reserved.
//

import Foundation

struct CharacterViewModel {
    
    let characterName: String
    let nameWithDescription: String
    
    init(character: Character) {
        self.characterName = character.characterName
        self.nameWithDescription = character.nameWithDescription
    }
}
