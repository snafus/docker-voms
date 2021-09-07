FROM centos:7.7.1908

# rpm –import http://repository.egi.eu/sw/production/umd/UMD-RPM-PGP-KEY

RUN rm -f /etc/yum.repos.d/UMD-* /etc/yum.repos.d/epel-* && \
  yum install -y epel-release && \
  yum install -y yum-priorities && \
  yum install -y http://repository.egi.eu/sw/production/umd/4/centos7/x86_64/updates/umd-release-4.1.3-1.el7.centos.noarch.rpm && \
  yum update -y && \
  curl -L http://repository.egi.eu/sw/production/cas/1/current/repo-files/EGI-trustanchors.repo | tee /etc/yum.repos.d/EGI-trustanchors.repo && \
  yum install -y ca-policy-egi-core fetch-crl && \	
  yum install -y voms-clients-java

#ENV VOMS_CLIENTS_JAVA_OPTIONS=-Xxm2m

RUN mkdir -p /voms/atlas && mkdir -p /etc/voms && mkdir -p /voms/dteam && \
echo -e "/DC=ch/DC=cern/OU=computers/CN=lcg-voms2.cern.ch\n/DC=ch/DC=cern/CN=CERN Grid Certification Authority" > /voms/atlas/lcg-voms2.cern.ch.lsc && \
  echo -e "/DC=ch/DC=cern/OU=computers/CN=voms2.cern.ch\n/DC=ch/DC=cern/CN=CERN Grid Certification Authority" > /voms/atlas/voms2.cern.ch.lsc && \
echo '"atlas" "lcg-voms2.cern.ch" "15001" "/DC=ch/DC=cern/OU=computers/CN=lcg-voms2.cern.ch" "atlas" "24"' > /etc/voms/atlas-lcg-voms2.cern.ch && \
echo '"atlas" "voms2.cern.ch" "15001" "/DC=ch/DC=cern/OU=computers/CN=voms2.cern.ch" "atlas" "24"' > /etc/voms/atlas-voms2.cern.ch && \
echo -e "/C=GR/O=HellasGrid/OU=hellasgrid.gr/CN=voms.hellasgrid.gr\n/C=GR/O=HellasGrid/OU=Certification Authorities/CN=HellasGrid CA 2016" > /voms/dteam/voms.hellasgrid.gr.lsc && \
echo -e "/C=GR/O=HellasGrid/OU=hellasgrid.gr/CN=voms2.hellasgrid.gr\n/C=GR/O=HellasGrid/OU=Certification Authorities/CN=HellasGrid CA 2016" > /voms/dteam/voms2.hellasgrid.gr.lsc &&\
echo '"dteam" "voms.hellasgrid.gr" "15004" "/C=GR/O=HellasGrid/OU=hellasgrid.gr/CN=voms.hellasgrid.gr" "dteam"' > /etc/voms/dteam-voms.hellasgrid.gr && \
echo '"dteam" "voms2.hellasgrid.gr" "15004" "/C=GR/O=HellasGrid/OU=hellasgrid.gr/CN=voms2.hellasgrid.gr" "dteam"' > /etc/voms/dteam-voms2.hellasgrid.gr 




ENV X509_VOMS_DIR=/voms

#CMD ['voms-proxy-init']
#CMD ['voms-proxy-init' ,'--cert=/.globus/usercert.pem', '--key=/.globus/userkey.pem' ,'--valid 196:00' ,'--out /x509_proxy' ,'--vomsdir /voms' ,'--vomses /etc/voms/']
#CMD voms-proxy-init --cert=/.globus/usercert.pem --key=/.globus/userkey.pem --valid 196:00 --out /voms/x509_proxy --vomsdir /voms --vomses /etc/voms/  --voms atlas
ENTRYPOINT ["voms-proxy-init", "--cert=/.globus/usercert.pem" ,"--key=/.globus/userkey.pem", "--valid=196:00" ,"--out=/voms/x509_proxy" ,"--vomsdir=/voms",  "--vomses=/etc/voms"]
CMD [" --voms atlas"]
