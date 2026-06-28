;;; init-japanese.el --- Japanese input (Mozc) -*- lexical-binding: t; -*-

;;; Commentary:
;; Comfortable Japanese input is the top priority for this config.  We use
;; mozc.el, which talks to the Mozc engine (Google-Japanese-Input quality)
;; entirely from within Emacs -- so it behaves identically whether Emacs is
;; a Windows/WSL GUI or a terminal reached over SSH (the common case: SSH
;; from the Pomera DM250 into the DGX Spark and run Emacs there).  An
;; in-Emacs input method avoids fighting per-OS IMEs that don't work over a
;; terminal at all.
;;
;; Candidates are shown inline via `mozc-popup', which works in both GUI and
;; -nw frames.  Toggle input with `C-\' (`toggle-input-method').
;;
;; Requirement: the helper binary `mozc_emacs_helper' must be on PATH.
;;   Debian/Ubuntu (Spark, WSL):  sudo apt-get install emacs-mozc-bin
;;   (see scripts/install-japanese-input.sh)
;; When the helper is absent (e.g. a native-Windows Emacs), this module
;; quietly does nothing so startup is unaffected.

;;; Code:

(use-package mozc
  :ensure t
  :if (executable-find "mozc_emacs_helper")
  :demand t
  :custom
  ;; Inline candidate popup; works in GUI and terminal/SSH alike.
  (mozc-candidate-style 'popup)
  :init
  (setq default-input-method "japanese-mozc"))

(use-package mozc-popup
  :ensure t
  :if (executable-find "mozc_emacs_helper")
  :after mozc
  :demand t)

(provide 'init-japanese)
;;; init-japanese.el ends here
