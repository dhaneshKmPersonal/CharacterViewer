//
//  CharacterTableViewCell.swift
//  CharacterViewer
//
//  Created by Dhanesh K M on 07/02/20.
//  Copyright © 2020 Dhanesh K M. All rights reserved.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {
    
    var characterViewModel: CharacterViewModel! {
        didSet {
            textLabel?.text = characterViewModel.characterName
        }
    }
}
