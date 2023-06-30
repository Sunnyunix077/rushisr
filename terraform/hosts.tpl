%{ for idx, hostname in hostnames ~}
${floating_ips[idx]} ${hostname}
%{ endfor ~}
