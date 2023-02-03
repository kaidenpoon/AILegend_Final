//
//  Home2.swift
//  DALL-E-2
//
//  Created by Kaiden Poon on 2/2/2023.
//

import SwiftUI

struct Home2: View {
    let fullScreen = UIScreen.main.bounds.size
    let singleImgWidth = (UIScreen.main.bounds.size.width - 32 - 30) / 4
    let gutter = 10
    let imgArr = ["Rectangle -1","Rectangle -2","Rectangle -3","Rectangle -4","Rectangle -5","Rectangle -6","Rectangle -7","Rectangle -8","Rectangle -9","Rectangle -10","Rectangle -11","Rectangle -12","Rectangle -13","Rectangle -14","Rectangle -15","Rectangle -16","Rectangle -17","Rectangle -18","Rectangle -19","Rectangle -20","Rectangle -21","Rectangle -22","Rectangle -23","Rectangle -24","Rectangle -25","Rectangle -26","Rectangle -27","Rectangle -28","Rectangle -29","Rectangle -30"]
    
    @ObservedObject var viewModel = MyViewModel()
    @State var isDone:Bool = false
    @State var isSearch:Bool = false
    @State var text:String = ""
    @State var loadingMgs = "Generating..."
    @State var image:UIImage?
    @State var isExpand:Bool = false
    
    var body: some View {
        ZStack(alignment:.bottom) {
            VStack{
                //MARK: logo view
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:111)
                
                Spacer()
    
                // gallery wall
                ZStack(alignment:.center) {
                    if !isSearch{
                        HStack(spacing:10) {
                            // left gallery
                            VStack(spacing:10){
                                Group {
                                    // top
//                                    Image("Rectangle -\(randomInt())")
                                    Image("\(imgArr[1])")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: (singleImgWidth * 2) + 10,height: singleImgWidth )
                                    
                                    // middle
                                    HStack {
                                        Group {
                                            Image("\(imgArr[Int.random(in: 0...29)])")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                            
                                            Image("\(imgArr[Int.random(in: 0...29)])")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                        }
                                        .cornerRadius(8)
                                    }
                                    
                                    // bottom
                                    Image("\(imgArr[Int.random(in: 0...29)])")
                                }
                                .cornerRadius(8)
                                
                            }
                            .shadow(color: .black.opacity(0.3), radius: 3, x: 3, y: 3)
                            
                            // right gallery
                            VStack(spacing:10){
                                Group {
                                    // top
                                    HStack {
                                        Group {
                                            Image("\(imgArr[Int.random(in: 0...29)])")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                            
                                            Image("\(imgArr[Int.random(in: 0...29)])")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                        }
                                        .cornerRadius(8)
                                    }
                                    
                                    // middle
                                    Image("\(imgArr[Int.random(in: 0...29)])")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                    
                                    Image("\(imgArr[Int.random(in: 0...29)])")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: (singleImgWidth * 2) + 10,height: singleImgWidth )
                                }
                                .cornerRadius(8)
                                
                            }
                            .shadow(color: .black.opacity(0.3), radius: 3, x: 3, y: 3)
                        }
                    }
                    
                    if isSearch{
                        VStack(spacing:16){
                            ActivityIndicator()

                            Text("Gernerating...")
                                .foregroundColor(Color("Viva"))
                                
                        }
                    }
                    
                    //MARK: show result
                    if isDone{
                        if let okImage = image{
                            Image(uiImage: okImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: fullScreen.width - 16, height: fullScreen.width - 16)
                                .cornerRadius(8)
                                .shadow(color: .black.opacity(0.3), radius: 3, x: 3, y: 3)

                            
                            
                        }
                    }
                }
                .padding(.horizontal,16)
                
                // action after generation
                if isDone{
                    HStack(spacing: 40) {
                        // give up the image
                        Button {
                            withAnimation{
                                self.image = nil
                                isDone = false
                                isSearch = false
                            }
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(Color("Viva"))
                        }
                        .frame(width: 44, height: 44)
                        .background(.white)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 3)
                        
                        // save image
                        Button{
                            guard let okImg = self.image else {return}
                            saveImage(albumName: "AI Legend", image: okImg)
                        } label: {
                            Image(systemName: "square.and.arrow.down")
                                .foregroundColor(.white)
                        }
                        .frame(width: 44, height: 44)
                        .background(Color("Viva"))
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 3)
                        
                    }
                    .padding(.top,24)
                }
                
                Spacer()
                
                //MARK: searach bar
                HStack(spacing: 16) {
                    
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(.white)
                            .frame(height:44)
                            .frame(maxWidth:.infinity)
                            .shadow(color: .black.opacity(0.3), radius: 3, x: 3, y: 3)
                        
                        TextField(text: $text) {
                            Text("Generate image by words...")
                        }
                        .frame(maxWidth:.infinity)
                        .padding(.horizontal,16)
                    }
                    
                    Button {
                        withAnimation {
                            if !text.isEmpty{
                                isSearch = true
                                Task{
                                    let result = await viewModel.generateImage(prompt: text)
                                    print("DEBUG: start generating")
                                    if result == nil{
                                        print("DEBUG: can't load image")
                                    }
                                    
                                    self.image = result
                                    isDone.toggle()
                                    
                                    text = ""
                                    
                                    
                                }
                            }
                        }
                    } label: {
                        Image("generate-btn")
                    }
                    .frame(width: 44,height: 44)
                    .background(Color("Viva"))
                    .cornerRadius(22)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 3, x: 3, y: 3)
                    
                }
                .padding(.horizontal,16)
                
            }
     
            .padding(.top,56)
            .padding(.bottom, 64)
            
            //MARK: admob
            Rectangle()
                .frame(height: 50)
        }
        .ignoresSafeArea()
        .onAppear{
            viewModel.setup()
        }
        
    }
    
    
    // save image into photo library
    func saveImage(albumName:String, image:UIImage){
        let album = CustomAlbum(name: albumName)
        album.save(image: image){ (result) in
            switch result{
            case .success(_):
                print("Succesfully save photo to album \"\(albumName)\"")
                self.isSearch = false
            case .failure(let err):
                print(err.localizedDescription)
                self.isDone = false
            }
        }
    }
    
    //END
}


struct Home2_Previews: PreviewProvider {
    static var previews: some View {
        Home2()
    }
}
