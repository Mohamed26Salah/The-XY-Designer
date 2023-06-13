//
//  MenuList.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 12/06/2023.
//
import SwiftUI

struct MenuList: View {
    //Gesture Properties...
    @Binding var offset: CGFloat
    @State var searchText: String = ""
    @Binding var getgestureOffset: CGFloat
    @State var lastOffset: CGFloat = 0
    @GestureState var gestureOffset: CGFloat = 0
    @Binding var show: Bool
    @Binding var isARPresented: Bool
    var RoomModel: BuildMyRoom
    var uploadScene: UploadScene
    var body: some View {
        GeometryReader{ proxy -> AnyView in
            let height = proxy.frame(in:
                    .global).height
            return AnyView(
                ZStack {
                    BlurView(style: .systemThinMaterialDark)
                        .clipShape(CustomCorner(corners: [.topLeft,.topRight], radius: 30))
                    VStack{
                        Capsule()
                            .fill(Color.white)
                            .frame(width: 60, height: 4)
                            .padding(.top)
                        BottomContent(show: $show, offset: $offset, isARPresented: $isARPresented, proxy: proxy, uploadScene: uploadScene, RoomModel: RoomModel)
                    }
                    .padding(.horizontal)
                    .frame(maxHeight: .infinity, alignment: .top)
                }
                    .offset(y: height - 100)
                    .offset(y: -offset > 0 ? -offset <= (height - 100) ? offset : -(height - 100) : 0)
                    .gesture(DragGesture().updating($gestureOffset, body: { value, out, _ in
                        var localOut = out
                            localOut = value.translation.height
                            DispatchQueue.main.async {
                                getgestureOffset = localOut
                            }
                            onChange()
                            out = localOut
                    })
                        .onEnded({ value in
                            let maxHeight = height - 100
                            withAnimation {
                                if -offset > 100 && -offset < maxHeight / 2 {
                                    offset = -(maxHeight / 3)
                                }
                                else if -offset > maxHeight / 2{
                                    offset = -maxHeight
                                }
                                else {
                                    offset = 0
                                }
                            }
                            lastOffset = offset
                        }))
                
            )
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
    func onChange(){
        DispatchQueue.main.async {
            self.offset = gestureOffset + lastOffset
        }
    }
    struct BottomContent: View {
        @Binding var show: Bool
        @Binding var offset: CGFloat
        @Binding var isARPresented: Bool
        var proxy: GeometryProxy
        var uploadScene: UploadScene
        var RoomModel: BuildMyRoom
//        @ObservedObject var uploadScene: UploadScene = UploadScene()
        @State private var selectedLight = "Default Light"
        let themes = ["Default Light", "Spot Light", "Ambient Light"]
        var body: some View {
            ZStack {
                VStack {
                    HStack {
                        Text("What are you going to do ?")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Spacer()
                        
                        Button {
                            withAnimation {
                                offset = 0
                                show.toggle()
                            }
                        } label: {
                            Text("Close")
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.top, 20)
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.white)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            VStack(spacing: 8){
                                Button {
                                    if let room = RoomModel.room {
                                        let stringRoomColors = room.dominantColors().mapValues { $0.map { $0.hexString } }
                                        uploadScene.uploadFile(scene: RoomModel.scene,getSceneID: room.specilaID() ,dominantColors: stringRoomColors, withOptimization: false, checkName: false)
                                        withAnimation {
                                            offset = 0
                                            show.toggle()
                                        }
                                        
                                    }
                                } label: {
                                    Image(systemName: "square.and.arrow.down")
                                        .font(.title)
                                        .frame(width: 65, height: 65)
                                        .foregroundColor(Color.white)
                                        .background(BlurView(style: .dark))
                                        .clipShape(Circle())
                                }
                                Text("Save")
                                    .foregroundColor(.white)
                                
                            }
                            VStack(spacing: 8){
                                Button {
                                    print("FuckMe")
                                } label: {
                                    Image(systemName: "wand.and.stars")
                                        .font(.title)
                                        .frame(width: 65, height: 65)
                                        .foregroundColor(Color.white)
                                        .background(BlurView(style: .dark))
                                        .clipShape(Circle())
                                }
                                Text("Optimize")
                                    .foregroundColor(.white)
                                
                            }
                            VStack(spacing: 8){
                                Button {
                                    isARPresented = true
                                    withAnimation {
                                        offset = 0
                                        show.toggle()
                                    }
                                } label: {
                                    Image(systemName: "arkit")
                                        .font(.title)
                                        .frame(width: 65, height: 65)
                                        .foregroundColor(Color.white)
                                        .background(BlurView(style: .dark))
                                        .clipShape(Circle())
                                }
                                Text("AR")
                                    .foregroundColor(.white)
                                
                            }
                            
                        }
                        .frame(width: proxy.size.width, alignment: .center)
                    }
                    .padding(.top)
                    
                    HStack {
                        Text("Light Options")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Spacer()
                        
                        //                    Button {
                        //                        print("FuckMe")
                        //                    } label: {
                        //                        Text("See All")
                        //                            .fontWeight(.bold)
                        //                            .foregroundColor(.gray)
                        //                    }
                    }
                    //                .padding(.top, 20)
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.white)
                    Form {
                        Picker("", selection: $selectedLight) {
                            ForEach(themes, id: \.self) {
                                Text($0)
                            }
                            //                            .background(BlurView(style: .dark))
                        }
                        //                        .background(BlurView(style: .dark))
                        .pickerStyle(.inline)
                        //                    Toggle("Bold Text", isOn: .constant(true))
                    }
                    .padding(.top, -20)
                    .padding(.horizontal, -10)
                    .scrollContentBackground(.hidden)
                    Spacer()
                    
                    
                }
//                HStack{
//                    Spacer()
//                    if uploadScene.showLoading {
//                        ProgressView()
//                            .tint(.primary)
//                            .foregroundColor(.secondary)
//                            .scaleEffect(3)
//
//                    }
//                    Spacer()
//                }
            }
            .onChange(of: selectedLight) { newValue in
                if newValue == "Default Light" {
                    if let ambientLight = RoomModel.scene.rootNode.childNode(withName: "ambientLight", recursively: true) {
                        ambientLight.removeFromParentNode()
                    }
                    if let spotLight = RoomModel.scene.rootNode.childNode(withName: "spotLight", recursively: true) {
                        spotLight.removeFromParentNode()
                        if let defaultLight = RoomModel.scene.rootNode.childNode(withName: "defaultLight", recursively: true){
                            defaultLight.removeFromParentNode()
                        }
                    }
                }else if newValue == "Spot Light"{
                    if (RoomModel.checkAllLight()){
                        RoomModel.spotLight()
                        return
                    }
                    if let ambientLight = RoomModel.scene.rootNode.childNode(withName: "ambientLight", recursively: true) {
                        ambientLight.removeFromParentNode()
                        RoomModel.spotLight()
                    }
                } else if newValue == "Ambient Light" {
                    if (RoomModel.checkAllLight()){
                        RoomModel.ambientLight()
                        return
                    }
                    if let spotLight = RoomModel.scene.rootNode.childNode(withName: "spotLight", recursively: true) {
                        spotLight.removeFromParentNode()
                        if let defaultLight = RoomModel.scene.rootNode.childNode(withName: "defaultLight", recursively: true){
                            defaultLight.removeFromParentNode()
                            RoomModel.ambientLight()
                        }
                    }
                }
            }
        }
    }
}

//struct MenuList_Previews: PreviewProvider {
//    static var previews: some View {
//        MenuList()
//    }
//}
