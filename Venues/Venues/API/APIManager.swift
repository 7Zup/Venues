//
//  APIManager.swift
//  Venues
//
//  Created by Fabrice FROEHLY on 14/08/2018.
//  Copyright © 2018 Fabrice FROEHLY. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - Connection CRUD operation errors

enum MapError: Error
{
    case CannotFetch(String)
    case CannotDecode(String)
    case CannotEncode(String)
    case NoData(String)
    case NoToken(String)
    case RequestFailed(String)
}

class APIManager {
    
    private let apiURL: String = "https://api.foursquare.com/v2/venues"
    
    private var client_id: String = "LQ4HJG2XXDS3NW0W4IDID4NRSTRFMDANMI3OV4QI41GRNFLM"
    private var client_secret: String = "LOTX5A1FWOOJDDWP1WXCLOEJBLCUR3E3FXXBMLATNK4YECH5"
    private var version: String = "20180323"
    
    static let shared = APIManager()
    
    private init() {}
    
    // MARK: - Object serialization
    
    // Request for single object
    func request<T: Codable>(requestType: HTTPMethod, urlParams: [String: String], route: String, params: [String: Any]? = nil, completionHandler: @escaping (_ object: T?) -> Void, errorHandler: ((MapError) -> Void)?) {
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        // Print request
        print("request route : \(apiURL)\(route)\(urlParamsToString(urlParams: urlParams))")
        print(headers.description)
        print("params \(String(describing: params ?? nil))")
        
        Alamofire.request("\(apiURL)\(route)\(urlParamsToString(urlParams: urlParams))", method: requestType, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                
                guard let data = response.data else {
                    errorHandler?(MapError.NoData("Error: Request data is empty"))
                    return
                }
                
                switch response.result {
                case .success:
                    do {
                        
                        // Check status code
                        if let responseR = response.response, responseR.statusCode < 200 || responseR.statusCode >= 300 {
                            errorHandler?(MapError.RequestFailed("Error - The request failed with status code \(responseR.statusCode)"))
                            return
                        }
                        
                        // Decode response
                        let decoder = JSONDecoder()
                        let decodedData: T = try decoder.decode(T.self, from: data)
                        
                        // Callback
                        completionHandler(decodedData)
                    } catch {
                        errorHandler?(MapError.CannotDecode("Error - Cannot decode data"))
                    }
                case .failure:
                    errorHandler?(MapError.RequestFailed("Error - The request failed with status code \(response.response?.statusCode ?? -1)"))
                }
        }
    }
    
    // Request for array of objects
    func requestArray<T: Codable>(requestType: HTTPMethod, urlParams: [String: String], route: String, params: [String: Any]? = nil, completionHandler: @escaping (_ object: [T]) -> Void, errorHandler: ((MapError) -> Void)?) {
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        // Print request
        print("request route : \(apiURL)\(route)\(urlParamsToString(urlParams: urlParams))")
        print(headers.description)
        print("params \(String(describing: params ?? nil))")
        
        Alamofire.request("\(apiURL)\(route)\(urlParamsToString(urlParams: urlParams))", method: requestType, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                
                guard let data = response.data else {
                    errorHandler?(MapError.NoData("Error: Request data is empty"))
                    return
                }
                
                switch response.result {
                case .success:
                    do {
                        
                        // Check status code
                        if let responseR = response.response, responseR.statusCode < 200 || responseR.statusCode >= 300 {
                            errorHandler?(MapError.RequestFailed("Error - The request failed with status code \(responseR.statusCode)"))
                            return
                        }

                        // Decode response
                        let decoder = JSONDecoder()
                        let decodedData: [T] = try decoder.decode([T].self, from: data)
                        
                        // Callback
                        completionHandler(decodedData)
                    } catch {
                        errorHandler?(MapError.CannotDecode("Error - Cannot decode data"))
                    }
                case .failure:
                    errorHandler?(MapError.RequestFailed("Error - The request failed with status code \(response.response?.statusCode ?? -1)"))
                }
        }
    }
    
    // Get every params the the url needs and returns the URL to add to the startig url
    func urlParamsToString(urlParams: [String: String]) -> String {
        
        var urlToAdd: String = "?"
        var dict = urlParams
        
        dict["client_id"] = client_id
        dict["client_secret"] = client_secret
        dict["v"] = version
        
        for (key, value) in dict {
            
            urlToAdd += key + "=" + value + "&"
        }
        urlToAdd = String(urlToAdd.dropLast())
        return urlToAdd
    }
}

// MARK: - Extension to encode class into dictionary

extension Encodable {
    
    func asDictionary() throws -> [String: Any] {
        
        let data = try JSONEncoder().encode(self)
        
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
