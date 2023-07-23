//
//  Extensions.swift
//  netfilxApp
//
//  Created by Nguyen  Khoa on 03/03/2023.
//

import Foundation
 
extension String {
    func capitalizeFirstLetter() -> String{
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
     
}
