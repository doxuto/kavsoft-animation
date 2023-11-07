//
//  LockscreenModel.swift
//  iOS16LockScreen
//
//  Created by Balaji on 12/08/22.
//

import SwiftUI
import PhotosUI
import SDWebImage
import Vision
import CoreImage
import CoreImage.CIFilterBuiltins

class LockscreenModel: ObservableObject{
    // MARK: Image Picker Properties
    @Published var pickedItem: PhotosPickerItem?{
        didSet{
            // MARK: Extracting Image
            extractImage()
        }
    }
    @Published var compressedImage: UIImage?
    @Published var detectedPerson: UIImage?
    
    // MARK: Scaling Properties
    @Published var scale: CGFloat = 1
    @Published var lastScale: CGFloat = 0
    
    @Published var textRect: CGRect = .zero
    @Published var view: UIView = .init()
    @Published var placeTextAbove: Bool = false
    @Published var onLoad: Bool = false
    
    func extractImage(){
        if let pickedItem{
            Task{
                guard let imageData = try? await pickedItem.loadTransferable(type: Data.self) else{return}
                // MARK: Resizing Image To Phone's Size * 2
                // So that Memory Will be Preserved
                let size = await UIApplication.shared.screenSize()
                let image = UIImage(data: imageData)?.sd_resizedImage(with: CGSize(width: size.width * 2, height: size.height * 2), scaleMode: .aspectFill)
                await MainActor.run(body: {
                    self.compressedImage = image
                    segmentPersonOnImage()
                })
            }
        }
    }
    
    // MARK: Person Segmentation Using Vision
    func segmentPersonOnImage(){
        guard let image = compressedImage?.cgImage else{return}
        // MARK: Request
        let request = VNGeneratePersonSegmentationRequest()
        // MARK: Set this to True only for Testing in Simulator
//        request.usesCPUOnly = true
        
        // MARK: Task Handler
        let task = VNImageRequestHandler(cgImage: image)
        do{
            try task.perform([request])
            
            // MARK: Result
            if let result = request.results?.first{
                let buffer = result.pixelBuffer
                maskWithOriginalImage(buffer: buffer)
            }
        }catch{
            print(error.localizedDescription)
        }
    }
    
    // MARK: It will Give the Mask/Outline of the Person present in the Image
    // We Need to Mask it With The Original Image, In Order to Remove the Background
    func maskWithOriginalImage(buffer: CVPixelBuffer){
        guard let cgImage = compressedImage?.cgImage else{return}
        let original = CIImage(cgImage: cgImage)
        let mask = CIImage(cvImageBuffer: buffer)
        
        // MARK: Scaling Properties of the Mask in order to fit perfectly
        let maskX = original.extent.width / mask.extent.width
        let maskY = original.extent.height / mask.extent.height
        
        let resizedMask = mask.transformed(by: CGAffineTransform(scaleX: maskX, y: maskY))
        
        // MARK: Filter Using Core Image
        let filter = CIFilter.blendWithMask()
        filter.inputImage = original
        filter.maskImage = resizedMask
        
        if let maskedImage = filter.outputImage{
            // MARK: Creating UIImage
            let context = CIContext()
            guard let image = context.createCGImage(maskedImage, from: maskedImage.extent) else{return}
            
            // This is Detected Person Image
            self.detectedPerson = UIImage(cgImage: image)
            self.onLoad = true
        }
    }
    
    // MARK: Checking TextView Coordinates Color is Still White or Not
    func verifyScreenColor(){
        // For More Depth Effect Converting it to midY to Miny
        // Make Sure it Pointing Out Your text Color
        let rgba = view.color(at: CGPoint(x: textRect.midX, y: (textRect.minY + 5)))
        print(rgba)
        // Note Since White Color is 1,1,1,1
        // I'm Directly Comparing
        // If You're Using Another Text Color
        // Then Give Those Color Components Here
        withAnimation(.easeInOut){
            if rgba.0 == 1 && rgba.1 == 1 && rgba.2 == 1 && rgba.3 == 1{
                placeTextAbove = false
            }else{
                placeTextAbove = true
            }
        }
    }
}

extension UIView{
    // RGBA
    func color(at point: CGPoint)->(CGFloat,CGFloat,CGFloat,CGFloat){
        let colorspace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        var pixelData: [UInt8] = [0,0,0,0]
        
        let context = CGContext(data: &pixelData, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorspace, bitmapInfo: bitmapInfo.rawValue)
        context!.translateBy(x: -point.x, y: -point.y)
        
        self.layer.render(in: context!)
        
        let red = CGFloat(pixelData[0]) / 255
        let blue = CGFloat(pixelData[1]) / 255
        let green = CGFloat(pixelData[2]) / 255
        let alpha = CGFloat(pixelData[3]) / 255
        
        return (red,green,blue,alpha)
    }
}

extension UIApplication{
    func screenSize()->CGSize{
        guard let window = connectedScenes.first as? UIWindowScene else{return .zero}
        return window.screen.bounds.size
    }
}
