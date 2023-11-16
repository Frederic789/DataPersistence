//
//  ContentView.swift
//  DataPersistence
//
//  Created by Student Account on 11/2/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Movie.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Movie.title, ascending: true)]) private var movies: FetchedResults<Movie>
    
    @State private var movieTitle: String = ""
    @State private var movieYear: String = ""
    @State private var movieDirector: String = ""
    @State private var showAlert = false

    var body: some View {
        VStack {
            Toggle("Dark Mode", isOn: $isDarkMode)
                .padding()
            
            TextField("Movie Title", text: $movieTitle)
            TextField("Year of Release", text: $movieYear)
                .keyboardType(.numberPad)
            TextField("Director's Name", text: $movieDirector)
            
            Button("Add Movie") {
                if isValidYear(movieYear) {
                    addMovie()
                } else {
                    showAlert = true
                }
            }
        
            
            .padding()
            
            .alert(isPresented: $showAlert) {
                            Alert(title: Text("Invalid Year"), message: Text("Please enter a valid year."), dismissButton: .default(Text("OK")))
                        }

            List {
                ForEach(movies, id: \.self) { movie in
                    VStack(alignment: .leading) {
                        Text(movie.title ?? "")
                        Text("\(movie.year)")
                        Text(movie.director ?? "")
                    }
                }
                .onDelete(perform: deleteMovies)
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)  // Set the color scheme
    }
    
    private func isValidYear(_ year: String) -> Bool {
           return Int16(year) != nil
       }

    private func addMovie() {
            let newMovie = Movie(context: viewContext)
            newMovie.title = movieTitle
            newMovie.year = Int16(movieYear) ?? 0
            newMovie.director = movieDirector

            do {
                try viewContext.save()
            } catch {
                // Handle the Core Data error.
                print(error.localizedDescription)
            }
        }

    private func deleteMovies(at offsets: IndexSet) {
        for index in offsets {
            let movie = movies[index]
            viewContext.delete(movie)
        }

        do {
            try viewContext.save()
        } catch {
            // Handle the Core Data error.
            print(error.localizedDescription)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}



