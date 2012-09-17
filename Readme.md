# Hare

Experimental web server written in Ruby. This is a toy project that I'm
using as a learning tool. It (eventually) interfaces with Rack directly.
The goal is to be Rails and Sinatra compatible.

### General Direction

The server will be 100% Ruby, including the parser. The first version
will not support file uploads, transfer encodings, etc, but it will
rather be the most simplistic implementation that is good enough for
dealing with simple requests through Sinatra or Rails.

After v1 is done, a general design decision will be takes by taking into
consideration some benchmarks and a range of http 'features' by I'd like
to implement.

### Status of this project

This project is not usable in any way yet. It's still very very alpha
yet and many core components have still to be built.

### TODO

These are things that I plan of working on.

#### Http Parser:

* Parse multiline headers
* Parse body
