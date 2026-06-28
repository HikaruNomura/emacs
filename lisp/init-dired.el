;;; init-dired.el --- Dired tweaks -*- lexical-binding: t; -*-

;;; Commentary:
;; Quality-of-life defaults for Dired, Emacs' built-in file manager.

;;; Code:

(use-package dired
  :ensure nil                           ; built in
  :custom
  ;; Human-readable sizes, directories first, all-but-implied entries.
  (dired-listing-switches "-alh --group-directories-first")
  ;; Reuse the same buffer when descending into a directory.
  (dired-kill-when-opening-new-dired-buffer t)
  ;; Guess the other visible Dired window as the default copy/move target.
  (dired-dwim-target t)
  :config
  ;; Auto-refresh Dired (and other buffers) when files change on disk.
  (setq global-auto-revert-non-file-buffers t)
  (global-auto-revert-mode 1))

(provide 'init-dired)
;;; init-dired.el ends here
