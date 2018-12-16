ARG coq_image="coqorg/coq:dev"
FROM ${coq_image}

ENV MATHCOMP_VERSION="dev"
ENV MATHCOMP_PACKAGE="coq-mathcomp-character"

ARG compiler="base"
# other possible value: "edge"

# TODO: Replace "opam pin add (…) && opam install (…)" with
# "opam install -y -j ${NJOBS} ." (no need for --deps-only)

RUN ["/bin/bash", "--login", "-c", "set -x \
  && declare -A switch_table \
  && switch_table=( [\"base\"]=\"${COMPILER}\" [\"edge\"]=\"${COMPILER_EDGE}\" ) \
  && compiler=\"${switch_table[${compiler}]}\" \
  && [ -n \"$compiler\" ] \
  && opam switch set ${compiler} \
  && eval $(opam env) \
  && opam repository add --all-switches --set-default coq-extra-dev https://coq.inria.fr/opam/extra-dev \
  && opam repository add --all-switches --set-default coq-core-dev https://coq.inria.fr/opam/core-dev \
  && opam update -y -u \
  && opam pin add -n -k version ${MATHCOMP_PACKAGE} ${MATHCOMP_VERSION} \
  && opam install -y -j ${NJOBS} ${MATHCOMP_PACKAGE} \
  && opam clean -a -c -s --logs \
  && opam config list && opam repo list && opam list"]
