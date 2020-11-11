//
//  ContentView.swift
//  FitnessApp
//
//  Created by Ural Ozden on 10.11.2020.
//

import SwiftUI

struct ContentView: View {
    @State var progress: Int = 103
    
    var body: some View {
        HomeView(progress: $progress)
        //WeightAdjustView(progress: $progress)
    }
}

struct HomeView: View {
    @Binding var progress: Int
    var body: some View {
        VStack{
            
            // welcome view
            WelcomeView()
            
            ScrollView(.vertical, showsIndicators: false)
            {
                // graph view
                GraphView()
                // next view
                NextView()
                // scale view
                ScaleView( progress: $progress)
                    .frame(height: UIScreen.screenWidth - 30)
            }
            Spacer()
            // custom tab view
            CustomTabView( progress: $progress)
        }
        .padding(.horizontal)
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
        HStack(alignment:.top,spacing:44){
            Image(systemName: "chevron.left")
            Text("Next Week")
                .bold()
            Image(systemName: "chevron.right")
        }
        Spacer()
    }
}

struct SliderConfig {
    let minimumValue: CGFloat = 90.0
    let maximumValue: CGFloat = 120.0
    let knobRadius: CGFloat = 25
}

struct ScaleView : View {
    @Binding var progress: Int
    @State var startAnimation = false
    let sliderConfig = SliderConfig()
    var body: some View{
        ZStack(alignment:.center){
            Circle()
                .trim(from: 0.5, to: 1.0)
                .stroke(Color.lightGray, style: StrokeStyle(lineWidth: 4, lineCap: .round))
            
            Circle()
                .trim(from: 0.5, to: 1.0)
                .stroke(Color.lightGray, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                .scaleEffect(0.9)
            
            Circle()
                .trim(from: 0.5, to: 1.0)
                .stroke(Color.mediumLightGray, style: StrokeStyle(lineWidth: 10, lineCap: .butt ,dash:[2,43]))
                .scaleEffect(0.80)
            
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.darkPurple)
                .frame(width: 12, height: 30)
                .offset(y:-130)
            
            Circle()
                .trim(from: 0.5, to: startAnimation ? CGFloat(progress)/sliderConfig.maximumValue : 0.0)
                .stroke(Color.darkPurple, style: StrokeStyle(lineWidth: 16, lineCap: .round))
                .scaleEffect(0.9)
            
            HStack{
                Text("\(progress)")
                    .font(.system(size: 40, weight:.black))
                Text("kg")
                    .font(.system(size: 40, weight:.regular))
            }
            .offset(y:-40)
        }
        .onAppear{
            withAnimation{
                startAnimation.toggle()
            }
        }
    }
}

struct CustomTabView : View {
    @Binding var progress: Int
    @State var showWeightAdjustView = false
    var body: some View{
        HStack(spacing:20){
            Image(systemName: "house")
                .foregroundColor(.darkPurple)
                .padding()
            
            Image(systemName: "waveform.path.ecg")
                .padding()
            
            Button(action: {
                showWeightAdjustView = true
            }, label: {
                
                ZStack{
                    Circle()
                        .fill(Color.darkPurple)
                        .frame(width: 44, height: 44)
                        .shadow(color: Color.darkPurple.opacity(0.4), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/,y: 10)
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                }
                
            })
            
            Image(systemName: "heart")
                .padding()
            
            Image(systemName: "person")
                .padding()
        }
        .font(.system(size: 24,weight:.light))
        .sheet(isPresented: $showWeightAdjustView, content: {
            //weight adjust view
            WeightAdjustView(progress: $progress)
        })
        Spacer()
    }
}

struct WeightAdjustView: View {
    @Binding var progress: Int
    var body: some View{
        VStack(spacing:20){
            // person background
            PersonBackgroundView(progress: $progress)
            Text("Weight")
                .font(.system(size: 22,weight:.semibold))
            // progress text
            ProgressTextView(progress:  $progress)
            // rular view
            RularView()
            // slider view
            SliderView(progress:  $progress)
            // next button view
            NextButtonView()
            
            Spacer()
            
        }
    }
}


struct PersonBackgroundView: View {
    @Binding var progress: Int
    var body: some View{
        ZStack{
            Circle()
                .fill(Color.lightPurple)
                .frame(width: UIScreen.screenWidth, height: UIScreen.screenWidth)
                .scaleEffect(1.5)
                .offset(y:-130)
            
            Image("background_nature")
                .resizable()
                .scaledToFit()
                .offset(y:-70)
            
            Image("man")
                .resizable()
                .scaledToFit()
                .offset(y:30)
        }
    }
}


struct ProgressTextView: View {
    @Binding var progress: Int
    var body: some View{
        HStack{
            Spacer()
            
            ForEach(Array(stride(from:90,through: 120,by: 10)), id: \.self){value in
                Text("\(inRange(value: value) ? progress :  value)")
                    .font(.system(size: inRange(value: value) ? 32 : 28,weight:.bold))
                    .foregroundColor( inRange(value: value) ? .darkPurple : .mediumLightGray)
                    .frame(width: 90)
                    .fixedSize()
                    .animation(nil)
                
                Spacer()
                
            }
        }
    }
    
    func inRange(value:Int) -> Bool{
        let range = value..<value+10
        return range.contains(progress)
    }
}
struct RularView: View {
    var body: some View{
        HStack(alignment: .bottom){
            Spacer()
            ForEach(Array(stride(from:90,through: 120,by: 5)), id: \.self){value in
                VStack{
                    Rectangle()
                        .fill(Color.mediumLightGray)
                        .frame(width: 1.5, height: value % 10 == 0 ? 20 : 15)
                
                    Text("\(value)")
                        .font(.system(size:10,weight:.bold))
                        .opacity(value % 10 == 0 ? 1.0 : 0.0)
                }
                Spacer()
            }
        }
    }
}

struct SliderView: View {
    @Binding var progress: Int
    var body: some View{
        HStack{
            ForEach(0..<5,id: \.self){ _ in
                Spacer()
            }
                
            GeometryReader{ geometry in
                Slider(progress:$progress, width: geometry.size.width)
            }
            .frame(height:50)
            
            ForEach(0..<5,id: \.self){ _ in
                Spacer()
            }
            
        }
    }
}

struct Slider:View{
    @Binding var progress: Int
    @State var knobPosition: CGFloat = 0.0
    let width: CGFloat
    let sliderConfig = SliderConfig()
    var dragGesture: some Gesture{
        DragGesture()
            .onChanged{ value in
                withAnimation{calculateProgress(xLocation: value.location.x)}
            }
    }
    
    
    var body: some View{
        ZStack(alignment: .leading){
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.lightGray)
                .frame(height:12)
            KnobView()
                .offset(x:knobPosition)
                .gesture(dragGesture)
        }
        .onAppear{
            calculateInitialKnobPosition()
        }
    }
    
    func calculateInitialKnobPosition(){
        let tempProgress = (CGFloat(progress) - sliderConfig.minimumValue) / (sliderConfig.maximumValue - sliderConfig.minimumValue)
        knobPosition = (tempProgress * width) - sliderConfig.knobRadius
    }
    
    func calculateProgress(xLocation: CGFloat){
        let tempProgress = xLocation/width
        
        if tempProgress > 0 && tempProgress <= 1{
            let roundedProgress = round((tempProgress * (sliderConfig.maximumValue - sliderConfig.minimumValue)) + sliderConfig.minimumValue)
            
            progress = Int(roundedProgress)
            
            let tempPosition = tempProgress * width - sliderConfig.knobRadius
            knobPosition = tempPosition > -sliderConfig.knobRadius ? tempPosition : -sliderConfig.knobRadius
        }
    }
}

struct KnobView: View {
    var body: some View{
        ZStack{
            Circle()
                .fill(Color.lightGray)
            
            Circle()
                .strokeBorder(Color.darkPurple,lineWidth: 5)
        }
        .frame(width: 30, height: 30)
        .padding(5)
    }
}



struct NextButtonView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View{
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            ZStack{
                RoundedRectangle(cornerRadius:25.0)
                    .fill(Color.darkPurple)
                    .frame(width:130,height: 50)
                    .shadow(color:Color.darkPurple.opacity(0.5),radius: 10,y:10)
                
                Text("Next")
                    .foregroundColor(.white)
            }
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
