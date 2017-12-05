(in-package :cl-user)

(defvar *file-path* #P"day_05.input")

(defun lines (path)
  (with-open-file (stream path)
    (loop for line = (read-line stream nil)
	  while line
	  collect line)))

(defun escape (instructions new-jump)
  (declare (optimize (speed 3) (debug 0) (safety 0))
	   (type (vector integer) instructions))
  (let ((stop (- (length instructions) 1))
	(index 0))
    (loop for i from 0
	  while (<= index stop)
	  do (let ((jump (svref instructions index)))
	       (setf (svref instructions index) (funcall new-jump jump)
		     index (+ index jump)))
	  finally (print i))))

(defun run (file-path new-jump)
  (let ((instructions (apply #'vector
			     (mapcar #'parse-integer
				     (lines *file-path*)))))
    (escape instructions new-jump)))

(run *file-path* (lambda (x) (+ x 1)))

(run *file-path* (lambda (x) (if (>= x 3)
				 (- x 1)
				 (+ x 1))))

