pasty-experiment
################

Pasty is a hypothetical paste tool where users can can store plain text (like
source code snippets) to be shared later on. Needless to say that this project
is just a humble - and small - experiment I worked on while experimenting Ruby
on Rails.

.. contents:: Table of Contents
  :local:

Main requirements
=================

* Ruby_ 2.5+
* PostgreSQL_
* Node_ 11.0+ (for development only)

Development setup
=================

Quickstart
----------

You can install the project locally using the following commands:

.. code-block:: shell

  $ git clone https://github.com/ellmetha/pasty-experiment && cd pasty-experiment
  $ bin/setup

The ``bin/setup`` script will install the required dependencies (gems using
bundler and node modules using yarn), create a local copy of the
``database.yml`` file and setup the database (create, migrate and seet it).

Once this is done you can run the develpent server using the following command:

.. code-block:: shell

  $ bundle exec rails s

(or you can also use the ``bin/rails s`` shortcut)

Congrats, you're in! The development server should now be accessible at http://127.0.0.1:3000.

Frontend developments
---------------------

This project use Webpack_ and Webpacker_ to bundle the assets of the
application. Client-side scripts and stylesheets are respectively written using
**vanilla JS** and Sass_. By now all the tools necessary to work on the assets
of this project should've been installed (the ``bin/setup`` command normally
should've taken care of it - otherwise it is still possible to do a quick
``yarn install``).

In development, Webpacker will compile bundle automatically. That being said,
it is possible to use a hot reloading server if you need to make frequent
changes to the asset files. To use hot reloading, all you have to do is to
launch a Webpack dev server as follows and then launch your Rails development
server in another terminal:

.. code-block:: shell

  $ bin/webpack-dev-server
  $ bin/rails s  # into another terminal

Running the test suite
======================

The test suite can be run using the following command:

.. code-block:: shell

  $ bin/rails test

For code coverage, the following command can be used:

.. code-block:: shell

  $ bin/rails test:coverage

Code quality checks can be triggered using the following command:

  $ bin/rubocop

.. _Node: https://nodejs.org
.. _PostgreSQL: https://www.postgresql.org
.. _Ruby: https://www.ruby-lang.org
.. _Sass: http://sass-lang.com
.. _Webpack: https://webpack.js.org
.. _Webpacker: https://github.com/rails/webpacker
