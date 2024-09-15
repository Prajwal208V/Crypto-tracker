//
//  LaunchView.swift
//  CryptoTracker
//
//  Created by Prajwal V on 12/09/24.
//

import SwiftUI

struct LaunchView: View {
     
    @State private var loadingText: [String] = "Loading your portfolio...".map{String($0)}
    @State private var showLoadingText: Bool = false
    @State private var counter: Int = 0
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var loopsCount: Int = 0
    @Binding var showLaunchView: Bool
    
    var body: some View {
        ZStack{
            Color.launch.background
                .ignoresSafeArea()
            Image("logo-transparent")
                .resizable()
                .frame(width: 100, height: 100)
            ZStack{
                if showLoadingText{
                    HStack(spacing:0){
                        ForEach(loadingText.indices){ index in
                            Text(loadingText[index])
                                .font(.headline)
                                .fontWeight(.heavy)
                                .foregroundColor(Color.launch.account)
                                .offset(y:counter == index ? -20 :0)
                        }
                    }
                    .transition(AnyTransition.scale.animation(.easeIn))
                }
            }
            .offset(y:70)
        }
        .onAppear{
            showLoadingText.toggle()
        }
        .onReceive(timer, perform: { _ in
            withAnimation(.spring()){
                
                let lastIndex = loadingText.count - 1
                if lastIndex == counter{
                    counter = 0
                    loopsCount += 1
                    if loopsCount >= 2{
                        showLaunchView = false
                    }
                }else{
                    counter+=1
                }
            }
        })
    }
}

#Preview {
    LaunchView(showLaunchView: .constant(true))
}
