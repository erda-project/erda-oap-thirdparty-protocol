package oap_plugins_gen_go

import (
	_ "github.com/erda-project/oap-plugins-gen-go/jaeger-thrift/agent"
	_ "github.com/erda-project/oap-plugins-gen-go/jaeger-thrift/baggage"
	_ "github.com/erda-project/oap-plugins-gen-go/jaeger-thrift/jaeger"
	_ "github.com/erda-project/oap-plugins-gen-go/jaeger-thrift/sampling"
	_ "github.com/erda-project/oap-plugins-gen-go/jaeger-thrift/zipkincore"
)