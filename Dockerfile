# ================================
# Swift build image
# ================================
FROM swift:5.10-jammy as build
WORKDIR /build

COPY ./Package.* ./
RUN swift package resolve \
    $([ -f ./Package.resolved ] && echo "--force-resolved-versions" || true)

COPY . .

RUN swift build -c release -Xswiftc -static-executable

WORKDIR /staging

RUN cp "$(swift build --package-path /build -c release --show-bin-path)/App" ./
RUN cp "/usr/libexec/swift/linux/swift-backtrace-static" ./
RUN find -L "$(swift build --package-path /build -c release --show-bin-path)/" -regex '.*\.resources$' -exec cp -Ra {} ./ \;

RUN [ -d /build/Public ] && { mv /build/Public ./Public && chmod -R a-w ./Public; } || true
RUN [ -d /build/Resources ] && { mv /build/Resources ./Resources && chmod -R a-w ./Resources; } || true

# ================================
# Frontend build image
# ================================
FROM oven/bun as build-js
WORKDIR /build

RUN mkdir Public

COPY ./package.json ./bun.lockb ./
RUN NODE_ENV=production bun install

COPY ./Resources/Frontend ./Resources/Frontend
COPY ./vite.config.js ./tsconfig.json ./
RUN NODE_ENV=production bun run build

# ================================
# Run image
# ================================
FROM gcr.io/distroless/cc-debian10
WORKDIR /app

COPY --from=build --chown=vapor:vapor /staging /app
COPY --from=build-js --chown=vapor:vapor /build/Public/build /app/Public/build

ENV SWIFT_BACKTRACE=enable=yes,sanitize=yes,threads=all,images=all,interactive=no,swift-backtrace=./swift-backtrace-static

ENTRYPOINT ["./App"]
CMD ["serve", "--env", "production", "--hostname", "0.0.0.0", "--port", "8080"]

EXPOSE 8080
