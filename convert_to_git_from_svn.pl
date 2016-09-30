use strict;
use warnings;
use 5.010;
use Path::Tiny qw(path);
use File::Basename;
my $filename = 'repository-list.txt';
my @projects = path($filename)->lines_utf8( { chomp => 1 } );

foreach my $project (@projects) {
    my $basename = basename($project);
    my @local_dir = path($basename.'.txt')->lines_utf8( { chomp => 1 } );
    foreach my $dir (@local_dir)
    {
        say qq{git svn clone -s --no-minimize-url --authors-file=authors.txt http://vcs/svn/$basename/$dir $basename/$dir};
    }
}
