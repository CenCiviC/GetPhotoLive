import Foundation
import SwiftUI
import PhotosUI

struct ContentView: View {
    
    @State private var images = [UIImage]()
    
    var body: some View {
        VStack {
            if images.count > 0 {
                GridView(images: images)
            } else {
                Text(String(images.count))
            }
        }
        .onAppear {
            loadPhotos()
        }
    }
    
    func loadPhotos() {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        options.fetchLimit = 9
        
        let result = PHAsset.fetchAssets(with: .image, options: options)
        
        DispatchQueue.global(qos: .background).async {
            result.enumerateObjects { (asset, _, _) in
                let imageManager = PHImageManager.default()
                let requestOptions = PHImageRequestOptions()
                requestOptions.isSynchronous = true
                
                imageManager.requestImage(for: asset, targetSize: CGSize(width: 150, height: 150), contentMode: .aspectFill, options: requestOptions) { (image, _) in
                    if let image = image {
                        self.images.append(image)
                    }
                }
            }
        }
    }
}

struct GridView: View {
    let images: [UIImage]
    
    var body: some View {
        VStack(spacing: 10) {
            ForEach(0..<3) { row in
                HStack(spacing: 10) {
                    ForEach(0..<3) { column in
                        Image(uiImage: images[row*3+column])
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width/3 - 10, height: UIScreen.main.bounds.width/3 - 10)
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
