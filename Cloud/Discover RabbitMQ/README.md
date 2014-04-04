# Down the Rabbit Hole with RabbitMQ: Discover the Joy of Multi-Platform Messaging

## Abstract

Gone are days of single platform, monolithic, transaction-based applications. Welcome to the cloud! We now live in a world where even a simple enterprise deployment involves many components written in many languages running on many operating systems in many locations. To the uninitiated the landscape is as fantastic and bewildering as Wonderland. In this presentation we'll explore one approach to managing a complex distributed system: asynchronous messaging. And we'll do it using RabbitMQ, a mature, fast, scalable, open source multi-platform messaging system. We'll begin by explaining some of the main drivers for asynchronous messaging. We'll take a look at what RabbitMQ can do. And we'll finish by writing some code to demonstrate what we've learned.

## Story

* Motivation for async
* What is async?
* What is RabbitMQ
* Artifacts
* Exchange Types
* Queues + Exchanges
* Message Characteristics
* High Performance
* High Availability
* Challenges
* Conclusion

## Outline

1. VHT
   * VHT (formerly Virtual Hold Technologies) in Akron
   * Call center solutions for Fortune 500 companies
   * Cable companies, airlines, credit card companies, video game console manufacturers
   * Erlang and Ruby shop
   * We build for scale
1. Navigator
   * Team Lead for new product team
   * New product is called Navigator
   * Just released 1.0 to limited customers
   * RabbitMQ central to architecture
   * Recognized early the benefits of async
1. Synchronous RPC
   * Send a message (such as an HTTP request)
   * Block, waiting for a response
   * Response is received
   * Unblock and move on
1. Characteristics of Synchronous RPC
   * On success there is a guarantee that the process is complete
   * On failure there is a guarantee that the process did not complete
   * On failure we do not know if the system is a corrupt state
1. Transactional RPC
   * Same message flow as synchronous
1. Characteristics of Transactional RPC
   * One important difference
   * On failure we have a guarantee that the system is in a consistent state
   * Transactions are slower and more resource intensive
   * But provide better guarantees
1. Not every RPC call needs guarantees
   * Modern high availability can give high degree of confidence
   * Many operations are tolerant of failure (sending an email)
   * High volume operations depend on speed
   * As do many data-constrained clients (mobile devices)
   * Under the right circumstances, async is the way to go
1. Asynchronous RPC
   * Send a message (such as an HTTP request)
   * Response is received
   * Sender does not block
   * Receiver performs operation *after* response sent
1. Characteristics of Asynchronous RPC
   * No guarantee on success
   * Success message means the request was *received*
   * Success does not mean the request was *processed*
   * Failure on send means the message was not received
   * Which guarantees the system is still in a consistent state
   * Full success means the system will be eventually be consistent
   * Full failure is a complete unknown
   * Response to the client is very, very fast
   * Operational capacity can be increased independent of API endpoints
1. Enter the Rabbit
   * RabbitMQ is a high performance, multi-platform message broker
   * Uses asynchronous messaging
   * Publishers send messages
   * Consumers receive messages
   * Supports any programming language
   * Supports multiple protocols
   * Everything is loosely coupled
   * Completely distributed
   * Both HA and HP are supported
   * Configuration can be tailored for need
1. AMQP
   * Advanced Message Queuing Protocol
   * Programmable: artifacts created upon connection
   * Connection
   * Channel
   * Exchange
   * Queue
   * Connection and channel are low-level, programmatic
   * Exchange and Queue are where the real work gets done
1. The AMQP Model
   * Publisher
   * Publishes to the Exchange
   * Message is routed to one or more Queues
   * Consumers subscribe to queues
   * From which messages are delivered
1. Power in Simplicity
   * Publishers and consumers are decoupled and independent
   * Messages may be routed to multiple consumers
   * Queues may be mirrored or persisted
   * Without acknowledgements messages will be redelivered
   * Messages may be re-queued on failure
1. Exchanges
   * Manage delivery based on type and routing key
   * Type and name are set at creation
   * Routing key for message is set at publish
   * Messages are never stored in the exchange
   * Messages with no matching queues are dropped
   * Four types of Exchanges: Direct, Fanout, Topic, Header
1. Direct Exchange
   * Delivery based on routing key
   * Intended for unicast routing
   * Message and queue routing key must match exactly
   * Supports multiple queues and multiple subscribers
1. Fanout Exchange
   * Broadcast messages
   * Routing key is ignored
   * Many queues, many consumers
1. Topic Exchange
   * Delivery based on routing key
   * Intended for multicast routing
   * Message and queue routing key use wildcard matching
   * Message is published with an explicit routing key
   * Consumers can use wildcards when subscribing to queues
   * Supports multiple queues and multiple subscribers
1. Headers Exchange
   * Similar to Direct but uses headers rather than routing key
   * Queues can be bound to an exchange with multiple headers
   * Multiple headers may be matched with "any" or "all"
1. Queues
   * Queues are "bound" to exchanges by consumers
   * Queues store messages delivered by exchanges
   * When there are no consumers messages accumulate
   * Queues are ephemeral by default (do not survive restart)
   * Queues can be declared as persistent (survive restart)
   * The prefetch attribute is used to create fair dispatch
   * Messages must be explicitly acknowledged or rejected
1. Work Queues
   * One publisher
   * Direct exchange with routing key
   * Many consumers on the same queue
   * Fair dispatch delivery (prefetch = 1)
1. Remote Procedure Call (RPC)
   * Same basic setup as work queue
   * But there is also a "reply-to" queue
   * Client publishes to work queue
   * Client adds "reply-to" as metadata
   * Client then listens to reply-to queue
   * Server publishes results to reply-to queue
   * Client receives response
1. Publish/Subscribe
   * One publisher
   * Fanout exchange (no routing key)
   * Many consumers on one or more queues
   * Every consumer receives every message
1. Topics
   * One publisher
   * Topic exchange
   * Every queue is bound with a routing key
   * Queue routing keys support wildcards
   * Many consumers on one or more queues
   * Every message has a routing key
   * Queues receive messages based on pattern matching
1. Navigator Work Queues
   * Basic direct exchange with fair dispatch
   * Uses the default exchange
   * Each worker type has its own routing key
   * A message with no reply-to is a "cast"
   * A message with a reply-to is a "call"
   * This was we support both sync and async
1. Navigator Control Exchange
   * Peer-to-peer messaging
   * Routing keys defined in product specs
   * One topic exchange shared by all workers
   * Each worker creates multiple queues
   * Queues are bound 1:1 to routing keys
   * Publisher selects recipients
   * Each recipient receives intended messages
1. Navigator Republish Exchange
   * Context worker receives messages on work queue
   * After processing a routing key is assigned
   * Routing key is based on attributes of the event
   * New message is published to a topic exchange
   * Zero or more "secondary" workers
   * Secondary workers bind to various routing keys
   * Secondary workers select which messages to receive
1. Architectural Principals
   * Eventual consistency
   * Best effort (no guarantees)
   * Degraded experience
   * Chunky over chatty
   * Resilience to transient errors
   * Favor idempotence
   * Cross-platform
   * Unlimited scalability
1. Future Topics
   * Exchange and queue attributes
   * Ack, nack, and reject
   * Transactions and confirms
   * Durable queues
   * Clustering
   * Mirrored queues
   * Plugins: Shovel and Federation
   * Management UI and CLI tools
   * Failover scenarios
