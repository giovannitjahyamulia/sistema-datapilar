//
//  EndPoint.swift
//  SistemaDatapilar
//
//  Created by Giovanni Tjahyamulia on 04/09/23.
//

import Foundation

enum EndPoint {
    case fetchList
    case fetchDetail
    
    var url: String {
        switch self {
            case .fetchList:
                return "https://www.themealdb.com/api/json/v1/1/filter.php?c=Seafood";
            case .fetchDetail:
                return "https://www.themealdb.com/api/json/v1/1/lookup.php?i="
        }
    }
    
    /*
    var url: URL {
        switch self {
            case .fetchList:
                return URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?c=Seafood")!
            case .fetchDetail:
                return URL(string:"https://www.themealdb.com/api/json/v1/1/lookup.php?i=52772")!
        }
    }
    */
}
