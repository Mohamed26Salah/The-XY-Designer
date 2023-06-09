//
//  Controls.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 05/05/2023.
//

import SwiftUI
import SwiftUIJoystick

struct Controls: View {
    @Binding var typeOfMovement: Bool
    @ObservedObject var RoomModel: BuildMyRoom
    var moniter: JoystickMonitor
    let draggableDiameter: CGFloat
    let geometry: GeometryProxy
    var body: some View {
        VStack (spacing: 0){
            Menu("MoveType") {
                Button("Up & Down", action: {
                    typeOfMovement = false
                })
                Button("Rotation", action: {
                    typeOfMovement = true
                })
            }
            .bold()
            .foregroundColor(.white)
            .padding(.horizontal,24)
            .padding(.vertical)
            .background{
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .foregroundColor(.secondary.opacity(0.6))
                    .frame(width: 60, height: 45)
                BlurView(style: .systemThickMaterialDark)
                    .cornerRadius(15)
            }
//            systemThinMaterialDark
            .padding()
            HStack{
                VStack(alignment: .center){
                    if (typeOfMovement){
                        CustomTextFieldCenter(customKeyboardChoice: .num, hint: "Degree", text: $RoomModel.angelRotation)
                            .background{
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .foregroundColor(.secondary.opacity(0.6))
                                BlurView(style: .systemThickMaterialDark)
                                    
                            }
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .padding(.leading, 20)
                        HStack(){
                            Button {
                                withAnimation {
                                    RoomModel.leftRotation()
                                }
                            } label: {
                                Image(systemName: "rotate.left")
                                    .font(.title2)
                            }
                            .foregroundColor(Color.white)
                            .padding(.horizontal,25)
                            .padding(.vertical)
                            .background{
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .foregroundColor(.secondary.opacity(0.6))
                                    .frame(width: 55, height: 45)
                                BlurView(style: .systemThickMaterialDark)
                                    
                            }
                            .cornerRadius(15)
                            Button {
                                withAnimation {
                                    RoomModel.rightRotation()
                                }
                            } label: {
                                Image(systemName: "rotate.right")
                                    .font(.title2)
                            }
                            .foregroundColor(Color.white)
                            .padding(.horizontal,25)
                            .padding(.vertical)
                            .background{
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .foregroundColor(.secondary.opacity(0.6))
                                    .frame(width: 55, height: 45)
                                BlurView(style: .systemThickMaterialDark)
                            }
                            .cornerRadius(15)
                        }
                        .padding(.leading,20)
                    }else {
                        Button {
                            withAnimation {
                                RoomModel.moveUp()
                            }
                        } label: {
                            Image(systemName: "arrow.up")
                                .font(.title2)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal,25)
                        .padding(.vertical)
                        .background{
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .foregroundColor(.secondary.opacity(0.3))
                            BlurView(style: .systemThickMaterialDark)
                                
                        }
                        .cornerRadius(15)
                        Button {
                            withAnimation {
                                RoomModel.moveDown()
                            }
                        } label: {
                            Image(systemName: "arrow.down")
                                .font(.title2)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal,25)
                        .padding(.vertical)
                        .background{
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .foregroundColor(.secondary.opacity(0.3))
                            BlurView(style: .systemThickMaterialDark)
                        }
                        .cornerRadius(15)
                    }
                }
                .frame(width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.height / 4)
                .padding(.horizontal,30)
                Spacer()
                JoystickBuilder(
                    monitor: self.moniter,
                    width: self.draggableDiameter,
                    shape: .circle,
                    background: {
                        // Example Background
                        RoundedRectangle(cornerRadius: 75).fill(Color.white.opacity(0.5))
                    },
                    foreground: {
                        // Example Thumb
                        Circle().fill(Color.black)
                    },
                    locksInPlace: false
                )
                .onReceive(moniter.$xyPoint) { _ in
                    RoomModel.handleJoyStick(xy: moniter.xyPoint)
                }
            }
            .padding(.top, -30)
        }
    }
}

//struct Controls_Previews: PreviewProvider {
//    static var previews: some View {
//        Controls()
//    }
//}
