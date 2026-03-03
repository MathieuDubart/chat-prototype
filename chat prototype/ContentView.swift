//
//  ContentView.swift
//  chat prototype
//
//  Created by Mathieu Dubart on 03/03/2026.
//

import SwiftUI
import Supabase

struct ContentView: View {
    
    @State var instruments: [Instrument] = []
    
    var body: some View {
        List(instruments) { instrument in
            Text(instrument.name)
        }
        .overlay {
            if instruments.isEmpty {
                ProgressView()
            }
        }
        .task {
            do {
                instruments = try await supabase.from("instruments").select().execute().value
            } catch {
                dump(error)
            }
        }
    }
}

#Preview {
    ContentView()
}
