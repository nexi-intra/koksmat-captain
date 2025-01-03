# Security Principal provisioning

## SharePoint

## Exchange

## Power Apps & Power Automate

# Trouble Shooting

## ModuleNotFoundError: No module named 'cryptography'

The error message you're encountering:

```
ModuleNotFoundError: No module named 'cryptography'
```

indicates that the `cryptography` library is not installed in your current Python environment. To resolve this, you'll need to install the `cryptography` module within your virtual environment. Below are step-by-step instructions to help you fix this issue.

### Step 1: Activate Your Virtual Environment

First, ensure that your virtual environment is activated. Based on the path you've provided, your virtual environment is located at:

```
/Users/nielsgregersjohansen/kitchens/koksmat-captain/.venv/
```

To activate it, open your terminal and run:

```bash
source /Users/nielsgregersjohansen/kitchens/koksmat-captain/.venv/bin/activate
```

**Note:** After activation, your terminal prompt should change, typically showing the name of the virtual environment in parentheses, e.g., `(.venv) user@machine:~$`.

### Step 2: Upgrade `pip` (Optional but Recommended)

It's a good practice to ensure that `pip` is up-to-date to avoid any installation issues.

```bash
pip install --upgrade pip
```

### Step 3: Install the `cryptography` Module

With the virtual environment activated, install the `cryptography` library using `pip`:

```bash
pip install cryptography
```

**Explanation:**

- **`pip`**: Python's package installer.
- **`install`**: The command to install a package.
- **`cryptography`**: The name of the package you want to install.

### Step 4: Verify the Installation

To confirm that the `cryptography` module is installed correctly, you can run:

```bash
python -c "import cryptography; print(cryptography.__version__)"
```

This command should print the version number of the `cryptography` library, indicating a successful installation. For example:

```
41.0.3
```

### Step 5: Run Your Script Again

Now that the `cryptography` module is installed, try running your script:

```bash
python /Users/nielsgregersjohansen/kitchens/koksmat-captain/azure-application-provisioning/create-self-signed-certificate.py
```

### Additional Troubleshooting

If you encounter issues during installation, consider the following steps:

#### 1. Ensure Xcode Command Line Tools Are Installed (macOS)

Some Python packages, including `cryptography`, may require compilation tools. Install the Xcode command line tools by running:

```bash
xcode-select --install
```

Follow the on-screen instructions to complete the installation.

#### 2. Check Python Version

Ensure you're using a compatible Python version (Python 3.6+ is recommended). You can check your Python version with:

```bash
python --version
```

#### 3. Recreate the Virtual Environment (If Necessary)

If activation doesn't work or you suspect the virtual environment is corrupted, you can recreate it:

```bash
# Deactivate the current environment if active
deactivate

# Remove the existing virtual environment directory
rm -rf /Users/nielsgregersjohansen/kitchens/koksmat-captain/.venv

# Create a new virtual environment
python3 -m venv /Users/nielsgregersjohansen/kitchens/koksmat-captain/.venv

# Activate the new virtual environment
source /Users/nielsgregersjohansen/kitchens/koksmat-captain/.venv/bin/activate

# Upgrade pip
pip install --upgrade pip

# Install cryptography
pip install cryptography
```

#### 4. Use a `requirements.txt` File (Optional)

If your project has multiple dependencies, it's beneficial to manage them using a `requirements.txt` file.

1. **Create a `requirements.txt` file** with the following content:

   ```text
   cryptography
   ```

2. **Install dependencies**:

   ```bash
   pip install -r requirements.txt
   ```

### Summary

1. **Activate your virtual environment**:

   ```bash
   source /Users/nielsgregersjohansen/kitchens/koksmat-captain/.venv/bin/activate
   ```

2. **Upgrade `pip`** (optional but recommended):

   ```bash
   pip install --upgrade pip
   ```

3. **Install the `cryptography` module**:

   ```bash
   pip install cryptography
   ```

4. **Verify the installation**:

   ```bash
   python -c "import cryptography; print(cryptography.__version__)"
   ```

5. **Run your script again**:

   ```bash
   python /Users/nielsgregersjohansen/kitchens/koksmat-captain/azure-application-provisioning/create-self-signed-certificate.py
   ```

Following these steps should resolve the `ModuleNotFoundError` and allow your script to run successfully. If you encounter any further issues, feel free to ask for more assistance!
