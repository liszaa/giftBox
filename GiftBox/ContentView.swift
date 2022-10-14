//
//  ContentView.swift
//  GiftBox
//
//  Created by Lisa on 12.10.2022.
//

import SwiftUI
import ExytePopupView


struct ContentView: View {
    @EnvironmentObject var db: DataWrapper
    
    init() {
        UITableView.appearance().backgroundColor = .red
        
    }
    
    var body: some View {
        NavigationStack {
            List(db.getAllTypes(), id: \.self ) { type in
                NavigationLink(destination: GiftsList(giftTypeId: type.id),
                               label: {
                    Text(type.title)
                })
            }
        }
        .background(.purple)
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
    
}

struct GiftsList: View {
    
    @EnvironmentObject var db: DataWrapper
    var giftTypeId: UUID
    @State var gifts = [Gift]()
    
    var body: some View {
        List(gifts, id: \.self ) { gift in
            NavigationLink(destination: GiftDetail(gift: gift), label: {
                Text(gift.title)
            })
            .disabled(!gift.isActive)
        }.onAppear {
            gifts = db.getGiftsByType(giftType: giftTypeId)
        }
    }

}

struct GiftDetail: View {
    
    @EnvironmentObject var db: DataWrapper
    let gift: Gift
    @Environment(\.presentationMode) var presentationMode
    @State var showingPopup = false
    @State var showingPopup2 = false
    
    var body: some View {
        HStack {
            Text(gift.title)
            Button("Активировать подарок") {
                showingPopup = true
            }
        }.popup(isPresented: $showingPopup) {
            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)) {
                VStack(spacing: 15) {
                    Image("cat").renderingMode(.original)
                    Image("text")
                        .resizable()
                        .frame(width: 300.0, height: 50.0)
                    Text("После того, как ты нажмешь кнопку ниже, отменить выбор будет нельзя")
                        .font(.custom("San Francisco", size: 16))
                        .padding(.leading)
                        .foregroundColor(Color.white)
                    Button("Выполнить желание") {
                        db.deavtivateGift(gift)
                        showingPopup2 = true
                    }
                    .buttonStyle(GrowingButton())
                
                }
                .padding(.vertical, 25)
                .padding(.horizontal, 30)
                .background(Color("popupColor").opacity(0.7))
                .background(.thinMaterial, in:
                                RoundedRectangle(cornerRadius: 16.00))
                
            }
            .edgesIgnoringSafeArea(.all)
            
        }.popup(isPresented: $showingPopup2) {
            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)) {
                VStack(spacing: 15) {
                    Image("text2")
                        .resizable()
                        .frame(width: 270, height: 70.0)
                    VStack() {
                    Text("Поздравляю!")
                            .font(.custom("San Francisco", size: 30).bold())
                        .foregroundColor(Color("myYellow"))
                        Text("Чтобы я исполнила желание")
                        Text("«" + gift.title + "»")
                        Text("Сделай скрин этого экрана и      отправь мне его в тг")
                    }
                    .multilineTextAlignment(.center)
                        .font(.custom("San Francisco", size: 18))
                        .padding(.leading)
                        .foregroundColor(Color.white)
                    
                    Button("На сегодня достаточно✨") {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    .buttonStyle(GrowingButton())
                }
                .padding(.vertical, 30)
                .padding(.horizontal, 30)
                .background(Color("popupColor").opacity(0.7))
                .background(.thinMaterial, in:
                                RoundedRectangle(cornerRadius: 16.00))
                
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct Popup: View {
    var body: some View {
        VStack {
            Text("🎁").font(.system(size: 150))
            
            Group{
                Text("Welcome!")
                    .font(.title)
                
                Button(action: {
                    print("tapped!")
                }, label: {
                    Text("Continue")
                        .foregroundColor(.white)
                        .frame(width: 200, height: 40)
                        .background(Color.green)
                        .cornerRadius(15)
                        .padding()
                })
            }.frame(maxHeight: .infinity, alignment: .bottom)
        }
    }
}

