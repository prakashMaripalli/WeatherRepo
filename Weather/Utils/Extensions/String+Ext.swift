//
//  String+Ext.swift
//  Weather
//
//  Created by Prakash maripalli on 5/18/23.
//

import Foundation
extension String {
    var urlEncoded:String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    var degreeCelciusSymbol: String {
        return self + "°C"
    }
}
