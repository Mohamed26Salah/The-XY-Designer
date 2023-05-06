//import SwiftUI
//import SceneKit
//struct AddFurniture: View {
//    @ObservedObject var newFurniutre = AddFurnitureViewModel()
//    var sceneRendererDelegate = SceneRendererDelegate()
//    var dimesntions = simd_float3(1.0,1.0,1.0)
//    @State var selectedCategory: String?
//    @Environment(\.presentationMode) var presentationMode
//    
//    var body: some View {
//        ScrollView(.horizontal, showsIndicators: false) { // wrap the view in a scroll view
//            VStack(alignment: .center, spacing: 20) {
//                SceneView(scene: newFurniutre.scene, options: [.allowsCameraControl],delegate: sceneRendererDelegate)
//                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
//                    .onTapGesture { location in
//                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//                    }
//                
//                HStack(spacing: 15) {
//                    ForEach(newFurniutre.categoryOption, id: \.self) { category in
//                        Button(action: {
//                            selectedCategory = category
//                            newFurniutre.subObjectCategory = newFurniutre.returnSubCategoryObjects(subCategoryObject: category)
//                        }, label: {
//                            VStack {
//                                Image(systemName: getRightImage(for: category))
//                                    .font(.system(size: 32))
//                                    .foregroundColor(selectedCategory == category ? .white : .black)
//                                Text(category.capitalized)
//                                    .font(.subheadline)
//                                    .foregroundColor(selectedCategory == category ? .white : .black)
//                            }
//                            .padding()
//                            .background(selectedCategory == category ? Color.grayFancy : Color.white)
//                            .cornerRadius(10)
//                            .shadow(color: .gray, radius: 2, x: 0, y: 2)
//                        })
//                    }
//                }
//                .padding(.horizontal, 20)
//                
//                VStack{
//                    HStack {
//                        Text("Width(m)")
//                            .bold()
//                        CustomTextFieldCenter(customKeyboardChoice: .num, hint: "1", text: $newFurniutre.xDimension)
//                    }
//                    HStack{
//                        Text("Height(m)")
//                            .bold()
//                        CustomTextFieldCenter(customKeyboardChoice: .num, hint: "1", text: $newFurniutre.yDimension)
//                    }
//                    HStack{
//                        Text("Length(m)")
//                            .bold()
//                        CustomTextFieldCenter(customKeyboardChoice: .num, hint: "1", text: $newFurniutre.zDimension)
//                    }
//                }
//                
//                Button {
//                    presentationMode.wrappedValue.dismiss()
//                } label: {
//                    HStack(spacing: 15){
//                        Text("Apply Changes")
//                            .fontWeight(.semibold)
//                            .contentTransition(.identity)
//                    }
//                }
//                .foregroundColor(.primary)
//                .padding(.horizontal,25)
//                .padding(.vertical)
//                .background{
//                    RoundedRectangle(cornerRadius: 10, style: .continuous)
//                        .foregroundColor(.grayFancy)
//                }
//                .padding(.vertical,25)
//                
//            }
//            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
//            .padding(.horizontal, 20)
//        }
//        .ignoresSafeArea()
//    }
//}
//
