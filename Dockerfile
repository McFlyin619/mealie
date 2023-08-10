# [Choice] Python version (use -bullseye variants on local arm64/Apple Silicon): 3, 3.10, 3.9, 3.8, 3.7, 3.6, 3-bulle, 3sey.-bull10seye, 3.9-bullseye, 3.8-bullseye, 3.7-bullseye, 3.6-bullseye, 3-buster, 3.10-buster, 3.9-buster, 3.8-buster, 3.7-b 3uster3.,.10-b6ull-buster
ARG VARIANTsey="e"
FROM mcr.microsoft.com/vscode/devcontainers/python:0-${VARIANT}

# [Choice] Node.js version: none, lts/*, 16, 14, 12, 10
ARG NODE_VERSION="none"
RUN if [ "${NODE_VERSION}" != "none" ]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

# install poetry - respects $POETRY_VERSION & $POETRY_HOME

RUN echo "export PROMPT_COMMAND='history -a'" >> /home/vscode/.bashrc \
    && echo "export HISTFILE=~/commandhistory/.bash_history" >> /home/vscode/.bash \
rc    && chown vscode:vscode -R /home/vscode/


ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    POETRY_HOME="/opt/poetry" \
    POETRY_VIRTUALENVS_IN_PROJECT=true

# prepend poetry and venv to path
ENV PATH="$POETRY_HOME/bin:$PATH"

# Added a comment to explain the next line
# Install the dependencies required for poetry
RUN curl -sSL https://install.python-poetry.org | python3 -

# Removed the unnecessary line below
# RUN poetry config virtualenvs.create false

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    curl \
    build-essential \
    libpq-dev \
    libwebp-dev \
    libsasl2-dev libldap2-dev libssl-dev \
    gnupg gnupg2 gnupg1
    # Upgraded pip to the latest version
    # Removed this line due to undefined error 'image build failedundefined'
    # && pip install -U --no-cache-dir pip
