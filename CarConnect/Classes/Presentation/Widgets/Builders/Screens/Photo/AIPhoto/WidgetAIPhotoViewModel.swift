//
//  WidgetAIPhotoViewModel.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 03.04.2026.
//

import RxSwift
import RxCocoa

final class WidgetAIPhotoViewModel {
    enum Action {
        case openHelper
        case openPreview
        case close
        case requestRemoveConfirmation
        case enterName(String)
    }
    
    private let storageModelId: Driver<String?>
    private let initialConfiguration: Driver<WidgetAIPhotoConfiguration?>
    
    private lazy var generateAIPhotoActivity = RxActivityIndicator()
    
    private lazy var service = WidgetPhotoService()
    
    private lazy var vehicleManager = VehicleManager()
    
    init(storageModelId: String?, configuration: WidgetAIPhotoConfiguration?) {
        self.storageModelId = BehaviorRelay(value: storageModelId).asDriver()
        self.initialConfiguration = BehaviorRelay(value: configuration).asDriver()
    }
}

// MARK: Public
extension WidgetAIPhotoViewModel {
    struct Input {
        let didTapHelper: Signal<Void>
        let didTapOpenPreview: Signal<Void>
        let didTapSave: Signal<Void>
        let didTapRemove: Signal<Void>
        let didRemoveConfirmed: Signal<Void>
        let didEnterName: Signal<String>
        let didSelectPhotoAssetIdFromPicker: Signal<String>
        let didEnterPrompt: Signal<String>
        let didTapGenerateAIPhoto: Signal<WidgetAIPhotoPreviewView.State>
    }
    
    struct Output {
        let action: Driver<Action>
        let state: Driver<WidgetAIPhotoPreviewView.State>
        let generateAIPhotoEnable: Driver<Bool>
        let generateAIPhotoActivity: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        let storageModel = makeStorageModel(id: storageModelId)
        let prompt = input.didEnterPrompt.asDriver(onErrorDriveWith: .never())
        let aiPreview = makeAIPreview(
            didTapGenerateAIPhoto: input.didTapGenerateAIPhoto,
            prompt: prompt
        )
        let state = makeState(
            initialConfiguration: initialConfiguration,
            didSelectPhotoAssetIdFromPicker: input.didSelectPhotoAssetIdFromPicker,
            aiPreview: aiPreview
        )
        
        return Output(
            action: makeAction(
                didTapHelper: input.didTapHelper,
                didTapOpenPreview: input.didTapOpenPreview,
                didTapSave: input.didTapSave,
                didTapRemove: input.didTapRemove,
                didRemoveConfirmed: input.didRemoveConfirmed,
                storageModelId: storageModelId,
                didEnterName: input.didEnterName,
                storageModel: storageModel,
                state: state,
                prompt: prompt
            ),
            state: state,
            generateAIPhotoEnable: makeGenerateAIPhotoEnable(
                state: state,
                prompt: prompt
            ),
            generateAIPhotoActivity: generateAIPhotoActivity.asDriver()
        )
    }
}

// MARK: Private
extension WidgetAIPhotoViewModel {
    func makeState(
        initialConfiguration: Driver<WidgetAIPhotoConfiguration?>,
        didSelectPhotoAssetIdFromPicker: Signal<String>,
        aiPreview: Driver<VehicleAIPreviewGenerateResult?>
    ) -> Driver<WidgetAIPhotoPreviewView.State> {
        let initial = initialConfiguration
            .map { config -> WidgetAIPhotoPreviewView.State in
                if let config {
                    return .fileName(config.aiPreviewFileName)
                } else {
                    return .empty
                }
            }
        
        let selectNewPhoto = didSelectPhotoAssetIdFromPicker
            .map { WidgetAIPhotoPreviewView.State.photoAssetId($0) }
            .asDriver(onErrorDriveWith: .never())
        
        let aiPreviewGenerated = aiPreview
            .compactMap { $0?.base64 }
            .map { WidgetAIPhotoPreviewView.State.generated($0) }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(initial, selectNewPhoto, aiPreviewGenerated)
    }
    
    func makeGenerateAIPhotoEnable(
        state: Driver<WidgetAIPhotoPreviewView.State>,
        prompt: Driver<String>
    ) -> Driver<Bool> {
        Driver
            .combineLatest(state, prompt)
            .map { state, prompt -> Bool in
                let stateEnable: Bool = {
                    switch state {
                    case .photoAssetId:
                        return true
                    default:
                        return false
                    }
                }()
                
                let promptEnable = !prompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                
                return stateEnable && promptEnable
            }
            .startWith(false)
    }
    
    func makeAIPreview(
        didTapGenerateAIPhoto: Signal<WidgetAIPhotoPreviewView.State>,
        prompt: Driver<String>
    ) -> Driver<VehicleAIPreviewGenerateResult?> {
        didTapGenerateAIPhoto
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(prompt) { ($0.assetId, $1) }
            .filter { $0.0 != nil }
            .flatMapLatest { assetId, prompt -> Driver<VehicleAIPreviewGenerateResult?> in
                guard let assetId else { return .never() }
                
                let data = Observable<(UIImage, String)>
                    .create { observer in
                        let requestId = PhotoAssetImageLoader.shared.loadImage(assetId: assetId) { image in
                            guard let image else {
                                observer.onCompleted()
                                return
                            }
                            
                            observer.onNext((image, prompt))
                            observer.onCompleted()
                        }
                        
                        return Disposables.create {
                            PhotoAssetImageLoader.shared.cancel(requestId)
                        }
                    }
                    .asDriver(onErrorDriveWith: .never())
                
                return data
                    .flatMapLatest { [weak self] image, prompt -> Driver<VehicleAIPreviewGenerateResult?> in
                        guard let self else { return .never() }
                        
                        return vehicleManager
                            .vehicleAIPreviewGenerate(image: image, prompt: prompt)
                            .asDriver(onErrorJustReturn: nil)
                    }
                    .trackActivity(self.generateAIPhotoActivity)
                    .asDriver(onErrorJustReturn: nil)
            }
    }
    
    func makeAction(
        didTapHelper: Signal<Void>,
        didTapOpenPreview: Signal<Void>,
        didTapSave: Signal<Void>,
        didTapRemove: Signal<Void>,
        didRemoveConfirmed: Signal<Void>,
        storageModelId: Driver<String?>,
        didEnterName: Signal<String>,
        storageModel: Driver<WidgetAIPhotoStorageModel?>,
        state: Driver<WidgetAIPhotoPreviewView.State>,
        prompt: Driver<String>
    ) -> Driver<Action> {
        let openHelper = didTapHelper
            .map { Action.openHelper }
            .asDriver(onErrorDriveWith: .never())
        
        let openPreview = didTapOpenPreview
            .map { Action.openPreview }
            .asDriver(onErrorDriveWith: .never())
        
        let enterName = didTapSave
            .withLatestFrom(storageModel)
            .map { Action.enterName($0?.name ?? "Photo") }
            .asDriver(onErrorDriveWith: .never())
        
        let requestRemoveConfirmation = didTapRemove
            .asDriver(onErrorDriveWith: .never())
            .map { Action.requestRemoveConfirmation }
        
        let saveAndClose = didEnterName
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(storageModelId) { ($0, $1) }
            .withLatestFrom(state) { ($0.0, $0.1, $1) }
            .withLatestFrom(prompt) { ($0.0, $0.1, $0.2, $1) }
            .flatMapLatest { name, id, state, prompt -> Signal<(String?, String, WidgetAIPhotoConfiguration)> in
                let image: UIImage? = {
                    switch state {
                    case .generated(let base64):
                        return UIImage(base64: base64)
                    default:
                        return nil
                    }
                }()
                guard let image else { return .never() }
                
                return Single<(String?, String, WidgetAIPhotoConfiguration)>
                    .create { observer in
                        guard let fileName = SharedImageFileStore.shared.save(image: image, format: .jpeg(quality: 0.9)) else {
                            observer(.failure(ContentError(.notContent)))
                            return Disposables.create()
                        }
                        
                        let configuration = WidgetAIPhotoConfiguration(
                            aiPreviewFileName: fileName,
                            prompt: prompt
                        )
                        
                        observer(.success((id, name, configuration)))
                        
                        return Disposables.create()
                    }
                    .asSignal(onErrorSignalWith: .never())
            }
            .flatMapLatest { id, name, configuration -> Driver<Action> in
                let model: Single<WidgetAIPhotoStorageModel> = { [weak self] in
                    guard let self else { return .never() }
                    
                    if let id {
                        return service.editAIPhoto(
                            name: name,
                            storageModelId: id,
                            configuration: configuration
                        )
                    } else {
                        return service
                            .saveAIPhoto(name: name, configuration: configuration)
                    }
                }()
                
                return model
                    .asDriver(onErrorDriveWith: .never())
                    .map { _ in Action.close }
            }
        
        let removeAndClose = didRemoveConfirmed
            .withLatestFrom(storageModelId)
            .compactMap { $0 }
            .flatMapLatest { [weak self] id -> Driver<Action> in
                guard let self else { return .never() }
                
                return service
                    .deleteAIPhoto(storageModelId: id)
                    .map { Action.close }
                    .asDriver(onErrorDriveWith: .never())
            }
        
        return Driver
            .merge(openHelper, openPreview, enterName, requestRemoveConfirmation, saveAndClose, removeAndClose)
    }
    
    func makeStorageModel(id: Driver<String?>) -> Driver<WidgetAIPhotoStorageModel?> {
        id
            .flatMapLatest { [weak self] id -> Driver<WidgetAIPhotoStorageModel?> in
                guard let self, let id else {
                    return .just(nil)
                }
                
                return service
                    .fetchAIPhotoConfigurations()
                    .map { configs -> WidgetAIPhotoStorageModel? in
                        configs.first(where: { $0.id == id })
                    }
                    .asDriver(onErrorJustReturn: nil)
            }
    }
}

// MARK: Additional
private extension WidgetAIPhotoPreviewView.State {
    var assetId: String? {
        switch self {
        case .photoAssetId(let id):
            return id
        default:
            return nil
        }
    }
}
