;;; init-theme.el --- Colour theme -*- lexical-binding: t; -*-

;;; Commentary:
;; Modus themes ship with Emacs (>= 28), so they load with no network and
;; render well in both GUI and terminal frames -- important for offline /
;; low-powered machines like the Pomera DM250.  Default is the dark
;; `modus-vivendi'; `<f5>' toggles to the light `modus-operandi'.

;;; Code:

;; The modus *theme files* live in etc/themes (on `custom-theme-load-path'),
;; but the modus-themes *API library* (toggle, the `modus-themes-*' options)
;; lives in that same dir, which is NOT on `load-path' -- so `require' it by
;; putting the themes directory on the load path first.
(let ((themes-dir (expand-file-name "themes" data-directory)))
  (when (file-directory-p themes-dir)
    (add-to-list 'load-path themes-dir)))

(use-package modus-themes
  :ensure nil                           ; built in
  :demand t                             ; load now: theme must apply at startup
  :bind ("<f5>" . modus-themes-toggle)
  :custom
  ;; Slightly richer defaults; cheap and terminal-safe.
  (modus-themes-italic-constructs t)
  (modus-themes-bold-constructs t)
  (modus-themes-org-blocks 'gray-background)
  ;; <f5> cycles between this dark/light pair.
  (modus-themes-to-toggle '(modus-vivendi modus-operandi))
  :config
  (load-theme 'modus-vivendi :no-confirm))

(provide 'init-theme)
;;; init-theme.el ends here
