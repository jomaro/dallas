# Why Dallas?

Dallas is a project inspired on Houston, an internal tool used by [EBANX](https://www.ebanx.com/en/) where I've worked for some years.

But what has made me like it so much that I decided to make a copy of it? Two things:

 - It's absurdly simple. The details are on the [README](https://github.com/jomaro/dallas) on how to create a new tool, with very minimal boilerplate
 - It's infinitely extensible, because code is infinitelly extensible. 


Also, I think this project is about responsibility and culture.

It's about the [Broken Window Theory](https://blog.codinghorror.com/the-broken-window-theory/) and not letting things get into a state
of disrepair that will cause a team to slowly disregard problems more and more until your software starts to rot.


## General lines of advice

- Monitor proactively, if you caught the issue, it may not be a problem. If your customer had to warn you about it, it's already a failure.

- Involve ALL of your team in platform monitoring. All developers should be able o operate the tool you use.

- Foster a culture of care and excellency.

- Keep your monitoring visible. People should be reminded by their environment that the platform health is everybody's responsibility.
There should be no "it's their task to fix the problem".

- Take advantage of the folder structure to divide the measurements of your teams and products.

- If you work on offices having TVs is really nice.

- Had an incident?
  - Create a new instrument to document to devs the faulty conditions the system has reached. 
Keep the code simple, as simple as possible. If the instrument is directed to developers they will probably be able to understand
what the problem is just by seeing the output and taking a look into the code. 
Unless the code is very complicated, you must focus on documenting the "why" of something being monitored, the what should be clear.

  - If the instrument is directed to non technical users you should be very explicit on what the issue is. 
For simplicity sake, Dallas is very limited on how it present information (a color status, a value and a big blob of text),
the lack of advanced tools and charts may seen like a limitation but most information can be conveyed through text with some effort.

- As the team achieve higher standards for incident management, include a "future preventions" section with tasks to ensure the same
failure does not happen again. You don't need to be perfect. You don't need to solve all the problems of the world. 
You need to ensure this specific problem will not hit us again. Think of it like a vaccine and antibodies.

- It may not seem like you're doing an astronomical progress, but ensure every day there is one less door from which chaos
may reach us. And with time, these doors will add up, people will start to see and the culture will follow.

- Do not deploy it together with your monitored application. Actually, make an effort to ensure they do not share a "single
point of failure" so preferably, deploy them in wildly different ways. You should always have at least one of them working.
The system is down? We should have the monitoring tools to guide ourselves towards a recovery. The monitoring system is down?
Let's block deploys, it is not a good moment to be inserting more features on the system if we are blind to it's bugs.

- Queues are for resources, not for teams.
Think of a database, even if you are running your queries against a replica running everything at the same time may kill it.
So use queues to limit how much stress you are willing to put into that resource.
So you should create one queue for resource, not one queue for team.
If an instrument access more than one resource one should put it in the queue of the most critical one.

- Create your internal framework. From experience, most instruments will follow same same 6/7 patterns.
Refactor it to make them easier to use. E.g. a function that mounts a `Measurement` struct from an `Ecto.Result`
where the value is the amount of lines, and the level `:error` is if there are results.


## How do I known if I should create an instrument to monitor aspect "X"?

It's mostly about risk. Things that are low damage but very common are good candidates to be covered by an instrument.
Also are things that do not happen frequently but have a high risk associated to it.

But it's also about taking the things out of your head.

Engineers heads are expensive pieces of real estate. Productivity is often about being able to keep a mental 
model of the system we are working on. Removing lateral worries is important to keep people focused.

This is a chance to free yourself from worries about that problem that comes back every quarter and gets you one 
unsatisfied customer every time.


## Instrument ideas

- Document your infra. Describe the resources you use on cloud providers and double check that they have in fact the correct configuration.
Particularly if it has happened that some cloud engineer decided to activate some flag thinking "this couldn't possibly have a bad effect right?".
E.g. for the love of good ensure Redis has "cluster mode" turned of because the client we use does not support it. 
Or, ensure all redis instances used are business class and have persistence or replication turned on.
Or, ensure DB/cache instances are not running on deprecated hardware generations.

- Monitor broken indexes in your database.

- Take a page from your accountant's book. It's not a popular idea on software development, but "double-entry bookkeeping" is a very powerful tool.
Of course you should never duplicate complex business logic, but when something is very important, it's worth to write it twice and compare the values
to ensure it has not changed inadvertently.

- Watch for tables that should have the same content across environments. Very useful for Bulkhead architectures.

- Run a quick reconciliation process on your partners. Just check if the volume processed on your side is the same as a count on their platform.

- Same thing with ETL tools, just count and sum both sides to be sure nothing egregious happened.

- Double check your infra uptime. Our memcached cluster has rebooted in the middle of the night? Something should be red, no need to panic, 
but we surely would appreciate the heads-up.

- Ensure your deploy is working. Compare the git hash from github with the one being returned from your check endpoints. 
Who never had a deploy failing because of a migration failed to run?

- Create metrics for progress and completion of your project. Actually... don't. 
You probably shouldn't do it on your monitoring platform, but you have a TV screen that your team is already accustomed to look at right?
You could use it to unsure the metrics are not worse today than they were yesterday, it is not pretty, nut everybody has to do some rush
job from time to time.

- Create a `Watchdog.signal("john.smith", "unique_descriptive_text")` on your monitored platform that generates a warning log every time it's called. 
Then create an instrument on Dallas to parse these logs and show on the screen how many times it has been called.
This is a killing tool for migrating old flows. Want to know if there is any volume still going through that old part of the system?
Put a watchdog call there and wait to see if your name appears on the screen. If you forget it, a colleague can give you a heads-up
that your monitored flow has happened.

## Conclusion

It's kinda cheeky, but this a tribute to a system that for years helped me take pride on my work.
