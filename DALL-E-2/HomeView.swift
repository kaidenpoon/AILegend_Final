//
//  HomeView.swift
//  DALL-E-2
//
//  Created by baobeiAi on 1/30/23.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel = MyViewModel()
    @State var searchText: String = ""
    @State var message: String = "Type to generate an image!"
    @State var image: UIImage?
    @State var isLoading = false
    @State var loaderMessage = "Generating an image..."
    
    
    var body: some View {
        VStack {
            HStack(alignment: .center,spacing:10){
                Image("titlelogo")
                Text("AI Image")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
            }
            Text("AI Generating")
                .font(.system(size: 12))
                .multilineTextAlignment(.center)
            
            Spacer()
            
            if isLoading{
                ActivityIndicator()
//                Text(loaderMessage)
//                ProgressView(loaderMessage)
//                    .tint(Color("icon"))
//                    .controlSize(.large)
//                    .font(.body)
//                    .padding()
//                    .background(Color("bg"))
//                    .cornerRadius(12)
//                    .shadow(radius: 5)
//                    .foregroundColor(Color("text"))
                
            }else{
                if let image = image{
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                        .frame(width: UIScreen.main.bounds.width-20, height: UIScreen.main.bounds.height/1.8)
                        .padding(10)
//                        .background(Color("bg"))
                        .cornerRadius(10)
                
                    Button{
                        print("Downloading...")
                        saveImage(albumName: "Dall-E-2", image: image)
                        self.isLoading = true
                        self.loaderMessage = "Downloading..."
                        
                    }label: {
                        Image(systemName: "square.and.arrow.down")
                            .font(.system(size: 25))
                            .aspectRatio( contentMode: .fit)
                            .foregroundColor(Color("icon"))
                            .frame(width: 25, height: 25)
                            .padding(10)
                        
                    }
                    .background(Color("textBox"))
                    .cornerRadius(100)
                    
                    Text("SAVE")
                        .foregroundColor(Color("text"))
                    
                    
                }else{
                    Text(message).foregroundColor(Color("text"))
                }
            }
            
            Spacer()
            
            // Search box and send button
            HStack(alignment: .center, spacing: 2){
                TextField("Question ...", text: $searchText)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 10)
                    .background(Color("textBox"))
                    .cornerRadius(100)
                    .background(RoundedRectangle(cornerRadius: 100, style: .continuous)
                        .stroke(.gray.opacity(0.6), lineWidth: 1.5))
                
                Button{
                    let grab = searchText
                    if !grab.trimmingCharacters(in: .whitespaces).isEmpty{
                        self.isLoading = true
                        self.loaderMessage = "Generating an image"
                        Task{
                            let result = await viewModel.generateImage(prompt: grab)
                            
                            self.isLoading = false
                            
                            if result == nil {
                                print("Failed to get an Image")
                                self.message = "Failed to generate an image!"
                            }
                            self.image = result
                        }
//                        self.searchText = ""
                    }else{
                        self.message = "Type something to generate an image."
                    }
                }label: {
                    Image("sendbtn")
                        .font(.system(size: 25))
                        .foregroundColor(Color("textBox"))
                        .padding(5)
                        .background(Color("text"))
                        .cornerRadius(100)
                }
            }.padding(.horizontal, 16)
        }
//        .background(Color("dalle2"))
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(Image("bgimg")
            .opacity(0.2)
            .edgesIgnoringSafeArea(.all))
        .onAppear{
            viewModel.setup()
        }
    }
    // save image into photo libra
    func saveImage(albumName:String, image:UIImage){
        let album = CustomAlbum(name: albumName)
        album.save(image: image){ (result) in
            switch result{
            case .success(_):
                print("Succesfully save photo to album \"\(albumName)\"")
                self.isLoading = false
            case .failure(let err):
                print(err.localizedDescription)
                self.isLoading = false
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
