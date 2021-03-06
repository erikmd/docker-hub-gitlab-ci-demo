ARG coq_image="coqorg/coq:dev"
FROM ${coq_image}

WORKDIR /home/coq/mathcomp

# FIXME: Replace this will actual contents (cf. Git tree of math-comp)
COPY _CoqProject .
COPY src src

ARG compiler="base"
# other possible value: "edge"

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
