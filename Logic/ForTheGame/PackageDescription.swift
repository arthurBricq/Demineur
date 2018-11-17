//
//  PackageDescription.swift
//  Demineur
//
//  Created by Arthur BRICQ on 17/11/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit


// Packs de pièces a achetés
struct PackagesDescription {
    let size: MoneyPackage.PackageSize
    let description: String
    let prix: Double
    let amountOfCoins: Int
}

let allPacks: [PackagesDescription] = [
    PackagesDescription(size: .small, description: "Achetez X pièces", prix: 0.99, amountOfCoins: 1),
    PackagesDescription(size: .medium, description: "Achetez une bourse de X pièces", prix: 2.99, amountOfCoins: 10),
    PackagesDescription(size: .large, description: "Achetez un grand coffre de X pièces", prix: 4.99, amountOfCoins: 100)
]

