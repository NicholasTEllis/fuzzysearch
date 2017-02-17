//
//  SearchTableViewController.swift
//  FuzzySearch
//
//  Created by Nicholas Ellis on 2/17/17.
//  Copyright © 2017 Nicholas Ellis. All rights reserved.
//

import UIKit
import Foundation

class SearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var fuzzSearchBar: UISearchBar!
    
    var words = [[String]]()
    var allWords = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDict()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let term = fuzzSearchBar.text else { return }
        fuzzySearch(term: term)
        tableView.reloadData()
    }
    
    func fuzzySearch(term: String) {
        words = [[]]
        for word in allWords {
            let wordLetters: [Character] = (word.first?.lowercased().characters.flatMap { $0 })!
            let searchLetters: [Character] = term.lowercased().characters.flatMap({ $0 })
            let wordSet = Set(wordLetters)
            let searchSet = Set(searchLetters)
            
            if searchSet.isSubset(of: wordSet) {
                words.append(word)
            }
        }
    }
    
    func createDict() {
        guard let path = Bundle.main.path(forResource: "dictionary", ofType: "json") else { return }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
            let jsonObj = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            
            guard let dict = jsonObj as? [String: Any] else { return }
            for obj in dict {
                let objDict = [obj.key, "\(obj.value)"]
                self.allWords.append(objDict)
            }
            
        } catch {
            NSLog(error.localizedDescription)
        }
        words = allWords
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        
        let word = words[indexPath.row] as [String]
        cell.textLabel?.text = word.first
        
        return cell
    }
}
