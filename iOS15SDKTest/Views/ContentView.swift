//
//  ContentView.swift
//  iOS15SDKTest
//
//  Created by Руслан Кукса on 10.06.2021.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
    //let columns = [GridItem()]
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(Array(zip(viewModel.images.indices, viewModel.images)), id: \.1.id) { index, image in
                        AsyncImage(url: URL(string: image.urls["small"]!)) { image in
                            
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                            
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 400, maxHeight: 400)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .onAppear {
                            Task {
                                await viewModel.loadMoreImages(index)
                            }
                        }
                    }
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
            }
            .navigationBarTitle("Photos", displayMode: .large)
            .searchable(text: $viewModel.searchText)
            .onChange(of: viewModel.searchText, perform: { newValue in
                Task {
                    await viewModel.loadImages()
                }
            })
            .task {
                await viewModel.loadImages()
            }
            .alert(item: $viewModel.alert) { alert in
                Alert(title: Text(alert.title),
                      message: Text(alert.message ?? ""),
                      dismissButton: .cancel(Text("Okay")))
            }
            .toolbar {
                ToolbarItem(id: UUID().uuidString,
                            placement: .navigationBarTrailing,
                            showsByDefault: true)
                {
                    Button(action: {}) {
                        Image(systemName: "square.grid.2x2")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
