;;; early-init.el --- Loaded before package system and GUI -*- lexical-binding: t; -*-

;;; Commentary:
;; Runs before package.el and frame creation.  Keep this light: only
;; things that must happen early (startup performance, suppressing UI
;; chrome before the first frame is drawn).

;;; Code:

;; Avoid garbage collection during startup, then restore a sane value.
(setq gc-cons-threshold most-positive-fixnum)
(add-hook 'emacs-startup-hook
          (lambda () (setq gc-cons-threshold (* 16 1024 1024))))

;; We initialise package.el explicitly in init.el.
(setq package-enable-at-startup nil)

;; Suppress UI chrome before the first frame so it never flashes in.
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

(setq inhibit-startup-screen t)

;;; early-init.el ends here
