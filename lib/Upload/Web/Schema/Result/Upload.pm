package Upload::Web::Schema::Result::Upload;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

Upload::Web::Schema::Result::Upload

=cut

__PACKAGE__->table("upload");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 md5

  data_type: 'text'
  is_nullable: 0

=head2 fname

  data_type: 'text'
  is_nullable: 0

=head2 download

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 max_download

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "md5",
  { data_type => "text", is_nullable => 0 },
  "fname",
  { data_type => "text", is_nullable => 0 },
  "download",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "max_download",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-07-04 22:48:02
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:OoAUMaSX7lJH/7isPmfc7w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
