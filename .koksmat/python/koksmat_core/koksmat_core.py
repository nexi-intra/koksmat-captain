# koksmat_core.py

import os
from pathlib import Path
import sys
import logging

# Configure logging
logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

# Global variable to store work directory
_workdir = None

def get_cwd() -> Path:
    """
    Get the current working directory.

    Returns:
        Path: Current working directory as a Path object.
    """
    cwd = Path.cwd()
    logger.debug(f"Current Working Directory: {cwd}")
    return cwd

def set_cwd(path: str) -> None:
    """
    Set the current working directory.

    Args:
        path (str): The path to set as the current working directory.

    Raises:
        FileNotFoundError: If the specified path does not exist.
        NotADirectoryError: If the specified path is not a directory.
        PermissionError: If the program lacks permissions to change to the specified directory.
    """
    target_path = Path(path).resolve()
    logger.debug(f"Attempting to set CWD to: {target_path}")

    if not target_path.exists():
        logger.error(f"The directory '{target_path}' does not exist.")
        raise FileNotFoundError(f"The directory '{target_path}' does not exist.")
    if not target_path.is_dir():
        logger.error(f"The path '{target_path}' is not a directory.")
        raise NotADirectoryError(f"The path '{target_path}' is not a directory.")

    try:
        os.chdir(target_path)
        logger.info(f"Changed CWD to: {target_path}")
    except PermissionError as e:
        logger.error(f"Permission denied to change to '{target_path}'.")
        raise PermissionError(f"Permission denied to change to '{target_path}'.") from e

def get_workdir() -> Path:
    """
    Get the work directory path.

    Returns:
        Path: Work directory path as a Path object.
    """
    global _workdir
    if _workdir is not None:
        logger.debug(f"Work Directory (cached): {_workdir}")
        return _workdir

    # Default workdir can be a 'work' subdirectory in the project root
    project_root = get_project_root()
    workdir = project_root / 'work'
    logger.debug(f"Default Work Directory: {workdir}")
    return workdir

def set_workdir(path: str) -> None:
    """
    Set the work directory path.

    Args:
        path (str): The path to set as the work directory.

    Raises:
        FileNotFoundError: If the specified path does not exist.
        NotADirectoryError: If the specified path is not a directory.
        PermissionError: If the program lacks permissions to access the specified directory.
    """
    global _workdir
    target_path = Path(path).resolve()
    logger.debug(f"Attempting to set Work Directory to: {target_path}")

    if not target_path.exists():
        logger.error(f"The directory '{target_path}' does not exist.")
        raise FileNotFoundError(f"The directory '{target_path}' does not exist.")
    if not target_path.is_dir():
        logger.error(f"The path '{target_path}' is not a directory.")
        raise NotADirectoryError(f"The path '{target_path}' is not a directory.")

    _workdir = target_path
    logger.info(f"Set Work Directory to: {_workdir}")

def get_project_root() -> Path:
    """
    Get the project root directory.

    The project root is determined as the parent directory of this module.

    Returns:
        Path: Project root directory as a Path object.
    """
    # If the module is part of a package, adjust accordingly
    try:
        project_root = Path(__file__).parent.resolve()
        logger.debug(f"Project Root determined from __file__: {project_root}")
    except NameError:
        # If __file__ is not defined, fallback to current working directory
        project_root = Path.cwd()
        logger.debug(f"Project Root determined from CWD: {project_root}")
    return project_root
