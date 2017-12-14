(ql:quickload '("alexandria" "skippy"))

(defpackage #:aoc-day-14
  (:use :cl :skippy))

(in-package #:aoc-day-14)

(defun skippy-eg ()
  (let* ((height 128)
	 (width 128)
	 (data-stream (make-data-stream :height height
					:width width
					:color-table t))
	 (image (make-image :height height :width width))
	 (red (ensure-color (rgb-color #xFF #x00 #x00)
			    (color-table data-stream)))
	 (white (ensure-color (rgb-color #xFF #xFF #xFF)
			      (color-table data-stream))))
    (add-image image data-stream)
    (fill (image-data image) white)
    (dotimes (i (truncate height 2))
      (let* ((start (* i width 2))
	     (end (+ start width)))
	(fill (image-data image) red :start start :end end)))
    (output-data-stream data-stream #P"example1.gif")))

;; Dirty naive version of Perl6's rotor, assuming no overlap and that
;; the sequence is evenly divisible by the chunk size
(defun rotor (seq chunk-size)
  ;; Can probaby use :by here
  (loop for i from 0 to (1- (/ (length seq) chunk-size))
     collecting (subseq seq (* i chunk-size)
			(+ (* i chunk-size) chunk-size))))

(defun nrevplace (list start run)
  ;; No point messing around if the run is 1 -- we won't end up
  ;; actually reversing anything.
  (when (> run 1)
    (let* ((len (length list))
	   (from-indexes (loop for i from start to (+ start run -1)
			    collecting (mod i len)))
	   (to-indexes (reverse from-indexes))
	   (from-indexes (subseq from-indexes 0
				 (truncate (/ (length from-indexes) 2)))))
      ;; (format t "Rotating ~a ~a~%" from-indexes to-indexes)
      (loop for from in from-indexes
	 for to in to-indexes
	 do (rotatef (svref list from)
		     (svref list to))))))

(defun sparse-hash (lengths)
  (let ((twine (apply #'vector (alexandria:iota 256)))
	(rounds 64)
	(curr 0)
	(skip 0))
    (loop for i from 1 to rounds
       do (loop for j across lengths
	     do (progn
		  (nrevplace twine curr j)
		  (setf curr (mod (+ curr j skip)
				  (length twine))
			skip (1+ skip)))))
    twine))

(defun dense-hash (lengths)
  (let ((sparse (rotor (sparse-hash lengths) 16)))
    (format t "~%~%~{~2,'0x~}~%"
	    (loop for chunk in sparse
	       collecting (reduce #'logxor chunk)))))

(defun run ()
  (let ((salt (list 17 31 73 47 23))
	(input "34,88,2,222,254,93,150,0,199,255,39,32,137,136,1,167"))
    (dense-hash (apply #'vector (nconc
				 (loop for c across input
				    collecting (char-code c))
				 salt)))))
