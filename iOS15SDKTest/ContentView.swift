//
//  ContentView.swift
//  iOS15SDKTest
//
//  Created by Руслан Кукса on 10.06.2021.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel()

    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack {
                    ForEach(viewModel.images, id: \.id) { image in
                        AsyncImage(url: URL(string: image.urls["small"]!)) { image in
                            
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                            
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(maxWidth: .infinity, minHeight: 400)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding()
                    }
                }
                .navigationTitle("Photos")
            }
        }
        .task {
            await viewModel.fetchImages()
        }
        .alert(item: $viewModel.alert) { alert in
            Alert(title: Text(alert.title),
                  message: Text(alert.message ?? ""),
                  dismissButton: .cancel(Text("Okay")))
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
