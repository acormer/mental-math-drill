.PHONY: serve

# Voice mode needs http:// (module workers and the model cache do not work from file://).
serve:
	python3 -m http.server 8000 --bind 127.0.0.1
