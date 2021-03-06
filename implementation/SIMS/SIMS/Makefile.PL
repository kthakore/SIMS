#!/usr/bin/env perl
# IMPORTANT: if you delete this file your app will not work as
# expected.  You have been warned.
use inc::Module::Install;
use Module::Install::Catalyst;    # Complain loudly if you don't have

# Catalyst::Devel installed or haven't said
# 'make dist' to create a standalone tarball.

name 'SIMS';
all_from 'lib/SIMS.pm';

requires 'Catalyst::Runtime' => '5.80029';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'Catalyst::Plugin::Authentication';
requires 'Catalyst::Plugin::Authorization::Roles';
requires 'Catalyst::Plugin::StackTrace';
requires 'Catalyst::Plugin::Session';
requires 'Catalyst::Plugin::Session::Store::Memcached';
requires 'Catalyst::Plugin::Session::State::Cookie';
requires 'Catalyst::Authentication::Store::DBIx::Class';
requires 'DBIx::Class::TimeStamp';
requires 'DBIx::Class::EncodedColumn';
requires 'Email::Simple::Creator';
requires 'Email::Sender::Simple';
requires 'Email::Sender::Transport::SMTP::TLS';
requires 'Try::Tiny';
requires 'SDL';
requires 'DBD::Pg';
requires 'Moose';
requires 'MooseX::NonMoose';
requires 'namespace::autoclean';
requires 'Class::Method::Modifiers';
requires 'DateTime::Format::DateParse';
requires 'Catalyst::View::TT';
requires 'Catalyst::Helper::View::PDF::Reuse';
requires
  'Config::General';  # This should reflect the config file format you've chosen

# See Catalyst::Plugin::ConfigLoader for supported formats
test_requires 'Test::More' => '0.88';
catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;


