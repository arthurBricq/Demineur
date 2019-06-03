//
//  functions.swift
//  HexagoneViewMineIt
//
//  Created by Arthur BRICQ on 31/03/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import Foundation
import UIKit

/**
 This method represents a function f(x) = ax + b, takes x as input and returns y = f(x) as output.
 */
func linearFunction(a: CGFloat, b: CGFloat, x: CGFloat) -> CGFloat {
    return (a*x + b)
}

/// This function execute the code in completion after seconds
func delay(seconds: Double, completion: @escaping ()-> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}

/**
 This method is helpful for the implementation of the haxagonal table. Indeed : all lines doesn't contain the same number. What we do is the following : for m elements in the first line, the second line has m-1, then m elements, then m-1 and so goes on.
 The function returns true if there is m elements in the line.
 */
func shouldThisLineContainsAllButtons(atLine i: Int) -> Bool {
    return i%2 == 0
}

/// This function return a random Int between 0 and n-1
func random(_ n: Int) -> Int {
    return Int(arc4random_uniform(UInt32(n)))
}

/// This function is used to display the position of the bombs.
func displayIntMatrix(matrix: [[Int]]) {
    
    let n = matrix.count
    
    for i in 0..<n {
        var stringToDisplay = String.init()
        
        for j in 0..<matrix[i].count {
            stringToDisplay += " \(matrix[i][j]) "
        }
        print(stringToDisplay)
    }
}

/**
 Il y a deux types de bouttons triangulaires : les type 1 (pointe vers le bas) et les types 2 (pointe vers le haut). On determine le type du boutton que l'on utilise grâce à la position i et j dans cette fonction. La fonction retourne le numéro 1 ou 2 pour décrire le type.
 */
func triangularButtonIsOfType(i: Int,j: Int) -> Int {
    var toReturn: Int = 2
    if i%2 == 0 {
        if j%2 == 0 { toReturn = 1 }
    } else {
        if j%2 == 1 { toReturn = 1 }
    }
    return toReturn
}


//// ********** VERSIONS INFINIE DU JEU **************** ////
/**
 Cette fonction est appelée juste avant d'enlèver la partie actuelle dans la version infinie. À cet instant, le containerView possède la prochaine partie. Cette fonction lui fournit donc la prochaine prochaine partie : celle qui aura comme index round+2.
 */



func nextGame(forCurrentRoundIndex round: Int) -> OneGame {
    /*
     Objectif : à partir du niveau du jeu, trouver la difficulté de la partie.
     Puis, grâce à cette difficulté, trouver une partie adéquate qui soit 1. aléatoire
     Se référer à GitHub pour comprendre le fonctionnement.
     */
    return OneGame(gameTypeWithNoOptionsWithoutNoneCases: .square, n: 4, m: 4, z: 4, totalTime: 60)
}

func colorForRGB(r:CGFloat,g:CGFloat,b:CGFloat)->UIColor {
    return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1.0)
}

func colorForHexString (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

/// Returns the model has a string
func modelIdentifier() -> String {
    if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] { return simulatorModelIdentifier }
    var sysinfo = utsname()
    uname(&sysinfo) // ignore return value
    return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
}

/// Cette fonction retourne vraie si le ratio de l'écran est celui de l'iphone X (2.11)
func isItABigScreen() -> Bool {
    if modelIdentifier() == "iPhone10,3" || modelIdentifier() == "iPhone10,6" { return true }
    else { return false }
}


extension String {
    // Permet de calculer la hauteur si on connait la largeur
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    func localized(lang:String) ->String {
        
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
}

