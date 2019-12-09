# RabbitMQ Cluster Setup

## Quickstart

### Setup Terraform
- Put gcloud client key named `credentials.json` in `terraform` directory
- Modify zone, region, project in `terraform/variables.tf` file

### Run Terraform
- `make plan`
- `make build`

### Installing
Connect to created cluster
- `gcloud beta container clusters get-credentials rabbitmq-cluster-demo --region us-east1 --project demo`

#### Install RabbitMQ using Helm
``` 
helm template chart/rabbitmq \
    --name rabbitmq-1 \
    --set rabbitmq.username=rabbit \
    --set rabbitmq.password=rabbit \
    | kubectl apply -f -
```

### Test cluster status
`kubectl exec -it rabbitmq-1-rabbitmq-0 -- rabbitmqctl cluster_status`

### Access admin dashboard
- Forward service port
 - `kubectl port-forward svc/rabbitmq-1-rabbitmq-svc 15672`

- Fetch the username
 - `kubectl get secret rabbitmq-1-rabbitmq-secret  --output=jsonpath='{.data.rabbitmq-user}' | base64 --decode`

- Fetch the password
 - `kubectl get secret rabbitmq-1-rabbitmq-secret  --output=jsonpath='{.data.rabbitmq-pass}' | base64 --decode`

### Cluster definition
Queues, exchanges and bindings are created during pod creation.
If you want to add additional look at the `values.yaml` file in `chart/rabbitmq` directory.

### Http API
- Publish to exchange: 
 - `curl -u <username>:<password> -H "content-type:application/json" \
    -X POST -d'{"payload":"Test","payload_encoding":"string","routing_key":""}' \
    http://localhost:15672/api/exchanges/%2f/<exchange>/publish`

### Test connection from another cluster
- `kubectl exec -it debug-b87555478-qw9zs -- /bin/bash -c "http -a $USER:$PASS http://$LOADBALANCER_IP:15672/api/vhosts"`
- It should say something like this: 
``` 
HTTP/1.1 200 OK
[
    {
        "cluster_state": {
            "rabbit@rabbitmq-1-rabbitmq-0.rabbitmq-1-rabbitmq-discovery.default.svc.cluster.local": "running", 
            "rabbit@rabbitmq-1-rabbitmq-1.rabbitmq-1-rabbitmq-discovery.default.svc.cluster.local": "running", 
            "rabbit@rabbitmq-1-rabbitmq-2.rabbitmq-1-rabbitmq-discovery.default.svc.cluster.local": "running"
        }, 
        "name": "/", 
        "tracing": false
    }
]
```

### Scaling
- `kubectl scale statefulsets rabbitmq-1-rabbitmq --replicas=5`

### Performance test a cluster
- `cd scripts/performance-test`
- First run prepopulate queues script:
  - Edit rabbitmq connection string: `amqp://rabbit:rabbit@10.142.0.90`
  - `kubectl apply -f prepopulate-job.yml`
- Then, with prepopulate job running run perf script:
  - Edit rabbitmq connection string: `amqp://rabbit:rabbit@10.142.0.90`
  - `kubectl apply -f perf-test-job.yml`
- Deleting a job will delete all queues and you will need to start again

## RabbitMQ clustering
- https://www.rabbitmq.com/cluster-formation.html
- https://www.rabbitmq.com/production-checklist.html
- https://www.rabbitmq.com/documentation.html

## Code examples
- https://github.com/GoogleCloudPlatform/click-to-deploy/tree/master/k8s/rabbitmq
- https://github.com/rabbitmq/rabbitmq-peer-discovery-k8s/tree/master/examples/k8s_statefulsets

