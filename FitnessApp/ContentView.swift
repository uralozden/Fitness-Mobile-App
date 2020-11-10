//
//  ContentView.swift
//  FitnessApp
//
//  Created by Ural Ozden on 10.11.2020.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HomeView()
    }
}

struct HomeView: View {
    var body: some View {
        VStack{
            // top bar
            TopBarView()
            // welcome view
            WelcomeView()
            // graph view
            GraphView()
            // next view
            NextView()
            // scale view
            ScaleView()
            // custom tab view
            CustomTabView()
        }
        .padding(.horizontal)
    }
}

struct TopBarView : View {
    var body: some View{
        HStack(alignment: .top){
            ZStack {
                Circle()
                    .fill(Color.darkPurple)
                    .frame(width: 6, height: 6)
                
                Circle()
                    .fill(Color.darkPurple)
                    .frame(width: 6, height: 6)
                    .offset(x:8,y:8)
                Circle()
                    .fill(Color.darkPurple)
                    .frame(width: 6, height: 6)
                    .offset(x:8,y:-8)
            }
            Spacer()
            
            Circle()
                .fill(Color.mediumLightGray)
                .frame(width: 35, height: 35)
        }
    }
}


struct WelcomeView : View {
    var body: some View{
        HStack{
            VStack(alignment: .leading) {
                Text("Hi, Ural")
                    .font(.system(size:22,weight:.bold))
                    .foregroundColor(.darkPurple)
                Text("Welcome back")
                    .font(.system(size:12,weight:.light))
                    .foregroundColor(.mediumLightGray)
            }
            
            Spacer()
        }
    }
}

struct GraphView : View {
    @State var startAnimation = false
    
    var body: some View{
        ZStack{
            GraphBaackgroundView()
            LineGraph(data:Data.caloryData)
                .trim(from: 0.0, to: startAnimation ?  /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/ : 0.0)
                .stroke(Color.darkPurple, lineWidth: 4.0)
                .frame(height:200)
                .offset(y:-20)
        }
        .onAppear{
            withAnimation(.easeIn(duration: 0.7)){
                startAnimation.toggle()
            }
        }
        Spacer()
    }
}


struct GraphBaackgroundView : View {
    var body: some View{
        ZStack(alignment: .top ){
            VStack(spacing:40){
                HStack{
                    Spacer()
                    Text("November")
                }
                ForEach(0..<5, id: \.self){ i in
                    Rectangle()
                        .fill(Color.lightGray)
                        .frame(height:1)
                }
                
                HStack{
                    ForEach(Data.weekArray, id: \.self){ day in
                        Text(day)
                        Spacer()
                    }
                }
                .offset(y:-28)
            }
            
            HStack{
                VStack(alignment:.leading,spacing:22){
                    Text("  ")
                    ForEach(Array(stride(from:4,through: 0,by: -1)), id: \.self){i in
                        Text("\(i * 100)")
                            .font(.system(size:15,weight:.regular))
                    }
                }
                .offset(y:-8)
                Spacer()
            }
        }
    }
}

struct LineGraph : Shape {
    var data: [CGFloat]
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        if data.count == 0{
            return path
        }
        
        var x:CGFloat = 30
        var y:CGFloat = 200 - data[0]/2
        path.move(to:CGPoint(x:x,y:y))
        var previousPoint = CGPoint(x:x,y:y)
        
        x += 40
        
        for i in 1..<data.count{
            
            y = 200 - data[i]/2
            
            let currentPoint =  CGPoint(x: x, y: y)
            let minusOffsetPoint =  CGPoint(x: currentPoint.x-20, y: currentPoint.y)
            let plusOffsetPoint =  CGPoint(x: previousPoint.x + 20, y: previousPoint.y)
            
            path.addCurve(to: currentPoint, control1: plusOffsetPoint, control2: minusOffsetPoint)
            
            previousPoint = CGPoint(x:x,y:y)
            x += 40
            
            
        }
        
        return path
    }
}

struct NextView : View {
    var body: some View{
        ZStack{
            
        }
    }
}

struct ScaleView : View {
    var body: some View{
        ZStack{
            
        }
    }
}

struct CustomTabView : View {
    var body: some View{
        ZStack{
            
        }
    }
}


struct Data {
    static let caloryData: [CGFloat] = [0,50,120,290,200,140,220,210,305]
    static let weekArray = ["su","mo","tu","wd","th","fr","sa"]
}

extension Color{
    static let lightPurple = Color.init(red: 160/255,green: 120/255, blue: 244/255)
    static let darkPurple = Color.init(red: 119/255,green: 50/255, blue: 249/255)
    static let lightGray = Color.init(red: 239/255,green: 239/255, blue: 239/255)
    static let mediumLightGray = Color.init(red: 185/255,green: 185/255, blue: 185/255)
}

extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
