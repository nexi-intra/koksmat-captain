# setup.py

from setuptools import setup, find_packages

setup(
    name='koksmat_core',
    version='0.1.0',
    description='A core module for managing directories in Koksmat projects.',
    author='Niels Gregers Johansen',
    author_email='niels.johansen@nexigroup.com',
    packages=find_packages(),
    install_requires=[],
    python_requires='>=3.6',
    classifiers=[
        'Programming Language :: Python :: 3',
        'Operating System :: OS Independent',
    ],
)
