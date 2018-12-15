ARG coq_image="coqorg/coq:dev"
FROM ${coq_image}

# TODO: Replace "make && make install"
# with "opam install -y -j ${NJOBS} ." (no need for --deps-only)
WORKDIR /home/coq/mathcomp

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
  && sudo chown -R coq:coq /home/coq/mathcomp \
  && coq_makefile -f _CoqProject -o Makefile \
  && make \
  && make install"]
