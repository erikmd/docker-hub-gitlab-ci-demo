ARG coq_image="coqorg/coq:dev"
FROM ${coq_image}

WORKDIR /home/coq/ci

COPY _CoqProject .
COPY src src

ARG compiler="base"
RUN ["/bin/bash", "--login", "-c", "set -x \
  && declare -A switch_table \
  && switch_table=( [\"base\"]=\"${COMPILER}\" [\"edge\"]=\"${COMPILER_EDGE}\" ) \
  && compiler=\"${switch_table[${compiler}]}\" \
  && [ -n \"$compiler\" ] \
  && opam switch set ${compiler} \
  && eval $(opam env) \
  && opam update -y \
  && opam config list && opam repo list && opam list \
  && opam clean -a -c -s --logs \
  && sudo chown -R coq:coq /home/coq/ci \
  && coq_makefile -f _CoqProject -o Makefile \
  && make \
  && make install"]

# CI math-comp
# coq-community opam
