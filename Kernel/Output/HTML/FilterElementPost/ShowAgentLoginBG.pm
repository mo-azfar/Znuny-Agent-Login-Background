# --
# Copyright (C) 2001-2024 OTRS AG, https://otrs.com/
# --
# $origin: otrs - 0000000000000000000000000000000000000000 - Kernel/Output/HTML/FilterElementPost/ShowAgentLoginBG.pm
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::FilterElementPost::ShowAgentLoginBG;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
);

use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# ---
    # Agent Login Background
# ---
    if ( $Param{TemplateFile} eq 'Login' )
    {
        if ( defined $ConfigObject->Get('AgentLoginBackground') )
        {
            my %AgentLoginBackground = %{ $ConfigObject->Get('AgentLoginBackground') };
            my %Data;

            for my $CSSStatement ( sort keys %AgentLoginBackground ) {
                if ( $CSSStatement eq 'BackgroundURL' ) {
                    my $WebPath = '';
                    if ( $AgentLoginBackground{$CSSStatement} !~ /(http|ftp|https):\//i ) {
                        $WebPath = $ConfigObject->Get('Frontend::WebPath');
                    }
                    $Data{'BackgroundURL'} = 'url(' . $WebPath . $AgentLoginBackground{$CSSStatement} . ')';
                }
                else {
                    $Data{$CSSStatement} = $AgentLoginBackground{$CSSStatement};
                }
            }

            my $CSS = qq~<style type="text/css">
            .LoginBG {
                width: $Data{'BackgroundWidth'};
                height: $Data{'BackgroundHeight'};
                background: $Data{'BackgroundURL'};
                background-position: $Data{'BackgroundPosition'};
                background-repeat: $Data{'BackgroundRepeat'};
                background-attachment: $Data{'BackgroundAttachment'};
                background-size: $Data{'BackgroundSize'};
            }
            </style>
            ~;

            #set background class on app wrapper
            my $SearchField1 = quotemeta "<div id=\"AppWrapper\">";
            my $ReturnField1 = qq~$CSS <div id="AppWrapper" class="LoginBG">
            ~;

            #search and replace
            ${ $Param{Data} } =~ s{$SearchField1}{$ReturnField1};

            #set mainbox to have transparent background
            my $SearchField2 = quotemeta " <div class=\"MainBox ARIARoleMain\">";
            my $ReturnField2 = qq~ <div class="MainBox ARIARoleMain" style="background:transparent;">
            ~;

            #search and replace
            ${ $Param{Data} } =~ s{$SearchField2}{$ReturnField2};

            my %AgentLoginAlert = %{ $ConfigObject->Get('AgentLoginAlert') };

            if ( $AgentLoginAlert{'Alert'} )
            {
                my $SearchAlert = quotemeta "<div class=\"WidgetSimple\">";
                my $ReturnAlert
                    = qq~<div class="MessageBox WithIcon" id="Alert" style="background-color: $AgentLoginAlert{'AlertBackground'}; color: $AgentLoginAlert{'AlertTextColor'}; margin-bottom: 15px;"><p>$AgentLoginAlert{'AlertText'}</p></div>
                <div class="WidgetSimple">
                ~;

                #search and replace
                ${ $Param{Data} } =~ s{$SearchAlert}{$ReturnAlert};
            }

            # add background color to maintenance text / warning box
            my $SearchField3 = quotemeta "<div class=\"MessageBox WithIcon\" id=\"SystemMaintenance\">";
            my $ReturnField3
                = qq~<div class="MessageBox WithIcon" id="SystemMaintenance" style="background-color:#deb887;">
            ~;

            #search and replace
            ${ $Param{Data} } =~ s{$SearchField3}{$ReturnField3};

            #color
            my %AgentLoginBackgroundColor = %{ $ConfigObject->Get('AgentLoginBackgroundColor') };

            #check if login form color need to be change
            if ( $AgentLoginBackgroundColor{'AgentLoginFormBackground'} )
            {
                #set agent login form background and border color
                my $SearchField4 = quotemeta "<div class=\"WidgetSimple\">";
                my $ReturnField4
                    = qq~<div class="WidgetSimple" style="background: $AgentLoginBackgroundColor{'AgentLoginFormBackground'}; border: $AgentLoginBackgroundColor{'AgentLoginFormBorder'};">
                ~;

                #search and replace
                ${ $Param{Data} } =~ s{$SearchField4}{$ReturnField4};

                #search and replace for another widget simple. Especially for forgot password section.
                ${ $Param{Data} } =~ s{$SearchField4}{$ReturnField4};
            }

            #check if label color need to be change
            if ( $AgentLoginBackgroundColor{'AgentLabelColor'} )
            {
                #set agent login username, password and 2fa label color
                for my $Label (qw( User Password TwoFactorToken ))
                {
                    my $SearchField5 = quotemeta "<label for=\"$Label\" class=\"Mandatory\">";
                    my $ReturnField5
                        = qq~<label for="$Label" class="Mandatory" style="color: $AgentLoginBackgroundColor{'AgentLabelColor'}">
                    ~;
                    ${ $Param{Data} } =~ s{$SearchField5}{$ReturnField5};
                }

                #non mandatory 2fa field
                my $SearchField6 = quotemeta "<label for=\"TwoFactorToken\" class=\"\">";
                my $ReturnField6
                    = qq~<label for="TwoFactorToken" style="color: $AgentLoginBackgroundColor{'AgentLabelColor'}">
                ~;
                ${ $Param{Data} } =~ s{$SearchField6}{$ReturnField6};

                #Username field for forgot password section
                my $SearchField7 = quotemeta "<label class=\"\" for=\"PasswordUser\" class=\"Mandatory\">";
                my $ReturnField7
                    = qq~<label class="" for="PasswordUser" class="Mandatory" style="color: $AgentLoginBackgroundColor{'AgentLabelColor'}">
                ~;
                ${ $Param{Data} } =~ s{$SearchField7}{$ReturnField7};
            }

            if ( $AgentLoginBackgroundColor{'AgentMOTDBackground'} )
            {
                #set motd background and border color
                my $SearchField8
                    = quotemeta "<div class=\"WidgetSimple MessageOfTheDayBox\" id=\"MessageOfTheDayBox\">";
                my $ReturnField8
                    = qq~<div class="WidgetSimple MessageOfTheDayBox" id="MessageOfTheDayBox" style="background: $AgentLoginBackgroundColor{'AgentMOTDBackground'}; border: $AgentLoginBackgroundColor{'AgentMOTDBorder'};">
                ~;

                #search and replace
                ${ $Param{Data} } =~ s{$SearchField8}{$ReturnField8};
            }

        }

    }

# ---

    return 1;
}

1;
