{% from "mtr/map.jinja" import exec_mtr as exec_mtr_map with context %}
{% set mtr_path = exec_mtr_map.get('fio_path','/usr/bin/mtr') %}
{% set cli_args = exec_mtr_map.get ('cmd_cli_args','') %}
{% set out_dir = exec_mtr_map.get('out_dir','/tmp/outputdata/mtr') %}
{% set test_id = grains.get('testgitref','no_test_id_grain') %}
{% set minion_id = grains.get('host', 'no_hostname_grain' ) %}
check_and_setup:
  cmd.run:
    - name: '{{ mtr_path }} -h'
  file.directory:
    - name: {{ out_dir }}

{% for target_host in host_list %}

{% set test_out_dir = [out_dir,target_host] | join('/') %}
{% set curtime = salt['cmd.run']('date +%s') %}
{% set base_cmd_list = [mtr_path, cli_args, [' > mtr.', {{minion_id}},'_',{{ target_host }}, {{ curtime }},'.xml']|join('')] %}  

run_mtr_jobfile_{{job_file}}:
  file.directory:
    - name: {{ test_out_dir }}
    - makedirs: True

  cmd.run:
    - name: {{ base_cmd_list | join(' ') }}
    - requires:
      - check_and_setup
      - file.directory
    - cwd:
      - {{ test_out_dir }}

{% endfor %}



    