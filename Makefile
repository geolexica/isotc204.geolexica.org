SHELL := /bin/bash
JSON_PP := json_pp -json_opt pretty,relaxed,utf8
# _site/api/concepts/*.json files are processed with jekyll-tidy-json plugin
GENERATED_JSONS := _site/api/concepts/*.jsonld

all: _site

clean:
	rm -rf _site _source/_data/info.yaml _source/_data/metadata.yaml

data: _source/_data/info.yaml _source/_data/metadata.yaml _source/_data/bibliography

_site: bundle | data
	bundle exec jekyll build

postprocess:
	echo "Postprocessing JSONs..."; \
	for f in ${GENERATED_JSONS}; do \
		mv $${f} .tmp.json; \
		${JSON_PP} < .tmp.json > $${f} && rm .tmp.json || mv .tmp.json $${f}; \
	done

bundle:
	bundle

_source/_data/info.yaml: isotc204-glossary/tc204-termbase.meta.yaml
	cp -f $< $@

_source/_data/metadata.yaml: metadata.yaml
	cp -f $< $@

_source/_data/bibliography: bibliography
	cp -rf $< $@

metadata.yaml:
	scripts/generate_metadata.rb

bibliography:
	scripts/generate_bibliography.rb

serve:
	bundle exec jekyll serve

.PHONY: data bundle all open serve clean postprocess
