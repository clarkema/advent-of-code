(ql:quickload "bordeaux-threads")

(defpackage #:aoc-day-15
  (:use :cl))

(in-package #:aoc-day-15)

(defun make-p1-generator (factor start)
  (let ((last start))
    (lambda ()
      (setf last (rem (* last factor)
		      2147483647)))))

(defun make-p2-generator (factor start check)
  (let ((last start))
    (lambda ()
      (loop
	 do (setf last (rem (* last factor)
			    2147483647))
	 until (zerop (rem last check))
	 finally (return last)))))


(defun part-1-simple ()
  (let ((a-start 516)
	(b-start 190))
    (loop with gen-a = (make-p1-generator 16807 a-start)
       with gen-b = (make-p1-generator 48271 b-start)
       for i from 1 to 40000000
       count (= (logand (funcall gen-a) #xFFFF)
		(logand (funcall gen-b) #xFFFF)) into matches
       finally (return matches) )))

(defun part-2-simple ()
  (let ((a-start 516)
	(b-start 190))
    (loop with gen-a = (make-p2-generator 16807 a-start 4)
       with gen-b = (make-p2-generator 48271 b-start 8)
       for i from 1 to 5000000
       count (= (logand (funcall gen-a) #xFFFF)
		(logand (funcall gen-b) #xFFFF)) into matches
       finally (return matches) )))
