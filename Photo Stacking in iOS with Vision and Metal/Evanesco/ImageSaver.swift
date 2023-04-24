/// Copyright (c) 2019 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import CoreImage

struct ImageSaver {
  var count = 0
  let url: URL
  
  init() {
    let uuid = UUID().uuidString
    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    url = urls[0].appendingPathComponent(uuid)
    try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: false, attributes: nil)
  }
  
  mutating func write(_ image: CIImage, as name: String? = nil) {
    guard let colorSpace = CGColorSpace(name: CGColorSpace.sRGB) else {
      return
    }
    let context = CIContext()
    let lossyOption = kCGImageDestinationLossyCompressionQuality as CIImageRepresentationOption
    let imgURL: URL
    if let name = name {
      imgURL = url.appendingPathComponent("\(name).jpg")
    } else {
      imgURL = url.appendingPathComponent("\(count).jpg")
    }
    try? context.writeJPEGRepresentation(of: image,
                                         to: imgURL,
                                         colorSpace: colorSpace,
                                         options: [lossyOption: 0.9])
    count += 1
  }
}
