//
//  ReaderView.swift
//  LottoGameMVVM
//
//  Created by 유성열 on 12/22/23.
//

import UIKit
import AVFoundation

// MARK: - QR 인식하는 UIView

// 카메라 화면을 View에 띄운다 -> QRCode를 인식 부분 이외에 어둡게 처리하고 인식 부분에 테두리 그림 -> 인식되면 데이터 처리
final class ReaderView: UIView {
    
    // MARK: - 뷰 속성
    
    // QR코드 뷰컨으로부터 커스텀생성자를 통해 뷰모델을 전달받는다.
    private var viewModel: QRCodeReaderViewModel
    
    // 카메라 화면 보여주는 Layer
    // AVCaptureSession은 캡처할 미디어의 설정과 캡처를 시작하고 관리, AVCaputureVideoPreviewLayer는 캡처 세션으로 부터 받은 비디오를 화면에 보여주는 역할
    var previewLayer: AVCaptureVideoPreviewLayer?
    var captureSession: AVCaptureSession?
    
    // 카메라 앵글 테두리 레이어 설정
    private var cornerLength: CGFloat = 20 // 모서리
    private var cornerLineWidth: CGFloat = 6 // 선의 굵기
    private var rectOfInterest: CGRect { // 카메라 앵글(사각형) 계산 속성
        CGRect(x: (bounds.width / 2) - (200 / 2), y: (bounds.height / 2) - (200 / 2), width: 200, height: 200)
    }
    
    // 계산 속성
    // captureSession이 nil이 아니면 captureSession.isRunning으로 현재 captureSession이 실행중인지 확인한다.(nil이면 flase를 반환해서 세션의 실행 여부를 알 수 없음을 나타냄)
    // captureSession이라는 AVCaptureSession 객체가 실행중인지 여부를 나타냄
    var isRunning: Bool {
        guard let captureSession = self.captureSession else { return false }
        return captureSession.isRunning // AVCaptureSession 클래스 내부에 isRunning이라는 속성이 존재하며 Bool 값을 반환하여 해당 세션이 현재 실행중인지 여부를 알려줌
    }
    
    // 촬영 시 어떤 데이터를 검사할지?(QR Code)
    // AVMetadataObject.ObjectType는 'AVCaputureMetadataOutput에서 처리하고자 하는 메타데이터 오브젝트의 유형을 정의하는 열거형 -> 이 중에서도 .qr은 QR코드를 나타내고 [AVMetadataObject.ObjectType]이 배열에 .qr코드를 추가하는 것
    let metadataObjectTypes: [AVMetadataObject.ObjectType] = [.qr]
    
    
    // MARK: - 뷰 생성자
    
    // 재정의 생성자
    override init(frame: CGRect) {
        self.viewModel = QRCodeReaderViewModel()
        super.init(frame: frame) // 저장속성을 모두 초기화 한 후 상위생성자를 호출해야 함.
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 커스텀 생성자 구현(뷰모델과 같이 생성)
    init(frame: CGRect, viewModel: QRCodeReaderViewModel) {
        self.viewModel = viewModel // 현재 단계의 속성을 초기화 하고
        super.init(frame: frame) // 상위 생성자를 호출한다.
        self.setupView()
    }
    
    // MARK: - 뷰 UI 설정 메서드
    // MARK: MVVM 패턴에서 뷰는 'UI를 표현'하고 뷰모델은 '비즈니스 로직'을 처리하는 것이므로 뷰에 대한 속성과 로직들을 뷰 내부에서 처리했다.
    
    // ❓❓❓ MVVM 패턴에 준수하는 것인지 점검 필요
    
    // AVCaptureSession을 실행하는 화면을 구성
    private func setupView() {
        self.clipsToBounds = true // 자신의 경계를 벗어나는 하위 요소들을 자름?
        self.captureSession = AVCaptureSession() // 캡처세션 인스턴스 생성
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return } // 기본 비디오 관련 입력 장치를 가져옴(기기가 카메라 지원이 되지 않는다면 nil)
        
        let videoInput: AVCaptureInput // AVCaptureSession에 입력을 제공하는 추상 클래스(캡처세션에 입력 장치를 연결하기 위한 클래스)
        
        do {
            // AVCaptureDeviceInput은 입력장치를 입력으로 받아들이는 클래스 (에러 발생할 수 있으므로 try do~Catch 사용)
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch let error { // let 바인딩으로 error 잡아냄
            print(error.localizedDescription)
            return
        }
        
        guard let captureSession = self.captureSession else {
            self.fail()
            return
        }
        
        // canAddInput은 captureSession에 카메라 입력(videoInput)을 추가할 수 있는지 확인(Bool 리턴)
        // addInput은 captureSession에 해당 입력을 추가함
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            self.fail()
            return
        }
        
        // AVCaptureMetadataOutput클래스는 AVCaptureSession에 추가하여 메타데이터 출력을 관리
        // 카메라로부터 입력된 미디어의 메타데이터를 캡처하고 처리하는데 사용(일반적으로 바코드, QR 코드)
        let metadataOutput = AVCaptureMetadataOutput()
        // canAddOutput은 captureSession에 metadataOutput을 추가할 수 있는지 확인(Bool 리턴)
        // addOutput은 captureSession에 metadataOutput을 추가
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            // setMetadataObjectsDelegate(self, queue: DispatchQueue.main)은 metadataOutput에 메타데이터 객체를 처리할 delegate를 설정(ReaderView가 델리게이트 역할)하고 메타데이터 처리를 위한 queue도 설정
            // metadataObjectTypes는 어떤 종류의 메타데이터를 캡처할지를 설정(여기선 .qr)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = self.metadataObjectTypes // .qr이 담겨있음
        } else {
            self.fail()
            return
        }
        
        self.setPreviewLayer() // 포커스 레이어
        self.setFocusZoneCornerLayer() // 포커스 테두리 레이어
        
        // QR코드 인식 범위 설정
        // metadataOutput.rectOfInterest는 AVCaptureSession에서 CGRect 크기만큼 인식 구역으로 지정
        // 해당 값은 먼저 AVCaptureSession을 running 상태로 만든 후 지정해줘야 정상 작동
        self.start()
        // rectOfInterest는 QR코드 메타데이터를 찾기 위한 관심 영역을 정의하는 사각형의 영역을 나타냄(영역 설정을 하면 카메라가 해당 영역만을 촬영하고 그 안에서만 QR코드를 감지) -> 결국 그 영역은 CGRect(rectOfInterest 계산 속성)로 사각형의 영역이 정의됨
        // metadataOutputRectConverted는 레이어 좌표 공간에서 메타데이터 출력의 사각형 좌표를 비디오 미리보기 레이어의 좌표 공간으로 변환해주는 역할(바코드를 찾을 관심 영역(rectOfInterest)을 레이어의 좌표 시스템으로 변환 후 metadataOutput.rectOfInterest에 값을 할당하여 메타데이터를 찾을 영역을 설정함)
        metadataOutput.rectOfInterest = previewLayer!.metadataOutputRectConverted(fromLayerRect: rectOfInterest)
    }
    
    // 중앙에 사각형 포커스 레이어 설정
    private func setPreviewLayer() {
        
        let readingRect = rectOfInterest // 계산 속성
        
        guard let captureSession = self.captureSession else { return }
        
        // AVCaptureVideoPreviewLayer 구성(설명은 위에 속성 부분에)
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) // caputerSession의 비디오 입력을 표시하기 위한 미리보기 뷰로 사용(카메라에 입력된 비디오를 화면에 표시하기 위한 레이어 사용)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill // 비디오 비율 조정(resizeAspectFill은 레이어의 사각형에 맞게 비디오를 확대 또는 축소해서 레이어를 가득채움)
        previewLayer.frame = self.layer.bounds // previewLayer의 프레임을 ReaderView의 크기와 같도록 설정(bounds는 뷰의 내부 좌표 공간에서의 크기로서 해당 뷰 내에서의 상대적인 위치와 크기를 정의 원점에서 해당 뷰의 크기를 정의)
        
        // 스캔 포커스
        // 스캔할 사각형(포커스존)을 구성, 해당 자리만 흐리지 않도록
        // CAShapeLayer에서 도형 모양을 그리고자 할때 CGPath를 사용(즉 previewLayer에다가 ShapeLayer를 그리는데 ShapeLayer의 모양이 [1.bounds 크기의 사각형, 2.readingRect 크기의 사각형] 두 개가 그려져 있는 것이다??)
        let path = CGMutablePath()
        path.addRect(bounds)
        path.addRect(readingRect)
        
        // Path(경로, 모양)은 그려졌고 Layer의 특징을 정하고 추가할 것.
        // 먼저 CAShapeLayer의 Path를 위에서 지정한 path로 설정
        // QRReader에서 백그라운드 컬러가 dimeed(흐리게) 처리가 되어야 하므로 Layer의 투명도를 0.6 정도 설정
        // 단 여기서 QRCode를 읽을 부분은 dimeed 처리가 되어 있으면 안됨, 이럴때 fillRule에서 evenOdd를
        // 지정해주는데 Path(도형)이 겹치는 부분(여기서는 readingRect, QRCode 읽는 부분)은 fillColor의 영향을 받지 않음.
        let maskLayer = CAShapeLayer() // CAShapeLayer는 CoreAnimation에서 제공하는 클래스로 경로(Shape)를 기반으로 하는 2D 도형을 그리고 애니메이션 및 스타일링을 적용함.(경로(Paths)기반 그리기: CGPath 객체를 사용하여 직선, 곡선, 다각형등의 도형을 그림)
        maskLayer.path = path
        maskLayer.fillColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.6).cgColor
        maskLayer.fillRule = .evenOdd
        
        previewLayer.addSublayer(maskLayer)
        
        self.layer.addSublayer(previewLayer)
        self.previewLayer = previewLayer
        
    }
    
    // 포커스 모서리의 테두리 레이어를 만듦
    private func setFocusZoneCornerLayer() {
        var cornerRadius = previewLayer?.cornerRadius ?? CALayer().cornerRadius // CALayer는 CoreAnimation 기본 구성 요소중 하나(그래픽 컨텐츠 표현하고 애니메이션 처리하는 객체 - UIView와 매우 유사한 기능)
        if cornerRadius > cornerLength { cornerRadius = cornerLength }
        if cornerLength > rectOfInterest.width / 2 { cornerLength = rectOfInterest.width / 2 }
        
        // Focus Zone의 각 모서리 point
        // CGPoint는 2차원 좌표 평면에서 한 지점을 표현(x,y 값으로 이루어진 구조체로 주로 좌표를 표현하고 다루는데 사용)(간단하게 말해서 2차원 좌표계에서 한 점의 위치를 나타냄))
        let upperLeftPoint = CGPoint(x: rectOfInterest.minX - cornerLineWidth / 2, y: rectOfInterest.minY - cornerLineWidth / 2)
        let upperRightPoint = CGPoint(x: rectOfInterest.maxX + cornerLineWidth / 2, y: rectOfInterest.minY - cornerLineWidth / 2)
        let lowerRightPoint = CGPoint(x: rectOfInterest.maxX + cornerLineWidth / 2, y: rectOfInterest.maxY + cornerLineWidth / 2)
        let lowerLeftPoint = CGPoint(x: rectOfInterest.minX - cornerLineWidth / 2, y: rectOfInterest.maxY + cornerLineWidth / 2)
        
        // 각 모서리를 중심으로 한 Edge를 그림.
        let upperLeftCorner = UIBezierPath() // UIBezierPath는 경로를 생성하고 관리하는 클래스(직선, 곡선, 사각형, 원 등 다양한 모양의 경로를 만들고 그림)
        upperLeftCorner.move(to: upperLeftPoint.offsetBy(dx: 0, dy: cornerLength))
        upperLeftCorner.addArc(withCenter: upperLeftPoint.offsetBy(dx: cornerRadius, dy: cornerRadius), radius: cornerRadius, startAngle: .pi, endAngle: 3 * .pi / 2, clockwise: true)
        upperLeftCorner.addLine(to: upperLeftPoint.offsetBy(dx: cornerLength, dy: 0))
        
        let upperRightCorner = UIBezierPath()
        upperRightCorner.move(to: upperRightPoint.offsetBy(dx: -cornerLength, dy: 0))
        upperRightCorner.addArc(withCenter: upperRightPoint.offsetBy(dx: -cornerRadius, dy: cornerRadius),
                                radius: cornerRadius, startAngle: 3 * .pi / 2, endAngle: 0, clockwise: true)
        upperRightCorner.addLine(to: upperRightPoint.offsetBy(dx: 0, dy: cornerLength))
        
        let lowerRightCorner = UIBezierPath()
        lowerRightCorner.move(to: lowerRightPoint.offsetBy(dx: 0, dy: -cornerLength))
        lowerRightCorner.addArc(withCenter: lowerRightPoint.offsetBy(dx: -cornerRadius, dy: -cornerRadius),
                                radius: cornerRadius, startAngle: 0, endAngle: .pi / 2, clockwise: true)
        lowerRightCorner.addLine(to: lowerRightPoint.offsetBy(dx: -cornerLength, dy: 0))
        
        let bottomLeftCorner = UIBezierPath()
        bottomLeftCorner.move(to: lowerLeftPoint.offsetBy(dx: cornerLength, dy: 0))
        bottomLeftCorner.addArc(withCenter: lowerLeftPoint.offsetBy(dx: cornerRadius, dy: -cornerRadius),
                                radius: cornerRadius, startAngle: .pi / 2, endAngle: .pi, clockwise: true)
        bottomLeftCorner.addLine(to: lowerLeftPoint.offsetBy(dx: 0, dy: -cornerLength))
        
        // 그려진 UIBezierPath를 묶어서 CAShapeLayer에 path를 추가 후 화면에 추가.
        let combinedPath = CGMutablePath() // CGMutablePath는 경로를 만들고 그리는데 사용되는 클래스로 경로(Path)를 만들기 위해 사용되며 선, 곡선, 다각형등을 그리고 편집할 수 있는 가변(mutable)한 경로를 생성
        combinedPath.addPath(upperLeftCorner.cgPath)
        combinedPath.addPath(upperRightCorner.cgPath)
        combinedPath.addPath(lowerRightCorner.cgPath)
        combinedPath.addPath(bottomLeftCorner.cgPath)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = combinedPath
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = cornerLineWidth
        shapeLayer.lineCap = .square
        
        self.previewLayer!.addSublayer(shapeLayer)
    }
}

// CGPoint 확장
extension CGPoint {
    // CGPoint + offsetBy
    // 현재 좌표에 dx와 dy를 더해 새로운 CGPoint를 반환함(변경된 좌표를 가진 새로운 CGPoint를 반환함)
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        var point = self
        point.x += dx
        point.y += dy
        return point
    }
}


// MARK: - 뷰 logic

extension ReaderView {
    
    func start() {
        print("AVCaptureSession Start Running")
        self.captureSession?.startRunning() // 캡처세션 시작
    }
    
    func stop() {
        self.captureSession?.stopRunning() // 캡처세션 중지
        viewModel.setReaderStatus(.stop)
        //self.delegate?.rederComplete(status: .stop) // 델리게이트 메서드에 스탑(열거형)-Bool 전달)
    }
    
    func fail() {
        viewModel.setReaderStatus(.fail)
        //self.delegate?.rederComplete(status: .fail)
        self.captureSession = nil
    }
    
    func found(code: String) { // QR 코드를 성공적으로 읽었을 때 호출.
        viewModel.setReaderStatus(.sucess(code))
        //self.delegate?.rederComplete(status: .sucess(code))
    }
}

// 리더뷰 확장해서 AVCaptureMetadataOutputObjectsDelegate 델리게이트 채택
// 카메라가 메타데이터를 출력할 때 발생하는 이벤트를 처리?
extension ReaderView: AVCaptureMetadataOutputObjectsDelegate {
    // 이 metadataOutput 메서드는 카메라에서 받은 메타데이터 오브젝트들을 처리하고 해당 오브젝트중에서 AVCaptureMetadataOutputObject로 변환 가능한 객체가 있다면 그 중에서 첫 번째 값을
    // 사용하여 QR 코드를 찾는 동작을 수행
    // 파라미터 output은 AVCaptureMetadataOutput 객체, metadataObjects은 카메라가 감지한 metadata 객체들의 배열, connection은 AVCaptureConnection 객체로, 연결된 입력 및 출력 장치 사이의 데이터 흐름을 관리
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        print("GET metadataOutput")
        //stop(isButtonTap: false)
        
        // metadataObjects 배열에서 첫 번째 객체를 가져와서 이 객체가 AVMetadataMachineReadableCodeObject로 타입캐스팅이 가능하고 그 안에 stringValue가 있는지 확인
        // 해당 코드값을 찾았다면 해당 코드값을 출력하고 found 메서드에 호출하여 찾은 코드를 처리하는 것 -> 그리고 stop 메서드로 카메라를 중지
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
                  let stringValue = readableObject.stringValue else { return }
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate)) // 진동을 울림
            //AudioServicesPlayAlertSound(SystemSoundID(1407)) // 이건 사운드
            found(code: stringValue) // QR코드를 성공적으로 읽었을때 호출되는 found
            print("Found metadata Value: \n \(stringValue)")
            stop() // 위 동작들 완료되면 캡처세션 중지
        }
    }
}



