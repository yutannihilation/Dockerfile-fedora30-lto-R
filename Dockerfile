FROM fedora:30

RUN dnf update -y
RUN dnf install -y 'dnf-command(download)' 'dnf-command(builddep)' rpmdevtools gcc make R-core
RUN dnf download -y --source R-core && dnf builddep -y R-core
RUN rpm -Uvh R-*.src.rpm
RUN sed -e '/^%global with_lto/s/0$/1/' -e '/^Release:/s/$/.lto/' /root/rpmbuild/SPECS/R.spec
RUN rpmbuild -ba /root/rpmbuild/SPECS/R.spec
RUN dnf reinstall /root/rpmbuild/SPMS/x86_64/R-core-*.rpm && \
  dnf install /root/rpmbuild/RPMS/x86_64/R-devel-*.rpm && \
  Rscript -e 'install.packages("stringr", repos = "https://cran.rstudio.com/")'
RUN curl -o /tmp/Nippon_0.7.1.tar.gz https://cran.r-project.org/src/contrib/Archive/Nippon/Nippon_0.7.1.tar.gz && \
  R CMD install /tmp/Nippon_0.7.1.tar.gz