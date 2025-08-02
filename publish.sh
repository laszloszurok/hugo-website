#!/bin/sh

echo "Generating static files..."
hugo --quiet

echo "Archiving static files for upload..."
tar czf public.tar.gz public

echo "Uploading archive..."
scp public.tar.gz envs.net:

echo "Removing local archive..."
rm -f public.tar.gz

echo "Extracting archive on the remote..."
ssh envs.net 'tar xzf public.tar.gz --touch --strip-components 1 --directory public_html && rm -f public.tar.gz'

echo "All done!"
