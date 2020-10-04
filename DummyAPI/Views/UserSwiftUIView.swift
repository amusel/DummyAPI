//
//  UserSwiftUIView.swift
//  DummyAPI
//
//  Created by Artem Musel on 04.10.2020.
//

import SwiftUI

/*  I am new in SwiftUI, sorry for poor formatting.
    Also I did not copy colors/images strictly,
    hope this is fine.
*/

struct UserSwiftUIView: View {
  @State var user: User
  @State var image = UIImage()
  
  var body: some View {
    ScrollView() {
      VStack(spacing: 0.0) {
        HeaderView(user: user, image: image)
        
        SubheaderView()
        
        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua")
          .lineLimit(3)
          .padding(.all)
        
        VStack(alignment: .center, spacing: 0.0) {
          Color.gray.frame(height: 0.5)
          
          HStack(alignment: .center) {
            Button(action: {
              print ("Button Pressed")
            }) {
              Image(systemName: "person.badge.plus.fill")
                .accentColor(.blue)
              Text("Follow")
            }.frame(minWidth: 0, maxWidth: .infinity)
            
            Color.gray.frame(width: 0.5)
            
            Button(action: {
              print ("Button Pressed")
            }) {
              Image(systemName: "envelope.fill")
                .accentColor(.blue)
              Text("Message")
            }.frame(minWidth: 0, maxWidth: .infinity)
            
          }
          
          Color.gray.frame(height: 0.5)
        }.padding(.bottom, 16.0)
        .frame(height: 80.0)
        
        Group {
          Text("Markets")
            .padding(.bottom, 8.0)
          
          VStack() {
            Text("Qatar Stock Exchange • Dubai Stock Exchange")
              .foregroundColor(Color.gray)
            
            Text("Riyadh Stock Exchange")
              .foregroundColor(Color.gray)
          }
        }
        
        Color.gray.frame(height: 0.5)
          .padding(.vertical)
        
        Group {
          Text("Qualification")
            .padding(.bottom, 8.0)
          
          Text("CFA • CMA • CEFA")
            .foregroundColor(Color.gray)
            .padding(.bottom)
        }
        
        Spacer()
      }.onAppear(perform: loadAdditionalData)
    }
  }
  
  func loadAdditionalData() {
    NetworkManager.shared.requestForUser(withID: user.id) { user in
      guard let user = user else {
        return
      }
      
      self.user = user
    }
    
    NetworkManager.shared.requestForUserImage(withUrl: user.imageURL) { image, url in
      DispatchQueue.main.async {
        guard let image = image else {
          return
        }
        
        self.image = image
      }
    }
  }
}

struct UserSwiftUIView_Previews: PreviewProvider {
  static var previews: some View {
    UserSwiftUIView(user: User())
  }
}

struct HeaderView: View {
  var user: User
  var image = UIImage()
  
  var body: some View {
    Group {
      HStack {
        Spacer()
        Button(action: {
          print ("Button Pressed")
        }) {
          Image(systemName: "ellipsis")
            .padding(.all)
            .accentColor(.gray)
        }
      }
      
      Image(uiImage: image)
        .clipShape(Circle())
      
      Image(systemName: "star.circle")
        .foregroundColor(.yellow)
        .background(Circle()
                      .foregroundColor(.white)
                      .frame(width: 24, height: 24))
        .offset(x: 0, y: -12)
      
      Text("\(user.firstName) \(user.lastName)")
        .font(.title)
        .padding([.leading, .bottom, .trailing], 8.0)
      
      
      HStack(alignment: .center, spacing: 24.0) {
        
        Text("@\(user.firstName)\(user.lastName)".lowercased())
          .lineLimit(1)
          .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
          .foregroundColor(Color.gray)
        
        Color.gray.frame(width: 0.5, height: 18)
        
        Text("\(user.lastName).com".lowercased())
          .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
          .foregroundColor(Color.gray)
      }.padding(.bottom, 8.0)
      
      Text("\(user.location?.country ?? "...")")
        .foregroundColor(Color.gray)
        .padding(.bottom, 32.0)
    }
  }
}

struct SubheaderView: View {
  var body: some View {
    VStack(alignment: .center, spacing: 0.0) {
      Color.gray.frame(height: 0.5)
      
      HStack(alignment: .center) {
        
        VStack(alignment: .center, spacing: 5.0) {
          Image(systemName: "ellipses.bubble.fill")
          Text("1241")
        }.frame(minWidth: 0, maxWidth: .infinity)
        Color.gray.frame(width: 0.5)
        
        VStack(alignment: .center, spacing: 5.0) {
          Image(systemName: "person.badge.plus.fill")
          Text("2212")
        }.frame(minWidth: 0, maxWidth: .infinity)
        Color.gray.frame(width: 0.5)
        
        VStack(alignment: .center, spacing: 5.0) {
          Image(systemName: "person.badge.minus.fill")
            .foregroundColor(.blue)
          Text("1544").foregroundColor(.blue)
        }.frame(minWidth: 0, maxWidth: .infinity)
        Color.gray.frame(width: 0.5)
        
        VStack(alignment: .center, spacing: 5.0) {
          Image(systemName: "dollarsign.circle.fill")
          Text("1023")
        }.frame(minWidth: 0, maxWidth: .infinity)
      }
      
      Color.gray.frame(height: 0.5)
    }
    .frame(height: 80.0)
    .background(Color(red: 0.969, green: 0.973, blue: 0.988))
  }
}
