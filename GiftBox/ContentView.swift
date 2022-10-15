//
//  ContentView.swift
//  GiftBox
//
//  Created by Lisa on 12.10.2022.
//

import SwiftUI
import ExytePopupView

struct ContentView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var db: DataWrapper
    @State var showingPopup = false
    @State var showPopup2 = false
    @State var showPopup3 = false
    @State private var wish = ""
    @State var willMoveToNextScreen = false
    
    
    var body: some View {
        Text("✨ Исполнение желаний ✨")
        NavigationView {
            VStack {
                List(db.getAllTypes(), id: \.self ) { type in
                    HStack {
                        Text("✨")
                        NavigationLink(destination: GiftsList(giftTypeId: type.id),
                                       label: {
                            Text(type.title).font(.custom("San Francisco", size: 15))
                        })
                    }
                }
                Button("Исполнить своё желание") {
                    showingPopup = true
                }
                .buttonStyle(GrowingButton())
            }
            .navigationTitle("КАТЕГОРИИ")
            .popup(isPresented: $showingPopup, closeOnTap: false, closeOnTapOutside: true, backgroundColor: Color.black) {
                ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
                    VStack(spacing: 15) {
                        Spacer()
                        Text("У тебя осталось 5 собственных желаний, если ты готов потратить одно из них, то следуй инструкции")
                        Spacer()
                        Button(" → ") {
                            showPopup2 = true
                        }
                        .buttonStyle(GrowingButton())
                        .padding(.bottom, 3)
                    }
                    .padding(.vertical, 30)
                    .padding(.horizontal, 30)
                    .frame(width: 350, height: 420)
                    .background(.ultraThickMaterial, in:
                                    RoundedRectangle(cornerRadius: 60.00))
                    
                }
                .edgesIgnoringSafeArea(.all)
                
            }.popup(isPresented: $showPopup2, closeOnTap: false, closeOnTapOutside: true, backgroundColor: Color.black) {
                VStack {
                    TextField("Wish", text: $wish)
                        .onSubmit() {
                            showPopup3 = true
                        }
                        .padding(.vertical, 30)
                        .padding(.horizontal, 30)
                        .frame(width: 200, height: 100)
                        .background(.ultraThickMaterial, in:
                                        RoundedRectangle(cornerRadius: 60.00))
                    
                }
                .edgesIgnoringSafeArea(.all)
                
            }.popup(isPresented: $showPopup3, closeOnTapOutside: true, backgroundColor: Color.black) {
                ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)) {
                    VStack(spacing: 15) {
                        Spacer().frame(height: 20)
                        Image("text2")
                            .resizable()
                            .frame(width: 270, height: 70.0)
                        Spacer().frame(height: 20)
                        VStack() {
                            Text("Чтобы я исполнила желание")
                            Text("«" + wish + "»")
                            Text("Сделай скрин этого экрана и      отправь мне его в тг")
                        }
                        .multilineTextAlignment(.center)
                        .font(.custom("San Francisco", size: 18))
                        .padding(.leading)
                        .foregroundColor(Color("popupTextColor"))
                        Spacer()
                        Button("На сегодня достаточно✨") {
                            showingPopup = false
                            showPopup2 = false
                            showPopup3 = false
                            wish = ""
                        }
                        .buttonStyle(GrowingButton())
                        .padding(.bottom, 3)
                    }
                    .padding(.vertical, 30)
                    .padding(.horizontal, 30)
                    .frame(width: 350, height: 420)
                    .background(.ultraThickMaterial, in:
                                    RoundedRectangle(cornerRadius: 60.00))
                    
                }
                .edgesIgnoringSafeArea(.all)
                
            }
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
        
    }
    
    struct GiftsList: View {
        @Environment(\.presentationMode) var mode: Binding<PresentationMode>
        @EnvironmentObject var db: DataWrapper
        
        var giftTypeId: UUID
        @State var gifts = [Gift]()
        
        var body: some View {
            List(gifts, id: \.self ) { gift in
                NavigationLink(destination: GiftDetail(gift: gift), label: {
                    Text(gift.title)
                })
                .isDetailLink(false)
                .disabled(!gift.isActive)
            }
            .onAppear {
                gifts = db.getGiftsByType(giftType: giftTypeId)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action : {
                self.mode.wrappedValue.dismiss()
            }){
                Image(systemName: "arrow.left")
                    .foregroundColor(Color("darkGray2"))
            })
        }
        
    }
    
    struct GiftDetail: View {
        
        @Environment(\.presentationMode) var mode: Binding<PresentationMode>
        @EnvironmentObject var db: DataWrapper
        let gift: Gift
        @State var showingPopup = false
        @State var showingPopup2 = false
        @State var areYouGoingToSecondView = false

        
        var body: some View {
            VStack(spacing: 10) {
                Spacer()
                    .frame(height: 30)
                Image("gift")
                    .resizable()
                    .frame(width: 150.0, height: 150.0)
                    .padding(.bottom, 5)
                Spacer()
                    .frame(height: 30)
                Text(gift.title)
                Spacer()
                Button("Активировать подарок") {
                    showingPopup = true
                }
                .buttonStyle(GrowingButton())
                .padding(.bottom, 70)
                
            }.popup(isPresented: $showingPopup, closeOnTapOutside: true, backgroundColor: Color.black) {
                ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
                    VStack(spacing: 15) {
                        Image("cat").renderingMode(.original)
                        Image("text")
                            .resizable()
                            .frame(width: 300.0, height: 50.0)
                        Text("После того, как ты нажмешь кнопку ниже, отменить выбор будет нельзя")
                            .font(.custom("San Francisco", size: 16))
                            .padding(.leading)
                            .foregroundColor(Color("popupTextColor"))
                        Button("Выполнить желание") {
                            db.deavtivateGift(gift)
                            showingPopup2 = true
                        }
                        .buttonStyle(GrowingButton())
                        
                    }
                    .padding(.vertical, 30)
                    .padding(.horizontal, 30)
                    //                .background(Color("popupColor").opacity(0.7))
                    .background(.ultraThickMaterial, in:
                                    RoundedRectangle(cornerRadius: 60.00))
                    
                }
                .edgesIgnoringSafeArea(.all)
                
            }.popup(isPresented: $showingPopup2, closeOnTapOutside: true, backgroundColor: Color.black) {
                ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)) {
                    VStack(spacing: 15) {
                        
                        Spacer().frame(height: 20)
                        Image("text2")
                            .resizable()
                            .frame(width: 270, height: 70.0)
                        Spacer().frame(height: 20)
                        VStack() {
                            Text("Чтобы я исполнила желание")
                            Text("«" + gift.title + "»")
                            Text("Сделай скрин этого экрана и      отправь мне его в тг")
                        }
                        .multilineTextAlignment(.center)
                        .font(.custom("San Francisco", size: 18))
                        .padding(.leading)
                        .foregroundColor(Color("popupTextColor"))
                        Spacer()
                        Button("На сегодня достаточно✨") {
                            NavigationUtil.popToRootView()
                        }
                        .buttonStyle(GrowingButton())
                        .padding(.bottom, 3)
                    }
                    .padding(.vertical, 30)
                    .padding(.horizontal, 30)
                    .frame(width: 350, height: 420)
                    .background(.ultraThickMaterial, in:
                                    RoundedRectangle(cornerRadius: 60.00))
                    
                }
                .edgesIgnoringSafeArea(.all)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action : {
                self.mode.wrappedValue.dismiss()
            }){
                Image(systemName: "arrow.left")
                    .foregroundColor(Color("darkGray2"))
            })
        }
    }
    
}

struct NavigationUtil {
  static func popToRootView() {
    findNavigationController(viewController: UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController)?
      .popToRootViewController(animated: true)
  }

  static func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
    guard let viewController = viewController else {
      return nil
    }

    if let navigationController = viewController as? UINavigationController {
      return navigationController
    }

    for childViewController in viewController.children {
      return findNavigationController(viewController: childViewController)
    }

    return nil
  }
}
