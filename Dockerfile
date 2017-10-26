# Includes Java 8, Ivy, Python/PyPandoc (2.7.12/3.5.2), R-base/R-base-dev (3.3.2+), Ruby2.3 build utilities

FROM ubuntu:16.04

# Notes:
# Trusty Tahr does not have JDK 8 support https://bugs.launchpad.net/trusty-backports/+bug/1368094
#
# The followings are organized in sections:
# First, Java / js
# Second, Python, using package for pip, then use pip for other packages (needs to be consistent)
#  (Pandoc is for R, Pygments is for Ruby; make & gcc are needed for Python and R)
# Third, R (this also depends on pandoc*, libssl)
# Forth, Ruby for doc build (this also depends on nodejs, Python)

RUN echo 'deb http://cran.cnr.Berkeley.edu/bin/linux/ubuntu xenial/' >> /etc/apt/sources.list && \
    gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9 && \
    gpg -a --export E084DAB9 | apt-key add - && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean && \
    apt-get update && \
    apt-get install --no-install-recommends -y curl wget && \
    apt-get install --no-install-recommends -y libssl-dev openjdk-8-jdk && \
    curl -sL https://deb.nodesource.com/setup_4.x | bash && \
    apt-get install --no-install-recommends -y git maven ivy nodejs && \
    update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java && \
    ln -s -T /usr/share/java/ivy.jar /usr/share/ant/lib/ivy.jar

RUN apt-get install --no-install-recommends -y make gcc libffi-dev libpython2.7-dev libpython3-dev python-pip pandoc pandoc-citeproc && \
    pip install virtualenv && \
    pip install setuptools && \
    pip install wheel && \
    pip install pyopenssl pypandoc numpy && \
    pip install pygments sphinx && \
    cd && \
    virtualenv -p python3 p35 && \
    . p35/bin/activate && \
    pip install setuptools && \
    pip install wheel && \
    pip install pyopenssl pypandoc numpy && \
    pip install pygments sphinx

RUN apt-get install --no-install-recommends -y libcurl4-openssl-dev libxml2-dev r-base r-base-dev && \
    apt-get install --no-install-recommends -y texlive-latex-base texlive texlive-fonts-extra texinfo qpdf && \
    Rscript -e "install.packages(c('curl', 'xml2', 'httr', 'devtools', 'testthat', 'knitr', 'rmarkdown', 'roxygen2', 'e1071', 'survival'), repos='http://cran.us.r-project.org/')" && \
    Rscript -e "devtools::install_github('jimhester/lintr')"

RUN apt-get install --no-install-recommends -y software-properties-common && \
    apt-add-repository -y ppa:brightbox/ruby-ng && \
    apt-get update && \
    apt-get install --no-install-recommends -y ruby2.3 ruby2.3-dev && \
    gem install jekyll --no-rdoc --no-ri && \
    gem install jekyll-redirect-from && \
    gem install pygments.rb && \
    echo '*DONE*'
