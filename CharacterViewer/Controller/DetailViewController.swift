//
//  DetailViewController.swift
//  CharacterViewer
//
//  Created by Dhanesh K M on 05/02/20.
//  Copyright © 2020 Dhanesh K M. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    @IBOutlet weak var characterDescription: UILabel!
    

    func configureView() {
        // Update the user interface for the detail item.
        if let character = character, let _ = view {
            characterName.text = character.characterName
            characterDescription.text = character.characterDescription
            guard let characterURL = character.url, let url = URL(string: characterURL) else {
                characterImageView.image = UIImage(named: "person")
                return
            }
            self.characterImageView.load(url: url)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    var character: Character? {
        didSet {
            // Update the view.
            configureView()
        }
    }
}

extension UIImageView {
     func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                } else {
                    self?.image = UIImage(named: "person")
                }
            }
        }
    }
}
