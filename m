Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 041033FBF9F
	for <lists+ceph-devel@lfdr.de>; Tue, 31 Aug 2021 01:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239019AbhH3Xzk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 30 Aug 2021 19:55:40 -0400
Received: from smtp1.onthe.net.au ([203.22.196.249]:50585 "EHLO
        smtp1.onthe.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238914AbhH3Xzi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 30 Aug 2021 19:55:38 -0400
X-Greylist: delayed 310 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Aug 2021 19:55:37 EDT
Received: from localhost (smtp2.private.onthe.net.au [10.200.63.13])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 5279C61C50
        for <ceph-devel@vger.kernel.org>; Tue, 31 Aug 2021 09:49:30 +1000 (EST)
Received: from smtp1.onthe.net.au ([10.200.63.11])
        by localhost (smtp.onthe.net.au [10.200.63.13]) (amavisd-new, port 10028)
        with ESMTP id KjupOUILNQMF for <ceph-devel@vger.kernel.org>;
        Tue, 31 Aug 2021 09:49:30 +1000 (AEST)
Received: from athena.private.onthe.net.au (chris-gw2-vpn.private.onthe.net.au [10.9.3.2])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 1F78561C2A
        for <ceph-devel@vger.kernel.org>; Tue, 31 Aug 2021 09:49:30 +1000 (EST)
Received: by athena.private.onthe.net.au (Postfix, from userid 1026)
        id 07CB0680468; Tue, 31 Aug 2021 09:49:30 +1000 (AEST)
Date:   Tue, 31 Aug 2021 09:49:29 +1000
From:   Chris Dunlop <chris@onthe.net.au>
To:     ceph-devel@vger.kernel.org
Subject: New pacific mon won't join with octopus mons
Message-ID: <20210830234929.GA3817015@onthe.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi,

Apologies if this isn't the correct mailing list for this, I've 
already tried getting help for this over on ceph-users but haven't 
received any response:

https://lists.ceph.io/hyperkitty/list/ceph-users@ceph.io/thread/YHTXK22C7CMBWCWKUCSL4U32GLQGBSJG/

I'm not sure, but I suspect this is a bug...

I'm stuck, mid upgrade from octopus to pacific using cephadm, at the 
point of upgrading the mons.

As background, this cluster started life 10 years ago with whatever was 
current at the time, and has been progressively upgraded with each new 
release. It's never had a cephfs on it and I ran into:

https://tracker.ceph.com/issues/51673

I created the temporary cephfs per the ticket and then ran into this 
next problem...

I have 3 mons still on octopus and in quorum. When I try to bring up a 
new pacific mon it stays permanently (over 10 minutes) in "probing" 
state with the pacific ceph-mon chewing up >300% CPU on it's host, and 
causing the octopus ceph-mons on the other hosts to chew up >100% CPU. 
I've left it for 10 minutes in that state and it hasn't progressed 
past "probing".

First up, I'm assuming a pacific mon is supposed to be able to join a 
quorum with octopus mons, otherwise how is an upgrade supposed to 
work?

The pacific mon, "b5", is v16.2.5 running under podman:

docker.io/ceph/ceph@sha256:829ebf54704f2d827de00913b171e5da741aad9b53c1f35ad59251524790eceb

The octopus mons are all v15.2.14. The lead octopus mon ("k2") is 
running under podman:

quay.io/ceph/ceph:v15

The other 2 octopus mons ("b2" and "b4") are standalone 
15.2.14-1~bpo10+1.  These are manually started due to the cephadm 
upgrade failing at the point of upgrading the mons and leaving me with 
only one cephadm mon running.

On start up of the pacific mon with debug_mon=20, over a 30 second 
period I see 765 "handle_probe_reply" sequences by the pacific mon, 
with the lead mon replying 200 times and the other two mons replying 
279 times each.

In the very first "handle_probe_reply" sequence we see an expected (I 
assume) "bootstrap" as the starting up mon doesn't yet have a monmap 
("got newer/committed monmap epoch 35, mine was 0"):

Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 10 mon.b5@-1(probing) e0 handle_probe mon_probe(reply c6618970-0ce0-4cb2-bc9a-dd5f29b62e24 name b4 quorum 0,1,2 leader 0 paxos( fc 365132587 lc 365133304 ) mon_release octopus) v7
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 10 mon.b5@-1(probing) e0 handle_probe_reply mon.2 v2:10.200.63.132:3300/0 mon_probe(reply c6618970-0ce0-4cb2-bc9a-dd5f29b62e24 name b4 quorum 0,1,2 leader 0 paxos( fc 365132587 lc 365133304 ) mon_release octopus) v7
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 10 mon.b5@-1(probing) e0  monmap is e0: 3 mons at {noname-a=[v2:10.200.63.130:3300/0,v1:10.200.63.130:6789/0],noname-b=[v2:10.200.63.132:3300/0,v1:10.200.63.132:6789/0],noname-c=[v2:192.168.254.251:3300/0,v1:192.168.254.251:6789/0]}
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 10 mon.b5@-1(probing) e0  got newer/committed monmap epoch 35, mine was 0
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 10 mon.b5@-1(probing) e35 bootstrap
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 10 mon.b5@-1(probing) e35 sync_reset_requester
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 10 mon.b5@-1(probing) e35 unregister_cluster_logger - not registered
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 10 mon.b5@-1(probing) e35 cancel_probe_timeout 0x5646293a0a20
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 10 mon.b5@-1(probing) e35 monmap e35: 3 mons at {b2=[v2:10.200.63.130:3300/0,v1:10.200.63.130:6789/0],b4=[v2:10.200.63.132:3300/0,v1:10.200.63.132:6789/0],k2=[v2:192.168.254.251:3300/0,v1:192.168.254.251:6789/0]}
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 10 mon.b5@-1(probing) e35 _reset
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 10 mon.b5@-1(probing).auth v0 _set_mon_num_rank num 0 rank 0
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 10 mon.b5@-1(probing) e35 cancel_probe_timeout (none scheduled)
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 10 mon.b5@-1(probing) e35 timecheck_finish
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 15 mon.b5@-1(probing) e35 health_tick_stop
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 15 mon.b5@-1(probing) e35 health_interval_stop
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 10 mon.b5@-1(probing) e35 scrub_event_cancel
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 10 mon.b5@-1(probing) e35 scrub_reset
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 10 mon.b5@-1(probing) e35 cancel_probe_timeout (none scheduled)
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 10 mon.b5@-1(probing) e35 reset_probe_timeout 0x5646293a0a20 after 10 seconds
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 10 mon.b5@-1(probing) e35 probing other monitors
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 10 mon.b5@-1(probing) e35 _ms_dispatch new session 0x5646293aafc0 MonSession(mon.1 [v2:10.200.63.130:3300/0,v1:10.200.63.130:6789/0] is open , features 0x3f01cfb8ffedffff (luminous)) features 0x3f01cfb8ffedffff
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700  5 mon.b5@-1(probing) e35 _ms_dispatch setting monitor caps on this connection
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 20 mon.b5@-1(probing) e35  entity_name  global_id 0 (none) caps allow *
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 20 is_capable service=mon command= read addr v2:10.200.63.130:3300/0 on cap allow *
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 20  allow so far , doing grant allow *
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 20  allow all

However every single "handle_probe_reply" sequence after that also 
does a "bootstrap", even though the mon at this point has a monmap 
which the same epoch ("got newer/committed monmap epoch 35, mine was 
35"), e.g.:

Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 10 mon.b5@-1(probing) e35 handle_probe mon_probe(reply c6618970-0ce0-4cb2-bc9a-dd5f29b62e24 name b4 quorum 0,1,2 leader 0 paxos( fc 365132587 lc 365133304 ) mon_release octopus) v7
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 10 mon.b5@-1(probing) e35 handle_probe_reply mon.2 v2:10.200.63.132:3300/0 mon_probe(reply c6618970-0ce0-4cb2-bc9a-dd5f29b62e24 name b4 quorum 0,1,2 leader 0 paxos( fc 365132587 lc 365133304 ) mon_release octopus) v7
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 10 mon.b5@-1(probing) e35  monmap is e35: 3 mons at {b2=[v2:10.200.63.130:3300/0,v1:10.200.63.130:6789/0],b4=[v2:10.200.63.132:3300/0,v1:10.200.63.132:6789/0],k2=[v2:192.168.254.251:3300/0,v1:192.168.254.251:6789/0]}
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 10 mon.b5@-1(probing) e35  got newer/committed monmap epoch 35, mine was 35
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 10 mon.b5@-1(probing) e35 bootstrap
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 10 mon.b5@-1(probing) e35 sync_reset_requester
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 10 mon.b5@-1(probing) e35 unregister_cluster_logger - not registered
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 10 mon.b5@-1(probing) e35 cancel_probe_timeout 0x5646293a0a20
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 10 mon.b5@-1(probing) e35 monmap e35: 3 mons at {b2=[v2:10.200.63.130:3300/0,v1:10.200.63.130:6789/0],b4=[v2:10.200.63.132:3300/0,v1:10.200.63.132:6789/0],k2=[v2:192.168.254.251:3300/0,v1:192.168.254.251:6789/0]}
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 10 mon.b5@-1(probing) e35 _reset
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 10 mon.b5@-1(probing).auth v0 _set_mon_num_rank num 0 rank 0
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 10 mon.b5@-1(probing) e35 cancel_probe_timeout (none scheduled)
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 10 mon.b5@-1(probing) e35 timecheck_finish
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 15 mon.b5@-1(probing) e35 health_tick_stop
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 15 mon.b5@-1(probing) e35 health_interval_stop
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 10 mon.b5@-1(probing) e35 scrub_event_cancel
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 10 mon.b5@-1(probing) e35 scrub_reset
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 10 mon.b5@-1(probing) e35 cancel_probe_timeout (none scheduled)
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 10 mon.b5@-1(probing) e35 reset_probe_timeout 0x5646293a0a20 after 10 seconds
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 10 mon.b5@-1(probing) e35 probing other monitors
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 20 mon.b5@-1(probing) e35 _ms_dispatch existing session 0x5646293aafc0 for mon.1
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 20 mon.b5@-1(probing) e35  entity_name  global_id 0 (none) caps allow *
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 20 is_capable service=mon command= read addr v2:10.200.63.130:3300/0 on cap allow *
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 20  allow so far , doing grant allow *
Aug 31 07:05:01 b5 conmon[3496814]: debug 2021-08-30T21:05:01.377+0000 7f43ead11700 20  allow all

That same sequence keeps repeating, just with the "name" changing 
between the octopus mons, i.e. "name b4", "name b2" and "name k2".

Referencing Monitor::handle_probe_reply() in src/mon/Monitor.cc (see 
also below), if we ever get past the bootstrap() we should get a 
message mentioning "peer", but we never see one.

That implies "mybl.contents_equal(m->monmap_bl)" is never true, and 
"has_ever_joined" is never true.

What's going on here?

Cheers,

Chris

----------------------------------------------------------------------
void Monitor::handle_probe_reply(MonOpRequestRef op)
{
...
   // newer map, or they've joined a quorum and we haven't?
   bufferlist mybl;
   monmap->encode(mybl, m->get_connection()->get_features());
   // make sure it's actually different; the checks below err toward
   // taking the other guy's map, which could cause us to loop.
   if (!mybl.contents_equal(m->monmap_bl)) {
     MonMap *newmap = new MonMap;
     newmap->decode(m->monmap_bl);
     if (m->has_ever_joined && (newmap->get_epoch() > monmap->get_epoch() ||
                                !has_ever_joined)) {
       dout(10) << " got newer/committed monmap epoch " << newmap->get_epoch()
                << ", mine was " << monmap->get_epoch() << dendl;
       delete newmap;
       monmap->decode(m->monmap_bl);
       notify_new_monmap(false);

       bootstrap();
       return;
     }
     delete newmap;
   }
   
   // rename peer?
   string peer_name = monmap->get_name(m->get_source_addr());
   if (monmap->get_epoch() == 0 && peer_name.compare(0, 7, "noname-") == 0) {
     dout(10) << " renaming peer " << m->get_source_addr() << " "
              << peer_name << " -> " << m->name << " in my monmap"
              << dendl;
     monmap->rename(peer_name, m->name);

     if (is_electing()) {
       bootstrap();
       return;
     }
   } else if (peer_name.size()) { 
     dout(10) << " peer name is " << peer_name << dendl;
   } else {
     dout(10) << " peer " << m->get_source_addr() << " not in map" << dendl;
   }
...
}
----------------------------------------------------------------------
