(in-package :cl-wolfram-generator)

(defparameter *wolfram* nil)
(defparameter *wolfram-reading-thread* nil)


(defun start-wolfram ()
  (unless (and *wolfram*
	       (eq :running (sb-impl::process-%status *wolfram*)))
    (setf *wolfram*
	  (sb-ext:run-program "WolframKernel" '()
			      :search t :wait nil
			      :pty t))
    (when *wolfram-reading-thread*
      (sb-thread:join-thread *wolfram-reading-thread*)
      (setf *wolfram-reading-thread* nil))
    (setf *wolfram-reading-thread*
	  (sb-thread:make-thread
	   #'(lambda (standard-output)
	       (let ((*standard-output* standard-output))
		 (loop for line = (read-line (sb-impl::process-pty *wolfram*) nil 'foo)
		    until (eq line 'foo)
		    do
		      (print line))))
	   :name "wolfram-reader"
	   :arguments (list *standard-output*)))))

(defun run (code)
  (assert (eq :running (sb-impl::process-%status *wolfram*)))
  (let ((s (sb-impl::process-pty *wolfram*)))
    (write-sequence
    (cl-wolfram-generator::emit-wl  :clear-env t
			       :code code)
    s)
   (terpri s)
   (force-output s)))


