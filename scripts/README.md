## Quickstart

### Flush all queues
It flushes/purges all deadletter and regular queues specified in bindings.json
- `./flush-queues.sh rabbit rabbit localhost:15672 bindings.json`

### Flush single queue
- `curl -X DELETE -u ${user}:${password} http://${url}/api/queues/%2F/${queue}/contents`
