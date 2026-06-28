;;; init-completion.el --- Minibuffer and in-buffer completion -*- lexical-binding: t; -*-

;;; Commentary:
;; The Vertico stack: a light layer on top of Emacs' built-in
;; `completing-read', so there is little lock-in if we ever want to swap
;; it out.
;;
;;   vertico    - vertical minibuffer completion UI
;;   orderless  - space-separated, order-independent matching
;;   marginalia - rich annotations next to candidates
;;   consult    - search/preview commands (buffers, lines, grep, ...)
;;   corfu      - in-buffer popup completion (kept deliberately light)
;;
;; Buffer completion (corfu) is configured conservatively: most code here
;; is written with help these days, so completion need only stay out of
;; the way until asked.

;;; Code:

;; Remember minibuffer history so Vertico can sort by recency.
(use-package savehist
  :ensure nil                           ; built in
  :init (savehist-mode 1))

(use-package vertico
  :init (vertico-mode 1)
  :custom
  (vertico-cycle t))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia
  :init (marginalia-mode 1))

(use-package consult
  :bind (("C-s"   . consult-line)        ; search current buffer
         ("C-x b" . consult-buffer)      ; switch buffer (with preview)
         ("M-y"   . consult-yank-pop)    ; browse the kill ring
         ("M-g g" . consult-goto-line)
         ("M-s r" . consult-ripgrep)))   ; project-wide search

(use-package corfu
  :init (global-corfu-mode 1)
  :custom
  ;; Light touch: pop up automatically, but only after a short pause and
  ;; a couple of characters, so it never feels noisy.
  (corfu-auto t)
  (corfu-auto-delay 0.25)
  (corfu-auto-prefix 2)
  (corfu-cycle t)
  (corfu-quit-no-match 'separator))

(provide 'init-completion)
;;; init-completion.el ends here
