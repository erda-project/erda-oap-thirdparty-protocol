JAEGER_THRIFT_VER=0.14
JAEGER_THRIFT_IMG=jaegertracing/thrift:$(JAEGER_THRIFT_VER)
JAEGER_THRIFT=docker run --rm -u $(shell id -u) -v "${PWD}/:/data" $(JAEGER_THRIFT_IMG) thrift
JAEGER_THRIFT_GO_ARGS=thrift_import="github.com/apache/thrift/lib/go/thrift"
JAEGER_THRIFT_GEN_DIR=jaeger-thrift
JAEGER_IMPORT_PATH=github.com/erda-project/oap-plugins-gen-go

.PHONY: init-submodule

build-all: jaeger-thrift

init-submodule:
	git submodule update --init --recursive

jaeger-thrift: init-submodule jaeger-thrift-image
	[ -d $(JAEGER_THRIFT_GEN_DIR) ] || mkdir $(JAEGER_THRIFT_GEN_DIR)
	$(JAEGER_THRIFT) -o /data --gen go:$(JAEGER_THRIFT_GO_ARGS) --out /data/$(JAEGER_THRIFT_GEN_DIR) /data/.protocols/jaeger-idl/thrift/agent.thrift
#	TODO sed is GNU and BSD compatible
	sed -i.bak 's|"zipkincore"|"$(JAEGER_IMPORT_PATH)/jaeger-thrift/zipkincore"|g' $(JAEGER_THRIFT_GEN_DIR)/agent/*.go
	sed -i.bak 's|"jaeger"|"$(JAEGER_IMPORT_PATH)/jaeger-thrift/jaeger"|g' $(JAEGER_THRIFT_GEN_DIR)/agent/*.go
	$(JAEGER_THRIFT) -o /data --gen go:$(JAEGER_THRIFT_GO_ARGS) --out /data/$(JAEGER_THRIFT_GEN_DIR) /data/.protocols/jaeger-idl/thrift/jaeger.thrift
	$(JAEGER_THRIFT) -o /data --gen go:$(JAEGER_THRIFT_GO_ARGS) --out /data/$(JAEGER_THRIFT_GEN_DIR) /data/.protocols/jaeger-idl/thrift/sampling.thrift
	$(JAEGER_THRIFT) -o /data --gen go:$(JAEGER_THRIFT_GO_ARGS) --out /data/$(JAEGER_THRIFT_GEN_DIR) /data/.protocols/jaeger-idl/thrift/baggage.thrift
	$(JAEGER_THRIFT) -o /data --gen go:$(JAEGER_THRIFT_GO_ARGS) --out /data/$(JAEGER_THRIFT_GEN_DIR) /data/.protocols/jaeger-idl/thrift/zipkincore.thrift
	rm -rf $(JAEGER_THRIFT_GEN_DIR)/*/*-remote $(JAEGER_THRIFT_GEN_DIR)/*/*.bak

jaeger-thrift-image:
	$(JAEGER_THRIFT) -version