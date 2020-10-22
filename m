Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0682296013
	for <lists+ceph-devel@lfdr.de>; Thu, 22 Oct 2020 15:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2900013AbgJVNfN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 22 Oct 2020 09:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726257AbgJVNfM (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 22 Oct 2020 09:35:12 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72624C0613CE
        for <ceph-devel@vger.kernel.org>; Thu, 22 Oct 2020 06:35:12 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id v200so1438335qka.0
        for <ceph-devel@vger.kernel.org>; Thu, 22 Oct 2020 06:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=a1RjAiBmKmPJiQCyuzg7jlkl4RhTUzvYasN8QOv4hKw=;
        b=DJhIOaZvI1lRwN1jvDNh9Irhbiq8f0tajLpBEd2j4Yf3tMblfIfNEtocZMl4XsvHbq
         CxhgZ4PyjY4nu67kH/lQ68aSPhn8UGuDupQXDLej71LNkWSuQk8VOW2a17Z1gUSIiVK6
         tD5aAu6/qywFN6xJgKLKoC938Ex2xsDwaUpOLQ1s3XENO1igCLunq/Rxe+B190qXWyFL
         kwNiabSFqMWGdLGZ/LvJRU5SyJKvdr6/Nyl7HeUKtZ19dQo4R/v/pMGEPdv8EKsSIhTe
         7huUMavzTwdkWAHKfToOMyejvgr+EmI8KvbxenHrbF3/ws0yh9sOAJifZGg00ftfD716
         O2Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=a1RjAiBmKmPJiQCyuzg7jlkl4RhTUzvYasN8QOv4hKw=;
        b=LN5V8JI1Quh1aU2JGu6PlKrZB8zfzYELujitGPP9rfPoNg+nNGgNtE5ru/BRyEBgqk
         AvgeRV2t7X6gazRk0fT7cgIxH8CfpLllw+OuGdMzB0PrJTXoNh1DQfLCP3LHLb+CpGhr
         0BcnyRH+IjCXJHHFPdfR8akjxGlKc6M02srv/BRdGO2R/+1znAZbeE37L/zXyZ1bQVA4
         hS/tkqNbbuVf+dzEIcVseCRAbe9JD9i9EzCC2g6yhMsl8ktMBIXYluFt2lI3SmS6n91b
         CVAXca6gXlsOamtQVzxm4bmInIBjdJh9AlyB4QJBwMYXsgARulWfq+mpOzJPnh+ZexY8
         TNdg==
X-Gm-Message-State: AOAM531dcAi7yCRQ/wRwmRWBjuvSvmh9BscSBymq0pkPkOwFlVkGaap6
        0xYf3ZZYTZEhFO7dOj/MMe+i3B+06bfLnF118EeF73ZOScM=
X-Google-Smtp-Source: ABdhPJzBuW3gnddiczZk3H+i26ueg+cIpsAC1SzXFZ81IpT9FGE0frle1OlesTw8W5jWsHBhaeBqWaUB0WJGOTAjItM=
X-Received: by 2002:a37:9e82:: with SMTP id h124mr811413qke.209.1603373711447;
 Thu, 22 Oct 2020 06:35:11 -0700 (PDT)
MIME-Version: 1.0
References: <CACo-D_AU21TT6wcuUXTDquUY1UtSb265ga+0SAvU2S-RCWmzTw@mail.gmail.com>
 <CABZ+qq=n8XFYNtrJKThG3OViYa12pVMU4b5eVr58ZFHxbAod=A@mail.gmail.com>
In-Reply-To: <CABZ+qq=n8XFYNtrJKThG3OViYa12pVMU4b5eVr58ZFHxbAod=A@mail.gmail.com>
From:   David C <dcsysengineer@gmail.com>
Date:   Thu, 22 Oct 2020 14:35:00 +0100
Message-ID: <CACo-D_DhNDXAyOjJR6W9JYhZP7m9pfbh7q-G1nDMJhHskdtOXQ@mail.gmail.com>
Subject: Re: [ceph-users] Urgent help needed please - MDS offline
To:     Dan van der Ster <dan@vanderster.com>,
        ceph-devel <ceph-devel@vger.kernel.org>, ceph-users@ceph.io
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Dan, many thanks for the response.

I was going down the route of looking at mds_beacon_grace but I now
realise when I start my MDS, it's swallowing up memory rapidly and
looks like the oom-killer is eventually killing the mds. With debug
upped to 10, I can see it's doing EMetaBlob.replays on various dirs in
the filesystem and I can't see any obvious issues.

This server has 128GB ram with 111GB free with the MDS stopped

The mds_cache_memory_limit is currently set to 32GB

Could this be a case of simply reducing the mds cache until I can get
this started again or is there another setting I should be looking at?
Is it safe to reduce the cache memory limit at this point?

The standby is currently down and has been deliberately down for a while now.

Log excerpt from debug 10 just before MDS is killed (path/to/dir
refers to a real path in my FS)

2020-10-22 13:29:49.527372 7fc72d39f700 10
mds.0.cache.ino(0x1000e4c0ff4) mark_dirty_parent
2020-10-22 13:29:49.527374 7fc72d39f700 10 mds.0.journal
EMetaBlob.replay noting opened inode [inode 0x1000e4c0ff4 [2,head]
/path/to/dir/{dc97bb9c-4600-48bb-b232-23f9e45caa6e}.tmp auth v904149
dirtyparent s
=0 n(v0 1=1+0) (iversion lock) | dirtyparent=1 dirty=1 0x561c23d66e00]
2020-10-22 13:29:49.527378 7fc72d39f700 10 mds.0.journal
EMetaBlob.replay inotable tablev 481253 <= table 481328
2020-10-22 13:29:49.527380 7fc72d39f700 10 mds.0.journal
EMetaBlob.replay sessionmap v 240341131 <= table 240378576
2020-10-22 13:29:49.527383 7fc72d39f700 10 mds.0.journal
EMetaBlob.replay request client.16250824:1416595263 trim_to 1416595263
2020-10-22 13:29:49.530097 7fc72d39f700 10 mds.0.log _replay
57437755528637~11764673 / 57441334490146 2020-10-22 09:08:56.198798:
EOpen [metab
lob 0x10009e1ec8e, 1881 dirs], 16748 open files
2020-10-22 13:29:49.530106 7fc72d39f700 10 mds.0.journal EOpen.replay
2020-10-22 13:29:49.530107 7fc72d39f700 10 mds.0.journal
EMetaBlob.replay 1881 dirlumps by unknown.0
2020-10-22 13:29:49.530109 7fc72d39f700 10 mds.0.journal
EMetaBlob.replay dir 0x10009e1ec8e
2020-10-22 13:29:49.530111 7fc72d39f700 10 mds.0.journal
EMetaBlob.replay updated dir [dir 0x10009e1ec8e /path/to/dir/ [2,head]
auth v=904150 cv=0/0 state=1073741824 f(v0 m2020-10-22 08:46:44.932805
89215=89215+0) n(v2 rc2020-10-22 08:46:44.932805 b133337592
89215=89215+0) hs=42927+1178,ss=0+0 dirty=2376 | child=1
0x56043c4bd100]
2020-10-22 13:29:50.275864 7fc731ba8700  5
mds.beacon.hostnamecephssd01 Sending beacon up:replay seq 13
2020-10-22 13:29:51.026368 7fc73732e700  5
mds.beacon.hostnamecephssd01 received beacon reply up:replay seq 13
rtt 0.750024
2020-10-22 13:29:51.026377 7fc73732e700  0
mds.beacon.hostnamecephssd01  MDS is no longer laggy
2020-10-22 13:29:54.275993 7fc731ba8700  5
mds.beacon.hostnamecephssd01 Sending beacon up:replay seq 14
2020-10-22 13:29:54.277360 7fc73732e700  5
mds.beacon.hostnamecephssd01 received beacon reply up:replay seq 14
rtt 0.00100003
2020-10-22 13:29:58.276117 7fc731ba8700  5
mds.beacon.hostnamecephssd01 Sending beacon up:replay seq 15
2020-10-22 13:29:58.277322 7fc73732e700  5
mds.beacon.hostnamecephssd01 received beacon reply up:replay seq 15
rtt 0.00100003
2020-10-22 13:30:02.276313 7fc731ba8700  5
mds.beacon.hostnamecephssd01 Sending beacon up:replay seq 16
2020-10-22 13:30:02.477973 7fc73732e700  5
mds.beacon.hostnamecephssd01 received beacon reply up:replay seq 16
rtt 0.202007

Thanks,
David

On Thu, Oct 22, 2020 at 1:41 PM Dan van der Ster <dan@vanderster.com> wrote:
>
> You can disable that beacon by increasing mds_beacon_grace to 300 or
> 600. This will stop the mon from failing that mds over to a standby.
> I don't know if that is set on the mon or mgr, so I usually set it on both.
> (You might as well disable the standby too -- no sense in something
> failing back and forth between two mdses).
>
> Next -- looks like your mds is in active:replay. Is it doing anything?
> Is it using lots of CPU/RAM? If you increase debug_mds do you see some
> progress?
>
> -- dan
>
>
> On Thu, Oct 22, 2020 at 2:01 PM David C <dcsysengineer@gmail.com> wrote:
> >
> > Hi All
> >
> > My main CephFS data pool on a Luminous 12.2.10 cluster hit capacity
> > overnight, metadata is on a separate pool which didn't hit capacity but the
> > filesystem stopped working which I'd expect. I increased the osd full-ratio
> > to give me some breathing room to get some data deleted once the filesystem
> > is back online. When I attempt to restart the MDS service, I see the usual
> > stuff I'd expect in the log but then:
> >
> > heartbeat_map is_healthy 'MDSRank' had timed out after 15
> >
> >
> > Followed by:
> >
> > mds.beacon.hostnamecephssd01 Skipping beacon heartbeat to monitors (last
> > > acked 4.00013s ago); MDS internal heartbeat is not healthy!
> >
> >
> > Eventually I get:
> >
> > >
> > > mds.beacon.hostnamecephssd01 is_laggy 29.372 > 15 since last acked beacon
> > > mds.0.90884 skipping upkeep work because connection to Monitors appears
> > > laggy
> > > mds.hostnamecephssd01 Updating MDS map to version 90885 from mon.0
> > > mds.beacon.hostnamecephssd01  MDS is no longer laggy
> >
> >
> > The "MDS is no longer laggy" appears to be where the service fails
> >
> > Meanwhile a ceph -s is showing:
> >
> > >
> > > cluster:
> > >     id:     5c5998fd-dc9b-47ec-825e-beaba66aad11
> > >     health: HEALTH_ERR
> > >             1 filesystem is degraded
> > >             insufficient standby MDS daemons available
> > >             67 backfillfull osd(s)
> > >             11 nearfull osd(s)
> > >             full ratio(s) out of order
> > >             2 pool(s) backfillfull
> > >             2 pool(s) nearfull
> > >             6 scrub errors
> > >             Possible data damage: 5 pgs inconsistent
> > >   services:
> > >     mon: 3 daemons, quorum hostnameceph01,hostnameceph02,hostnameceph03
> > >     mgr: hostnameceph03(active), standbys: hostnameceph02, hostnameceph01
> > >     mds: cephfs-1/1/1 up  {0=hostnamecephssd01=up:replay}
> > >     osd: 172 osds: 161 up, 161 in
> > >   data:
> > >     pools:   5 pools, 8384 pgs
> > >     objects: 76.25M objects, 124TiB
> > >     usage:   373TiB used, 125TiB / 498TiB avail
> > >     pgs:     8379 active+clean
> > >              5    active+clean+inconsistent
> > >   io:
> > >     client:   676KiB/s rd, 0op/s rd, 0op/s w
> >
> >
> > The 5 pgs inconsistent is not a new issue, that is from past scrubs, just
> > haven't gotten around to manually clearing them although I suppose they
> > could be related to my issue
> >
> > The cluster has no clients connected
> >
> > I did notice in the ceph.log, some OSDs that are in the same host as the
> > MDS service briefly went down when trying to restart the MDS but examining
> > the logs of those particular OSDs isn't showing any glaring issues.
> >
> > Full MDS log at debug 5 (can go higher if needed):
> >
> > 2020-10-22 11:27:10.987652 7f6f696f5240  0 set uid:gid to 167:167
> > (ceph:ceph)
> > 2020-10-22 11:27:10.987669 7f6f696f5240  0 ceph version 12.2.10
> > (177915764b752804194937482a39e95e0ca3de94) luminous (stable), process
> > ceph-mds, pid 2022582
> > 2020-10-22 11:27:10.990567 7f6f696f5240  0 pidfile_write: ignore empty
> > --pid-file
> > 2020-10-22 11:27:11.027981 7f6f62616700  1 mds.hostnamecephssd01 Updating
> > MDS map to version 90882 from mon.0
> > 2020-10-22 11:27:15.097957 7f6f62616700  1 mds.hostnamecephssd01 Updating
> > MDS map to version 90883 from mon.0
> > 2020-10-22 11:27:15.097989 7f6f62616700  1 mds.hostnamecephssd01 Map has
> > assigned me to become a standby
> > 2020-10-22 11:27:15.101071 7f6f62616700  1 mds.hostnamecephssd01 Updating
> > MDS map to version 90884 from mon.0
> > 2020-10-22 11:27:15.105310 7f6f62616700  1 mds.0.90884 handle_mds_map i am
> > now mds.0.90884
> > 2020-10-22 11:27:15.105316 7f6f62616700  1 mds.0.90884 handle_mds_map state
> > change up:boot --> up:replay
> > 2020-10-22 11:27:15.105325 7f6f62616700  1 mds.0.90884 replay_start
> > 2020-10-22 11:27:15.105333 7f6f62616700  1 mds.0.90884  recovery set is
> > 2020-10-22 11:27:15.105344 7f6f62616700  1 mds.0.90884  waiting for osdmap
> > 73745 (which blacklists prior instance)
> > 2020-10-22 11:27:15.149092 7f6f5be09700  0 mds.0.cache creating system
> > inode with ino:0x100
> > 2020-10-22 11:27:15.149693 7f6f5be09700  0 mds.0.cache creating system
> > inode with ino:0x1
> > 2020-10-22 11:27:41.021708 7f6f63618700  1 heartbeat_map is_healthy
> > 'MDSRank' had timed out after 15
> > 2020-10-22 11:27:43.029290 7f6f5f610700  1 heartbeat_map is_healthy
> > 'MDSRank' had timed out after 15
> > 2020-10-22 11:27:43.029297 7f6f5f610700  0 mds.beacon.hostnamecephssd01
> > Skipping beacon heartbeat to monitors (last acked 4.00013s ago); MDS
> > internal heartbeat is not healthy!
> > 2020-10-22 11:27:45.866711 7f6f5fe11700  1 heartbeat_map reset_timeout
> > 'MDSRank' had timed out after 15
> > 2020-10-22 11:28:01.021965 7f6f63618700  1 heartbeat_map is_healthy
> > 'MDSRank' had timed out after 15
> > 2020-10-22 11:28:03.029862 7f6f5f610700  1 heartbeat_map is_healthy
> > 'MDSRank' had timed out after 15
> > 2020-10-22 11:28:03.029885 7f6f5f610700  0 mds.beacon.hostnamecephssd01
> > Skipping beacon heartbeat to monitors (last acked 4.00113s ago); MDS
> > internal heartbeat is not healthy!
> > 2020-10-22 11:28:06.022033 7f6f63618700  1 heartbeat_map is_healthy
> > 'MDSRank' had timed out after 15
> > 2020-10-22 11:28:07.029955 7f6f5f610700  1 heartbeat_map is_healthy
> > 'MDSRank' had timed out after 15
> > 2020-10-22 11:28:07.029961 7f6f5f610700  0 mds.beacon.hostnamecephssd01
> > Skipping beacon heartbeat to monitors (last acked 8.00126s ago); MDS
> > internal heartbeat is not healthy!
> > 2020-10-22 11:28:11.022099 7f6f63618700  1 heartbeat_map is_healthy
> > 'MDSRank' had timed out after 15
> > 2020-10-22 11:28:11.030024 7f6f5f610700  1 heartbeat_map is_healthy
> > 'MDSRank' had timed out after 15
> > 2020-10-22 11:28:11.030028 7f6f5f610700  0 mds.beacon.hostnamecephssd01
> > Skipping beacon heartbeat to monitors (last acked 12.0014s ago); MDS
> > internal heartbeat is not healthy!
> > 2020-10-22 11:28:15.030092 7f6f5f610700  1 heartbeat_map is_healthy
> > 'MDSRank' had timed out after 15
> > 2020-10-22 11:28:15.030099 7f6f5f610700  0 mds.beacon.hostnamecephssd01
> > Skipping beacon heartbeat to monitors (last acked 16.0015s ago); MDS
> > internal heartbeat is not healthy!
> > 2020-10-22 11:28:16.022165 7f6f63618700  1 heartbeat_map is_healthy
> > 'MDSRank' had timed out after 15
> > 2020-10-22 11:28:19.030163 7f6f5f610700  1 heartbeat_map is_healthy
> > 'MDSRank' had timed out after 15
> > 2020-10-22 11:28:19.030169 7f6f5f610700  0 mds.beacon.hostnamecephssd01
> > Skipping beacon heartbeat to monitors (last acked 20.0016s ago); MDS
> > internal heartbeat is not healthy!
> > 2020-10-22 11:28:21.022231 7f6f63618700  1 heartbeat_map is_healthy
> > 'MDSRank' had timed out after 15
> > 2020-10-22 11:28:23.030233 7f6f5f610700  1 heartbeat_map is_healthy
> > 'MDSRank' had timed out after 15
> > 2020-10-22 11:28:23.030241 7f6f5f610700  0 mds.beacon.hostnamecephssd01
> > Skipping beacon heartbeat to monitors (last acked 24.0008s ago); MDS
> > internal heartbeat is not healthy!
> > 2020-10-22 11:28:26.022295 7f6f63618700  1 heartbeat_map is_healthy
> > 'MDSRank' had timed out after 15
> > 2020-10-22 11:28:27.030305 7f6f5f610700  1 heartbeat_map is_healthy
> > 'MDSRank' had timed out after 15
> > 2020-10-22 11:28:27.030311 7f6f5f610700  0 mds.beacon.hostnamecephssd01
> > Skipping beacon heartbeat to monitors (last acked 28.0009s ago); MDS
> > internal heartbeat is not healthy!
> > 2020-10-22 11:28:28.401161 7f6f5fe11700  1 heartbeat_map reset_timeout
> > 'MDSRank' had timed out after 15
> > 2020-10-22 11:28:28.401168 7f6f5fe11700  1 mds.beacon.hostnamecephssd01
> > is_laggy 29.372 > 15 since last acked beacon
> > 2020-10-22 11:28:28.401177 7f6f5fe11700  1 mds.0.90884 skipping upkeep work
> > because connection to Monitors appears laggy
> > 2020-10-22 11:28:28.401187 7f6f62616700  1 mds.hostnamecephssd01 Updating
> > MDS map to version 90885 from mon.0
> > 2020-10-22 11:28:31.659817 7f6f64595700  0 mds.beacon.hostnamecephssd01
> >  MDS is no longer laggy
> > 2020-10-22 11:36:15.880009 7f88ee4ac240  0 set uid:gid to 167:167
> > (ceph:ceph)
> > 2020-10-22 11:36:15.880026 7f88ee4ac240  0 ceph version 12.2.10
> > (177915764b752804194937482a39e95e0ca3de94) luminous (stable), process
> > ceph-mds, pid 2022663
> > 2020-10-22 11:36:15.883118 7f88ee4ac240  0 pidfile_write: ignore empty
> > --pid-file
> > 2020-10-22 11:36:15.921200 7f88e73cd700  1 mds.hostnamecephssd01 Updating
> > MDS map to version 90887 from mon.2
> > 2020-10-22 11:36:20.270298 7f88e73cd700  1 mds.hostnamecephssd01 Updating
> > MDS map to version 90888 from mon.2
> > 2020-10-22 11:36:20.270329 7f88e73cd700  1 mds.hostnamecephssd01 Map has
> > assigned me to become a standby
> > 2020-10-22 11:36:20.272917 7f88e73cd700  1 mds.hostnamecephssd01 Updating
> > MDS map to version 90889 from mon.2
> > 2020-10-22 11:36:20.277063 7f88e73cd700  1 mds.0.90889 handle_mds_map i am
> > now mds.0.90889
> > 2020-10-22 11:36:20.277069 7f88e73cd700  1 mds.0.90889 handle_mds_map state
> > change up:boot --> up:replay
> > 2020-10-22 11:36:20.277079 7f88e73cd700  1 mds.0.90889 replay_start
> > 2020-10-22 11:36:20.277086 7f88e73cd700  1 mds.0.90889  recovery set is
> > 2020-10-22 11:36:20.277096 7f88e73cd700  1 mds.0.90889  waiting for osdmap
> > 73746 (which blacklists prior instance)
> > 2020-10-22 11:36:20.322318 7f88e0bc0700  0 mds.0.cache creating system
> > inode with ino:0x100
> > 2020-10-22 11:36:20.322918 7f88e0bc0700  0 mds.0.cache creating system
> > inode with ino:0x1
> > 2020-10-22 11:36:47.922531 7f88e43c7700  1 heartbeat_map is_healthy
> > 'MDSRank' had timed out after 15
> > 2020-10-22 11:36:47.922549 7f88e43c7700  0 mds.beacon.hostnamecephssd01
> > Skipping beacon heartbeat to monitors (last acked 4.00013s ago); MDS
> > internal heartbeat is not healthy!
> > 2020-10-22 11:36:50.914516 7f88e83cf700  1 heartbeat_map is_healthy
> > 'MDSRank' had timed out after 15
> > 2020-10-22 11:36:51.351457 7f88e4bc8700  1 heartbeat_map reset_timeout
> > 'MDSRank' had timed out after 15
> > 2020-10-22 11:37:07.923089 7f88e43c7700  1 heartbeat_map is_healthy
> > 'MDSRank' had timed out after 15
> > 2020-10-22 11:37:07.923126 7f88e43c7700  0 mds.beacon.hostnamecephssd01
> > Skipping beacon heartbeat to monitors (last acked 3.99913s ago); MDS
> > internal heartbeat is not healthy!
> > 2020-10-22 11:37:10.914767 7f88e83cf700  1 heartbeat_map is_healthy
> > 'MDSRank' had timed out after 15
> > 2020-10-22 11:37:11.923216 7f88e43c7700  1 heartbeat_map is_healthy
> > 'MDSRank' had timed out after 15
> > 2020-10-22 11:37:11.923223 7f88e43c7700  0 mds.beacon.hostnamecephssd01
> > Skipping beacon heartbeat to monitors (last acked 7.99926s ago); MDS
> > internal heartbeat is not healthy!
> > 2020-10-22 11:37:15.914831 7f88e83cf700  1 heartbeat_map is_healthy
> > 'MDSRank' had timed out after 15
> > 2020-10-22 11:37:15.923286 7f88e43c7700  1 heartbeat_map is_healthy
> > 'MDSRank' had timed out after 15
> > 2020-10-22 11:37:15.923294 7f88e43c7700  0 mds.beacon.hostnamecephssd01
> > Skipping beacon heartbeat to monitors (last acked 11.9994s ago); MDS
> > internal heartbeat is not healthy!
> > 2020-10-22 11:37:19.923359 7f88e43c7700  1 heartbeat_map is_healthy
> > 'MDSRank' had timed out after 15
> > 2020-10-22 11:37:19.923366 7f88e43c7700  0 mds.beacon.hostnamecephssd01
> > Skipping beacon heartbeat to monitors (last acked 15.9995s ago); MDS
> > internal heartbeat is not healthy!
> > 2020-10-22 11:37:20.914917 7f88e83cf700  1 heartbeat_map is_healthy
> > 'MDSRank' had timed out after 15
> > 2020-10-22 11:37:23.923430 7f88e43c7700  1 heartbeat_map is_healthy
> > 'MDSRank' had timed out after 15
> > 2020-10-22 11:37:23.923437 7f88e43c7700  0 mds.beacon.hostnamecephssd01
> > Skipping beacon heartbeat to monitors (last acked 19.9996s ago); MDS
> > internal heartbeat is not healthy!
> > 2020-10-22 11:37:25.914981 7f88e83cf700  1 heartbeat_map is_healthy
> > 'MDSRank' had timed out after 15
> > 2020-10-22 11:37:27.923501 7f88e43c7700  1 heartbeat_map is_healthy
> > 'MDSRank' had timed out after 15
> > 2020-10-22 11:37:27.923508 7f88e43c7700  0 mds.beacon.hostnamecephssd01
> > Skipping beacon heartbeat to monitors (last acked 23.9998s ago); MDS
> > internal heartbeat is not healthy!
> > 2020-10-22 11:37:30.915046 7f88e83cf700  1 heartbeat_map is_healthy
> > 'MDSRank' had timed out after 15
> > 2020-10-22 11:37:31.923572 7f88e43c7700  1 heartbeat_map is_healthy
> > 'MDSRank' had timed out after 15
> > 2020-10-22 11:37:31.923579 7f88e43c7700  0 mds.beacon.hostnamecephssd01
> > Skipping beacon heartbeat to monitors (last acked 27.9999s ago); MDS
> > internal heartbeat is not healthy!
> > 2020-10-22 11:37:32.412628 7f88e4bc8700  1 heartbeat_map reset_timeout
> > 'MDSRank' had timed out after 15
> > 2020-10-22 11:37:32.412635 7f88e4bc8700  1 mds.beacon.hostnamecephssd01
> > is_laggy 28.4889 > 15 since last acked beacon
> > 2020-10-22 11:37:32.412643 7f88e4bc8700  1 mds.0.90889 skipping upkeep work
> > because connection to Monitors appears laggy
> > 2020-10-22 11:37:32.412657 7f88e73cd700  1 mds.hostnamecephssd01 Updating
> > MDS map to version 90890 from mon.2
> > 2020-10-22 11:37:35.978858 7f88e934c700  0 mds.beacon.hostnamecephssd01
> >  MDS is no longer laggy
> >
> >
> > Thanks in advance for any assistance you can provide!
> > David
> > _______________________________________________
> > ceph-users mailing list -- ceph-users@ceph.io
> > To unsubscribe send an email to ceph-users-leave@ceph.io
