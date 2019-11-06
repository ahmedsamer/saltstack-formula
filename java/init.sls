{% from "java/map.jinja" import java with context %}

{% if java.provider == 'oracle' and java.oracle is defined %}
java_repository:
  pkgrepo.managed:
    - humanname: Java Apt Repository
    - name: "{{ java.oracle.repo }} {{ salt['grains.get']('oscodename') }} main"
    - file: {{ java.oracle.repo_list_file }}
    - keyserver: {{ java.oracle.repo_key_server }}
    - keyid: {{ java.oracle.repo_key_id }}

java_install:
  pkg.installed:
    - name: {{ java.oracle.pkg }}
    - require:
      - pkgrepo: java_repository
  debconf.set:
   - data:
       'shared/accepted-oracle-license-v1-1': {'type': 'boolean', 'value': True}
   - require_in:
       - pkg: java_install

install_libxtst6_for_jconsole:
  pkg.installed:
    - name: libxtst6

set_java8_as_default:
  pkg.installed:
    - name: oracle-java8-set-default
{% endif %}


{% if java.provider == 'openjdk' and java.openjdk is defined %}
java_repository:
  pkgrepo.managed:
    - humanname: Java Apt Repository
    - name: "{{ java.openjdk.repo }} {{ salt['grains.get']('oscodename') }} main"
    - file: {{ java.openjdk.repo_list_file }}
    - keyserver: {{ java.openjdk.repo_key_server }}
    - keyid: {{ java.openjdk.repo_key_id }}

java_install:
  pkg.installed:
    - name: openjdk-{{ java.openjdk.version }}-jdk-headless

install_libxtst6_for_jconsole:
  pkg.installed:
    - name: libxtst6
{% endif %}
