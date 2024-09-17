build:
	docker build -t apptainer-docker .
apptainer:
	docker run -it -u0 --rm -w /work apptainer-docker bash 