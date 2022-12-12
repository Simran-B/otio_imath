ARG OTIO_VERSION=v0.15

# (A): No system Imath, leading to a linker error - comment out below line
# (B): Use system Imath with OTIO_IMATH_LIBS - uncomment below line
# (C): Use system Imath with OTIO_IMATH_LIBS and IMATH_INCLUDES - uncomment below line
# (D): Use system Imath with OTIO_FIND_IMATH=ON - uncomment below line
#FROM aswf/ci-package-imath:2022 as ci-package-imath

FROM olivevideoeditor/ci-common:2 as ci-otio
ARG OTIO_VERSION
ENV OTIO_VERSION=${OTIO_VERSION} \
    OLIVE_INSTALL_PREFIX=/usr/local
COPY build_otio.sh DisableImathPythonRelease.patch FixTestsIncludeDir.patch \
     /tmp/

# (A): Comment out below 2 lines
# (B), (C), (D): Uncomment below 2 lines
#COPY --from=ci-package-imath /. /usr/local/
#RUN patch -u /usr/local/lib64/cmake/Imath/ImathTargets-release.cmake /tmp/DisableImathPythonRelease.patch

# HACK: The ASWF Imath is compiled with Python support that we ignore to avoid an error:
#  set_property could not find TARGET Imath::PyImath_Python3_9.

RUN /tmp/before_build.sh && \
    /tmp/build_otio.sh && \
    /tmp/copy_new_files.sh

FROM scratch as ci-package-otio
COPY --from=ci-otio /package/. /

FROM aswf/ci-package-openexr:2022 as ci-package-openexr
FROM aswf/ci-package-imath:2022 as ci-package-imath
FROM olivevideoeditor/ci-common:2 as build

COPY --from=ci-package-openexr /. /usr/local/
COPY --from=ci-package-imath /. /usr/local/
COPY --from=ci-package-otio /. /usr/local/

RUN patch -u /usr/local/lib64/cmake/Imath/ImathTargets-release.cmake /tmp/DisableImathPythonRelease.patch

# Use docker build ... --build-arg BUST_CACHE=<something-random> to force re-copying and rebuild
ARG BUST_CACHE
RUN echo "Busting cache..."
COPY main.cpp CMakeLists.txt FindOpenEXR.cmake /opt/olive

RUN mkdir build && cd build && \
    cmake .. -G Ninja && \
    cmake --build . && ./app
