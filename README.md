# Run your personal MLFlow server on the Neu.ro platform with neuro-flow

This is a [`neuro-flow`](https://github.com/neuro-inc/neuro-flow) action launching an instance of [MLFlow tracking server](https://www.mlflow.org/docs/latest/tracking.html).
You can use it to track your ML experiments and model training as well as to deploy models to production using our [MLFlow2Seldon integration](https://github.com/neuro-inc/mlops-k8s-mlflow2seldon)

The MLFlow action exposes several arguments, two of which are mandatory: `backend_store_uri` and `default_artifact_root`.

## Usage example could be found in the [.neuro/live.yaml](.neuro/live.yaml) file.

## Arguments

### `backend_store_uri`

URI of the storage which should be used to dump experiments, their metrics, registered models, etc.
You can find more information [here](https://mlflow.org/docs/latest/tracking.html#backend-stores).

#### Examples

* Postgres server as a job within the same project:
```
args:
	backend_store_uri: postgresql://postgres:password@${{ inspect_job('postgres').internal_hostname_named }}:5432
```

* SQLite persistent on a platform disk or storage.
This also implies adding the respective disk's mount path `/some/path` to the `volumes` argument.
```
args:
    backend_store_uri: sqlite:///some/path/mlflow.db
```

* Regular file. 
In this case, the *MLFlow registered models* functionality will not work.
In order to use this functionality, you must run your server using a database-backed store (see the note [here](https://www.mlflow.org/docs/latest/tracking.html#backend-stores)).
```
args:
    backend_store_uri: /path/to/store 
```

### `default_artifact_root`

A place to store MLFlow artifacts such as model dumps.
This path should also be accessible from the training job.
You can find more information [here](https://mlflow.org/docs/latest/tracking.html#artifact-stores)

#### Example

You can use platform storage as a backend.
To do this, use a local path for artifact store:
1. Set this input's value to the mount path of the needed volume.
2. Add its read-write reference to the `inputs.volumes` list.

```
args:
	volumes_code_remote:${{ volumes.mlflow_artifacts.mount }}
```

### `volumes`

Reference to a list of volumes which should be mounted to the MLFlow server job. Empty by default.

#### Example

```
args:
    volumes: "${{ to_json(
        [
          volumes.mlflow_artifacts.ref_rw,
          volumes.mlflow_storage.ref_rw
        ]
      ) }}"
```

### `envs`

List of environment variables added to the job. Empty by default.

#### Example

```
args:
	envs: "${{ to_json(
        {
          'ENV1': 'env_1_value',
          'ENV2': 'env_2_value'
        }
      ) }}"
```

### `http_auth`

Boolean value specifying whether to use HTTP authentication for Jupyter or not. `"False"` by default.

#### Example

Enable HTTP authentication by setting this argument to True.
Note that your training job should be able to communicate with MLFlow guarded by the Neu.ro platform authentication solution.
```
args:
    http_auth: "True"
```


### `life_span`

A value specifying how long the MLFlow server job should be running. `"10d"` by default.

#### Example

```
args:
	life_span: 1d2h3m
```

### `port`

HTTP port to use for the MLFlow server. `"5000"` by default.

#### Example

```
args:
    http_port: "4444"
```

### `job_name`

Predictable subdomain name which replaces the job's ID in the full job URI. `""` by default (i.e., the job ID will be used).

#### Example

```
args:
	job_name: "mlflow-server"
```


### `preset`

Resource preset to use when running the Jupyter job. `""` by default (i.e., the first preset specified in the `neuro config show` list will be used).

#### Example

```
args:
    preset: cpu-small
```

### `extra_params`

Additional parameters transferred to the `mlflow server` command. `""` by default.
Check the full list of accepted parameters via `mlflow server --help`.

#### Example

```
args:
    extra_params: "--workers 2 --host example.com"
```
