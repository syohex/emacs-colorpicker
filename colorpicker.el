;;; colorpicker.el --- ColorPicker

;; Copyright (C) 2015 by Syohei YOSHIDA

;; Author: Syohei YOSHIDA <syohex@gmail.com>
;; URL: https://github.com/syohex/emacs-colorpicker
;; Version: 0.01

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;; Code:

(defvar colorpicker--script
  (concat (if load-file-name
              (file-name-directory load-file-name)
            default-directory)
          "script/colorpicker.py"))

(defun colorpicker--pick-color (color)
  (with-temp-buffer
    (let ((ret (if color
                   (process-file colorpicker--script nil '(t nil) nil color)
                 (process-file colorpicker--script nil '(t nil) nil))))
      (unless (zerop ret)
        (error "Can't launch '%s'" colorpicker--script))
      (goto-char (point-min))
      (buffer-substring-no-properties (point) (line-end-position)))))

(defun colorpicker--bounds ()
  (let ((bounds (bounds-of-thing-at-point 'symbol)))
    (when bounds
      (save-excursion
        (goto-char (car bounds))
        (when (= (char-before) ?#)
          (cons (1- (car bounds)) (cdr bounds)))))))

;;;###autoload
(defun colorpicker ()
  (interactive)
  (let ((color (thing-at-point 'symbol))
        (bounds (colorpicker--bounds)))
    (let ((picked-color (colorpicker--pick-color (concat "#" color))))
      (unless (string= "" picked-color)
        (when bounds
          (goto-char (car bounds))
          (delete-region (point) (cdr bounds)))
        (insert picked-color)))))

(provide 'colorpicker)

;;; colorpicker.el ends here
