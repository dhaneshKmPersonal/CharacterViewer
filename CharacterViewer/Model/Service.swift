//
//  Service.swift
//  CharacterViewer
//
//  Created by Dhanesh K M on 05/02/20.
//  Copyright © 2020 Dhanesh K M. All rights reserved.
//

import Foundation

enum RequestStatus {
    typealias OnSuccess = (([Character]) -> Void)
    typealias OnError = ((Error) -> Void)
}

enum Keys {
    static let relatedTopics = "RelatedTopics"
    static let icon = "Icon"
    static let url = "URL"
    static let text = "Text"
}

class Service {
    
    let url: String
    static let shared = Service()
    
    private init() {
        self.url  = {
            var url = "http://api.duckduckgo.com/?q=simpsons+characters&format=json"
            #if WIRE
                url = "http://api.duckduckgo.com/?q=the+wire+characters&format=json"
            #endif
            return url
        }()
    }
    
    func fetchCharacters(onSuccess: @escaping(RequestStatus.OnSuccess), onFailure: @escaping(RequestStatus.OnError)) {
        guard let url = URL(string: url) else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                onFailure(error)
                return
            }
            if data == nil {
                debugPrint("Empty response")
                return
            }
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                debugPrint("Server error")
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
                onSuccess(self.parseCharacters(data: json!))
            } catch {
                debugPrint("JSON error: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func parseCharacters(data: [String : Any]) -> [Character] {
        var characters = [Character]()
        guard let relatedTopics = data[Keys.relatedTopics] as? [[String: Any]] else {
            return characters
        }
        for item in relatedTopics {
            var name: String?
            var description: String?
            var avatarUrl: String?
            if let text = item[Keys.text] as? String {
                let nameAndDescriptionComponents = text.components(separatedBy: " - ")
                if !nameAndDescriptionComponents.isEmpty {
                    name = nameAndDescriptionComponents.first
                    description = nameAndDescriptionComponents.last
                }
                if let icon = item[Keys.icon] as? [String : String?], let url = icon[Keys.url] {
                    avatarUrl = url
                }
                let character = Character(characterName: name ?? "", characterDescription: description ?? "", url: avatarUrl, nameWithDescription: text)
                characters.append(character)
            }
        }
        return characters
    }
    
}
