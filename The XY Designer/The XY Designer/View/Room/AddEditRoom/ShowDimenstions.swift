//
//  ShowDimenstions.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 09/05/2023.
//

import SwiftUI
import SceneKit

struct ShowDimenstions: View {
    @ObservedObject var furniture: AddEditMaster
    @State var selectedCategory: String?
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    var disabled: Bool
    var nodeToBeDeleted: MaterialNode!
    init(furniture: AddEditMaster, disabled: Bool, node: MaterialNode? = nil) {
        self.furniture = furniture
        self.disabled = disabled
        if node != nil {
            self.nodeToBeDeleted = node
        }
    }
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack {
                if let newFurniture = furniture as? AddFurnitureViewModel{
                    SelectCategory(newFurniture: newFurniture, selectedCategory: $selectedCategory)
                }
                if (disabled) {
                    DeleteButton(action: {
                        if let node = nodeToBeDeleted {
                            node.removeFromParentNode()
                        }
                        presentationMode.wrappedValue.dismiss()
                    })
                }
                EditFurnitureScale(xDimenstion: $furniture.xDimension, yDimenstion: $furniture.yDimension, zDimenstion: $furniture.zDimension)
                    .opacity(disabled ? 0.5 : 1.0)
                    .disabled(disabled)
            }
        }
//        .padding(.top, 100)
        .padding(.horizontal, 20)
        .ignoresSafeArea()
    }
}
struct SelectCategory: View {
    var newFurniture: AddFurnitureViewModel
    @Binding var selectedCategory: String?
    var body: some View{
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(newFurniture.categoryOption, id: \.self) { category in
                    Button(action: {
                        selectedCategory = category
                        newFurniture.subObjectCategory = newFurniture.returnSubCategoryObjects(subCategoryObject: category)
                    }, label: {
                        VStack {
                            if(category == "singleBed"){
                                Image(newFurniture.getRightImage(for: category))
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 24)
                                    .font(.system(size: 32))
                                    .foregroundColor(selectedCategory == category ? .white : .black)
                            }else {
                                Image(systemName: newFurniture.getRightImage(for: category))
                                    .font(.system(size: 32))
                                    .foregroundColor(selectedCategory == category ? .white : .black)
                            }
                            Text(category.capitalized)
                                .font(.subheadline)
                                .foregroundColor(selectedCategory == category ? .white : .black)
                        }
                        .padding()
                        .background(selectedCategory == category ? Color.grayFancy : Color.white)
                        .cornerRadius(10)
                        .shadow(color: .gray, radius: 2, x: 0, y: 2)
                    })
                }
            }
            .padding(.horizontal, 20)
        }
    }
}
struct EditFurnitureScale: View {
    @Binding var xDimenstion: String
    @Binding var yDimenstion: String
    @Binding var zDimenstion: String
    var body: some View {
        VStack{
            HStack {
                Text("Width(m)")
                    .bold()
                CustomTextFieldCenter(customKeyboardChoice: .scale, hint: "1", text: $xDimenstion)
            }
            HStack{
                Text("Height(m)")
                    .bold()
                CustomTextFieldCenter(customKeyboardChoice: .scale, hint: "1", text: $yDimenstion)
                    
            }
            HStack{
                Text("Length(m)")
                    .bold()
                CustomTextFieldCenter(customKeyboardChoice: .scale, hint: "1", text: $zDimenstion)
                   
            }
        }
        .foregroundColor(.black)
//        .foregroundColor(Color(UIColor { traitCollection in
//            return traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
//        }))
        
    }
}

struct ObjectCategory: View {
    @Binding var selectedCategory: String?
    let categories: [String]
    
    var body: some View {
        VStack {
            Text("Select a category:")
                .font(.headline)
            Picker(selection: $selectedCategory, label: Text("")) {
                ForEach(categories, id: \.self) { category in
                    Text(category.capitalized)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(height: 150)
        }
    }
}
//struct ShowDimenstions_Previews: PreviewProvider {
//    static var previews: some View {
//        ShowDimenstions()
//    }
//}
