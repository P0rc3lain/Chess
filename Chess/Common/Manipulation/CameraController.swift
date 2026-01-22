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
        let translation = PNAnimatedFloat3.static(from: [0, 0.41, 5])
        let transform = camera.animator.transform(coordinateSpace: camera.animation).rotation
        let newOrientation = simd_quatf(angle: Float(angleDegress).radians, axis: [0, 1, 0])
        let animation = PNKeyframeAnimation<simd_quatf>(keyFrames: [transform, newOrientation * transform],
                                                        times: [0, 1],
                                                        maximumTime: 2)
        let acs = PNAnimatedCoordinateSpace(translation: translation,
                                            rotation: animation,
                                            scale: PNAnimatedFloat3.defaultScale)
        camera.animator.chronometer.reset()
        camera.animation = acs
    }
    func rotate(camera: PNAnimatedCameraNode, quatf: simd_quatf) {
        let translation = PNAnimatedFloat3.static(from: [0, 0.41, 5])
        let transform = camera.animator.transform(coordinateSpace: camera.animation).rotation
        let animation = PNKeyframeAnimation<simd_quatf>(keyFrames: [transform * quatf],
                                                        times: [0],
                                                        maximumTime: 0)
        let acs = PNAnimatedCoordinateSpace(translation: translation,
                                            rotation: animation,
                                            scale: PNAnimatedFloat3.defaultScale)
        camera.animator.chronometer.reset()
        camera.animation = acs
    }
    func set(camera: PNAnimatedCameraNode, transformation: simd_float4x4) {
        camera.animator.chronometer.reset()
        camera.animation = .static(from: transformation)
    }
}
