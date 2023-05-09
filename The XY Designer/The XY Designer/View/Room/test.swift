////
////  AddFurniture.swift
////  The XY Designer
////
////  Created by Mohamed Salah on 04/05/2023.
////
//
//import SwiftUI
//import SceneKit
//import RoomPlan
//
//struct AddFurniture: View {
//    var mainN: SCNNode
//    @ObservedObject var newFurniture = AddFurnitureViewModel()
//    @State var selectedCategory: String?
//    @Environment(\.presentationMode) var presentationMode
//    @Environment(\.colorScheme) var colorScheme
//    init(mainNode: SCNNode) {
//        mainN = mainNode
//        //        self._newFurniture = ObservedObject(wrappedValue: AddFurnitureViewModel(mainN: mainNode))
//    }
//    var body: some View {
//        GeometryReader { geometry in
//            VStack {
////                Spacer()
//                HStack{
//                    Spacer()
//                    DismissButton {
//                        presentationMode.wrappedValue.dismiss()
//                    }
//                    .padding()
//                }
//                sceneOfNewFurniture(newFurniture: newFurniture)
//                    .frame(width: geometry.size.width, height: geometry.size.height / 2)
//                    .background(Color(UIColor.white)) // Add background modifier here
//
//                Spacer()
////                ScrollView(.vertical, showsIndicators: false){
////                    VStack {
////                        SelectCategory(newFurniture: newFurniture, selectedCategory: $selectedCategory)
////                        EditFurnitureScale(xDimenstion: $newFurniture.xDimension, yDimenstion: $newFurniture.yDimension, zDimenstion: $newFurniture.zDimension)
////                        SaveChangesButton(newFurniture: newFurniture, mainNode: mainN, presentationMode: _presentationMode)
////                    }
////                }
////                .padding(.top, 100)
////                .padding(.horizontal, 75)
////                .ignoresSafeArea()
//                ShowDimenstions(mainN: mainN, furniture: newFurniture)
//            }
//            .background(Color(UIColor.white))
//            .ignoresSafeArea()
//        }
//
//    }
//}
//
//struct sceneOfNewFurniture: View {
//    var newFurniture: AddFurnitureViewModel
////    var sceneRendererDelegate = SceneRendererDelegate()
////    ,delegate: sceneRendererDelegate
//    var body: some View{
//        SceneView(scene: newFurniture.scene, options: [.allowsCameraControl, .autoenablesDefaultLighting])
//            .onTapGesture { location in
//                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//            }
//    }
//}
////struct SelectCategory: View {
////    var newFurniture: AddFurnitureViewModel
////    @Binding var selectedCategory: String?
////    var body: some View{
////        ScrollView(.horizontal, showsIndicators: false) {
////            HStack(spacing: 15) {
////                ForEach(newFurniture.categoryOption, id: \.self) { category in
////                    Button(action: {
////                        selectedCategory = category
////                        newFurniture.subObjectCategory = newFurniture.returnSubCategoryObjects(subCategoryObject: category)
////                    }, label: {
////                        VStack {
////                            if(category == "singleBed"){
////                                Image(newFurniture.getRightImage(for: category))
////                                    .resizable()
////                                    .aspectRatio(contentMode: .fit)
////                                    .frame(width: 50, height: 24)
////                                    .font(.system(size: 32))
////                                    .foregroundColor(selectedCategory == category ? .white : .black)
////                            }else {
////                                Image(systemName: newFurniture.getRightImage(for: category))
////                                    .font(.system(size: 32))
////                                    .foregroundColor(selectedCategory == category ? .white : .black)
////                            }
////                            Text(category.capitalized)
////                                .font(.subheadline)
////                                .foregroundColor(selectedCategory == category ? .white : .black)
////                        }
////                        .padding()
////                        .background(selectedCategory == category ? Color.grayFancy : Color.white)
////                        .cornerRadius(10)
////                        .shadow(color: .gray, radius: 2, x: 0, y: 2)
////                    })
////                }
////            }
////            .padding(.horizontal, 20)
////        }
////    }
////}
////struct EditFurnitureScale: View {
////    @Binding var xDimenstion: String
////    @Binding var yDimenstion: String
////    @Binding var zDimenstion: String
////    var body: some View {
////        VStack{
////            HStack {
////                Text("Width(m)")
////                    .bold()
////                    .foregroundColor(.black)
////                CustomTextFieldCenter(customKeyboardChoice: .num, hint: "1", text: $xDimenstion)
////            }
////            HStack{
////                Text("Height(m)")
////                    .bold()
////                    .foregroundColor(.black)
////                CustomTextFieldCenter(customKeyboardChoice: .num, hint: "1", text: $yDimenstion)
////            }
////            HStack{
////                Text("Length(m)")
////                    .bold()
////                CustomTextFieldCenter(customKeyboardChoice: .num, hint: "1", text: $zDimenstion)
////            }
////        }
////        .foregroundColor(.black)
////    }
////}
////struct SaveChangesButton: View {
////    var newFurniture: AddFurnitureViewModel
////    var mainNode: SCNNode
////    @Environment(\.presentationMode) var presentationMode
////    var body: some View{
////        Button {
////            //            newFurniture.addToTheMainScene()
////            let node = newFurniture.returnNewFurniture()
////            BuildMyRoomAssistant().addNewFurniture(addObjectsTO: mainNode, newFurniture: node)
////            presentationMode.wrappedValue.dismiss()
////        } label: {
////            HStack(spacing: 15){
////                Text("Apply Changes")
////                    .fontWeight(.semibold)
////                    .contentTransition(.identity)
////            }
////        }
////        .foregroundColor(.primary)
////        .padding(.horizontal,25)
////        .padding(.vertical)
////        .background{
////            RoundedRectangle(cornerRadius: 10, style: .continuous)
////                .foregroundColor(.grayFancy)
////        }
////        .padding(.vertical,25)
////    }
////}
////struct ObjectCategory: View {
////    @Binding var selectedCategory: String?
////    let categories: [String]
////
////    var body: some View {
////        VStack {
////            Text("Select a category:")
////                .font(.headline)
////            Picker(selection: $selectedCategory, label: Text("")) {
////                ForEach(categories, id: \.self) { category in
////                    Text(category.capitalized)
////                }
////            }
////            .pickerStyle(WheelPickerStyle())
////            .frame(height: 150)
////        }
////    }
////}
//
//struct AddFurniture_Previews: PreviewProvider {
//    static var node = SCNNode()
//    //    static var furniture = AddFurnitureViewModel(mainN: node)
//    static var previews: some View {
//        AddFurniture(mainNode: node)
//    }
//}
