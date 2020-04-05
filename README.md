# Herpetology
HerpetologyPro is a *beta* tool to teach people to identify reptiles and amphibians in their area. The end goal is that if people
aren't afraid of wildlife they won't harm it. It is a react front end reading from a ruby on rails API. AWS S3 is used for image serving.

This is a largely largely crowd sourced project with users uploading their own photos and 
contributing to the pages on each species. The live version is hosted @ [herpetology.pro](https://herpetology.pro)
Get in touch with me if you are interested in contributing to this project. Or feel free to submit a PR.

This project is an exercise in wheel building for me, all forms, games, models, etc, except auth are homegrown.

# Conventions
- Code should use specie vs species to differentiate the plural, I know that's it's not technically correct but rails heavily relies on singular/plural. Same for genus vs genera etc.
- When variables are in an order use next and prev as prefixes.
- Data is plural, datum is singular
- Taxon is the general term for domain,kindgom,phylum,class,family,order,genus,species, and the plural is taxons

# Todo:
- Tip approvals
- Restore species->genus->... relationships the taxon_id column seems to be nil sadly.
- Make modal more accessible
- Handle google auth failure when email already exists in the system
- Quiz on venomous/not as well as name
- Setup email
- Variable zoom on zoom-in feature 
- Learn to spell venemous...

# Done:
- Tip submissions (April 6, 2020)
- Build out a reusable modal (April 5, 2020)
- Show tips on species picker after guess (April 5, 2020)
- Define go to_hash method for reuse on taxon/tip to be ingested by js components. (April 4, 2020) 
- Upgrade to rails 6 (April 2, 2020)
- Amazon SES for password emails (October 19, 2019)
- React component for forgot password -- just used default form from devise instead (October 19, 2019)
- Fix reports being for incorrect photos / species on learning page (October X, 2019)
- Fix signup path for devise (October 7, 2019)
- Google/reddit/fb/myspace/whatever social sign ouath (September 5, 2019) Oh Ya!
- Learning mode signup prompt after a few questions (like comp mode) (September 5, 2019)
- Learning mode persistent data with local storage (September 4, 2019)
- Learning Mode (September 1, 2019)
- Make sure we have accurate data on venomous species, this may be possible to do by hand (reports will help too) (July 10, 2019)
- Add "Dead herp" to report options (July 10, 2019)
- Admin Interface to handle reports (July 7, 2019)
- Gamification (July 6 ,2019)
- Scoreboard with most contributions + max 10 users + current_user + accuracy (July 6, 2019)
- Daily scoreboard (July 6, 2019)
- All time most accurate (July 6, 2019)
- Menu / subregion areas with toggles (July 4, 2019)
- Toggle showing photos of deceased animals (setting for signed in users) (July 3, 2019) 
- Reporting feature, types:  (July 3, 2019)
  - Bad ID
  - No Herp
  - Venomous or not
- React components for sign up / sign in (July 1, 2019)
- Tag photos by dead/alive (June 31, 2019)
- Fix genus species capitalization (June 31, 2019)
- Style this shit (June  31, 2019)
- Capitalize scientific names correctly (June 26, 2019)
- Sort out very slow query in region.rb to find subregions with > 6 photograped species (June 25, 2019)
  - This ended up being one of those normalization vs speed problems and the data is quite denormalized now, upside is the queries are lightning fast (:
- Seperate scientific name and common name accuracy (June 25, 2019)
- Cache the regions a taxon in found in json so we can import with the seed w/o scraping herpmapper (June 24, 2019)
- Figure out how to load all the herpmapper photos from a downloaded version so I don't have to keep re'dl'ing them (June 24 ,2019)
- Build out admin roles for power users (June 23, 2019)
- Properly handle when there is no common name (June 10, 2019)
  - Herpmapper had common names for all their species
- Improve region picking (June 10, 2019)
- Fix whatever in quiz#show is looping (appears to be database related, doesn't happen with sqlite but does with mysql)
  - Turned out to be duplicates the tier-species join table (20k entires crashed everything) after removing the dupes all is well
  - https://www.n8ta.com/sql/rails/2019/07/20/fixing-a-join-table-with-dupliactes.html 
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
4. bundle exec rails db:schema:load
5. Request access to photos from herpmapper, modify their script to preface photos with a_ and d_ for alive/dead (configure imports:herp photos to match where you placed this folder)
6. bundle exec rails db:seed (you'll need to configure herp_photos.rake)
6. bundle exec rake imports:taxonomy
7. bundle exec rake imports:herp_create_regions
8. bundle exec rake imports:herp_regions
9. bundle exec rake imports:herp_photos
10. bundle exec rake imports:root_taxon_photos
11. bundle exec rake maintenance:update_taxon_validity
12. bundle exec rake maintenance:update_regions_root_taxons_table 
13. rails assets:precompile RAILS_ENV=production 
14. rails s -e production