SciSci
========

SciSci is a note taking application that collects notes into ideas, rathern than by sources. By doing this, you can focus on the content of your research, rather than trying to remember where you learned certain facts.
You can access the site at http://www.SciSciNotes.com

Development 
-----

Development is in two sections. On the local machine, the branches ' local\_development, master ' should exist. On the server, there should be * development, master * .

 All development should take place on `local_development`, tested throroughly, and then merged into local `master`. Then, push local `master` to server `development` for testing on the production server.

 Use `bundle exec rackup` to open a new instance on port `9292`. This will allow for testing on the production server while still maintaining integrity. Then, you can merge `development` into `master`, issue `service nginx restart`, and all changes should be propogated accordingly.

Deployment
--------
Setup Passenger and Nginx according to their tutorials on the Passenger website. The owner of `config.ru` is who executes the rest of the program, so be sure all assets and things are accessible to that owner (`chown username file.ext` or `chown -R username directory/`). This is especially useful if there is a error similar to "trying to execute in a read-only database". 
