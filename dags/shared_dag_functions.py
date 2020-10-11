"""
Very, very generic job success/fail notifications. Will need to add app pwd to airflow.cfg and replace dummy vals.
"""

from airflow.utils.email import send_email


def notify_fail(context):

    title = f"FAILED: {context.get('dag')} (Airflow)"
    body = f"""
        Run ID: {context.get('run_id')}<br>
        Start Time: {context.get('execution_date')}
        """
    send_email('username@email.com', title, body)


def notify_success(context):

    title = f"SUCCESS: {context.get('dag')} (Airflow)"
    body = f"""
        Run ID: {context.get('run_id')}<br>
        Start Time: {context.get('execution_date')}
        """
    send_email('username@email.com', title, body)

