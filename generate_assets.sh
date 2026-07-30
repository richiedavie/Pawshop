#!/bin/bash
set -e

mkdir -p assets/images/products assets/images/pets

create_product_img() {
  filename="$1"
  bg_color="$2"
  fg_color="$3"
  emoji="$4"
  title="$5"
  category="$6"

  # Create a 600x600 beautiful image card with rounded container, emoji illustration, and typography
  convert -size 600x600 xc:"$bg_color" \
    -fill "$fg_color" -stroke "$fg_color" -strokewidth 2 \
    -draw "roundrectangle 40,40 560,560 32,32" \
    -fill white -stroke transparent \
    -draw "roundrectangle 55,55 545,545 24,24" \
    -fill "$fg_color" -font "DejaVu-Sans" -pointsize 140 -gravity center -annotate +0-60 "$emoji" \
    -fill "#2E2E2E" -font "DejaVu-Sans-Bold" -pointsize 32 -gravity center -annotate +0+100 "$title" \
    -fill "#6E6E6E" -font "DejaVu-Sans" -pointsize 22 -gravity center -annotate +0+150 "$category" \
    "assets/images/products/$filename"
}

create_pet_avatar() {
  filename="$1"
  bg_color="$2"
  emoji="$3"
  name="$4"

  convert -size 400x400 xc:"$bg_color" \
    -fill white -stroke "#4C7A5E" -strokewidth 6 \
    -draw "circle 200,200 200,40" \
    -fill "#2E2E2E" -font "DejaVu-Sans" -pointsize 120 -gravity center -annotate +0-20 "$emoji" \
    -fill "#4C7A5E" -font "DejaVu-Sans-Bold" -pointsize 28 -gravity center -annotate +0+120 "$name" \
    "assets/images/pets/$filename"
}

# Dog Products
create_product_img "dog_canned_stew.png" "#F4F7F4" "#4C7A5E" "🥫" "Gourmet Beef Stew" "DOG FOOD"
create_product_img "dog_chew_rope.png" "#FDF8E8" "#C9A24B" "🧶" "Tough Cotton Rope" "DOG TOYS"
create_product_img "dog_squeaky_ball.png" "#FBF2F2" "#D32F2F" "🎾" "Interactive Rubber Ball" "DOG TOYS"
create_product_img "dog_leather_harness.png" "#F5F2ED" "#8B5A2B" "🦮" "Padded Leather Harness" "DOG ACCESSORIES"
create_product_img "dog_bed_orthopedic.png" "#EFEFF8" "#4A4E69" "🛏️" "Orthopedic Foam Bed" "DOG ACCESSORIES"
create_product_img "dog_deshedding_brush.png" "#F4F7F4" "#3E6A4E" "🧹" "De-Shedding Grooming Brush" "DOG GROOMING"
create_product_img "dog_shampoo_oatmeal.png" "#FDF8E8" "#C9A24B" "🧴" "Organic Oatmeal Shampoo" "DOG GROOMING"
create_product_img "dog_joint_chews.png" "#F2F7F2" "#4C7A5E" "💊" "Hip & Joint Glucosamine" "DOG HEALTH"
create_product_img "dog_dental_sticks.png" "#F8F7F4" "#2E2E2E" "🦴" "Daily Dental Sticks" "DOG HEALTH"

# Cat Products
create_product_img "cat_dry_salmon.png" "#F4F7F4" "#4C7A5E" "🐟" "Wild Salmon Kibble" "CAT FOOD"
create_product_img "cat_tuna_pouch.png" "#FDF8E8" "#C9A24B" "🍤" "Tuna & Shrimp Wet Pouch" "CAT FOOD"
create_product_img "cat_feather_wand.png" "#FBF2F2" "#D32F2F" "🪶" "Teaser Feather Wand" "CAT TOYS"
create_product_img "cat_catnip_mouse.png" "#F2F7F2" "#4C7A5E" "🐭" "Catnip Plush Mice (3pk)" "CAT TOYS"
create_product_img "cat_tree_tower.png" "#F5F2ED" "#8B5A2B" "🏰" "Multi-Level Cat Tree Tower" "CAT ACCESSORIES"
create_product_img "cat_ceramic_bowl.png" "#EFEFF8" "#4A4E69" "🥣" "Ergonomic Ceramic Bowl" "CAT ACCESSORIES"
create_product_img "cat_grooming_glove.png" "#F4F7F4" "#3E6A4E" "🧤" "Gentle Hair Remover Glove" "CAT GROOMING"
create_product_img "cat_claw_clipper.png" "#FDF8E8" "#C9A24B" "✂️" "Safety Claw Clipper" "CAT GROOMING"
create_product_img "cat_hairball_paste.png" "#F8F7F4" "#2E2E2E" "🧪" "Hairball Relief Malt Paste" "CAT HEALTH"
create_product_img "cat_calming_diffuser.png" "#F2F7F2" "#4C7A5E" "🌬️" "Pheromone Calming Diffuser" "CAT HEALTH"

# Pet Avatars
create_pet_avatar "pet_dog_avatar.png" "#EAF2ED" "🐶" "Bella"
create_pet_avatar "pet_cat_avatar.png" "#FDF8E8" "🐱" "Milo"
create_pet_avatar "pet_dog_avatar2.png" "#FBF2F2" "🐕" "Max"
create_pet_avatar "pet_cat_avatar2.png" "#EFEFF8" "🐈" "Luna"

echo "Asset generation complete!"
