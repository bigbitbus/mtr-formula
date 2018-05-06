{% from "mtr/map.jinja" import exec_mtr as exec_mtr_map with context %}
{% set mtr_path = exec_mtr_map.get('fio_path','/usr/bin/mtr') %}
{% set cli_args = exec_mtr_map.get ('cmd_cli_args','') %}
{% set out_dir = exec_mtr_map.get('out_dir','/tmp/outputdata/mtr') %}
{% set test_id = grains.get('testgitref','no_test_id_grain') %}
{% set minion_id = grains.get('id', 'no_hostname_grain' ) %}
{% set do_ping = mtr_map.get('do_ping', True) %}

check_and_setup:
  cmd.run:
    - name: '{{ mtr_path }} -h' 

{% for target_host, ext_ip in salt['mine.get']('*', 'grains.get').items() %}

{% set test_out_dir = [out_dir,target_host] | join('/') %}
{% set curtime = salt['cmd.run']('date +%s') %}
{% set filename =  ['mtr.',minion_id,'_',target_host,'_',curtime] | join('') %}
{% set base_cmd_list = [mtr_path,cli_args,ext_ip] %}  

make_dir_{{target_host}}_{{ curtime }}:
  file.directory:
    - name: {{ test_out_dir }}
    - makedirs: True

{% if do_mtr==True %}
run_mtr_{{target_host}}_{{ curtime }}:
  cmd.run:
    - names: 
      - '{{ base_cmd_list | join(' ') }} > {{ filename }}.mtr'
    - requires:
      - check_and_setup
      - make_dir_{{target_host}}_{{ curtime }}
    - cwd: {{ test_out_dir }}
{% endif %}

{% if do_ping==True}
run_ping_{{target_host}}_{{ curtime }}:
    cmd.run:
    - names: 
      - 'ping {{ ext_ip }} -c 30 -D > {{ filename }}.ping'
    - requires:
      - make_dir_{{target_host}}_{{ curtime }}
    - cwd: {{ test_out_dir }}
{% endif %}

{% endfor %}



    