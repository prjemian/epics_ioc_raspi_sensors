# FILENAME...	release.pl
#
# USAGE... This PERL script is used in conjunction with a start_epics_xxx
#          script to setup environment variables for medm.  It defaults to
#          csh output, but a switch enables bash output (second form below).
#
# ORIGINAL AUTHOR: Ron Sluiter
# 
# SYNOPSIS...	perl release.pl (<ioctop> directory)
#               perl -s release.pl -form=bash (<ioctop> directory)  
#
#
#
# MODIFICATION LOG...
# 03/25/04 rls Support for GATEWAY environment variable.
# 04/08/04 rls Bug fix for spaces between macro and '=' sign; e.g. MPF = /home/mpf.
# 01/25/08 rls Support "include" entries without a macro; e.g. "include /home/ioc/configure/MASTER_RELEASE"
# 01/29/08 rls Bug fix; "($macro) =" line is wrong.
# 04/06/11 daa Add bash output format support.
# 03/20/15 kcl Rewrite to use recursive function, allows in-place resolution of included files

#
#Version:	$Revision: 2.0 $
#Modified By:	$Author: klang $
#Last Modified:	$Date: 2011-04-06 20:39:55 $

use Env;

$top = $ARGV[0];

sub Parse
{	
	my ($file, $applications) = @_;	
	
	if (-r "$file")
	{
		open(my $fh, "$file") or die "Cannot open $file\n";
		
		while ($line = <$fh>)
		{			
			next if ( $line =~ /\s*#/ );
			
			chomp($line);
			$_ = $line;
			
			#test for "include" command
			($prefix,$post) = /(.*)\s* (.*)/;
			
			if ($prefix eq "include")
			{
				($prefix,$macro,$post) = /(.*)\s* \s*\$\((.*)\)(.*)/;
				
				if ($macro eq "")
				{
					#true if no macro is present
					#the following looks for
					#prefix = post
					($prefix,$post) = /(.*)\s* \s*(.*)/;
				}
				else
				{
					$base = $applications{$macro};
				
					if ($base eq "")
					{
						#print "error: $macro was not previously defined\n";
					}
					else
					{
						$post = $base . $post;
					}
				}
				
				Parse($post, $applications);
			}
			else
			{
				#the following looks for
				#prefix = $(macro)post
				($prefix,$macro,$post) = /(.*)\s*=\s*\$\((.*)\)(.*)/;
				
				if ($macro eq "")
				{
					#true ifno macro is present
					#the following looks for
					#prefix = post
					($prefix,$post) = /(.*)\s*=\s*(.*)/;
				}
				else
				{
					$base = $applications{$macro};
					
					if ($base eq "")
					{
						#print "error: $macro was not previously defined\n";
					}
					else
					{
						$post = $base . $post;
					}
				}
				
				$prefix =~ s/^\s+|\s+$//g; # strip leading and trailing whitespace.
				
				if ("$prefix" ne "")
				{
					$applications{"$prefix"} = "$post";
				}
			}
		}
		
		close $fh;
    }
}

my $applications;

$applications{"TOP"} = $top;

if ($ENV{GATEWAY} ne "")
{
    # Add GATEWAY to macro list.
    $applications{GATEWAY} = $ENV{GATEWAY};
}

$format = 0;
if ($form eq "bash")
{
    $format = 1;
}

Parse("$top/configure/RELEASE", $applications);

foreach $key (keys %applications)
{
	if ($format == 1)
	{
		print "$key=$applications{$key}\n";
	}
	else
	{
		print "set $key = $applications{$key}\n";
	}
}
