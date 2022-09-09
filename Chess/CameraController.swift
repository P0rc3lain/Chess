//
//  CameraController.swift
//  Chess
//
//  Created by Mateusz Stompór on 09/09/2022.
//

import Engine
import simd

class CameraController {
    func rotate(camera: PNAnimatedCameraNode, angleDegress: Int) {
        let translation = PNAnimatedFloat3.static(from: [0, 0, 5])
        let transform = camera.animator.transform(coordinateSpace: camera.animation).rotation
        let newOrientation = simd_quatf(angle: Float(angleDegress).radians, axis: [0, 1, 0])
        let animation = PNKeyframeAnimation<simd_quatf>(keyFrames: [transform, newOrientation * transform],
                                                        times: [0, 1],
                                                        maximumTime: 1)
        let acs = PNAnimatedCoordinateSpace(translation: translation,
                                            rotation: animation,
                                            scale: PNAnimatedFloat3.defaultScale)
        camera.animator.chronometer.reset()
        camera.animation = acs
    }
}
