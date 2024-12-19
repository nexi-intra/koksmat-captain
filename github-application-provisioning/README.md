# Provision GitHub Applications

1. **Generates a JWT for GitHub App authentication.**
2. **Obtains an installation access token.**
3. **Creates or updates a workflow in a repository.**
4. **Triggers the workflow manually (if needed).**
5. **Monitors the workflow run status.**

### **Prerequisites**

1. **Manually Create a GitHub App:**

   GitHub Apps cannot be created via the API or CLI; they must be created manually through the GitHub website. Follow these steps:

   - **Navigate to GitHub Settings:**

     - Go to your GitHub account settings.
     - Click on **Developer settings** in the sidebar.
     - Select **GitHub Apps**.

   - **Create a New GitHub App:**

     - Click **New GitHub App**.
     - Fill in the required details:
       - **App name**
       - **Homepage URL**
       - **Webhook URL** (optional, but useful for event handling)
       - **Callback URL** (if you plan to use OAuth)
     - Under **Permissions & events**, set the necessary permissions:
       - **Actions**: Read & Write
       - **Workflows**: Read & Write
       - **Repositories**: Read & Write (adjust based on your needs)
     - **Subscribe to events** relevant to your workflows if needed.
     - Click **Create GitHub App**.

   - **Generate a Private Key:**

     - After creating the App, generate and download a private key (`.pem` file). **Keep this file secure** as it’s used for authentication.

   - **Install the GitHub App:**
     - Install the App on the desired repositories or organizations. This process will provide you with an **Installation ID**.

2. **Set Up Your Development Environment:**

   - **Python 3.6+** is recommended.
   - Install the required Python packages:
     ```bash
     pip install PyJWT requests
     ```
   - **Git** should be installed if you plan to perform Git operations (e.g., cloning repositories).

### **Python Script Overview**

The Python script will perform the following steps:

1. **Generate a JWT using the App's private key.**
2. **Obtain an Installation Access Token using the JWT.**
3. **Interact with the GitHub API to manage workflows:**
   - Create or update a workflow file.
   - Trigger the workflow manually (optional).
   - Monitor the workflow run status.

### **Detailed Python Script**

```python
import jwt
import time
import requests
import os
import subprocess
from pathlib import Path

# ----------------------- Configuration -----------------------

# Replace these variables with your actual values
APP_ID = "YOUR_GITHUB_APP_ID"  # GitHub App ID
PRIVATE_KEY_PATH = "path/to/your/private-key.pem"  # Path to your App's private key
INSTALLATION_ID = "YOUR_INSTALLATION_ID"  # Installation ID of the App
REPO_OWNER = "YOUR_REPO_OWNER"  # e.g., your GitHub username or organization
REPO_NAME = "YOUR_REPO_NAME"
WORKFLOW_FILE_PATH = ".github/workflows/example_workflow.yml"
WORKFLOW_CONTENT = """
name: Example Workflow

on:
  workflow_dispatch:
  push:
    branches:
      - main

jobs:
  example_job:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Run a script
        run: echo "Hello, World!"
"""

GITHUB_API_URL = "https://api.github.com"

# ----------------------- Helper Functions -----------------------

def generate_jwt(app_id, private_key_path):
    """
    Generates a JWT for GitHub App authentication.
    """
    with open(private_key_path, 'r') as key_file:
        private_key = key_file.read()

    # Define JWT payload
    payload = {
        'iat': int(time.time()),
        'exp': int(time.time()) + (10 * 60),  # JWT valid for 10 minutes
        'iss': app_id
    }

    # Generate JWT
    encoded_jwt = jwt.encode(payload, private_key, algorithm='RS256')
    return encoded_jwt

def get_installation_access_token(jwt_token, installation_id):
    """
    Obtains an installation access token using the JWT.
    """
    url = f"{GITHUB_API_URL}/app/installations/{installation_id}/access_tokens"
    headers = {
        'Authorization': f'Bearer {jwt_token}',
        'Accept': 'application/vnd.github.v3+json'
    }

    response = requests.post(url, headers=headers)
    response.raise_for_status()
    return response.json()['token']

def create_or_update_workflow(access_token, owner, repo, workflow_path, workflow_content):
    """
    Creates or updates a workflow file in the specified repository.
    """
    # Clone the repository to a temporary directory
    temp_dir = Path("temp-repo")
    if temp_dir.exists():
        subprocess.run(["rm", "-rf", str(temp_dir)], check=True)
    subprocess.run(["git", "clone", f"https://github.com/{owner}/{repo}.git", str(temp_dir)], check=True)

    # Define the full path to the workflow file
    workflow_full_path = temp_dir / workflow_path

    # Create directories if they don't exist
    workflow_full_path.parent.mkdir(parents=True, exist_ok=True)

    # Write the workflow content
    with open(workflow_full_path, 'w') as wf_file:
        wf_file.write(workflow_content)

    # Commit and push the changes
    subprocess.run(["git", "-C", str(temp_dir), "add", workflow_path], check=True)
    subprocess.run(["git", "-C", str(temp_dir), "commit", "-m", "Add/Update example workflow"], check=True)
    subprocess.run(["git", "-C", str(temp_dir), "push"], check=True)

    # Cleanup
    subprocess.run(["rm", "-rf", str(temp_dir)], check=True)
    print(f"Workflow '{workflow_path}' has been created/updated in {owner}/{repo}.")

def trigger_workflow(access_token, owner, repo, workflow_id, ref="main"):
    """
    Triggers a workflow dispatch event.
    """
    url = f"{GITHUB_API_URL}/repos/{owner}/{repo}/actions/workflows/{workflow_id}/dispatches"
    headers = {
        'Authorization': f'token {access_token}',
        'Accept': 'application/vnd.github.v3+json'
    }
    data = {
        'ref': ref
    }

    response = requests.post(url, headers=headers, json=data)
    response.raise_for_status()
    print(f"Workflow {workflow_id} has been triggered on ref {ref}.")

def get_latest_workflow_run(access_token, owner, repo):
    """
    Retrieves the latest workflow run for the repository.
    """
    url = f"{GITHUB_API_URL}/repos/{owner}/{repo}/actions/runs?per_page=1"
    headers = {
        'Authorization': f'token {access_token}',
        'Accept': 'application/vnd.github.v3+json'
    }

    response = requests.get(url, headers=headers)
    response.raise_for_status()
    runs = response.json()['workflow_runs']
    if not runs:
        return None
    return runs[0]

def monitor_workflow_run(access_token, owner, repo, run_id):
    """
    Monitors the status of a workflow run until completion.
    """
    url = f"{GITHUB_API_URL}/repos/{owner}/{repo}/actions/runs/{run_id}"
    headers = {
        'Authorization': f'token {access_token}',
        'Accept': 'application/vnd.github.v3+json'
    }

    print(f"Monitoring workflow run ID: {run_id}")
    while True:
        response = requests.get(url, headers=headers)
        response.raise_for_status()
        run = response.json()
        status = run['status']
        conclusion = run['conclusion']
        print(f"Current run status: {status}")

        if status == "completed":
            print(f"Workflow run completed with conclusion: {conclusion}")
            break

        time.sleep(10)  # Wait for 10 seconds before polling again

# ----------------------- Main Execution -----------------------

def main():
    try:
        # Step 1: Generate JWT
        jwt_token = generate_jwt(APP_ID, PRIVATE_KEY_PATH)
        print("JWT generated successfully.")

        # Step 2: Get Installation Access Token
        access_token = get_installation_access_token(jwt_token, INSTALLATION_ID)
        print("Installation access token obtained successfully.")

        # Step 3: Create or Update Workflow
        create_or_update_workflow(access_token, REPO_OWNER, REPO_NAME, WORKFLOW_FILE_PATH, WORKFLOW_CONTENT)

        # Step 4: (Optional) Trigger the Workflow Manually
        # First, get the workflow ID by its filename or name
        # Here, we'll fetch all workflows and find the one matching our workflow file
        workflows_url = f"{GITHUB_API_URL}/repos/{REPO_OWNER}/{REPO_NAME}/actions/workflows"
        headers = {
            'Authorization': f'token {access_token}',
            'Accept': 'application/vnd.github.v3+json'
        }
        response = requests.get(workflows_url, headers=headers)
        response.raise_for_status()
        workflows = response.json()['workflows']

        # Find the workflow by file path
        workflow = next((wf for wf in workflows if wf['path'] == f"/{WORKFLOW_FILE_PATH}"), None)
        if not workflow:
            print(f"No workflow found at path {WORKFLOW_FILE_PATH}.")
            return

        workflow_id = workflow['id']
        print(f"Found workflow ID: {workflow_id}")

        # Trigger the workflow
        trigger_workflow(access_token, REPO_OWNER, REPO_NAME, workflow_id)

        # Step 5: Monitor the Workflow Run
        # Wait a few seconds to allow the workflow to start
        time.sleep(5)

        latest_run = get_latest_workflow_run(access_token, REPO_OWNER, REPO_NAME)
        if not latest_run:
            print("No workflow runs found.")
            return

        run_id = latest_run['id']
        monitor_workflow_run(access_token, REPO_OWNER, REPO_NAME, run_id)

    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    main()
```

### **Script Breakdown**

1. **Configuration Section:**

   - **APP_ID:** Your GitHub App's ID.
   - **PRIVATE_KEY_PATH:** Path to the `.pem` private key file downloaded when creating the App.
   - **INSTALLATION_ID:** The Installation ID where the App is installed. You can obtain this via the GitHub UI or by listing installations via the API.
   - **REPO_OWNER & REPO_NAME:** The owner (user or organization) and repository name where you want to manage workflows.
   - **WORKFLOW_FILE_PATH:** Path to the workflow YAML file within the repository.
   - **WORKFLOW_CONTENT:** The YAML content of the workflow you wish to create or update.
   - **GITHUB_API_URL:** Base URL for GitHub's API.

2. **Helper Functions:**

   - **generate_jwt:** Creates a JWT required for GitHub App authentication using `PyJWT`.
   - **get_installation_access_token:** Exchanges the JWT for an Installation Access Token, which is used for subsequent API calls.
   - **create_or_update_workflow:** Clones the repository, writes the workflow file, commits, and pushes it back. This function uses `subprocess` to execute Git commands. Ensure that Git is installed and accessible in your system's PATH.
   - **trigger_workflow:** Triggers the workflow manually using the `workflow_dispatch` event.
   - **get_latest_workflow_run:** Retrieves the latest workflow run to monitor its status.
   - **monitor_workflow_run:** Polls the workflow run status until it's completed.

3. **Main Execution Flow:**

   - **Generate JWT:** Authenticates as the GitHub App.
   - **Obtain Installation Access Token:** Authenticates as the App installation to perform actions.
   - **Create or Update Workflow:** Ensures the workflow file exists in the repository.
   - **Trigger Workflow:** Optionally triggers the workflow manually.
   - **Monitor Workflow:** Continuously checks the workflow run status until completion.

### **Important Considerations**

1. **Security:**

   - **Protect Your Private Key:** Ensure that your GitHub App's private key (`.pem` file) is stored securely and is **never** exposed in version control or logs.
   - **Environment Variables:** Consider using environment variables or secure storage mechanisms (like AWS Secrets Manager, Azure Key Vault, etc.) to manage sensitive data.

2. **Dependencies:**

   - **Python Packages:** Ensure `PyJWT` and `requests` are installed.
   - **Git:** The script uses Git via `subprocess`. Make sure Git is installed and properly configured on your system.
   - **Permissions:** The GitHub App must have appropriate permissions to read/write workflows and repositories.

3. **Error Handling:**

   - The script includes basic error handling using `try-except`. For production use, consider implementing more robust error handling and logging mechanisms.

4. **Workflow File Path:**

   - Ensure that the `WORKFLOW_FILE_PATH` corresponds to the correct location within your repository (e.g., `.github/workflows/`).

5. **Rate Limiting:**

   - Be mindful of GitHub's API rate limits. Implement retries or exponential backoff as needed for more resilient scripts.

6. **Installation ID:**

   - If you don’t know your Installation ID, you can retrieve it using the following function:

     ```python
     def list_installations(jwt_token):
         url = f"{GITHUB_API_URL}/app/installations"
         headers = {
             'Authorization': f'Bearer {jwt_token}',
             'Accept': 'application/vnd.github.v3+json'
         }
         response = requests.get(url, headers=headers)
         response.raise_for_status()
         return response.json()

     # Usage within main():
     installations = list_installations(jwt_token)
     for install in installations['installations']:
         print(f"Installation ID: {install['id']}, Repository: {install['repository']['full_name']}")
     ```

### **Alternative Approach: Using GitHub's GraphQL API**

While the above script uses GitHub's REST API, you can also leverage GitHub's GraphQL API for more efficient data retrieval and mutations. However, for simplicity and broader compatibility, the REST API approach is often preferred, especially for tasks like workflow management.

### **Conclusion**

By following the above steps and utilizing the provided Python script, you can automate the management of GitHub workflows through a GitHub App with fine-grained permissions. This approach offers a secure and scalable way to interact with GitHub repositories, trigger workflows, and monitor their execution programmatically.

Remember to test the script in a controlled environment before deploying it in production to ensure it behaves as expected.
