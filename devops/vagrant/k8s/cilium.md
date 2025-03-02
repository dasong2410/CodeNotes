

https://docs.cilium.io/en/stable/network/kubernetes/kubeproxy-free/
https://docs.cilium.io/en/stable/network/servicemesh/ingress/

```bash
API_SERVER_IP=192.168.56.7
API_SERVER_PORT=6443
helm upgrade cilium cilium/cilium --version 1.16.5 \
    --namespace kube-system \
    --set kubeProxyReplacement=true \
    --set k8sServiceHost=${API_SERVER_IP} \
    --set k8sServicePort=${API_SERVER_PORT} \
    --set socketLB.hostNamespaceOnly=true \
    --set ingressController.enabled=true \
    --set ingressController.loadbalancerMode=dedicated \
    --reuse-values

 helm upgrade cilium cilium/cilium --version 1.16.5 \
    --namespace kube-system \
    --reuse-values \
    --set ingressController.enabled=true \
    --set ingressController.loadbalancerMode=dedicated

kubectl -n kube-system rollout restart deployment/cilium-operator
kubectl -n kube-system rollout restart ds/cilium
```
