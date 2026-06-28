;;; init-fonts.el --- GUI fonts -*- lexical-binding: t; -*-

;;; Commentary:
;; Fonts only matter in a graphical frame, so everything here is guarded
;; by `display-graphic-p' and applied per-frame (so it also works for an
;; Emacs daemon serving both GUI and -nw clients).
;;
;; We do not assume any particular font is installed: each machine may
;; have a different subset.  `my/font-families' is tried in order and the
;; first one actually present wins, falling back to the OS default.  The
;; preferred family is UDEV Gothic, which covers both ASCII and Japanese;
;; `scripts/install-fonts.{sh,ps1}' install it per platform.

;;; Code:

(require 'init-platform)

(defcustom my/font-size 120
  "Default face height in 1/10 pt (120 = 12pt)."
  :type 'integer :group 'my)

(defvar my/font-families
  '("UDEV Gothic" "UDEV Gothic 35"      ; preferred (ASCII + Japanese)
    "HackGen" "HackGen35" "Cica" "Myrica M"
    ;; OS fallbacks, in case none of the above are installed.
    "Consolas" "Menlo" "DejaVu Sans Mono" "Noto Sans Mono")
  "Monospace families to try, in order of preference.")

(defvar my/jp-font-families
  '("UDEV Gothic" "HackGen" "Cica" "Myrica M"
    "Yu Gothic" "Noto Sans CJK JP" "Noto Sans Mono CJK JP")
  "Japanese-capable families for the CJK fallback fontset.")

(defun my/first-available-font (families)
  "Return the first family in FAMILIES that is installed, or nil."
  (seq-find (lambda (f) (find-font (font-spec :family f))) families))

(defun my/apply-fonts (&optional frame)
  "Set the default and CJK fonts for FRAME, if it is graphical."
  (when (display-graphic-p frame)
    (let ((mono (my/first-available-font my/font-families))
          (jp   (my/first-available-font my/jp-font-families)))
      (when mono
        (set-face-attribute 'default frame
                            :family mono :height my/font-size)
        ;; Keep a proportional-ish variable-pitch consistent too.
        (set-face-attribute 'fixed-pitch frame :family mono))
      ;; Route Japanese (and kana/CJK punctuation) through a JP font so
      ;; glyphs render even when the main family lacks them.
      (when jp
        (dolist (script '(han kana cjk-misc))
          (set-fontset-font t script (font-spec :family jp) frame))))))

;; Apply now (for the first GUI frame) and on every new frame (daemon).
(my/apply-fonts)
(add-hook 'after-make-frame-functions #'my/apply-fonts)

(provide 'init-fonts)
;;; init-fonts.el ends here
