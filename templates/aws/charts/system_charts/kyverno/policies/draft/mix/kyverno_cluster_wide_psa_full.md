apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: add-psa-labels-full
  annotations:
    policies.kyverno.io/title: Add PSA Labels
    policies.kyverno.io/category: Pod Security Admission
    policies.kyverno.io/severity: medium
    kyverno.io/kyverno-version: 1.7.1
    policies.kyverno.io/minversion: 1.6.0
    kyverno.io/kubernetes-version: "1.24"
    policies.kyverno.io/subject: Namespace
    policies.kyverno.io/description: >-
      Pod Security Admission (PSA) can be controlled via the assignment of labels
      at the Namespace level which define the Pod Security Standard (PSS) profile
      in use and the action to take. If not using a cluster-wide configuration
      via an AdmissionConfiguration file, Namespaces must be explicitly labeled.
      This policy assigns the labels `pod-security.kubernetes.io/enforce=baseline`
      and `pod-security.kubernetes.io/warn=restricted` to all new Namespaces if
      those labels are not included.
spec:
  rules:
  - name: add-baseline-enforce-restricted-warn
    match:
      any:
      - resources:
          kinds:
          - Namespace
    mutate:
      patchStrategicMerge:
        metadata:
          labels:
            +(pod-security.kubernetes.io/enforce): baseline
            +(pod-security.kubernetes.io/warn): restricted
---
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: deny-privileged-profile
  annotations:
    policies.kyverno.io/title: Deny Privileged Profile
    policies.kyverno.io/category: Pod Security Admission
    policies.kyverno.io/severity: medium
    kyverno.io/kyverno-version: 1.7.1
    policies.kyverno.io/minversion: 1.6.0
    kyverno.io/kubernetes-version: "${cluster_version}"
    policies.kyverno.io/subject: Namespace
    policies.kyverno.io/description: >-
      When Pod Security Admission (PSA) is enforced at the cluster level
      via an AdmissionConfiguration file which defines a default level at
      baseline or restricted, setting of a label at the `privileged` profile
      will effectively cause unrestricted workloads in that Namespace, overriding
      the cluster default. This may effectively represent a circumvention attempt
      and should be closely controlled. This policy ensures that only those holding
      the cluster-admin ClusterRole may create Namespaces which assign the label
      `pod-security.kubernetes.io/enforce=privileged`.
spec:
  validationFailureAction: audit
  rules:
  - name: check-privileged
    match:
      any:
      - resources:
          kinds:
            - Namespace
          selector:
            matchLabels:
              pod-security.kubernetes.io/enforce: privileged
    exclude:
      any:
      - clusterRoles:
        - cluster-admin
    validate:
      message: Only cluster-admins may create Namespaces that allow setting the privileged level.
      deny: {}
