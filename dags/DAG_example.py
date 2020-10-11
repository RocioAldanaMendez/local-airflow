from airflow.models import DAG
from airflow.operators.bash_operator import BashOperator
from datetime import datetime, timedelta

import os
import sys

module_path = os.path.abspath(os.path.join('shared_dag_functions.py'))
sys.path.append(module_path)
from shared_dag_functions import notify_fail, notify_success

args = {
    'owner': 'Airflow',
    'depends_on_past': False,
    'start_date': datetime(2020, 9, 1),
    'email_on_success': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 0,
    'retry_delay': timedelta(minutes=5)
}

dag = DAG(
    dag_id='DAG_example',
    default_args=args,
    schedule_interval='0/15 * * * *',
    dagrun_timeout=timedelta(minutes=30),
    is_paused_upon_creation=True,
    max_active_runs=1,
    catchup=False
    )

script = '/root/airflow/scripts/script_example.py'
t1 = BashOperator(
    task_id='bash_run_python_script',
    bash_command=f'python {script}',
    on_failure_callback=notify_fail,
    on_success_callback=notify_success,
    dag=dag,
    execution_timeout=timedelta(minutes=20)
    )