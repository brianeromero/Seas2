//
//  GeocodingUtility.swift
//  Seas2
//
//  Created by Brian Romero on 6/5/24.
//
import Foundation
import SwiftUI
import CoreData
import Combine

func geocodeAddress(_ address: String, completion: @escaping (Result<(latitude: Double, longitude: Double), Error>) -> Void) {
    let apiKey = "AIzaSyBSGUnuzggEBdGQXuk-6G06OyD7kXxu1VM"
    let encodedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    let urlString = "https://maps.googleapis.com/maps/api/geocode/json?address=\(encodedAddress)&key=\(apiKey)"
    
    guard let url = URL(string: urlString) else {
        completion(.failure(NSError(domain: "GeocodingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
        return
    }
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let data = data else {
            completion(.failure(NSError(domain: "GeocodingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
            return
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            guard let status = json?["status"] as? String, status == "OK" else {
                let errorMessage = (json?["error_message"] as? String) ?? "Unknown error"
                completion(.failure(NSError(domain: "GeocodingError", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                return
            }
            
            if let results = json?["results"] as? [[String: Any]], let location = results.first?["geometry"] as? [String: Any], let coordinates = location["location"] as? [String: Double] {
                let latitude = coordinates["lat"]!
                let longitude = coordinates["lng"]!
                completion(.success((latitude, longitude)))
            } else {
                completion(.failure(NSError(domain: "GeocodingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])))
            }
        } catch {
            completion(.failure(error))
        }
    }.resume()
}
