//
//  ToolView.swift
//  Bili-Swift
//
//  Created by zzh on 2024/7/27.
//

import PhotosUI
import SwiftUI
import UIKit

struct ToolView: View {
    @State private var selectedImage: UIImage?
    @State private var selectedLivePhoto: PHLivePhoto?
    @State private var showingPicker = false
    var body: some View {
        VStack {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit().onTapGesture {
                        do {
                            print(selectedImage)

                            print(selectedLivePhoto)
                        } catch {
                            debugPrint(error)
                        }
                    }
            }
            if let selectedLivePhoto = selectedLivePhoto {
                Text("Live Photo selected!")
            }
            Button("Select Photo") {
                showingPicker = true
            }
        }
        .sheet(isPresented: $showingPicker) {
            ImagePicker(selectedImage: $selectedImage, selectedLivePhoto: $selectedLivePhoto)
        }.navigationTitle("LivePhoto")
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var selectedLivePhoto: PHLivePhoto?
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.mediaTypes = ["public.image", "com.apple.live-photo"]
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            debugPrint(info)
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            if let livePhoto = info[.livePhoto] as? PHLivePhoto {
                debugPrint("is livephoto")
                parent.selectedLivePhoto = livePhoto
            } else {
                debugPrint("is not livephoto")
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    ToolView()
}
