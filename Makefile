plan:
	$(eval current_dir := $$(shell pwd))
	(docker run -it -w /work -v $(current_dir)/terraform:/work hashicorp/terraform:light init)
	(docker run -it -w /work -v $(current_dir)/terraform:/work hashicorp/terraform:light validate)
	(docker run -it -w /work -v $(current_dir)/terraform:/work hashicorp/terraform:light plan)

build:
	$(eval current_dir := $$(shell pwd))
	(docker run -it -w /work -v $(current_dir)/terraform:/work hashicorp/terraform:light init)
	(docker run -it -w /work -v $(current_dir)/terraform:/work hashicorp/terraform:light validate)
	(docker run -it -w /work -v $(current_dir)/terraform:/work hashicorp/terraform:light plan)
	(docker run -it -w /work -v $(current_dir)/terraform:/work hashicorp/terraform:light apply -auto-approve)
