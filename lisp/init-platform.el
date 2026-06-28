;;; init-platform.el --- Environment detection -*- lexical-binding: t; -*-

;;; Commentary:
;; A thin layer that detects *where* Emacs is running so later modules can
;; adapt.  This config is used across several machines and both GUI and
;; terminal frames:
;;
;;   Windows (native, PowerShell), WSL2, DGX Spark (ARM64 Linux),
;;   and a Pomera DM250 (ARM Linux, low-powered, often offline / -nw).
;;
;; The predicates below are plain constants so they are cheap to test from
;; anywhere.  Nothing here should require network access or a GUI.

;;; Code:

;; Shared customize group for this config's own options (`my/...').
(defgroup my nil "Personal Emacs configuration." :group 'convenience)

(defconst my/windows-p (eq system-type 'windows-nt)
  "Non-nil on native Microsoft Windows.")

(defconst my/macos-p (eq system-type 'darwin)
  "Non-nil on macOS.")

(defconst my/linux-p (eq system-type 'gnu/linux)
  "Non-nil on any GNU/Linux (includes WSL2).")

(defconst my/wsl-p
  (and my/linux-p
       (or (getenv "WSL_DISTRO_NAME")
           (and (file-readable-p "/proc/version")
                (with-temp-buffer
                  (insert-file-contents "/proc/version")
                  (goto-char (point-min))
                  (and (re-search-forward "[Mm]icrosoft" nil t) t)))))
  "Non-nil when this GNU/Linux is running under WSL2.")

(defun my/gui-p ()
  "Non-nil when the *current* frame is graphical.
Call this rather than testing at load time: a daemon can serve both
GUI and terminal frames in one session, so the answer is per-frame."
  (display-graphic-p))

;; Per-host overrides go here.  `system-name' is the hostname; fill these
;; in once each machine's name is known (e.g. the DGX Spark or DM250) to
;; special-case font size, behaviour, etc.
(defconst my/host (downcase (or (and (boundp 'system-name) (format "%s" system-name))
                                (system-name) ""))
  "Lower-cased hostname, for host-specific tweaks.")

(provide 'init-platform)
;;; init-platform.el ends here
