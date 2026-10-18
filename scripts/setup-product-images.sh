#!/usr/bin/env bash
set -e

declare -A IMAGES=(
  [11]="https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=800"
  [12]="https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?w=800"
  [13]="https://images.unsplash.com/photo-1625842268584-8f3296236761?w=800"
  [14]="https://images.unsplash.com/photo-1590602847861-f357a9332bbc?w=800"
  [19]="https://images.unsplash.com/photo-1598488035139-bdbb2231ce04?w=800"
  [21]="https://images.unsplash.com/photo-1598488035139-bdbb2231ce04?w=800"
  [23]="https://images.unsplash.com/photo-1520523839898-50712825e617?w=800"
  [24]="https://images.unsplash.com/photo-1544816155-12df9643f363?w=800"
)

for pid in "${!IMAGES[@]}"; do
  url="${IMAGES[$pid]}"
  echo "Importing image for Product ID $pid..."
  curl -sL "$url" -o "/tmp/prod_$pid.jpg"
  wp media import "/tmp/prod_$pid.jpg" --post_id="$pid" --featured_image --allow-root || true
  rm -f "/tmp/prod_$pid.jpg"
done

echo "All product images imported successfully!"
