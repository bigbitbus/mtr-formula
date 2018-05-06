{% from "mtr/map.jinja" import exec_mtr as exec_mtr_map with context %}
{% set mtr_path = exec_mtr_map.get('fio_path','/usr/bin/mtr') %}
{% set cli_args = exec_mtr_map.get ('cmd_cli_args','') %}
{% set out_dir = exec_mtr_map.get('out_dir','/tmp/outputdata/mtr') %}
{% set test_id = grains.get('testgitref','no_test_id_grain') %}
{% set minion_id = grains.get('id', 'no_hostname_grain' ) %}

check_and_setup:
  cmd.run:
    - name: '{{ mtr_path }} -h'
    

{% for target_host, ext_ip in salt['mine.get']('*', 'grains.get').items() %}

{% set test_out_dir = [out_dir,target_host] | join('/') %}
{% set curtime = salt['cmd.run']('date +%s') %}
{% set filename =  ['mtr.',minion_id,'_',target_host,'_',curtime,'.txt'] | join('') %}
{% set base_cmd_list = [mtr_path,cli_args,ext_ip] %}  

run_mtr_{{target_host}}_{{ curtime }}:
  file.directory:
    - name: {{ test_out_dir }}
    - makedirs: True

  cmd.run:
    - names: 
      - '{{ base_cmd_list | join(' ') }} > {{ filename }}'
      - sleep 1
    - requires:
      - check_and_setup
      - file.directory
    - cwd: {{ test_out_dir }}

{% endfor %}



    