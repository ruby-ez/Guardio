;; Decentralized Insurance Contract

;; Constants
(define-constant contract-admin tx-sender)
(define-constant err-admin-only (err u100))
(define-constant err-invalid-request (err u101))
(define-constant err-insufficient-funds (err u102))
(define-constant err-not-covered (err u103))
(define-constant err-invalid-parameters (err u104))
(define-constant max-protection u1000000000) ;; Maximum coverage amount
(define-constant max-period u52560) ;; Maximum duration (about 1 year in blocks)
(define-constant min-payment u1000) ;; Minimum premium amount

;; Data Maps
(define-map protection-contracts
    principal
    {
        protection-amount: uint,
        payment: uint,
        termination: uint
    })

(define-map protection-requests
    principal
    {
        value: uint, 
        approved: bool
    })

;; Variables
(define-data-var protection-fund uint u0)

;; Admin Functions
(define-public (create-policy (protection-amount uint) (payment uint) (period uint))
    (let ((termination (+ block-height period)))
        (begin
            (asserts! (is-eq tx-sender contract-admin) err-admin-only)
            (asserts! (<= protection-amount max-protection) err-invalid-parameters)
            (asserts! (>= payment min-payment) err-invalid-parameters)
            (asserts! (<= period max-period) err-invalid-parameters)
            (map-set protection-contracts tx-sender
                {
                    protection-amount: protection-amount,
                    payment: payment,
                    termination: termination
                })
            (ok true))))

;; User Functions
(define-public (purchase-policy (protection-amount uint) (period uint))
    (let 
        ((contract-payment (* protection-amount (/ u1 u100) period))
         (termination (+ block-height period)))
        (begin
            (asserts! (<= protection-amount max-protection) err-invalid-parameters)
            (asserts! (<= period max-period) err-invalid-parameters)
            (asserts! (>= contract-payment min-payment) err-invalid-parameters)
            
            ;; Safe arithmetic operations with checks
            (asserts! (>= (+ (var-get protection-fund) contract-payment) 
                         (var-get protection-fund)) 
                     err-invalid-parameters)
            
            (try! (stx-transfer? contract-payment tx-sender (as-contract tx-sender)))
            (var-set protection-fund (+ (var-get protection-fund) contract-payment))
            (map-set protection-contracts tx-sender
                {
                    protection-amount: protection-amount,
                    payment: contract-payment,
                    termination: termination
                })
            (ok true))))

(define-public (file-claim (value uint))
    (let 
        ((contract (unwrap! (map-get? protection-contracts tx-sender) (err err-not-covered))))
        (begin
            (asserts! (<= value (get protection-amount contract)) (err err-invalid-request))
            (asserts! (is-ok (as-contract (stx-transfer? value tx-sender tx-sender))) (err err-insufficient-funds))
            (var-set protection-fund (- (var-get protection-fund) value))
            (map-set protection-requests tx-sender
                {
                    value: value,
                    approved: true
                })
            (ok true))))

;; Read-Only Functions
(define-read-only (get-policy-details (holder principal))
    (map-get? protection-contracts holder))

(define-read-only (get-claim-details (requester principal))
    (map-get? protection-requests requester))

(define-read-only (get-fund-balance)
    (var-get protection-fund))