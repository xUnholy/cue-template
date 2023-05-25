package main

import templates "github.com/xunholy/cue-template/templates"

// Define the schema for the user-supplied values.
// At runtime, Timoni injects the supplied values
// and validates them according to the Config schema.
values: templates.#Config

// Define how Timoni should build, validate and
// apply the Kubernetes resources.
timoni: {
	apiVersion: "v1alpha1"

	// Define the instance that outputs the Kubernetes resources.
	// At runtime, Timoni builds the instance and validates
	// the resulting resources according to their Kubernetes schema.
	instance: templates.#Instance & {
		// The user-supplied values are merged with the
		// default values at runtime by Timoni.
		config: values
		// The instance name and namespace tag values
		// are injected at runtime by Timoni.
		config: {
			metadata: {
				name:      string @tag(name)
				namespace: string @tag(namespace)
			}
		}
	}

	// Pass Kubernetes resources outputted by the instance
	// to Timoni's multi-step apply.
	apply: all: [ for obj in instance.objects {obj}]
}
