ScraperApp
----------

- ScraperApp is a collection of Ruby scripts (rake tasks) that are used to scrap different kind of data and download/upload it to AWS S3 bucket(s) or local storage.
- Currently implemented features focus on fashion items from different sources.
- Item types: Bags, Shoes, Cloth
- Sources:
	- Aggregator sites: MyTheresa, Net-A-Porter, Yoox
	- Designer sites: Dolce & Gabbana, Fendi, Gucci, Jimmy Choo, LaPerla, Prada, Tom Ford
- Scripts are simple and with little adjustment can be used to scrap different kind of content from various sources.

Technical info:
---------------
- As already stated, scripts are written in Ruby and "hosted" in Rails environment

Ruby version: 2.2.2
Rails version: 4.2.5
Postgres version 9.5

- Script can be executed using local DB (use for development/testing) or remote DB (used for production)
- If you plan to run script using the local DB, then ensure you have installed Postgres 9.5 version

Setting up the project:
-----------------------
- Install RVM
- Install Ruby 2.2.2
- Create gemset 'yewno_scraper_app'
- Install Postgres 9.5 (if you're using local DB)
- Ensure you have `.env` and `database.yml` files in your app's root folder. If you are not familiar with those files, `.env` is used for sensitive info and environment variables and shouldn't be commited on public repos. It is used to store info like AWS access keys, passwords, usernames, DB hosts and so on. `database.yml` is config file used to specify connection string to your DB(s).

- Run `bundle install` - to install gems
- Run `bundle exec rake db:create` - to create DB
- Run `bundle exec rake db:migrate` - to create DB schema
- Run `bundle exec rake s3:create_s3_buckets` to create AWS S3 bucket(s)
- Run `bundle exec rake local:create_folders` to create local folder structure (optional -> use if you want to download data to your local storage instead of AWS S3)
- You're set, now you can run rake tasks (scripts)

Folder structure:
-----------------
- All scripts are within `lib/tasks` folder
- Some script helpers can be found in `lib/helpers` folder
- `tasks/aws_s3_related` folder contains script which creates AWS S3 bucket(s) so content can be uploaded in appropriate bucket(s)
- `tasks/local_folders` folder contains script which creates local folder structure so content can be downloaded directly to local drive
- `tasks/fashion` folder contains script that are used to prepare (crawl for data), scrap and download data
- `log` folder contains log files created by scripts

`tasks/fashion` folder has following structure: <item_type>/<designer>/<source>/<all_files_that_actually_do_the_work>

So, if you, for example look inside `../tasks/fashion/bags/dolcegabbana/mytheresa` folder, you can see following files:

	- bags.csv
	- download.rake
	- preparation.rake
	- s3_download.rake
	- scraping.rake

Order of execution:

1. `preparation.rake` file contains rake task which is used to prepare (crawl for data) data which can be used for scraping later on.
- `prepare` task, crawls for links and creates a `bags.csv` file which contains link to be scraped.
- To run this script inside your app's root folder type: `bundle exec rake bags_dg_mytheresa:prepare`
- Note: some folders doesn't contain `preparation.rake` task, because links for items are manually crawled. In that case, skip this step.

2. `scraping.rake` file contains rake task which is used to scrap relevant data from each link in `bags.csv` file.
- Please note that if you run this script now it can happen that some of the links inside `bags.csv` files are not relevant anymore (don't exist), so you should run task from `preparation.rake` file to prepare new valid links (old content will be replaced).
- To run this script inside your app's root folder type: `bundle exec rake bags_dg_mytheresa:scrap`

3. Finally you can run tasks from `download.rake` or `s3_download.rake` files. It depends where you want your files to be.
- If you prefare files to be downloaded to your local storage, run rake task from `download.rake` file: `bundle exec rake bags_dg_mytheresa:download`
- If you prefare files to be downloaded to AWS S3 bucket, run rake task from `s3_download.rake` file: `bundle exec rake bags_dg_mytheresa:s3_download`

Other folders inside `tasks/fashion/...` may have different (additional) files, but pretty much the same applies like in given example.
Data scraped from `yoox` aggregator doesn't have `preparation.rake` file (prepare script), because links are crawled manually using JavaScript, or other techniques.


Scripts listing (rake tasks):
-----------------------------
rake bags_armani_armani:s3_download          # Download Armani bags data to AWS S3
rake bags_armani_armani:scrap                # Scrap Armani bags data
rake bags_armani_yoox:s3_download            # Download Armani bags data to AWS S3
rake bags_armani_yoox:scrap                  # Scrap Armani bags data
rake bags_bb_bb:s3_download                  # Download Burberry bags data to AWS S3
rake bags_bb_bb:scrap                        # Scrap Burberry bags data
rake bags_bb_mytheresa:s3_download           # Download Burberry bags data to AWS S3
rake bags_bb_mytheresa:scrap                 # Scrap Burberry bags data
rake bags_bb_netaporter:s3_download          # Download Burberry bags data to AWS S3
rake bags_bb_netaporter:scrap                # Scrap Burberry bags data
rake bags_bb_yoox:s3_download                # Download Burberry bags data to AWS S3
rake bags_bb_yoox:scrap                      # Scrap Burberry bags data
rake bags_chanel_chanel:s3_download          # Download Chanel bags data to AWS S3
rake bags_chanel_chanel:scrap                # Scrap Chanel bags data
rake bags_ck_ck:s3_download                  # Download Calvin Klein bags data to AWS S3
rake bags_ck_ck:scrap                        # Scrap Calvin Klein bags data
rake bags_ck_yoox:s3_download                # Download Calvin Klein bags data to AWS S3
rake bags_ck_yoox:scrap                      # Scrap Calvin Klein bags data
rake bags_dg_dg:download                     # Download DolceGabbana bags data on local disk
rake bags_dg_dg:prepare                      # Prepare DolceGabbana bags data
rake bags_dg_dg:s3_download                  # Download DolceGabbana bags data to AWS S3
rake bags_dg_dg:scrap                        # Scrap Dolce Gabbana bags data
rake bags_dg_mytheresa:prepare               # Prepare DolceGabbana bags data
rake bags_dg_mytheresa:s3_download           # Download DolceGabbana bags data to AWS S3
rake bags_dg_mytheresa:scrap                 # Scrap DolceGabbana bags data
rake bags_dg_mytheresa_old:download          # Download DolceGabbana bags data on local disk
rake bags_dg_netaporter:download             # Download DolceGabbana bags data on local disk
rake bags_dg_netaporter:prepare              # Prepare DolceGabbana bags data
rake bags_dg_netaporter:s3_download          # Download DolceGabbana bags data to AWS S3
rake bags_dg_netaporter:scrap                # Scrap DolceGabbana bags data
rake bags_dg_yoox:s3_download                # Download DolceGabbana bags data to AWS S3
rake bags_dg_yoox:scrap                      # Scrap DolceGabbana bags data
rake bags_dior_dior:s3_download              # Download Dior bags data to AWS S3
rake bags_dior_dior:scrap                    # Scrap Dior bags data
rake bags_etro_etro:s3_download              # Download Etro bags data to AWS S3
rake bags_etro_etro:scrap                    # Scrap Etro bags data
rake bags_etro_yoox:s3_download              # Download Etro bags data to AWS S3
rake bags_etro_yoox:scrap                    # Scrap Etro bags data
rake bags_fendi_fendi:download               # Download Fendi bags data on local disk
rake bags_fendi_fendi:prepare                # Prepare Fendi bags data
rake bags_fendi_fendi:s3_download            # Download Fendi bags data to AWS S3
rake bags_fendi_fendi:scrap                  # Scrap Fendi bags data
rake bags_fendi_mytheresa:download           # Download Fendi bags data on local disk
rake bags_fendi_mytheresa:prepare            # Prepare Fendi bags data
rake bags_fendi_mytheresa:s3_download        # Download Fendi bags data to AWS S3
rake bags_fendi_mytheresa:scrap              # Scrap Fendi bags data
rake bags_fendi_netaporter:download          # Download Fendi bags data on local disk
rake bags_fendi_netaporter:prepare           # Prepare Fendi bags data
rake bags_fendi_netaporter:s3_download       # Download Fendi bags data to AWS S3
rake bags_fendi_netaporter:scrap             # Scrap Fendi bags data
rake bags_fendi_yoox:s3_download             # Download  Fendi bags data to AWS S3
rake bags_fendi_yoox:scrap                   # Scrap Fendi bags data
rake bags_givenchy_mytheresa:s3_download     # Download Givenchy bags data to AWS S3
rake bags_givenchy_mytheresa:scrap           # Scrap Givenchy bags data
rake bags_givenchy_netaporter:s3_download    # Download Givenchy bags data to AWS S3
rake bags_givenchy_netaporter:scrap          # Scrap Givenchy bags data
rake bags_givenchy_yoox:s3_download          # Download Givenchy bags data to AWS S3
rake bags_givenchy_yoox:scrap                # Scrap Givenchy bags data
rake bags_gr_yoox:s3_download                # Download Gianvito Rossi bags data to AWS S3
rake bags_gr_yoox:scrap                      # Scrap Gianvito Rossi bags data
rake bags_gucci_gucci:download               # Download Gucci bags data on local disk
rake bags_gucci_gucci:prepare                # Prepare Gucci bags data
rake bags_gucci_gucci:s3_download            # Download Gucci bags data to AWS S3
rake bags_gucci_gucci:scrap                  # Scrap Gucci bags data
rake bags_gucci_mytheresa:prepare            # Prepare Gucci bags data
rake bags_gucci_mytheresa:s3_download        # Download Gucci bags data to AWS S3
rake bags_gucci_mytheresa:scrap              # Scrap Gucci bags data
rake bags_gucci_mytheresa_old:download       # Download Gucci bags data on local disk
rake bags_gucci_netaporter:prepare           # Prepare Gucci bags data
rake bags_gucci_netaporter:s3_download       # Download Gucci bags data to AWS S3
rake bags_gucci_netaporter:scrap             # Scrap Gucci bags data
rake bags_gucci_netaporter_old:download      # Download Gucci bags data on local disk
rake bags_gucci_yoox:s3_download             # Download Gucci bags data to AWS S3
rake bags_gucci_yoox:scrap                   # Scrap Gucci bags data
rake bags_jc_mytheresa:s3_download           # Download Jimmy Choo bags data to AWS S3
rake bags_jc_netaporter:s3_download          # Download Jimmy Choo bags data to AWS S3
rake bags_jc_yoox:s3_download                # Download Jimmy Choo bags data to AWS S3
rake bags_jc_yoox:scrap                      # Scrap Jimmy Choo bags data
rake bags_jimmy_mytheresa:download           # Download Jimmy Choo bags data on local disk
rake bags_jimmy_mytheresa:prepare            # Prepare Jimmy Choo bags data
rake bags_jimmy_mytheresa:scrap              # Scrap Jimmy Choo bags data
rake bags_jimmy_netaporter:download          # Download Jimmy Choo bags data on local disk
rake bags_jimmy_netaporter:prepare           # Prepare Jimmy Choo bags data
rake bags_jimmy_netaporter:scrap             # Scrap Jimmy Choo bags data
rake bags_lp_lp:download                     # Download La Perla bags data on local disk
rake bags_lp_lp:s3_download                  # Download La Perla bags data to AWS S3
rake bags_lp_lp:scrap                        # Scrap La Perla bags data
rake bags_lv_lv:s3_download                  # Download Louis Vuitton bags data to AWS S3
rake bags_lv_lv:scrap                        # Scrap Louis Vuitton bags data
rake bags_migrate_dg:start                   # Migrate DolceGabbana bags data
rake bags_migrate_fendi:start                # Migrate Fendi bags data
rake bags_migrate_gucci:start                # Migrate Gucci bags data
rake bags_migrate_jc:start                   # Migrate Jimmy Choo bags data
rake bags_migrate_lp:start                   # Migrate La Perla bags data
rake bags_migrate_prada:start                # Migrate Prada bags data
rake bags_migrate_tf:start                   # Migrate Tom Ford bags data
rake bags_miumiu_miumiu:s3_download          # Download Miu Miu bags data to AWS S3
rake bags_miumiu_miumiu:scrap                # Scrap Miu Miu bags data
rake bags_miumiu_mytheresa:s3_download       # Download Miu Miu bags data to AWS S3
rake bags_miumiu_mytheresa:scrap             # Scrap Miu Miu bags data
rake bags_miumiu_netaporter:s3_download      # Download Miu Miu bags data to AWS S3
rake bags_miumiu_netaporter:scrap            # Scrap Miu Miu bags data
rake bags_miumiu_yoox:s3_download            # Download Miu Miu bags data to AWS S3
rake bags_miumiu_yoox:scrap                  # Scrap Miu Miu bags data
rake bags_moncler_moncler:s3_download        # Download Moncler bags data to AWS S3
rake bags_moncler_moncler:scrap              # Scrap Moncler bags data
rake bags_moschino_moschino:s3_download      # Download Moschino bags data to AWS S3
rake bags_moschino_moschino:scrap            # Scrap Moschino bags data
rake bags_moschino_netaporter:s3_download    # Download Moschino bags data to AWS S3
rake bags_moschino_netaporter:scrap          # Scrap Moschino bags data
rake bags_moschino_yoox:s3_download          # Download Moschino bags data to AWS S3
rake bags_moschino_yoox:scrap                # Scrap Moschino bags data
rake bags_prada_mytheresa:download           # Download Prada bags data on local disk
rake bags_prada_mytheresa:prepare            # Prepare Prada bags data
rake bags_prada_mytheresa:s3_download        # Download Prada bags data to AWS S3
rake bags_prada_mytheresa:scrap              # Scrap Prada bags data
rake bags_prada_netaporter:download          # Download Prada bags data on local disk
rake bags_prada_netaporter:prepare           # Prepare Prada bags data
rake bags_prada_netaporter:s3_download       # Download Prada bags data to AWS S3
rake bags_prada_netaporter:scrap             # Scrap Prada bags data
rake bags_prada_prada:download               # Download Prada bags data on local disk
rake bags_prada_prada:prepare                # Prepare Prada bags data
rake bags_prada_prada:s3_download            # Download Prada bags data to AWS S3
rake bags_prada_prada:scrap                  # Scrap Prada bags data
rake bags_prada_yoox:s3_download             # Download Prada bags data to AWS S3
rake bags_prada_yoox:scrap                   # Scrap Prada bags data
rake bags_rc_rc:s3_download                  # Download Roberto Cavalli bags data to AWS S3
rake bags_rc_rc:scrap                        # Scrap Roberto Cavalli bags data
rake bags_rc_yoox:s3_download                # Download Roberto Cavalli bags data to AWS S3
rake bags_rc_yoox:scrap                      # Scrap Roberto Cavalli bags data
rake bags_sl_mytheresa:s3_download           # Download Saint Laurent bags data to AWS S3
rake bags_sl_mytheresa:scrap                 # Scrap Saint Laurent bags data
rake bags_sl_netaporter:s3_download          # Download Saint Laurent bags data to AWS S3
rake bags_sl_netaporter:scrap                # Scrap Saint Laurent bags data
rake bags_sl_sl:s3_download                  # Download Saint Laurent bags data to AWS S3
rake bags_sl_sl:scrap                        # Scrap Saint Laurent bags data
rake bags_sl_yoox:s3_download                # Download Saint Laurent bags data to AWS S3
rake bags_sl_yoox:scrap                      # Scrap Saint Laurent bags data
rake bags_tf_mytheresa:s3_download           # Download Tom Ford bags data to AWS S3
rake bags_tf_netaporter:s3_download          # Download Tom Ford bags data to AWS S3
rake bags_tf_tf:s3_download                  # Download Tom Ford bags data to AWS S3
rake bags_tf_yoox:s3_download                # Download Tom Ford bags data to AWS S3
rake bags_tf_yoox:scrap                      # Scrap Tom Ford bags data
rake bags_tods_mytheresa:s3_download         # Download Tod's bags data to AWS S3
rake bags_tods_mytheresa:scrap               # Scrap Tod's bags data
rake bags_tods_netaporter:s3_download        # Download Tod's bags data to AWS S3
rake bags_tods_netaporter:scrap              # Scrap Tods bags data
rake bags_tods_tods:s3_download              # Download Tod's bags data to AWS S3
rake bags_tods_tods:scrap                    # Scrap Tod's bags data
rake bags_tods_yoox:s3_download              # Download Tod's bags data to AWS S3
rake bags_tods_yoox:scrap                    # Scrap Tod's bags data
rake bags_tomford_mytheresa:download         # Download TomFord bags data on local disk
rake bags_tomford_mytheresa:prepare          # Prepare Tom Ford bags data
rake bags_tomford_mytheresa:scrap            # Scrap Tom Ford bags data
rake bags_tomford_netaporter:download        # Download TomFord bags data on local disk
rake bags_tomford_netaporter:prepare         # Prepare TomFord bags data
rake bags_tomford_netaporter:scrap           # Scrap TomFord bags data
rake bags_tomford_tomford:download           # Download Tom Ford bags data on local disk
rake bags_tomford_tomford:scrap              # Scrap TomFord bags data
rake bags_valentino_mytheresa:s3_download    # Download Valentino bags data to AWS S3
rake bags_valentino_mytheresa:scrap          # Scrap Valentino bags data
rake bags_valentino_netaporter:s3_download   # Download Valentino bags data to AWS S3
rake bags_valentino_netaporter:scrap         # Scrap Valentino bags data
rake bags_valentino_valentino:s3_download    # Download Valentino bags data to AWS S3
rake bags_valentino_valentino:scrap          # Scrap Valentino bags data
rake bags_valentino_yoox:s3_download         # Download Valentino bags data to AWS S3
rake bags_valentino_yoox:scrap               # Scrap Valentino bags data
rake bags_versace_netaporter:s3_download     # Download Versace bags data to AWS S3
rake bags_versace_netaporter:scrap           # Scrap Versace bags data
rake bags_versace_versace:s3_download        # Download Versace bags data to AWS S3
rake bags_versace_versace:scrap              # Scrap Versace bags data
rake bags_versace_yoox:s3_download           # Download Versace bags data to AWS S3
rake bags_versace_yoox:scrap                 # Scrap Versace bags data
----------------------------------------------------------------------------------------
rake cloth_armani_armani:s3_download         # Download Armani cloth data to AWS S3
rake cloth_armani_armani:scrap               # Scrap Armani cloth data
rake cloth_armani_yoox:s3_download           # Download Armani cloth data to AWS S3
rake cloth_armani_yoox:scrap                 # Scrap Armani cloth data
rake cloth_bb_bb:s3_download                 # Download Burberry cloth data to AWS S3
rake cloth_bb_bb:scrap                       # Scrap Burberry cloth data
rake cloth_bb_mytheresa:s3_download          # Download Burberry cloth data to AWS S3
rake cloth_bb_mytheresa:scrap                # Scrap Burberry cloth data
rake cloth_bb_netaporter:s3_download         # Download Burberry cloth data to AWS S3
rake cloth_bb_netaporter:scrap               # Scrap Burberry cloth data
rake cloth_bb_yoox:s3_download               # Download Burberry cloth data to AWS S3
rake cloth_bb_yoox:scrap                     # Scrap Burberry cloth data
rake cloth_ck_ck:s3_download                 # Download Calvin Klein cloth data to AWS S3
rake cloth_ck_ck:scrap                       # Scrap Calvin Klein cloth data
rake cloth_ck_mytheresa:s3_download          # Download Calvin Klein cloth data to AWS S3
rake cloth_ck_mytheresa:scrap                # Scrap Calvin Klein cloth data
rake cloth_ck_netaporter:s3_download         # Download Calvin Klein cloth data to AWS S3
rake cloth_ck_netaporter:scrap               # Scrap Calvin Klein cloth data
rake cloth_ck_yoox:s3_download               # Download Calvin Klein cloth data to AWS S3
rake cloth_ck_yoox:scrap                     # Scrap Calvin Klein cloth data
rake cloth_dg_dg:download                    # Download DolceGabbana cloth data on local disk
rake cloth_dg_dg:s3_download                 # Download DolceGabbana cloth data to AWS S3
rake cloth_dg_dg:scrap                       # Scrap Dolce Gabbana cloth data
rake cloth_dg_mytheresa:download             # Download DolceGabbana cloth data on local disk
rake cloth_dg_mytheresa:prepare              # Prepare DolceGabbana cloth data
rake cloth_dg_mytheresa:s3_download          # Download DolceGabbana cloth data to AWS S3
rake cloth_dg_mytheresa:scrap                # Scrap DolceGabbana cloth data
rake cloth_dg_netaporter:download            # Download DolceGabbana cloth data on local disk
rake cloth_dg_netaporter:prepare             # Prepare DolceGabbana cloth data
rake cloth_dg_netaporter:s3_download         # Download DolceGabbana cloth data to AWS S3
rake cloth_dg_netaporter:scrap               # Scrap DolceGabbana cloth data
rake cloth_dg_yoox:s3_download               # Download DolceGabbana cloth data to AWS S3
rake cloth_dg_yoox:scrap                     # Scrap DolceGabbana cloth data
rake cloth_dior_yoox:s3_download             # Download Dior cloth data to AWS S3
rake cloth_dior_yoox:scrap                   # Scrap Dior cloth data
rake cloth_etro_etro:s3_download             # Download Etro cloth data to AWS S3
rake cloth_etro_etro:scrap                   # Scrap Etro cloth data
rake cloth_etro_mytheresa:s3_download        # Download Etro cloth data to AWS S3
rake cloth_etro_mytheresa:scrap              # Scrap Etro cloth data
rake cloth_etro_netaporter:s3_download       # Download Etro cloth data to AWS S3
rake cloth_etro_netaporter:scrap             # Scrap Etro cloth data
rake cloth_etro_yoox:s3_download             # Download Etro cloth data to AWS S3
rake cloth_etro_yoox:scrap                   # Scrap Etro cloth data
rake cloth_fendi_fendi:download              # Download Fendi cloth data on local disk
rake cloth_fendi_fendi:prepare               # Prepare Fendi cloth data
rake cloth_fendi_fendi:s3_download           # Download Fendi cloth data to AWS S3
rake cloth_fendi_fendi:scrap                 # Scrap Fendi cloth data
rake cloth_fendi_mytheresa:download          # Download Fendi cloth data on local disk
rake cloth_fendi_mytheresa:prepare           # Prepare Fendi cloth data
rake cloth_fendi_mytheresa:s3_download       # Download Fendi cloth data to AWS S3
rake cloth_fendi_mytheresa:scrap             # Scrap Fendi cloth data
rake cloth_fendi_netaporter:download         # Download Fendi cloth data on local disk
rake cloth_fendi_netaporter:prepare          # Prepare Fendi cloth data
rake cloth_fendi_netaporter:s3_download      # Download Fendi cloth data to AWS S3
rake cloth_fendi_netaporter:scrap            # Scrap Fendi cloth data
rake cloth_fendi_yoox:s3_download            # Download Fendi cloth data to AWS S3
rake cloth_fendi_yoox:scrap                  # Scrap Fendi cloth data
rake cloth_givenchy_mytheresa:s3_download    # Download Givenchy cloth data to AWS S3
rake cloth_givenchy_mytheresa:scrap          # Scrap Givenchy cloth data
rake cloth_givenchy_netaporter:s3_download   # Download Givenchy cloth data to AWS S3
rake cloth_givenchy_netaporter:scrap         # Scrap Givenchy cloth data
rake cloth_givenchy_yoox:s3_download         # Download Givenchy cloth data to AWS S3
rake cloth_givenchy_yoox:scrap               # Scrap Givenchy cloth data
rake cloth_gucci_gucci:download              # Download Gucci cloth data on local disk
rake cloth_gucci_gucci:prepare               # Prepare Gucci cloth data
rake cloth_gucci_gucci:s3_download           # Download Gucci cloth data to AWS S3
rake cloth_gucci_gucci:scrap                 # Scrap Gucci cloth data
rake cloth_gucci_mytheresa:download          # Download Gucci cloth data on local disk
rake cloth_gucci_mytheresa:prepare           # Prepare Gucci cloth data
rake cloth_gucci_mytheresa:s3_download       # Download Gucci cloth data to AWS S3
rake cloth_gucci_mytheresa:scrap             # Scrap Gucci cloth data
rake cloth_gucci_netaporter:download         # Download Gucci cloth data on local disk
rake cloth_gucci_netaporter:prepare          # Prepare Gucci cloth data
rake cloth_gucci_netaporter:s3_download      # Download Gucci cloth data to AWS S3
rake cloth_gucci_netaporter:scrap            # Scrap Gucci cloth data
rake cloth_gucci_yoox:s3_download            # Download Gucci cloth data to AWS S3
rake cloth_gucci_yoox:scrap                  # Scrap Gucci cloth data
rake cloth_laperla_netaporter:download       # Download La Perla cloth data on local disk
rake cloth_laperla_netaporter:prepare        # Prepare La Perla cloth data
rake cloth_laperla_netaporter:s3_download    # Download La Perla cloth data to AWS S3
rake cloth_laperla_netaporter:scrap          # Scrap La Perla cloth data
rake cloth_lp_lp:download                    # Download La Perla cloth data on local disk
rake cloth_lp_lp:s3_download                 # Download LaPerla cloth data to AWS S3
rake cloth_lp_lp:scrap                       # Scrap La Perla cloth data
rake cloth_lp_yoox:s3_download               # Download LaPerla cloth data to AWS S3
rake cloth_lp_yoox:scrap                     # Scrap LaPerla cloth data
rake cloth_migrate:start                     # Migrate cloth data
rake cloth_migrate_dg:start                  # Migrate DolceGabbana cloth data
rake cloth_migrate_fendi:start               # Migrate Fendi cloth data
rake cloth_migrate_gucci:start               # Migrate Gucci cloth data
rake cloth_migrate_jc:start                  # Migrate Jimmy Choo cloth data
rake cloth_migrate_lp:start                  # Migrate La Perla cloth data
rake cloth_migrate_prada:start               # Migrate Prada cloth data
rake cloth_migrate_tf:start                  # Migrate Tom Ford cloth data
rake cloth_miumiu_miumiu:s3_download         # Download Miu Miu cloth data to AWS S3
rake cloth_miumiu_miumiu:scrap               # Scrap Miu Miu cloth data
rake cloth_miumiu_mytheresa:s3_download      # Download Miu Miu cloth data to AWS S3
rake cloth_miumiu_mytheresa:scrap            # Scrap Miu Miu cloth data
rake cloth_miumiu_netaporter:s3_download     # Download Miu Miu cloth data to AWS S3
rake cloth_miumiu_netaporter:scrap           # Scrap Miu Miu cloth data
rake cloth_miumiu_yoox:s3_download           # Download Miu Miu cloth data to AWS S3
rake cloth_miumiu_yoox:scrap                 # Scrap Miu Miu cloth data
rake cloth_moncler_moncler:s3_download       # Download Moncler cloth data to AWS S3
rake cloth_moncler_moncler:scrap             # Scrap Moncler cloth data
rake cloth_moncler_mytheresa:s3_download     # Download Moncler cloth data to AWS S3
rake cloth_moncler_mytheresa:scrap           # Scrap Moncler cloth data
rake cloth_moncler_netaporter:s3_download    # Download Moncler cloth data to AWS S3
rake cloth_moncler_netaporter:scrap          # Scrap Moncler cloth data
rake cloth_moschino_moschino:s3_download     # Download Moschino cloth data to AWS S3
rake cloth_moschino_moschino:scrap           # Scrap Moschino cloth data
rake cloth_moschino_netaporter:s3_download   # Download Moschino cloth data to AWS S3
rake cloth_moschino_netaporter:scrap         # Scrap Moschino cloth data
rake cloth_moschino_yoox:s3_download         # Download Moschino cloth data to AWS S3
rake cloth_moschino_yoox:scrap               # Scrap Moschino cloth data
rake cloth_prada_mytheresa:download          # Download Prada cloth data on local disk
rake cloth_prada_mytheresa:prepare           # Prepare Prada cloth data
rake cloth_prada_mytheresa:s3_download       # Download Prada cloth data to AWS S3
rake cloth_prada_mytheresa:scrap             # Scrap Prada cloth data
rake cloth_prada_netaporter:download         # Download Prada cloth data on local disk
rake cloth_prada_netaporter:prepare          # Prepare Prada cloth data
rake cloth_prada_netaporter:s3_download      # Download Prada cloth data to AWS S3
rake cloth_prada_netaporter:scrap            # Scrap Prada cloth data
rake cloth_prada_yoox:s3_download            # Download Prada cloth data to AWS S3
rake cloth_prada_yoox:scrap                  # Scrap Prada cloth data
rake cloth_rc_mytheresa:s3_download          # Download Roberto Cavalli cloth data to AWS S3
rake cloth_rc_mytheresa:scrap                # Scrap Roberto Cavalli cloth data
rake cloth_rc_netaporter:s3_download         # Download Roberto Cavalli cloth data to AWS S3
rake cloth_rc_netaporter:scrap               # Scrap Roberto Cavalli cloth data
rake cloth_rc_rc:s3_download                 # Download Roberto Cavalli cloth data to AWS S3
rake cloth_rc_rc:scrap                       # Scrap Roberto Cavalli cloth data
rake cloth_rc_yoox:s3_download               # Download Roberto Cavalli cloth data to AWS S3
rake cloth_rc_yoox:scrap                     # Scrap Roberto Cavalli cloth data
rake cloth_sl_mytheresa:s3_download          # Download Saint Laurent cloth data to AWS S3
rake cloth_sl_mytheresa:scrap                # Scrap Saint Laurent cloth data
rake cloth_sl_netaporter:s3_download         # Download Saint Laurent cloth data to AWS S3
rake cloth_sl_netaporter:scrap               # Scrap Saint Laurent cloth data
rake cloth_sl_sl:s3_download                 # Download Saint Laurent cloth data to AWS S3
rake cloth_sl_sl:scrap                       # Scrap Saint Laurent cloth data
rake cloth_sl_yoox:s3_download               # Download Saint Laurent cloth data to AWS S3
rake cloth_sl_yoox:scrap                     # Scrap Saint Laurent cloth data
rake cloth_tf_mytheresa:s3_download          # Download Tom Ford cloth data to AWS S3
rake cloth_tf_netaporter:s3_download         # Download Tom Ford cloth data to AWS S3
rake cloth_tf_tf:s3_download                 # Download Tom Ford cloth data to AWS S3
rake cloth_tf_yoox:s3_download               # Download Tom Ford cloth data to AWS S3
rake cloth_tf_yoox:scrap                     # Scrap Tom Ford cloth data
rake cloth_tomford_mytheresa:download        # Download TomFord cloth data on local disk
rake cloth_tomford_mytheresa:prepare         # Prepare Tom Ford cloth data
rake cloth_tomford_mytheresa:scrap           # Scrap Tom Ford cloth data
rake cloth_tomford_netaporter:download       # Download TomFord cloth data on local disk
rake cloth_tomford_netaporter:prepare        # Prepare TomFord cloth data
rake cloth_tomford_netaporter:scrap          # Scrap TomFord cloth data
rake cloth_tomford_tomford:download          # Download Tom Ford cloth data on local disk
rake cloth_tomford_tomford:scrap             # Scrap TomFord cloth data
rake cloth_valentino_mytheresa:s3_download   # Download Valentino cloth data to AWS S3
rake cloth_valentino_mytheresa:scrap         # Scrap Valentino cloth data
rake cloth_valentino_netaporter:s3_download  # Download Valentino cloth data to AWS S3
rake cloth_valentino_netaporter:scrap        # Scrap Valentino cloth data
rake cloth_valentino_valentino:s3_download   # Download Valentino cloth data to AWS S3
rake cloth_valentino_valentino:scrap         # Scrap Valentino cloth data
rake cloth_valentino_yoox:s3_download        # Download Valentino cloth data to AWS S3
rake cloth_valentino_yoox:scrap              # Scrap Valentino cloth data
rake cloth_versace_mytheresa:s3_download     # Download Versace cloth data to AWS S3
rake cloth_versace_mytheresa:scrap           # Scrap Versace cloth data
rake cloth_versace_netaporter:s3_download    # Download Versace cloth data to AWS S3
rake cloth_versace_netaporter:scrap          # Scrap Versace cloth data
rake cloth_versace_versace:s3_download       # Download Versace cloth data to AWS S3
rake cloth_versace_versace:scrap             # Scrap Versace cloth data
rake cloth_versace_yoox:s3_download          # Download Versace cloth data to AWS S3
rake cloth_versace_yoox:scrap                # Scrap Versace cloth data
----------------------------------------------------------------------------------------
rake shoes_armani_armani:s3_download         # Download Armani shoes data to AWS S3
rake shoes_armani_armani:scrap               # Scrap Armani shoes data
rake shoes_armani_yoox:s3_download           # Download Armani shoes data to AWS S3
rake shoes_armani_yoox:scrap                 # Scrap Armani shoes data
rake shoes_bb_bb:s3_download                 # Download Burberry shoes data to AWS S3
rake shoes_bb_bb:scrap                       # Scrap Burberry shoes data
rake shoes_bb_mytheresa:s3_download          # Download Burberry shoes data to AWS S3
rake shoes_bb_mytheresa:scrap                # Scrap Burberry shoes data
rake shoes_bb_netaporter:s3_download         # Download Burberry shoes data to AWS S3
rake shoes_bb_netaporter:scrap               # Scrap Burberry shoes data
rake shoes_bb_yoox:s3_download               # Download Burberry shoes data to AWS S3
rake shoes_bb_yoox:scrap                     # Scrap Burberry shoes data
rake shoes_chanel_chanel:s3_download         # Download Chanel shoes data to AWS S3
rake shoes_chanel_chanel:scrap               # Scrap Chanel shoes data
rake shoes_ck_ck:s3_download                 # Download Calvin Klein shoes data to AWS S3
rake shoes_ck_ck:scrap                       # Scrap Calvin Klein shoes data
rake shoes_ck_mytheresa:s3_download          # Download Calvin Klein shoes data to AWS S3
rake shoes_ck_mytheresa:scrap                # Scrap Calvin Klein shoes data
rake shoes_ck_yoox:s3_download               # Download Calvin Klein shoes data to AWS S3
rake shoes_ck_yoox:scrap                     # Scrap Calvin Klein shoes data
rake shoes_dg_dg:download                    # Download DolceGabbana shoes data on local disk
rake shoes_dg_dg:s3_download                 # Download DolceGabbana shoes data to AWS S3
rake shoes_dg_dg:scrap                       # Scrap Dolce Gabbana shoes data
rake shoes_dg_mytheresa:download             # Download DolceGabbana shoes data on local disk
rake shoes_dg_mytheresa:prepare              # Prepare DolceGabbana shoes data
rake shoes_dg_mytheresa:s3_download          # Download DolceGabbana shoes data to AWS S3
rake shoes_dg_mytheresa:scrap                # Scrap DolceGabbana shoes data
rake shoes_dg_netaporter:download            # Download DolceGabbana shoes data on local disk
rake shoes_dg_netaporter:prepare             # Prepare DolceGabbana shoes data
rake shoes_dg_netaporter:s3_download         # Download DolceGabbana shoes data to AWS S3
rake shoes_dg_netaporter:scrap               # Scrap DolceGabbana shoes data
rake shoes_dg_yoox:s3_download               # Download DolceGabbana shoes data to AWS S3
rake shoes_dg_yoox:scrap                     # Scrap DolceGabbana shoes data
rake shoes_dior_dior:s3_download             # Download Dior shoes data to AWS S3
rake shoes_dior_dior:scrap                   # Scrap Dior shoes data
rake shoes_dior_yoox:s3_download             # Download Dior shoes data to AWS S3
rake shoes_dior_yoox:scrap                   # Scrap Dior shoes data
rake shoes_etro_etro:s3_download             # Download Etro shoes data to AWS S3
rake shoes_etro_etro:scrap                   # Scrap Etro shoes data
rake shoes_etro_mytheresa:s3_download        # Download Etro shoes data to AWS S3
rake shoes_etro_mytheresa:scrap              # Scrap Etro shoes data
rake shoes_etro_netaporter:s3_download       # Download Etro shoes data to AWS S3
rake shoes_etro_netaporter:scrap             # Scrap Etro shoes data
rake shoes_etro_yoox:s3_download             # Download Etro shoes data to AWS S3
rake shoes_etro_yoox:scrap                   # Scrap Etro shoes data
rake shoes_fendi_fendi:download              # Download Fendi shoes data on local disk
rake shoes_fendi_fendi:prepare               # Prepare Fendi shoes data
rake shoes_fendi_fendi:s3_download           # Download Fendi shoes data to AWS S3
rake shoes_fendi_fendi:scrap                 # Scrap Fendi shoes data
rake shoes_fendi_mytheresa:download          # Download Fendi shoes data on local disk
rake shoes_fendi_mytheresa:prepare           # Prepare Fendi shoes data
rake shoes_fendi_mytheresa:s3_download       # Download Fendi shoes data to AWS S3
rake shoes_fendi_mytheresa:scrap             # Scrap Fendi shoes data
rake shoes_fendi_netaporter:download         # Download Fendi shoes data on local disk
rake shoes_fendi_netaporter:prepare          # Prepare Fendi shoes data
rake shoes_fendi_netaporter:s3_download      # Download Fendi shoes data to AWS S3
rake shoes_fendi_netaporter:scrap            # Scrap Fendi shoes data
rake shoes_fendi_yoox:s3_download            # Download Fendi shoes data to AWS S3
rake shoes_fendi_yoox:scrap                  # Scrap Fendi shoes data
rake shoes_givenchy_mytheresa:s3_download    # Download Givenchy shoes data to AWS S3
rake shoes_givenchy_mytheresa:scrap          # Scrap Givenchy shoes data
rake shoes_givenchy_netaporter:s3_download   # Download Givenchy shoes data to AWS S3
rake shoes_givenchy_netaporter:scrap         # Scrap Givenchy shoes data
rake shoes_givenchy_yoox:s3_download         # Download Givenchy shoes data to AWS S3
rake shoes_givenchy_yoox:scrap               # Scrap Givenchy shoes data
rake shoes_gr_gr:s3_download                 # Download Gianvito Rossi shoes data to AWS S3
rake shoes_gr_gr:scrap                       # Scrap Gianvito Rossi shoes data
rake shoes_gr_mytheresa:s3_download          # Download Gianvito Rossi shoes data to AWS S3
rake shoes_gr_mytheresa:scrap                # Scrap Gianvito Rossi shoes data
rake shoes_gr_netaporter:s3_download         # Download Gianvito Rossi shoes data to AWS S3
rake shoes_gr_netaporter:scrap               # Scrap Gianvito Rossi shoes data
rake shoes_gr_yoox:s3_download               # Download Gianvito Rossi shoes data to AWS S3
rake shoes_gr_yoox:scrap                     # Scrap Gianvito Rossi shoes data
rake shoes_gucci_gucci:download              # Download Gucci shoes data on local disk
rake shoes_gucci_gucci:prepare               # Prepare Gucci shoes data
rake shoes_gucci_gucci:s3_download           # Download Gucci shoes data to AWS S3
rake shoes_gucci_gucci:scrap                 # Scrap Gucci bags data
rake shoes_gucci_mytheresa:download          # Download Gucci shoes data on local disk
rake shoes_gucci_mytheresa:prepare           # Prepare Gucci shoes data
rake shoes_gucci_mytheresa:s3_download       # Download Gucci shoes data to AWS S3
rake shoes_gucci_mytheresa:scrap             # Scrap Gucci shoes data
rake shoes_gucci_netaporter:download         # Download Gucci shoes data on local disk
rake shoes_gucci_netaporter:prepare          # Prepare Gucci shoes data
rake shoes_gucci_netaporter:s3_download      # Download Gucci shoes data to AWS S3
rake shoes_gucci_netaporter:scrap            # Scrap Gucci shoes data
rake shoes_gucci_yoox:s3_download            # Download Gucci shoes data to AWS S3
rake shoes_gucci_yoox:scrap                  # Scrap Gucci shoes data
rake shoes_jc_mytheresa:s3_download          # Download Jimmy Choo shoes data to AWS S3
rake shoes_jc_netaporter:s3_download         # Download Jimmy Choo shoes data to AWS S3
rake shoes_jc_yoox:s3_download               # Download Jimmy Choo shoes data to AWS S3
rake shoes_jc_yoox:scrap                     # Scrap Jimmy Choo shoes data
rake shoes_jimmy_mytheresa:download          # Download Jimmy Choo shoes data on local disk
rake shoes_jimmy_mytheresa:prepare           # Prepare Jimmy Choo shoes data
rake shoes_jimmy_mytheresa:scrap             # Scrap Jimmy Choo shoes data
rake shoes_jimmy_netaporter:download         # Download Jimmy Choo shoes data on local disk
rake shoes_jimmy_netaporter:prepare          # Prepare Jimmy Choo shoes data
rake shoes_jimmy_netaporter:scrap            # Scrap Jimmy Choo shoes data
rake shoes_lp_lp:download                    # Download La Perla shoes data on local disk
rake shoes_lp_lp:s3_download                 # Download LaPerla shoes data to AWS S3
rake shoes_lp_lp:scrap                       # Scrap La Perla shoes data
rake shoes_lv_lv:s3_download                 # Download Louis Vuitton shoes data to AWS S3
rake shoes_lv_lv:scrap                       # Scrap Louis Vuitton shoes data
rake shoes_migrate:start                     # Migrate shoes data
rake shoes_migrate_dg:start                  # Migrate DolceGabbana shoes data
rake shoes_migrate_fendi:start               # Migrate Fendi shoes data
rake shoes_migrate_gucci:start               # Migrate Gucci shoes data
rake shoes_migrate_jc:start                  # Migrate Jimmy Choo shoes data
rake shoes_migrate_lp:start                  # Migrate La Perla shoes data
rake shoes_migrate_prada:start               # Migrate Prada shoes data
rake shoes_migrate_tf:start                  # Migrate Tom Ford shoes data
rake shoes_miumiu_miumiu:s3_download         # Download Miu Miu shoes data to AWS S3
rake shoes_miumiu_miumiu:scrap               # Scrap Miu Miu shoes data
rake shoes_miumiu_mytheresa:s3_download      # Download Miu Miu shoes data to AWS S3
rake shoes_miumiu_mytheresa:scrap            # Scrap Miu Miu shoes data
rake shoes_miumiu_netaporter:s3_download     # Download Miu Miu shoes data to AWS S3
rake shoes_miumiu_netaporter:scrap           # Scrap Miu Miu shoes data
rake shoes_miumiu_yoox:s3_download           # Download Miu Miu shoes data to AWS S3
rake shoes_miumiu_yoox:scrap                 # Scrap Miu Miu shoes data
rake shoes_moncler_moncler:s3_download       # Download Moncler shoes data to AWS S3
rake shoes_moncler_moncler:scrap             # Scrap Moncler shoes data
rake shoes_moncler_mytheresa:s3_download     # Download Moncler shoes data to AWS S3
rake shoes_moncler_mytheresa:scrap           # Scrap Moncler shoes data
rake shoes_moncler_netaporter:s3_download    # Download Moncler shoes data to AWS S3
rake shoes_moncler_netaporter:scrap          # Scrap Moncler shoes data
rake shoes_moschino_moschino:s3_download     # Download Moschino shoes data to AWS S3
rake shoes_moschino_moschino:scrap           # Scrap Moschino shoes data
rake shoes_moschino_yoox:s3_download         # Download Moschino shoes data to AWS S3
rake shoes_moschino_yoox:scrap               # Scrap Moschino shoes data
rake shoes_prada_mytheresa:download          # Download Prada shoes data on local disk
rake shoes_prada_mytheresa:prepare           # Prepare Prada shoes data
rake shoes_prada_mytheresa:s3_download       # Download Prada shoes data to AWS S3
rake shoes_prada_mytheresa:scrap             # Scrap Prada shoes data
rake shoes_prada_netaporter:download         # Download Prada shoes data on local disk
rake shoes_prada_netaporter:prepare          # Prepare Prada shoes data
rake shoes_prada_netaporter:s3_download      # Download Prada shoes data to AWS S3
rake shoes_prada_netaporter:scrap            # Scrap Prada shoes data
rake shoes_prada_prada:download              # Download Prada shoes data on local disk
rake shoes_prada_prada:prepare               # Prepare Prada shoes data
rake shoes_prada_prada:s3_download           # Download Prada shoes data to AWS S3
rake shoes_prada_prada:scrap                 # Scrap Prada shoes data
rake shoes_prada_yoox:s3_download            # Download Prada shoes data to AWS S3
rake shoes_prada_yoox:scrap                  # Scrap Prada shoes data
rake shoes_rc_rc:s3_download                 # Download Roberto Cavalli shoes data to AWS S3
rake shoes_rc_rc:scrap                       # Scrap Roberto Cavalli shoes data
rake shoes_rc_yoox:s3_download               # Download Roberto Cavalli shoes data to AWS S3
rake shoes_rc_yoox:scrap                     # Scrap Roberto Cavalli shoes data
rake shoes_sl_mytheresa:s3_download          # Download Saint Laurent shoes data to AWS S3
rake shoes_sl_mytheresa:scrap                # Scrap Saint Laurent shoes data
rake shoes_sl_netaporter:s3_download         # Download Saint Laurent shoes data to AWS S3
rake shoes_sl_netaporter:scrap               # Scrap Saint Laurent shoes data
rake shoes_sl_sl:s3_download                 # Download Saint Laurent shoes data to AWS S3
rake shoes_sl_sl:scrap                       # Scrap Saint Laurent shoes data
rake shoes_sl_yoox:s3_download               # Download Saint Laurent shoes data to AWS S3
rake shoes_sl_yoox:scrap                     # Scrap Saint Laurent shoes data
rake shoes_tf_mytheresa:s3_download          # Download Tom Ford shoes data to AWS S3
rake shoes_tf_netaporter:s3_download         # Download Tom Ford shoes data to AWS S3
rake shoes_tf_tf:s3_download                 # Download Tom Ford shoes data to AWS S3
rake shoes_tf_yoox:s3_download               # Download Tom Ford shoes data to AWS S3
rake shoes_tf_yoox:scrap                     # Scrap Tom Ford shoes data
rake shoes_tods_mytheresa:s3_download        # Download Tod's shoes data to AWS S3
rake shoes_tods_mytheresa:scrap              # Scrap Tod's shoes data
rake shoes_tods_netaporter:s3_download       # Download Tod's shoes data to AWS S3
rake shoes_tods_netaporter:scrap             # Scrap Tod's shoes data
rake shoes_tods_tods:s3_download             # Download Tod's shoes data to AWS S3
rake shoes_tods_tods:scrap                   # Scrap Tod's shoes data
rake shoes_tods_yoox:s3_download             # Download Tod's shoes data to AWS S3
rake shoes_tods_yoox:scrap                   # Scrap Tod's shoes data
rake shoes_tomford_mytheresa:download        # Download TomFord shoes data on local disk
rake shoes_tomford_mytheresa:prepare         # Prepare TomFord shoes data
rake shoes_tomford_mytheresa:scrap           # Scrap Tom Ford shoes data
rake shoes_tomford_netaporter:download       # Download TomFord shoes data on local disk
rake shoes_tomford_netaporter:prepare        # Prepare TomFord shoes data
rake shoes_tomford_netaporter:scrap          # Scrap TomFord shoes data
rake shoes_tomford_tomford:download          # Download Tom Ford shoes data on local disk
rake shoes_tomford_tomford:scrap             # Scrap TomFord shoes data
rake shoes_valentino_mytheresa:s3_download   # Download Valentino shoes data to AWS S3
rake shoes_valentino_mytheresa:scrap         # Scrap Valentino shoes data
rake shoes_valentino_netaporter:s3_download  # Download Valentino shoes data to AWS S3
rake shoes_valentino_netaporter:scrap        # Scrap Valentino shoes data
rake shoes_valentino_valentino:s3_download   # Download Valentino shoes data to AWS S3
rake shoes_valentino_valentino:scrap         # Scrap Valentino shoes data
rake shoes_versace_mytheresa:s3_download     # Download Versace shoes data to AWS S3
rake shoes_versace_mytheresa:scrap           # Scrap Versace shoes data
rake shoes_versace_versace:s3_download       # Download Versace shoes data to AWS S3
rake shoes_versace_versace:scrap             # Scrap Versace shoes data
rake shoes_versace_yoox:s3_download          # Download Versace shoes data to AWS S3
rake shoes_versace_yoox:scrap                # Scrap Versace shoes data
