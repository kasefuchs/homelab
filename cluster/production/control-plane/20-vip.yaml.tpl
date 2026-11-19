apiVersion: v1alpha1
kind: Layer2VIPConfig
link: bond0
name: "{{ (urlParse .ClusterEndpoint).hostname }}"
