import "@typespec/http";
import "@typespec/versioning";
import "./service/healthz.tsp";

using Http;
using Versioning;

@service(#{ title: "Core System API" })
@server("https://example.com", "Single server endpoint")
@versioned(Versions)
@route("/api")
namespace CoreSystem;

enum Versions {
  v1: "1.0.0",
}
