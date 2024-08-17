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
    
    private let cache = NSCache<NSString, CacheEntry>()
    private var lastRequestTime: Date?
    private let requestInterval: TimeInterval = 5 // 5 seconds between requests
    
    private let cacheLifetime: TimeInterval = 5 * 60 // 5 minutes
    
    func fetchEvents(completion: @escaping (Result<[TicketmasterEvent], Error>) -> Void) {
        let urlString = "\(baseURL)?apikey=\(apiKey)&city=Saint%20Louis"
        let cacheKey = NSString(string: urlString)
        
        // Check cache first
        if let cachedResult = cache.object(forKey: cacheKey) {
            if Date().timeIntervalSince(cachedResult.timestamp) < cacheLifetime {
                completion(.success(cachedResult.events))
                return
            }
        }
        
        // Rate limiting
        if let lastRequest = lastRequestTime,
           Date().timeIntervalSince(lastRequest) < requestInterval {
            let delay = requestInterval - Date().timeIntervalSince(lastRequest)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.performRequest(urlString: urlString, cacheKey: cacheKey, completion: completion)
            }
        } else {
            performRequest(urlString: urlString, cacheKey: cacheKey, completion: completion)
        }
    }
    
    private func performRequest(urlString: String, cacheKey: NSString, completion: @escaping (Result<[TicketmasterEvent], Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        lastRequestTime = Date()
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
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
                let events = response._embedded.events
                
                // Cache the result
                self.cache.setObject(CacheEntry(events: events), forKey: cacheKey)
                
                completion(.success(events))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

class CacheEntry {
    let events: [TicketmasterEvent]
    let timestamp: Date
    
    init(events: [TicketmasterEvent]) {
        self.events = events
        self.timestamp = Date()
    }
}
