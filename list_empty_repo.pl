#!/usr/bin/env perl
use strict;
use warnings;
use 5.010;
use Path::Tiny qw(path);
use File::Basename;

# See http://search.cpan.org/~rclamp/File-Find-Rule-0.32/README
use File::Find::Rule;

my $filename = 'repository-list.txt';
my @projects = path($filename)->lines_utf8( { chomp => 1 } );

foreach my $project (@projects) {
    my $basename = basename($project);
    my @local_dir = path( $basename . '.txt' )->lines_utf8( { chomp => 1 } );
    foreach my $dir (@local_dir) {

        # my @paths = read_dir( '/path/to/dir', prefix => 1 ) ;
        list_dir(qq{$basename/$dir});

# say qq{git svn clone -s --no-minimize-url --authors-file=authors.txt http://vcs/svn/$basename/$dir $basename/$dir};
    }
}

sub list_dir {

# If a base directory was not past to the script, assume current working director
    my ($base_dir) = @_;                     #shift // '.';
    my $find_rule = File::Find::Rule->new;

    # Do not descend past the first level
    $find_rule->maxdepth(1);

    # Only return directories
    $find_rule->directory;
    # my @sub_dirs     = ();
    # my @exclude_dirs = qw($base_dir);

    # $find_rule->or(
    # $find_rule->new->directory->name(@exclude_dirs)->prune->discard,
    # $find_rule->new );

    # Apply the rule and retrieve the subdirectories
    # @sub_dirs = $find_rule->in($base_dir);
    my @sub_dirs =File::Find::Rule
	->mindepth(1)
	->maxdepth(1)
	->not_name($base_dir)
	# ->directory
	->in($base_dir);

    my $dirs = @sub_dirs + 0;

    # Print out the name of each directory on its own line
    if ( $dirs == 1 ) {
        # say qq{\$base_dir : $base_dir: $dirs } . join( "\n", @sub_dirs );
        say qq{$base_dir};
    }

    # print join( "\n", @sub_dirs );
}
