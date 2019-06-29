//
//  UIView.swift
//  Demineur
//
//  Created by Marin on 29/06/2019.
//  Copyright © 2019 Arthur BRICQ. All rights reserved.
//

import UIKit

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
