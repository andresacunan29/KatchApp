//
//  TicketMasterService.swift
//  KatchApp
//
//  Created by Andres Acuna on 8/15/24.
//
import Foundation

struct TicketmasterEvent: Codable, Identifiable {
    let id: String
    let name: String
    let dates: Dates
    let images: [Image]
    
    struct Dates: Codable {
        let start: Start
        
        struct Start: Codable {
            let localDate: String
        }
    }
    
    struct Image: Codable {
        let url: String
    }
}

struct TicketmasterResponse: Codable {
    let _embedded: Embedded
    
    struct Embedded: Codable {
        let events: [TicketmasterEvent]
    }
}

class TicketmasterService {
    static let shared = TicketmasterService()
    private init() {}
    
    private let apiKey = "QlQCAYj0lhryo7bpmlFGXgDAI2PKAJ01"
    private let baseURL = "https://app.ticketmaster.com/discovery/v2/events.json"
    
    func fetchEvents(completion: @escaping (Result<[TicketmasterEvent], Error>) -> Void) {
        let urlString = "\(baseURL)?apikey=\(apiKey)&city=Saint%20Louis"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(TicketmasterResponse.self, from: data)
                completion(.success(response._embedded.events))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
