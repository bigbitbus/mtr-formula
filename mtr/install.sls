{% from "mtr/map.jinja" import install_mtr as mtr_map with context %}
{% set package = mtr_map.get('package', 'mtr') %}
{% set install_from_source = mtr_map.get('install_from_source', False) %}
{% set install_paping = mtr_map.get('install_paping', True) %}

{% if install_from_source==False %}
install_mtr_package:
  pkg.installed:
    - name: {{ package }}
{% else %}
{% set prereqs = mtr_map.get('prereq_packages',[]) %}
{% set mtrurl = mtr_map.get('mtr_source_url','url_needed')  %}

install_prereqs:
  pkg.latest:
    - pkgs: {{ prereqs }}

download_source:
  cmd.run:
    - names: 
      - rm -rf mtr*
      - wget {{ mtrurl }} -O mtr.tar.gz
    - cwd: /tmp

compile_source:
  cmd.script:
    - name: compileinstall.sh
    - source: salt://mtr/files/compileinstall.sh
    - requires:
      - install_prereqs
      - download_source

{% endif %}

{% if install_paping==True %}
{% set paping_url = mtr_map.get('paping_url','url_needed')  %}
download_paping:
  cmd.run:
    - names: 
      - wget {{ paping_url }} -O paping.tar.gz
      - tar -xvzf paping.tar.gz
      - mv paping /usr/local/bin
    - cwd: /tmp

{%endif%}    
    

