// Code generated by cue get go. DO NOT EDIT.

//cue:generate cue get go k8s.io/api/policy/v1beta1

package v1beta1

import (
	"k8s.io/apimachinery/pkg/util/intstr"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/api/core/v1"
)

// PodDisruptionBudgetSpec is a description of a PodDisruptionBudget.
#PodDisruptionBudgetSpec: {
	// An eviction is allowed if at least "minAvailable" pods selected by
	// "selector" will still be available after the eviction, i.e. even in the
	// absence of the evicted pod.  So for example you can prevent all voluntary
	// evictions by specifying "100%".
	// +optional
	minAvailable?: null | intstr.#IntOrString @go(MinAvailable,*intstr.IntOrString) @protobuf(1,bytes,opt)

	// Label query over pods whose evictions are managed by the disruption
	// budget.
	// A null selector selects no pods.
	// An empty selector ({}) also selects no pods, which differs from standard behavior of selecting all pods.
	// In policy/v1, an empty selector will select all pods in the namespace.
	// +optional
	selector?: null | metav1.#LabelSelector @go(Selector,*metav1.LabelSelector) @protobuf(2,bytes,opt)

	// An eviction is allowed if at most "maxUnavailable" pods selected by
	// "selector" are unavailable after the eviction, i.e. even in absence of
	// the evicted pod. For example, one can prevent all voluntary evictions
	// by specifying 0. This is a mutually exclusive setting with "minAvailable".
	// +optional
	maxUnavailable?: null | intstr.#IntOrString @go(MaxUnavailable,*intstr.IntOrString) @protobuf(3,bytes,opt)

	// UnhealthyPodEvictionPolicy defines the criteria for when unhealthy pods
	// should be considered for eviction. Current implementation considers healthy pods,
	// as pods that have status.conditions item with type="Ready",status="True".
	//
	// Valid policies are IfHealthyBudget and AlwaysAllow.
	// If no policy is specified, the default behavior will be used,
	// which corresponds to the IfHealthyBudget policy.
	//
	// IfHealthyBudget policy means that running pods (status.phase="Running"),
	// but not yet healthy can be evicted only if the guarded application is not
	// disrupted (status.currentHealthy is at least equal to status.desiredHealthy).
	// Healthy pods will be subject to the PDB for eviction.
	//
	// AlwaysAllow policy means that all running pods (status.phase="Running"),
	// but not yet healthy are considered disrupted and can be evicted regardless
	// of whether the criteria in a PDB is met. This means perspective running
	// pods of a disrupted application might not get a chance to become healthy.
	// Healthy pods will be subject to the PDB for eviction.
	//
	// Additional policies may be added in the future.
	// Clients making eviction decisions should disallow eviction of unhealthy pods
	// if they encounter an unrecognized policy in this field.
	//
	// This field is beta-level. The eviction API uses this field when
	// the feature gate PDBUnhealthyPodEvictionPolicy is enabled (enabled by default).
	// +optional
	unhealthyPodEvictionPolicy?: null | #UnhealthyPodEvictionPolicyType @go(UnhealthyPodEvictionPolicy,*UnhealthyPodEvictionPolicyType) @protobuf(4,bytes,opt)
}

// UnhealthyPodEvictionPolicyType defines the criteria for when unhealthy pods
// should be considered for eviction.
// +enum
#UnhealthyPodEvictionPolicyType: string // #enumUnhealthyPodEvictionPolicyType

#enumUnhealthyPodEvictionPolicyType:
	#IfHealthyBudget |
	#AlwaysAllow

// IfHealthyBudget policy means that running pods (status.phase="Running"),
// but not yet healthy can be evicted only if the guarded application is not
// disrupted (status.currentHealthy is at least equal to status.desiredHealthy).
// Healthy pods will be subject to the PDB for eviction.
#IfHealthyBudget: #UnhealthyPodEvictionPolicyType & "IfHealthyBudget"

// AlwaysAllow policy means that all running pods (status.phase="Running"),
// but not yet healthy are considered disrupted and can be evicted regardless
// of whether the criteria in a PDB is met. This means perspective running
// pods of a disrupted application might not get a chance to become healthy.
// Healthy pods will be subject to the PDB for eviction.
#AlwaysAllow: #UnhealthyPodEvictionPolicyType & "AlwaysAllow"

// PodDisruptionBudgetStatus represents information about the status of a
// PodDisruptionBudget. Status may trail the actual state of a system.
#PodDisruptionBudgetStatus: {
	// Most recent generation observed when updating this PDB status. DisruptionsAllowed and other
	// status information is valid only if observedGeneration equals to PDB's object generation.
	// +optional
	observedGeneration?: int64 @go(ObservedGeneration) @protobuf(1,varint,opt)

	// DisruptedPods contains information about pods whose eviction was
	// processed by the API server eviction subresource handler but has not
	// yet been observed by the PodDisruptionBudget controller.
	// A pod will be in this map from the time when the API server processed the
	// eviction request to the time when the pod is seen by PDB controller
	// as having been marked for deletion (or after a timeout). The key in the map is the name of the pod
	// and the value is the time when the API server processed the eviction request. If
	// the deletion didn't occur and a pod is still there it will be removed from
	// the list automatically by PodDisruptionBudget controller after some time.
	// If everything goes smooth this map should be empty for the most of the time.
	// Large number of entries in the map may indicate problems with pod deletions.
	// +optional
	disruptedPods?: {[string]: metav1.#Time} @go(DisruptedPods,map[string]metav1.Time) @protobuf(2,bytes,rep)

	// Number of pod disruptions that are currently allowed.
	disruptionsAllowed: int32 @go(DisruptionsAllowed) @protobuf(3,varint,opt)

	// current number of healthy pods
	currentHealthy: int32 @go(CurrentHealthy) @protobuf(4,varint,opt)

	// minimum desired number of healthy pods
	desiredHealthy: int32 @go(DesiredHealthy) @protobuf(5,varint,opt)

	// total number of pods counted by this disruption budget
	expectedPods: int32 @go(ExpectedPods) @protobuf(6,varint,opt)

	// Conditions contain conditions for PDB. The disruption controller sets the
	// DisruptionAllowed condition. The following are known values for the reason field
	// (additional reasons could be added in the future):
	// - SyncFailed: The controller encountered an error and wasn't able to compute
	//               the number of allowed disruptions. Therefore no disruptions are
	//               allowed and the status of the condition will be False.
	// - InsufficientPods: The number of pods are either at or below the number
	//                     required by the PodDisruptionBudget. No disruptions are
	//                     allowed and the status of the condition will be False.
	// - SufficientPods: There are more pods than required by the PodDisruptionBudget.
	//                   The condition will be True, and the number of allowed
	//                   disruptions are provided by the disruptionsAllowed property.
	//
	// +optional
	// +patchMergeKey=type
	// +patchStrategy=merge
	// +listType=map
	// +listMapKey=type
	conditions?: [...metav1.#Condition] @go(Conditions,[]metav1.Condition) @protobuf(7,bytes,rep)
}

// DisruptionAllowedCondition is a condition set by the disruption controller
// that signal whether any of the pods covered by the PDB can be disrupted.
#DisruptionAllowedCondition: "DisruptionAllowed"

// SyncFailedReason is set on the DisruptionAllowed condition if reconcile
// of the PDB failed and therefore disruption of pods are not allowed.
#SyncFailedReason: "SyncFailed"

// SufficientPodsReason is set on the DisruptionAllowed condition if there are
// more pods covered by the PDB than required and at least one can be disrupted.
#SufficientPodsReason: "SufficientPods"

// InsufficientPodsReason is set on the DisruptionAllowed condition if the number
// of pods are equal to or fewer than required by the PDB.
#InsufficientPodsReason: "InsufficientPods"

// PodDisruptionBudget is an object to define the max disruption that can be caused to a collection of pods
#PodDisruptionBudget: {
	metav1.#TypeMeta

	// Standard object's metadata.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata
	// +optional
	metadata?: metav1.#ObjectMeta @go(ObjectMeta) @protobuf(1,bytes,opt)

	// Specification of the desired behavior of the PodDisruptionBudget.
	// +optional
	spec?: #PodDisruptionBudgetSpec @go(Spec) @protobuf(2,bytes,opt)

	// Most recently observed status of the PodDisruptionBudget.
	// +optional
	status?: #PodDisruptionBudgetStatus @go(Status) @protobuf(3,bytes,opt)
}

// PodDisruptionBudgetList is a collection of PodDisruptionBudgets.
#PodDisruptionBudgetList: {
	metav1.#TypeMeta

	// Standard object's metadata.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata
	// +optional
	metadata?: metav1.#ListMeta @go(ListMeta) @protobuf(1,bytes,opt)

	// items list individual PodDisruptionBudget objects
	items: [...#PodDisruptionBudget] @go(Items,[]PodDisruptionBudget) @protobuf(2,bytes,rep)
}

// Eviction evicts a pod from its node subject to certain policies and safety constraints.
// This is a subresource of Pod.  A request to cause such an eviction is
// created by POSTing to .../pods/<pod name>/evictions.
#Eviction: {
	metav1.#TypeMeta

	// ObjectMeta describes the pod that is being evicted.
	// +optional
	metadata?: metav1.#ObjectMeta @go(ObjectMeta) @protobuf(1,bytes,opt)

	// DeleteOptions may be provided
	// +optional
	deleteOptions?: null | metav1.#DeleteOptions @go(DeleteOptions,*metav1.DeleteOptions) @protobuf(2,bytes,opt)
}

// PodSecurityPolicy governs the ability to make requests that affect the Security Context
// that will be applied to a pod and container.
// Deprecated in 1.21.
#PodSecurityPolicy: {
	metav1.#TypeMeta

	// Standard object's metadata.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata
	// +optional
	metadata?: metav1.#ObjectMeta @go(ObjectMeta) @protobuf(1,bytes,opt)

	// spec defines the policy enforced.
	// +optional
	spec?: #PodSecurityPolicySpec @go(Spec) @protobuf(2,bytes,opt)
}

// PodSecurityPolicySpec defines the policy enforced.
#PodSecurityPolicySpec: {
	// privileged determines if a pod can request to be run as privileged.
	// +optional
	privileged?: bool @go(Privileged) @protobuf(1,varint,opt)

	// defaultAddCapabilities is the default set of capabilities that will be added to the container
	// unless the pod spec specifically drops the capability.  You may not list a capability in both
	// defaultAddCapabilities and requiredDropCapabilities. Capabilities added here are implicitly
	// allowed, and need not be included in the allowedCapabilities list.
	// +optional
	defaultAddCapabilities?: [...v1.#Capability] @go(DefaultAddCapabilities,[]v1.Capability) @protobuf(2,bytes,rep,casttype=k8s.io/api/core/v1.Capability)

	// requiredDropCapabilities are the capabilities that will be dropped from the container.  These
	// are required to be dropped and cannot be added.
	// +optional
	requiredDropCapabilities?: [...v1.#Capability] @go(RequiredDropCapabilities,[]v1.Capability) @protobuf(3,bytes,rep,casttype=k8s.io/api/core/v1.Capability)

	// allowedCapabilities is a list of capabilities that can be requested to add to the container.
	// Capabilities in this field may be added at the pod author's discretion.
	// You must not list a capability in both allowedCapabilities and requiredDropCapabilities.
	// +optional
	allowedCapabilities?: [...v1.#Capability] @go(AllowedCapabilities,[]v1.Capability) @protobuf(4,bytes,rep,casttype=k8s.io/api/core/v1.Capability)

	// volumes is an allowlist of volume plugins. Empty indicates that
	// no volumes may be used. To allow all volumes you may use '*'.
	// +optional
	volumes?: [...#FSType] @go(Volumes,[]FSType) @protobuf(5,bytes,rep,casttype=FSType)

	// hostNetwork determines if the policy allows the use of HostNetwork in the pod spec.
	// +optional
	hostNetwork?: bool @go(HostNetwork) @protobuf(6,varint,opt)

	// hostPorts determines which host port ranges are allowed to be exposed.
	// +optional
	hostPorts?: [...#HostPortRange] @go(HostPorts,[]HostPortRange) @protobuf(7,bytes,rep)

	// hostPID determines if the policy allows the use of HostPID in the pod spec.
	// +optional
	hostPID?: bool @go(HostPID) @protobuf(8,varint,opt)

	// hostIPC determines if the policy allows the use of HostIPC in the pod spec.
	// +optional
	hostIPC?: bool @go(HostIPC) @protobuf(9,varint,opt)

	// seLinux is the strategy that will dictate the allowable labels that may be set.
	seLinux: #SELinuxStrategyOptions @go(SELinux) @protobuf(10,bytes,opt)

	// runAsUser is the strategy that will dictate the allowable RunAsUser values that may be set.
	runAsUser: #RunAsUserStrategyOptions @go(RunAsUser) @protobuf(11,bytes,opt)

	// RunAsGroup is the strategy that will dictate the allowable RunAsGroup values that may be set.
	// If this field is omitted, the pod's RunAsGroup can take any value. This field requires the
	// RunAsGroup feature gate to be enabled.
	// +optional
	runAsGroup?: null | #RunAsGroupStrategyOptions @go(RunAsGroup,*RunAsGroupStrategyOptions) @protobuf(22,bytes,opt)

	// supplementalGroups is the strategy that will dictate what supplemental groups are used by the SecurityContext.
	supplementalGroups: #SupplementalGroupsStrategyOptions @go(SupplementalGroups) @protobuf(12,bytes,opt)

	// fsGroup is the strategy that will dictate what fs group is used by the SecurityContext.
	fsGroup: #FSGroupStrategyOptions @go(FSGroup) @protobuf(13,bytes,opt)

	// readOnlyRootFilesystem when set to true will force containers to run with a read only root file
	// system.  If the container specifically requests to run with a non-read only root file system
	// the PSP should deny the pod.
	// If set to false the container may run with a read only root file system if it wishes but it
	// will not be forced to.
	// +optional
	readOnlyRootFilesystem?: bool @go(ReadOnlyRootFilesystem) @protobuf(14,varint,opt)

	// defaultAllowPrivilegeEscalation controls the default setting for whether a
	// process can gain more privileges than its parent process.
	// +optional
	defaultAllowPrivilegeEscalation?: null | bool @go(DefaultAllowPrivilegeEscalation,*bool) @protobuf(15,varint,opt)

	// allowPrivilegeEscalation determines if a pod can request to allow
	// privilege escalation. If unspecified, defaults to true.
	// +optional
	allowPrivilegeEscalation?: null | bool @go(AllowPrivilegeEscalation,*bool) @protobuf(16,varint,opt)

	// allowedHostPaths is an allowlist of host paths. Empty indicates
	// that all host paths may be used.
	// +optional
	allowedHostPaths?: [...#AllowedHostPath] @go(AllowedHostPaths,[]AllowedHostPath) @protobuf(17,bytes,rep)

	// allowedFlexVolumes is an allowlist of Flexvolumes.  Empty or nil indicates that all
	// Flexvolumes may be used.  This parameter is effective only when the usage of the Flexvolumes
	// is allowed in the "volumes" field.
	// +optional
	allowedFlexVolumes?: [...#AllowedFlexVolume] @go(AllowedFlexVolumes,[]AllowedFlexVolume) @protobuf(18,bytes,rep)

	// AllowedCSIDrivers is an allowlist of inline CSI drivers that must be explicitly set to be embedded within a pod spec.
	// An empty value indicates that any CSI driver can be used for inline ephemeral volumes.
	// +optional
	allowedCSIDrivers?: [...#AllowedCSIDriver] @go(AllowedCSIDrivers,[]AllowedCSIDriver) @protobuf(23,bytes,rep)

	// allowedUnsafeSysctls is a list of explicitly allowed unsafe sysctls, defaults to none.
	// Each entry is either a plain sysctl name or ends in "*" in which case it is considered
	// as a prefix of allowed sysctls. Single * means all unsafe sysctls are allowed.
	// Kubelet has to allowlist all allowed unsafe sysctls explicitly to avoid rejection.
	//
	// Examples:
	// e.g. "foo/*" allows "foo/bar", "foo/baz", etc.
	// e.g. "foo.*" allows "foo.bar", "foo.baz", etc.
	// +optional
	allowedUnsafeSysctls?: [...string] @go(AllowedUnsafeSysctls,[]string) @protobuf(19,bytes,rep)

	// forbiddenSysctls is a list of explicitly forbidden sysctls, defaults to none.
	// Each entry is either a plain sysctl name or ends in "*" in which case it is considered
	// as a prefix of forbidden sysctls. Single * means all sysctls are forbidden.
	//
	// Examples:
	// e.g. "foo/*" forbids "foo/bar", "foo/baz", etc.
	// e.g. "foo.*" forbids "foo.bar", "foo.baz", etc.
	// +optional
	forbiddenSysctls?: [...string] @go(ForbiddenSysctls,[]string) @protobuf(20,bytes,rep)

	// AllowedProcMountTypes is an allowlist of allowed ProcMountTypes.
	// Empty or nil indicates that only the DefaultProcMountType may be used.
	// This requires the ProcMountType feature flag to be enabled.
	// +optional
	allowedProcMountTypes?: [...v1.#ProcMountType] @go(AllowedProcMountTypes,[]v1.ProcMountType) @protobuf(21,bytes,opt)

	// runtimeClass is the strategy that will dictate the allowable RuntimeClasses for a pod.
	// If this field is omitted, the pod's runtimeClassName field is unrestricted.
	// Enforcement of this field depends on the RuntimeClass feature gate being enabled.
	// +optional
	runtimeClass?: null | #RuntimeClassStrategyOptions @go(RuntimeClass,*RuntimeClassStrategyOptions) @protobuf(24,bytes,opt)
}

// AllowedHostPath defines the host volume conditions that will be enabled by a policy
// for pods to use. It requires the path prefix to be defined.
#AllowedHostPath: {
	// pathPrefix is the path prefix that the host volume must match.
	// It does not support `*`.
	// Trailing slashes are trimmed when validating the path prefix with a host path.
	//
	// Examples:
	// `/foo` would allow `/foo`, `/foo/` and `/foo/bar`
	// `/foo` would not allow `/food` or `/etc/foo`
	pathPrefix?: string @go(PathPrefix) @protobuf(1,bytes,rep)

	// when set to true, will allow host volumes matching the pathPrefix only if all volume mounts are readOnly.
	// +optional
	readOnly?: bool @go(ReadOnly) @protobuf(2,varint,opt)
}

// FSType gives strong typing to different file systems that are used by volumes.
#FSType: string // #enumFSType

#enumFSType:
	#AzureFile |
	#Flocker |
	#FlexVolume |
	#HostPath |
	#EmptyDir |
	#GCEPersistentDisk |
	#AWSElasticBlockStore |
	#GitRepo |
	#Secret |
	#NFS |
	#ISCSI |
	#Glusterfs |
	#PersistentVolumeClaim |
	#RBD |
	#Cinder |
	#CephFS |
	#DownwardAPI |
	#FC |
	#ConfigMap |
	#VsphereVolume |
	#Quobyte |
	#AzureDisk |
	#PhotonPersistentDisk |
	#StorageOS |
	#Projected |
	#PortworxVolume |
	#ScaleIO |
	#CSI |
	#Ephemeral |
	#All

#AzureFile:             #FSType & "azureFile"
#Flocker:               #FSType & "flocker"
#FlexVolume:            #FSType & "flexVolume"
#HostPath:              #FSType & "hostPath"
#EmptyDir:              #FSType & "emptyDir"
#GCEPersistentDisk:     #FSType & "gcePersistentDisk"
#AWSElasticBlockStore:  #FSType & "awsElasticBlockStore"
#GitRepo:               #FSType & "gitRepo"
#Secret:                #FSType & "secret"
#NFS:                   #FSType & "nfs"
#ISCSI:                 #FSType & "iscsi"
#Glusterfs:             #FSType & "glusterfs"
#PersistentVolumeClaim: #FSType & "persistentVolumeClaim"
#RBD:                   #FSType & "rbd"
#Cinder:                #FSType & "cinder"
#CephFS:                #FSType & "cephFS"
#DownwardAPI:           #FSType & "downwardAPI"
#FC:                    #FSType & "fc"
#ConfigMap:             #FSType & "configMap"
#VsphereVolume:         #FSType & "vsphereVolume"
#Quobyte:               #FSType & "quobyte"
#AzureDisk:             #FSType & "azureDisk"
#PhotonPersistentDisk:  #FSType & "photonPersistentDisk"
#StorageOS:             #FSType & "storageos"
#Projected:             #FSType & "projected"
#PortworxVolume:        #FSType & "portworxVolume"
#ScaleIO:               #FSType & "scaleIO"
#CSI:                   #FSType & "csi"
#Ephemeral:             #FSType & "ephemeral"
#All:                   #FSType & "*"

// AllowedFlexVolume represents a single Flexvolume that is allowed to be used.
#AllowedFlexVolume: {
	// driver is the name of the Flexvolume driver.
	driver: string @go(Driver) @protobuf(1,bytes,opt)
}

// AllowedCSIDriver represents a single inline CSI Driver that is allowed to be used.
#AllowedCSIDriver: {
	// Name is the registered name of the CSI driver
	name: string @go(Name) @protobuf(1,bytes,opt)
}

// HostPortRange defines a range of host ports that will be enabled by a policy
// for pods to use.  It requires both the start and end to be defined.
#HostPortRange: {
	// min is the start of the range, inclusive.
	min: int32 @go(Min) @protobuf(1,varint,opt)

	// max is the end of the range, inclusive.
	max: int32 @go(Max) @protobuf(2,varint,opt)
}

// SELinuxStrategyOptions defines the strategy type and any options used to create the strategy.
#SELinuxStrategyOptions: {
	// rule is the strategy that will dictate the allowable labels that may be set.
	rule: #SELinuxStrategy @go(Rule) @protobuf(1,bytes,opt,casttype=SELinuxStrategy)

	// seLinuxOptions required to run as; required for MustRunAs
	// More info: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/
	// +optional
	seLinuxOptions?: null | v1.#SELinuxOptions @go(SELinuxOptions,*v1.SELinuxOptions) @protobuf(2,bytes,opt)
}

// SELinuxStrategy denotes strategy types for generating SELinux options for a
// Security Context.
#SELinuxStrategy: string // #enumSELinuxStrategy

#enumSELinuxStrategy:
	#SELinuxStrategyMustRunAs |
	#SELinuxStrategyRunAsAny

// SELinuxStrategyMustRunAs means that container must have SELinux labels of X applied.
#SELinuxStrategyMustRunAs: #SELinuxStrategy & "MustRunAs"

// SELinuxStrategyRunAsAny means that container may make requests for any SELinux context labels.
#SELinuxStrategyRunAsAny: #SELinuxStrategy & "RunAsAny"

// RunAsUserStrategyOptions defines the strategy type and any options used to create the strategy.
#RunAsUserStrategyOptions: {
	// rule is the strategy that will dictate the allowable RunAsUser values that may be set.
	rule: #RunAsUserStrategy @go(Rule) @protobuf(1,bytes,opt,casttype=RunAsUserStrategy)

	// ranges are the allowed ranges of uids that may be used. If you would like to force a single uid
	// then supply a single range with the same start and end. Required for MustRunAs.
	// +optional
	ranges?: [...#IDRange] @go(Ranges,[]IDRange) @protobuf(2,bytes,rep)
}

// RunAsGroupStrategyOptions defines the strategy type and any options used to create the strategy.
#RunAsGroupStrategyOptions: {
	// rule is the strategy that will dictate the allowable RunAsGroup values that may be set.
	rule: #RunAsGroupStrategy @go(Rule) @protobuf(1,bytes,opt,casttype=RunAsGroupStrategy)

	// ranges are the allowed ranges of gids that may be used. If you would like to force a single gid
	// then supply a single range with the same start and end. Required for MustRunAs.
	// +optional
	ranges?: [...#IDRange] @go(Ranges,[]IDRange) @protobuf(2,bytes,rep)
}

// IDRange provides a min/max of an allowed range of IDs.
#IDRange: {
	// min is the start of the range, inclusive.
	min: int64 @go(Min) @protobuf(1,varint,opt)

	// max is the end of the range, inclusive.
	max: int64 @go(Max) @protobuf(2,varint,opt)
}

// RunAsUserStrategy denotes strategy types for generating RunAsUser values for a
// Security Context.
#RunAsUserStrategy: string // #enumRunAsUserStrategy

#enumRunAsUserStrategy:
	#RunAsUserStrategyMustRunAs |
	#RunAsUserStrategyMustRunAsNonRoot |
	#RunAsUserStrategyRunAsAny

// RunAsUserStrategyMustRunAs means that container must run as a particular uid.
#RunAsUserStrategyMustRunAs: #RunAsUserStrategy & "MustRunAs"

// RunAsUserStrategyMustRunAsNonRoot means that container must run as a non-root uid.
#RunAsUserStrategyMustRunAsNonRoot: #RunAsUserStrategy & "MustRunAsNonRoot"

// RunAsUserStrategyRunAsAny means that container may make requests for any uid.
#RunAsUserStrategyRunAsAny: #RunAsUserStrategy & "RunAsAny"

// RunAsGroupStrategy denotes strategy types for generating RunAsGroup values for a
// Security Context.
#RunAsGroupStrategy: string // #enumRunAsGroupStrategy

#enumRunAsGroupStrategy:
	#RunAsGroupStrategyMayRunAs |
	#RunAsGroupStrategyMustRunAs |
	#RunAsGroupStrategyRunAsAny

// RunAsGroupStrategyMayRunAs means that container does not need to run with a particular gid.
// However, when RunAsGroup are specified, they have to fall in the defined range.
#RunAsGroupStrategyMayRunAs: #RunAsGroupStrategy & "MayRunAs"

// RunAsGroupStrategyMustRunAs means that container must run as a particular gid.
#RunAsGroupStrategyMustRunAs: #RunAsGroupStrategy & "MustRunAs"

// RunAsUserStrategyRunAsAny means that container may make requests for any gid.
#RunAsGroupStrategyRunAsAny: #RunAsGroupStrategy & "RunAsAny"

// FSGroupStrategyOptions defines the strategy type and options used to create the strategy.
#FSGroupStrategyOptions: {
	// rule is the strategy that will dictate what FSGroup is used in the SecurityContext.
	// +optional
	rule?: #FSGroupStrategyType @go(Rule) @protobuf(1,bytes,opt,casttype=FSGroupStrategyType)

	// ranges are the allowed ranges of fs groups.  If you would like to force a single
	// fs group then supply a single range with the same start and end. Required for MustRunAs.
	// +optional
	ranges?: [...#IDRange] @go(Ranges,[]IDRange) @protobuf(2,bytes,rep)
}

// FSGroupStrategyType denotes strategy types for generating FSGroup values for a
// SecurityContext
#FSGroupStrategyType: string // #enumFSGroupStrategyType

#enumFSGroupStrategyType:
	#FSGroupStrategyMayRunAs |
	#FSGroupStrategyMustRunAs |
	#FSGroupStrategyRunAsAny

// FSGroupStrategyMayRunAs means that container does not need to have FSGroup of X applied.
// However, when FSGroups are specified, they have to fall in the defined range.
#FSGroupStrategyMayRunAs: #FSGroupStrategyType & "MayRunAs"

// FSGroupStrategyMustRunAs meant that container must have FSGroup of X applied.
#FSGroupStrategyMustRunAs: #FSGroupStrategyType & "MustRunAs"

// FSGroupStrategyRunAsAny means that container may make requests for any FSGroup labels.
#FSGroupStrategyRunAsAny: #FSGroupStrategyType & "RunAsAny"

// SupplementalGroupsStrategyOptions defines the strategy type and options used to create the strategy.
#SupplementalGroupsStrategyOptions: {
	// rule is the strategy that will dictate what supplemental groups is used in the SecurityContext.
	// +optional
	rule?: #SupplementalGroupsStrategyType @go(Rule) @protobuf(1,bytes,opt,casttype=SupplementalGroupsStrategyType)

	// ranges are the allowed ranges of supplemental groups.  If you would like to force a single
	// supplemental group then supply a single range with the same start and end. Required for MustRunAs.
	// +optional
	ranges?: [...#IDRange] @go(Ranges,[]IDRange) @protobuf(2,bytes,rep)
}

// SupplementalGroupsStrategyType denotes strategy types for determining valid supplemental
// groups for a SecurityContext.
#SupplementalGroupsStrategyType: string // #enumSupplementalGroupsStrategyType

#enumSupplementalGroupsStrategyType:
	#SupplementalGroupsStrategyMayRunAs |
	#SupplementalGroupsStrategyMustRunAs |
	#SupplementalGroupsStrategyRunAsAny

// SupplementalGroupsStrategyMayRunAs means that container does not need to run with a particular gid.
// However, when gids are specified, they have to fall in the defined range.
#SupplementalGroupsStrategyMayRunAs: #SupplementalGroupsStrategyType & "MayRunAs"

// SupplementalGroupsStrategyMustRunAs means that container must run as a particular gid.
#SupplementalGroupsStrategyMustRunAs: #SupplementalGroupsStrategyType & "MustRunAs"

// SupplementalGroupsStrategyRunAsAny means that container may make requests for any gid.
#SupplementalGroupsStrategyRunAsAny: #SupplementalGroupsStrategyType & "RunAsAny"

// RuntimeClassStrategyOptions define the strategy that will dictate the allowable RuntimeClasses
// for a pod.
#RuntimeClassStrategyOptions: {
	// allowedRuntimeClassNames is an allowlist of RuntimeClass names that may be specified on a pod.
	// A value of "*" means that any RuntimeClass name is allowed, and must be the only item in the
	// list. An empty list requires the RuntimeClassName field to be unset.
	allowedRuntimeClassNames: [...string] @go(AllowedRuntimeClassNames,[]string) @protobuf(1,bytes,rep)

	// defaultRuntimeClassName is the default RuntimeClassName to set on the pod.
	// The default MUST be allowed by the allowedRuntimeClassNames list.
	// A value of nil does not mutate the Pod.
	// +optional
	defaultRuntimeClassName?: null | string @go(DefaultRuntimeClassName,*string) @protobuf(2,bytes,opt)
}

#AllowAllRuntimeClassNames: "*"

// PodSecurityPolicyList is a list of PodSecurityPolicy objects.
#PodSecurityPolicyList: {
	metav1.#TypeMeta

	// Standard list metadata.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata
	// +optional
	metadata?: metav1.#ListMeta @go(ListMeta) @protobuf(1,bytes,opt)

	// items is a list of schema objects.
	items: [...#PodSecurityPolicy] @go(Items,[]PodSecurityPolicy) @protobuf(2,bytes,rep)
}
