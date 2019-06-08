# README
SnakeID is a WIP tool to teach people to identify snakes based on their photos.

I aim to make this a largely crowd sourced project with users uploading their own photos and 
contributing to the pages on each species. The live version will be hosted @ snakes.n8ta.com
when ready for launch. Get in touch with me if you are interested in contributing to this project.

# Conventions
- Code should use specie vs species to differentiate the plural. Same for genus vs genera etc.
- When variables that are in some order use next and prev as prefixes.

# Todo:
- Improve region picking 
- Variable zoom on zoom-in feature 
- Ruby version in gemfile
- Style this shit
- Built report system
- All the user shit like email passwords
- Build out admin roles for power users
- Gamification
- Fit Splines

# Done:
- Tag species by reigon from HerpMapper (June 7, 2019)
- Streamline seeding into one command vs many rake tasks (June 7, 2019)
- Start using UserSpeciesDatum model (June 1, 2019)
- Show percentage correct on prior species (June 1, 2019)
- Zoom in feature (May 31, 2019)
- Ensure "photos" scraped are actually photos not html pages titled .jpg, lol that was a weird bug. (May 30, 2019)
- Migrate to AWS and import herpmapper data (20k images!) (May 29, 2019)
- Import data from herpmapper (May 28, 2019)
- Publish alpha 1.0.0 (May 28, 2019)
- Get in touch with herpmapper about getting data officially (May 25, 2019)
- Restructure models to support more detailed taxonomy superfamilies etc. (May 24, 2019)
- Import taxonomy (May 24, 2019)
- Import images from reddit with rake task (May 24, 2019)
- Use reddit api to search ALL of a given users posts + the posts url (May 23, 2019)

# Deployment:
1. Configure rb in .env
2. bundle install
3. yarn install
4. mkdir tmp/reddit; mkdir tmp/pitt; mkdir tmp/herpmapper
5. rails db:migrate RAILS_ENV=production
6. rails imports:taxonomy RAILS_ENV=production
7. rails imports:pitt RAILS_ENV=production
8. rails imports:reddit RAILS_ENV=production
9. rails db:seed RAILS_ENV=production
10. rails imports:regions RAILS_ENV=production  
11. rails assets:precompile RAILS_ENV=production 
12. rails webpacker:compile (? not sure ?)
12. rails s -e production