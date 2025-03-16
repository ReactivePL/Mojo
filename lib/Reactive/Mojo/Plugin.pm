package Reactive::Mojo::Plugin;

use 5.006;
use strict;
use warnings;

use Mojo::Base 'Mojolicious::Plugin';

use Reactive::Core;
use Reactive::Mojo::TemplateRenderer;

=head1 NAME

Reactive::Mojo::Plugin - Mojolicious plugin for Reactive

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Register the plugin in startup method of your Mojolicious App

It takes `namespaces` configuration param which should be an arrayref of the namespaces within your app to scan for Reactive components

sub startup ($self) {
    ...
    $self->secrets($config->{secrets});

    $self->plugin(
        'Reactive::Mojo::Plugin',
        {
            namespaces => [
                'My::App::Components',
            ],
        },
    );
    ...

Then within you templates you can use a component like

<%= reactive('Counter') %>

or if there is initial state you want to set

<%= reactive('Counter', value => 10) %>

see Reactive::Core and Reactive::Examples for more information about creating components

=cut

sub register {
    my $self = shift;
    my $app = shift;
    my $conf = shift;

    my $renderer = Reactive::Mojo::TemplateRenderer->new(
        app => $app,
    );

    my $reactive = Reactive::Core->new(
        template_renderer => $renderer,
        secret => $app->secrets->[0],
        component_namespaces => $conf->{namespaces} // [],
    );

    $app->helper(reactive => sub {
        my ($c, $component, %args) = @_;
        return $reactive->initial_render($component, %args);
    });

    $app->routes->post('/reactive' => sub {
        my $c = shift;

        my $data = $c->req->json;

        $c->render(
            json => $reactive->process_request($data)
        );
    });
}

=head1 AUTHOR

Robert Moore, C<< <robert at r-moore.tech> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-reactive-mojo at rt.cpan.org>, or through
the web interface at L<https://rt.cpan.org/NoAuth/ReportBug.html?Queue=Reactive-Mojo>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Reactive::Mojo::Plugin


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<https://rt.cpan.org/NoAuth/Bugs.html?Dist=Reactive-Mojo>

=item * CPAN Ratings

L<https://cpanratings.perl.org/d/Reactive-Mojo>

=item * Search CPAN

L<https://metacpan.org/release/Reactive-Mojo>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2025 by Robert Moore.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)


=cut

1; # End of Reactive::Mojo
