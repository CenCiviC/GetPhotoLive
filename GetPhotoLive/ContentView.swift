import Foundation
import SwiftUI
import PhotosUI
//
//This code defines a RecentPicturesGrid view that fetches the 9 most recent photos from the user's photo library and displays them in a 3x3 grid. Here's a brief explanation of how it works:
//
//We start by defining a @State variable called recentPhotos, which will hold the array of recent photos that we fetch from the photo library.
//In the body of the view, we define a grid layout with 3 columns using the LazyVGrid view, and loop over the recentPhotos array using a ForEach loop. For each photo, we create an Image view that displays the photo and applies some formatting to make it fit nicely in the grid.
//We wrap the LazyVGrid in a ScrollView to allow the user to scroll through the grid if there are more than 9 photos in the library.
//We use the onAppear modifier to call the fetchRecentPhotos() function when the view appears. This function uses the PHAsset and PHImageManager classes from the Photos framework to fetch the 9 most recent photos from the library, and adds them to the recentPhotos array as UIImage objects.
//Finally, we define a preview provider for the view so we can see what it looks like in Xcode's canvas.
//To use this code in your own project, simply create a new SwiftUI view and copy the RecentPicturesGrid code into it. You'll also need to add the Photos framework to your project by going to the Project settings > General > Frameworks, Libraries, and Embedded Content, and adding it to the list of frameworks.


struct RecentPicturesGrid: View {
    @State private var recentPhotos: [UIImage] = []
    
    var body: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 3)
        
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(recentPhotos, id: \.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width / 3 - 15, height: UIScreen.main.bounds.width / 3 - 15)
                        .clipped()
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
        .onAppear {
            fetchRecentPhotos()
        }
    }
    
    func fetchRecentPhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = 9
        
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        fetchResult.enumerateObjects { (asset, _, _) in
            let manager = PHImageManager.default()
            let options = PHImageRequestOptions()
            options.deliveryMode = .highQualityFormat
            options.isSynchronous = true
            
            manager.requestImage(for: asset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFill, options: options) { (image, _) in
                if let image = image {
                    recentPhotos.append(image)
                }
            }
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RecentPicturesGrid()
    }
}
