# ================================
# Swift build image
# ================================
FROM --platform=amd64 swift:5.10-jammy as build
WORKDIR /build

COPY ./Package.* ./
RUN swift package resolve \
	$([ -f ./Package.resolved ] && echo "--force-resolved-versions" || true)

COPY . .

RUN swift build -c release -Xswiftc -g -Xswiftc -static-executable

WORKDIR /staging

RUN cp "$(swift build --package-path /build -c release --show-bin-path)/App" ./
RUN cp "/usr/libexec/swift/linux/swift-backtrace-static" ./
RUN find -L "$(swift build --package-path /build -c release --show-bin-path)/" -regex '.*\.resources$' -exec cp -Ra {} ./ \;

RUN [ -d /build/public ] && { mv /build/public ./public && chmod -R a-w ./public; } || true
RUN [ -d /build/resources ] && { mv /build/resources ./resources && chmod -R a-w ./resources; } || true

# ================================
# Frontend build image
# ================================
FROM oven/bun as build-js
WORKDIR /build

RUN mkdir Public

COPY ./package.json ./bun.lockb ./
RUN NODE_ENV=production bun install

COPY ./resources ./resources
COPY ./vite.config.js ./tsconfig.json ./tailwind.config.js ./postcss.config.js ./
RUN NODE_ENV=production bun run build

# ================================
# Run image
# ================================
FROM --platform=amd64 gcr.io/distroless/cc-debian10
WORKDIR /app

COPY --from=build-js --chown=vapor:vapor /build/public/build /app/public/build
COPY --from=build --chown=vapor:vapor /staging /app

ENV SWIFT_BACKTRACE=enable=yes,sanitize=yes,threads=all,images=all,interactive=no,demangle=yes,swift-backtrace=./swift-backtrace-static

ENTRYPOINT ["./App"]
CMD ["serve", "--env", "production", "--hostname", "0.0.0.0", "--port", "8080"]

EXPOSE 8080
