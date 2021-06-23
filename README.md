# Run your personal MLFlow server on top of Neu.ro platform with neuro-flow

This is a [`neuro-flow`](https://github.com/neuro-inc/neuro-flow) action launching an instance of [MLFlow tracking server](https://www.mlflow.org/docs/latest/tracking.html).
You might use it to track your ML experiments, model trainings as well as deploying those models to production using our [MLFlow2Seldon intrgration](https://github.com/neuro-inc/mlops-k8s-mlflow2seldon)

MLFlow action exposes several parametes, two of which are mandatory: `backend_store_uri` and `default_artifact_root`.

## Usage example could be found in [.neuro/live.yaml](.neuro/live.yaml) file.

## Arguments description

### `backend_store_uri`

URI to the storage, which should be used to dump experiments, their metrics, registered models, etc.
More information could be found [here](https://mlflow.org/docs/latest/tracking.html#backend-stores).

#### Examples

Postgres server as a job within the same project:
```
args:
	backend_store_uri: postgresql://postgres:password@${{ inspect_job('postgres').internal_hostname_named }}:5432
```

SQLite persistet on a platform disk.
This also implies adding the respective disk with the mount part `/some/path` to the `volumes` argument.
```
args:
    backend_store_uri: sqlite:///some/path/mlflow.db
```

Regular file. In this case "MLFlow registered models" will not work.
```
args:
    backend_store_uri: /path/to/store 
```

### `default_artifact_root`

Place, where to store MLFlow artifacts (such as model dumps).
Beware, this path should also be accessible from the training job.
More information could be found [here](https://mlflow.org/docs/latest/tracking.html#artifact-stores)

#### Example

You could use a platform storage as a backend.
In this case use a local path for artifact store:
    1. set this input equal to the `mount path` of needed volume,
    2. add its read-write reference to the `inputs.volumes` list

```
args:
	volumes_code_remote:${{ volumes.mlflow_artifacts.mount }}
```

### `volumes`

Reference to a list of volumes, which should be mounted into the MLFlow server job. Empty by default.

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

List of environment variables, added to the job. Empty by default

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

Whether to use HTTP authentication for Jupyter or not. `"False"` by default.

#### Example
Enable http_auth via setting it to True. In this case your training job should be able to communicate with hidden behind SSO MLFlow. 
```
args:
    http_auth: "True"
```


### `life_span`

How log should the MLFlow server job run. `"10d"` by default.

#### Example

```
args:
	life_span: 1d2h3m
```

### `port`

HTTP port to use for MLFlow server. `"5000"` by default.

#### Example

```
args:
    http_port: "4444"
```

### `job_name`

Predictable subdomain name which replaces the job's ID in the full job URI. `""` by default (jobID will be used).

#### Example

```
args:
	job_name: "mlflow-server"
```


### `preset`

Resource preset to use when running the Jupyter job. `""` by default (the first one in `neuro config show` list will be used).

#### Example

```
args:
    preset: cpu-small
```

### `extra_params`

Additional parameters transferred to the `mlflow server` command. `""` by default.
Checkout the list of parameters via `mlflow server --help`.

#### Example

```
args:
    extra_params: "--workers 2 --host example.com"
```
