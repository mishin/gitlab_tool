use v5.10;
use warnings FATAL => 'all';
use strict;
use Try::Tiny;
use GitLab::API::v3;
use GitLab::API::v3::Constants qw( :all );
my $v3_api_url = 'http://perl.com/api/v3/';
my $token = 'gitlab_secret_token';

my $api = GitLab::API::v3->new(
    url   => $v3_api_url,
    token => $token,
);

use Path::Tiny qw(path);
use File::Basename;
my $filename = 'repository-list.txt';
my @projects = path($filename)->lines_utf8( { chomp => 1 } );

my $filename_empty_repo = 'empty_repo.txt';
my @projects_empty_repo =
  path($filename_empty_repo)->lines_utf8( { chomp => 1 } );
my %hash_projects_empty_repo;
@hash_projects_empty_repo{@projects_empty_repo} =
  (1) x scalar(@projects_empty_repo);

foreach my $project (@projects) {
    my $basename = basename($project);
    my @local_dir = path($basename.'.txt')->lines_utf8( { chomp => 1 } );
    foreach my $dir (@local_dir)
    {
	if ( !$hash_projects_empty_repo{"$basename/$dir"} ) { 
        say qq{cd \${MAIN}/$basename/$dir};
        say qq{git remote add origin git\@perl.com:$basename/$dir.git};
        say qq{git add -A};
        say qq{git commit -m 'migrating to git'};
        say qq{git push origin master};
		}
    }
}
#
#my @projects = qw(VTB
#Directum
#C24
#2015
#ESB.SCAN_WS
#Services
#Bank2_22);

#foreach my $project (@projects) {
##    create_repository ( $project);
#}
sub get_group_id {
    my ($group_name) = @_;
    my $group_id;
    my $groups = $api->groups();
    for my $group (@{$groups}) {
        if ($group->{name} eq $group_name) {
            $group_id = $group->{id};
        }
    }
    return $group_id;
}



sub create_repository {
    my ($project_name, $group_id) = @_;
    my %params = (
        name             => $project_name,
        namespace_id     => $group_id,
        path             => $project_name,
        visibility_level => $GITLAB_VISIBILITY_LEVEL_INTERNAL);

    try {
            my $project = $api->create_project(
                \%params,
            );
        } catch {
                warn "caught error: $_"; # not $@
            };
}