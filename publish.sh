#!/bin/sh

set -o errexit

echo "Generating static files..."
hugo --quiet

if [ ! -d venv ]; then
    echo "Installing pagefind in a python virtual environment..."
    python3 -m venv venv
    pip install 'pagefind[extended]'
fi

echo "Activating python virtual environment..."
. venv/bin/activate

echo "Generating search index with pagefind..."
python3 -m pagefind --site public

echo "Archiving static files for upload..."
tar czf public.tar.gz public

echo "Uploading archive..."
scp public.tar.gz envs.net:

echo "Removing local archive..."
rm -f public.tar.gz

echo "Extracting archive on the remote..."
ssh envs.net 'tar xzf public.tar.gz --touch --strip-components 1 --directory public_html && rm -f public.tar.gz'

echo "All done!"
