//
//  ImagePicker.swift
//  FitNote
//
//  Created by Pavel on 17.06.23.
//

import Foundation
import SwiftUI


struct ImagePicker: UIViewControllerRepresentable {
    

    @Binding var imageUrl: URL?
    @Binding var changeProfileImage: Bool
    
  
    @Environment(\.dismiss) var dismiss
    
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        
        return imagePicker
        
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
      
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
     
        var parent: ImagePicker
     
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
    
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            

            if let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                parent.imageUrl = imageURL
                parent.changeProfileImage = true
            }
        
            parent.dismiss()
         
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
}
