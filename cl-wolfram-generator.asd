(asdf:defsystem cl-py-generator
    :version "0"
    :description "Emit Wolfram Language code"
    :maintainer " <kielhorn.martin@gmail.com>"
    :author " <kielhorn.martin@gmail.com>"
    :licence "GPL"
    :depends-on ("alexandria")
    :serial t
    :components ((:file "package")
		 (:file "wl")
		 (:file "pipe")
		 ) )
