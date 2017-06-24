#lang typed/racket

(require typed/racket/unsafe)

(require/typed/provide ffi/unsafe
  [#:opaque CType ctype?]
  [#:opaque CPointer cpointer?])


(provide (all-defined-out))

;(define (XDisplay-pointer? p) (λ (p) (eq? (cpointer-tag p) 'XDisplay)))
;; TODO: use macros to parse the defitions and convert them to types
(define-type Long Integer)
(define-type ULong Nonnegative-Integer)
(define-type Int Integer)
(define-type UInt Nonnegative-Integer)
(define-type Bool Boolean)

;;is this right? #f for 0 and positive int for window pointer
(define-type Time ULong)
(define-type XID Nonnegative-Integer)
(define-type KeyCode Byte)
(define-type KeySym XID)
(define-type Cursor XID)
;(define-type Window (Option Positive-Integer))
(define-type Window XID)
;;this is weird
(define-type Modifiers (Listof (U 'ShiftMask 'LockMask 'ControlMask
                                  'Mod1Mask 'Mod2Mask 'Mod3Mask 'Mod4Mask 'Mod5Mask
                                  'Button1Mask 'Button2Mask 'Button3Mask
                                  'Button4Mask 'Button5Mask Any)))
(define-type GrabMode (U 'GrabModeSync 'GrabModeAsync))

(define-type InputMask (Listof (U 'NoEventMask 'KeyPressMask 'KeyReleaseMask
                                  'ButtonPressMask 'ButtonReleaseMask 'EnterWindowMask
                                  'LeaveWindowMask 'PointerMotionMask 'PointerMotionHintMask
                                  'Button1MotionMask 'Button2MotionMask 'Button3MotionMask
                                  'Button4MotionMask 'Button5MotionMask 'ButtonMotionMask
                                  'KeymapStateMask 'ExposureMask 'VisibilityChangeMask
                                  'StructureNotifyMask 'ResizeRedirectMask
                                  'SubstructureNotifyMask 'SubstructureRedirectMask
                                  'FocusChangeMask 'PropertyChangMask 'ColormapChangeMask
                                  'OwnerGrabButtonMask)))

(define-type EventType
  (U 'KeyPress 'KeyRelease 'ButtonPress 'ButtonRelease 'MotionNotify 'EnterNotify
     'LeaveNotify 'FocusIn 'FocusOut 'KeymapNotify 'Expose 'GraphicsExpose
     'NoExpose 'VisibilityNotify 'CreateNotify 'DestroyNotify 'UnmapNotify
     'MapNotify 'MapRequest 'ReparentNotify 'ConfigureNotify 'ConfigureRequest
     'GravityNotify 'ResizeRequest 'CirculateNotify 'CirculateRequest 
     'PropertyNotify 'SelectionClear 'SelectionRequest 'SelectionNotify 'ColormapNotify 
     'ClientMessage 'MappingNotify 'LASTEvent))

;(define-type XDisplay-pointer Integer)
;;https://groups.google.com/forum/#!topic/racket-users/-pgP7-C_3D4
;;TODO: fix that by declaring struct?
(require/typed/provide "../x11/x11.rkt"
  [#:opaque XDisplay XDisplay?] ;;TODO: /careful, possible name collision?
  [#:opaque XWindowAttributes XWindowAttributes?]
  [#:opaque XEvent XEvent?]
  [None Zero]
  [CurrentTime Time]
  ;;[#:opaque Window (Option Integer)]
  [XOpenDisplay (-> (Option String) XDisplay)]
  [XDefaultRootWindow (-> XDisplay Window)]
  ;;TODO: manual says Long should be Window, Int should be Bool
  [XGrabKeyboard (-> XDisplay Long Int Int Int Long Int)]
  [XGrabKey (-> XDisplay Int Modifiers Window Bool GrabMode GrabMode Void)]
  [XKeysymToKeycode (-> XDisplay KeySym KeyCode)]
  [XStringToKeysym (-> String KeySym)]
  ;; TODO change UInt to some button type
  [XGrabButton (-> XDisplay UInt Modifiers Window Bool InputMask GrabMode GrabMode Window Cursor Void)]
  [XRaiseWindow (-> XDisplay Window Void)]
  [XGrabPointer (-> XDisplay Window Bool InputMask GrabMode GrabMode Window Cursor Time Int)]
  [XGetWindowAttributes (-> XDisplay Window (Option XWindowAttributes))]
  [XMoveResizeWindow (-> XDisplay Window Int Int UInt UInt Int)]
  [XUngrabPointer (-> XDisplay Time Int)]
  [XNextEvent (-> XDisplay XEvent Int)]
  [XNextEvent* (-> XDisplay XEvent)]
  [XEvent-type (-> XEvent EventType)]
  ;; TODO add all XKeyEvent functions (via macro?)
  [XKeyEvent-subwindow (-> XEvent Window)] ; cstruct =/= struct :(
  ;; TODO add all XButtonEvent functions (tedious...)
  [XButtonEvent-subwindow (-> XEvent Window)]
  [XButtonEvent-button (-> XEvent UInt)]
  [XButtonEvent-x-root (-> XEvent Int)]
  [XButtonEvent-y-root (-> XEvent Int)]
  ;; TODO add all XMotionEvent functions
  [XMotionEvent-x-root (-> XEvent Int)]
  [XMotionEvent-y-root (-> XEvent Int)]
  [XMotionEvent-window (-> XEvent Window)]
  ;;
  [make-dummy-XEvent (-> XEvent)]
  ;; TODO add all XWindowAttributes
  [XWindowAttributes-x (-> XWindowAttributes Int)]
  [XWindowAttributes-y (-> XWindowAttributes Int)]
  [XWindowAttributes-width (-> XWindowAttributes UInt)] ;; TODO : manual says Int though
  [XWindowAttributes-height (-> XWindowAttributes UInt)]

;  [#:struct XKeyEvent
;   ([type : Int]
;    [serial : ULong]
;    [send-event : Bool]
;    [display : XDisplay]
;    [window : Window]
;    [root : Window]
;    [subwindow : Window]
;    [time : Time]
;    [x : Int]
;    [y : Int]
;    [x-root : Int]
;    [y-root : Int]
;    [state : Modifiers]
;    [keycode : UInt]
;    [same-screen : Bool])]
  )

