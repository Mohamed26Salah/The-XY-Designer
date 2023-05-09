//
//  ShowGallery.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 09/05/2023.
//

import SwiftUI
import PhotosUI

struct ShowGallery: View {
    var nodeToBeEdited: MaterialNode
    var editFurniture = EditFurniture()
    @State var data: Data?
    @State var selectedItems: [PhotosPickerItem] = []
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        HStack{
            Spacer()
            PhotosPicker(
                selection: $selectedItems,
                maxSelectionCount: 1,
                matching: .images
            ){
                Text("Select From Gallary")
                    .fontWeight(.semibold)
                    .contentTransition(.identity)
            }
            .foregroundColor(.primary)
            .padding(.horizontal,25)
            .padding(.vertical)
            .background{
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .foregroundColor(.secondary.opacity(0.3))
            }
            .onChange(of: selectedItems) { newValue in
                guard let item = selectedItems.first else{
                    return
                }
                item.loadTransferable(type: Data.self) { result in
                    switch result {
                    case .success(let data):
                        if let data = data{
                            self.data = data
                            if let uiImage = UIImage(data: data){
                                DispatchQueue.main.async {
                                    editFurniture.applyTextureFromGallery(to: nodeToBeEdited, imageName: uiImage)
                                }
//                                presentationMode.wrappedValue.dismiss()
                                
                            }
                        } else {
                            print("Data is nil")
                        }
                    case .failure(let failure):
                        fatalError("\(failure)")
                    }
                    
                }
            }
            Spacer()
        }
    }
}

//struct ShowGallery_Previews: PreviewProvider {
//    static var previews: some View {
//        ShowGallery()
//    }
//}
