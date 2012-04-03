The standard Unix toolset is line-based.  This is great when you data is
structured as lines, but not so much otherwise.

One solution to this is to have object pipelines; this is what [PowerShell]
does.  I'm lazy, though, and don't really want to learn a new shell or rewrite
all these utilities to use objects.  I also don't use Windows.  *Note: if
Windows-specific is your reason to not use PowerShell, take a look at [Pash], a
port to a number of other systems.*

[PowerShell]: http://en.wikipedia.org/wiki/Powershell
[Pash]: http://pash.sourceforge.net/

`lineify` will compress your text-based objects down into one line per object;
`unlineify` will expand them back.  These two commands bookend your pipechain,
so

    $> ./foo | grep | awk | sed

becomes

    $> ./foo | lineify | grep | awk | sed | unlineify

# Parsers

Defining a parser should be easy.  Let's look at a Tomcat error log:

	Mar 28, 2012 12:36:56 PM org.apache.catalina.core.ApplicationContext log
	SEVERE: Exception while dispatching incoming RPC call
	com.google.gwt.user.server.rpc.UnexpectedException: Service method 'public abstract java.util.Collection edu.calpoly.csc.scheduler.view.web.client.GreetingService.getAllOriginalDocuments()' threw an unexpected exception: java.util.NoSuchElementException
		at com.google.gwt.user.server.rpc.RPC.encodeResponseForFailure(RPC.java:385)
		at com.google.gwt.user.server.rpc.RPC.invokeAndEncodeResponse(RPC.java:588)
		at com.google.gwt.user.server.rpc.RemoteServiceServlet.processCall(RemoteServiceServlet.java:208)
		at com.google.gwt.user.server.rpc.RPC.invokeAndEncodeResponse(RPC.java:569)
		... 17 more

Our parse-file should look something like this:

	\w+ \d+, \d+ [\d:]+ .*
	[A-Z]+: .*
	        at .*
	        [...]
	        \.\.\. \d+ more

Standard regex stuff for the most part.  There's one special thing, though: a
line that contains nothing but whitespace and `[...]` will match any number of
lines until the following line.  If there *is* no following line, it'll stop
matching when the first line of the parser is matched again or the end of the
file is reached.

Put this in `$HOME/.config/lineify/parsers/tomcat` and use (un)lineify with `-p
tomcat`.

