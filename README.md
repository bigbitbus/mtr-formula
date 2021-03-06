# MTR formula

[MTR](http://www.bitwizard.nl/mtr/) is a network benchmarking tool (a supercharged combination of ping and traceroute). This [salt formula](https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html) can be used to install it from the package repository or from source, and execute it and store the execution output in a specified directory.

See the full Salt Formulas installation and usage instructions [here](http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html).
## What this formula offers

* mtr.install - to install mtrg (from the OS packages - the default,  or from source if the pillar mtr:lookup:install_from_source is set). For example:
```
salt \* state.apply mtr.install pillar='{"mtr":{"lookup": {"install_from_source": True}}}'
```
You can also set the mtr version via a lookup pillar *stressng_source_url*; the stress-ng source archives are [available here](https://www.bitwizard.nl/mtr/files/).

* stressng.execute - Run mtr.

The output directory (*out_dir*) is specified in the pillar. The formula will create a subdirectory under the out_dir folder whose name will correspond to the job-file name. All the stress-ng results for that job file will be stored in this subdirectory. The job file will also be stored in this subdirectory under the filename job.stress.

Look at the _pillar.example_ file for more examples.