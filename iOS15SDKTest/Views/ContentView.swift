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
                    ForEach(viewModel.images, id: \.id) { image in
                        PictureCardView(
                            imageURL: URL(string: image.urls["small"]!)!,
                            onDownload: {
                                
                            }
                        )
                            .onAppear {
                                Task {
                                    await viewModel.loadMoreImages(image)
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
