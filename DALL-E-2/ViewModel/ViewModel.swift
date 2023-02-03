//
//  ViewModel.swift
//  DALL-E-2
//
//  Created by baobeiAi on 1/30/23.
//

import Foundation
import OpenAIKit
import UIKit
import SwiftUI

final class MyViewModel : ObservableObject{

    private var openAi: OpenAI?
    
    func setup(){
        // initiate the client
        openAi = OpenAI(
            Configuration(
                organization: "Personal",
                apiKey: ""
            )
        )
    }
    
    func generateImage(prompt: String) async -> UIImage? {
        // make sure we've our client ready
        guard let openAi = openAi else {return nil}
        
        do{
            // create generated image configuration
            let params = ImageParameters(
                prompt: prompt,
                resolution: .medium,
                responseFormat: .base64Json
                
            )
            //
            let result =  try await openAi.createImage(parameters: params)
            
            // grab the first image data
            let data = result.data[0].image
            // decode image from base64
            let image = try openAi.decodeBase64Image(data)
            
            return image
        }
        catch{
            print(String(describing: error))
            return nil
        }
    }
 
}
