# Docker voms
Run a voms command in docker as an easy way to get a proxy

## To Run in the Docker
voms-proxy-init --cert=/.globus/usercert.pem --key=/.globus/userkey.pem --valid 196:00 --out /x509_proxy --vomsdir /voms --vomses /etc/voms/  --voms atlas

## Entrypoint
docker run --rm  -it -v ${HOME}/.globus/userkey.pem:/.globus/userkey.pem:ro -v ${HOME}/.globus/usercert.pem:/.globus/usercert.pem:ro -v ${HOME}/.voms:/.voms   blandard/jwvoms:1.0



