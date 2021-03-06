# ----- Get QEMU binaries -----
FROM debian:buster as QEMU
RUN apt-get update && apt-get install -qqy qemu-user-static

# ----- Base Image -----
FROM arm64v8/ubuntu:bionic

# Copy QEMU for arm64
COPY --from=QEMU /usr/bin/qemu-aarch64-static /usr/bin/qemu-aarch64-static

# ----- Parameters to tune for different versions
ARG BSPURL=https://developer.download.nvidia.com/embedded/L4T/r32_Release_v1.0/jetson-nano/BSP
ARG DRIVER_PACK=Jetson-Nano-Tegra210_Linux_R32.1.0_aarch64.tbz2

# ----- Install Basic Tools
RUN apt-get update && apt-get install -y --no-install-recommends \
  ca-certificates \
  curl \
  sudo \
  bzip2 \
  lbzip2 \
  && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# ----- Install NVIDIA driver pack
# Reference: https://github.com/idavis/JetsonContainers
RUN curl -sSL ${BSPURL}/${DRIVER_PACK} -o ${DRIVER_PACK} && \
  echo "14303c9a1dcc65b9d0d0b5ee8ea942f4d88e2304 *./${DRIVER_PACK}" | sha1sum -c --strict - && \
  tar -xpj --overwrite -f ./${DRIVER_PACK} && \
  sed -i '/.*tar -I lbzip2 -xpmf ${LDK_NV_TEGRA_DIR}\/config\.tbz2.*/c\tar -I lbzip2 -xpm --overwrite -f ${LDK_NV_TEGRA_DIR}\/config.tbz2' ./Linux_for_Tegra/apply_binaries.sh && \
  ./Linux_for_Tegra/apply_binaries.sh -r / && \
  rm -rf ./Linux_for_Tegra && \
  rm ./${DRIVER_PACK}

ENV LD_LIBRARY_PATH=/usr/lib/aarch64-linux-gnu/tegra:/usr/lib/aarch64-linux-gnu/tegra-egl:${LD_LIBRARY_PATH}

RUN ln -s /usr/lib/aarch64-linux-gnu/tegra/libnvidia-ptxjitcompiler.so.32.1.0 /usr/lib/aarch64-linux-gnu/tegra/libnvidia-ptxjitcompiler.so
RUN ln -s /usr/lib/aarch64-linux-gnu/tegra/libnvidia-ptxjitcompiler.so.32.1.0 /usr/lib/aarch64-linux-gnu/tegra/libnvidia-ptxjitcompiler.so.1
RUN ln -sf /usr/lib/aarch64-linux-gnu/tegra/libGL.so /usr/lib/aarch64-linux-gnu/libGL.so
RUN ln -s /usr/lib/aarch64-linux-gnu/libcuda.so /usr/lib/aarch64-linux-gnu/libcuda.so.1
RUN ln -sf /usr/lib/aarch64-linux-gnu/tegra-egl/libEGL.so /usr/lib/aarch64-linux-gnu/libEGL.so
