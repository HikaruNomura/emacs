;;; init-ui.el --- Basic UI defaults -*- lexical-binding: t; -*-

;;; Commentary:
;; Minimal, uncontroversial UI tweaks.  The first of the lisp/init-*.el
;; modules; more will be added over time.

;;; Code:

(setq inhibit-startup-screen t
      initial-scratch-message nil
      ring-bell-function 'ignore)

(column-number-mode 1)
(global-display-line-numbers-mode 1)
(show-paren-mode 1)

(provide 'init-ui)
;;; init-ui.el ends here
