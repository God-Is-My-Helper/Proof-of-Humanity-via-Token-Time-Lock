(define-map humans
  { user: principal }
  { locked-at: uint, verified: bool })

;; --- Constants
(define-constant WAIT-TIME u144) ;; ~24 hours in blocks
(define-constant LOCK-AMOUNT u1000000) ;; 1 STX

;; --- Error Codes
(define-constant ERR-USER-ALREADY-EXISTS u101)
(define-constant ERR-ALREADY-VERIFIED u102)
(define-constant ERR-WAIT-TIME-NOT-MET u103)
(define-constant ERR-USER-NOT-FOUND u404)

(define-public (prove-humanness)
  (let ((sender tx-sender))
    ;; A user can only start the process if they haven't already.
    ;; This prevents re-locking STX and resetting the timer.
    (asserts! (is-none (map-get? humans { user: sender })) (err ERR-USER-ALREADY-EXISTS))
    (try! (stx-transfer? LOCK-AMOUNT sender (as-contract tx-sender)))
    (map-set humans
      { user: sender }
      { locked-at: block-height, verified: false })
    (ok true)))

(define-public (claim-humanness)
  (let* ((sender tx-sender)
         (human-record (unwrap! (map-get? humans { user: sender }) (err ERR-USER-NOT-FOUND))))

    ;; Check if already verified
    (asserts! (not (get verified human-record)) (err ERR-ALREADY-VERIFIED))

    ;; Check if wait time has passed
    (asserts! (>= (- block-height (get locked-at human-record)) WAIT-TIME) (err ERR-WAIT-TIME-NOT-MET))

    (begin
      (try! (stx-transfer? LOCK-AMOUNT (as-contract tx-sender) sender))
      (map-set humans
        { user: sender }
        { locked-at: (get locked-at human-record), verified: true })
      (ok true))))

(define-read-only (is-human (user principal))
  ;; If a user is not in the map, they are not verified.
  ;; Return (ok false) instead of an error for a cleaner API.
  (match (map-get? humans { user: user })
    human => (ok (get verified human))
    none => (ok false)))
