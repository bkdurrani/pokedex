//
//  PokeCell.swift
//  pokedax-by-devslopes
//
//  Created by bahadur khan on 26/12/2015.
//  Copyright © 2015 bahadur khan. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    var pokemon: Pokemon!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5.0
    }
    
    func configCell(pokemon: Pokemon) {
        
        self.pokemon = pokemon
        self.nameLbl.text = self.pokemon.name.capitalizedString
        self.thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
    }
}
