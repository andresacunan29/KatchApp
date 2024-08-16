//
//  EventListView.swift
//  KatchApp
//
//  Created by Andres Acuna on 8/12/24.
//
import SwiftUI

struct EventListView: View {
    @State private var events: [TicketmasterEvent] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            List {
                if isLoading {
                    ProgressView("Loading events...")
                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else {
                    ForEach(events) { event in
                        EventRow(event: event)
                    }
                }
            }
            .navigationTitle("Events Near You")
            .onAppear(perform: loadEvents)
        }
    }
    
    private func loadEvents() {
        isLoading = true
        errorMessage = nil
        
        TicketmasterService.shared.fetchEvents { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let fetchedEvents):
                    self.events = fetchedEvents
                case .failure(let error):
                    self.errorMessage = "Failed to load events: \(error.localizedDescription)"
                }
            }
        }
    }
}

struct EventRow: View {
    let event: TicketmasterEvent
    
    var body: some View {
        HStack {
            if let imageUrl = event.images.first?.url,
               let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 50, height: 50)
                .cornerRadius(5)
            }
            
            VStack(alignment: .leading) {
                Text(event.name)
                    .font(.headline)
                Text(event.dates.start.localDate)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}
