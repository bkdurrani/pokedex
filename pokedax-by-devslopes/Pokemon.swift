//
//  Pokemon.swift
//  pokedax-by-devslopes
//
//  Created by bahadur khan on 26/12/2015.
//  Copyright © 2015 bahadur khan. All rights reserved.
//

import Foundation
import Alamofire
class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _types: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutiontxt: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLevel: String!
    private var _pokemonUrl: String!
    
    var description: String {
        get {
            if _description == nil {
                _description = ""
            }
            return _description
        }
    }
    
    var nextEvolutionLevel: String {
        get {
            if _nextEvolutionLevel == nil {
                _nextEvolutionLevel = ""
            }
            return _nextEvolutionLevel
        }
        
    }
    var nextEvolutionId: String {
        
        get {
            if _nextEvolutionId == nil {
                _nextEvolutionId = ""
            }
            return _nextEvolutionId
        }
    }
    
    var nextEvolutionTxt: String {
        get {
            if _nextEvolutiontxt == nil {
                _nextEvolutiontxt = ""
            }
            return _nextEvolutiontxt
        }
    }
    
    var types: String {
        get {
            if _types == nil {
                _types = ""
            }
            return _types
        }
    }
    
    var defense: String {
        get {
            if _defense == nil {
                _defense = ""
            }
            return _defense
        }
    }
    var attack: String {
        get {
            if _attack == nil {
                _attack = ""
            }
            return _attack
        }
    }
    var name: String {
        get {
            return _name
        }
    }
    //"/api/v1/pokemon/1/"
    
    var pokedexId: Int {
        get {
            return _pokedexId
        }
    }
    var height : String {
        get {
            return _height
        }
    }
    
    var weight : String {
        get {
            return _weight
        }
    }
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
        
    }
    
    func downloadPokemonDetails(completed: DownloadComplete) {
        
        let url = NSURL(string: self._pokemonUrl)
        Alamofire.request(.GET, url!).responseJSON { response in
            let result = response.result
            //print(result.value.debugDescription)
        
            if let dic = result.value as? Dictionary<String, AnyObject> {
                
                if let weight  = dic["weight"] as? String {
                    self._weight = weight
                }
                
                if let height  = dic["height"] as? String {
                    self._height = height
                }
                
                if let attack  = dic["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                if let defense  = dic["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                //IMPORTANT TO SEE BLOW CODE
                if let types = dic["types"] as? [Dictionary<String, String>] where types.count > 0 {
                    if let name = types[0]["name"] {
                        self._types = name.capitalizedString
                    }
                    if types.count > 1 {
                        for var x = 1; x < types.count; x++ {
                            if let name = types[x]["name"] {
                                self._types! += "/\(name.capitalizedString)"
                            }
                        }
                    }
                   // print(types.debugDescription)
                } else {
                    self._types = ""
                }
                
                if let descArray = dic["descriptions"] as? [Dictionary<String, String>] where descArray.count > 0 {
                    if let url = descArray[0]["resource_uri"] {
                        let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                        Alamofire.request(.GET, nsurl).responseJSON { response in
                            let result = response.result
                            
                            if let descDict = result.value as? Dictionary<String, AnyObject> {
                                
                                if let description = descDict["description"] as? String {
                                    self._description = description
                                }
                            }
                            
                            completed()
                        }
                    }
                    
                    
                } else {
                    self._description = ""
                }
                
                
                if let evolutions = dic["evolutions"] as? [Dictionary<String, AnyObject>] where evolutions.count > 0 {
                    
                    if let to = evolutions[0]["to"] as? String {
                        
                        //Mega is not found
                        // Can't support mega pokemon right now but
                        // api still has mega data
                        if to.rangeOfString("mega") == nil {
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                let num = newStr.stringByReplacingOccurrencesOfString("/",  withString: "")
                                self._nextEvolutionId = num
                                self._nextEvolutiontxt = to
                                
                                if let lvl = evolutions[0]["level"] as? Int {
                                    self._nextEvolutionLevel = "\(lvl)"
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}