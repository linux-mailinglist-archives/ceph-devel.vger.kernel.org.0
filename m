Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1A5B295EB9
	for <lists+ceph-devel@lfdr.de>; Thu, 22 Oct 2020 14:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504148AbgJVMlF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 22 Oct 2020 08:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2441107AbgJVMlE (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 22 Oct 2020 08:41:04 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AAE7C0613CE
        for <ceph-devel@vger.kernel.org>; Thu, 22 Oct 2020 05:41:04 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id w27so2080799ejb.3
        for <ceph-devel@vger.kernel.org>; Thu, 22 Oct 2020 05:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vanderster.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EC3O4BElx6NVeJRMUK7RX7olusqpawSFJtmryZ/PZ1k=;
        b=glElqHDNgRasbDjrmB76BqDxZMWCQydc3BsnadbhwvQig0RJN7q5yaYPJvl+yDuFSP
         aoOhgVS3Y7EloF5SCawCvVHYcBx84Ij5BH1mbmqvweLjo7u0LgsKdBtQgu4bsB0sWku2
         TfHkl/ud0+RmtIywrpQ4sSa7xkJ69bNnB27hA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EC3O4BElx6NVeJRMUK7RX7olusqpawSFJtmryZ/PZ1k=;
        b=oK9d8t4T0QQepmSIJ7c5AbczowYQTqU7bhWcXBYsvpQ43s1EkbFnwrford5C+q/mYd
         7EU1S2yYk6fFkiHG5ho8IbKAGzjvAyG9yzn6IypeSzdvZ7vZ+XKfoeRZprYc0PLuu5N1
         qivgH8G3Fd7VvyDCkBZ2zyWdCMKZjlBsRHVPb6L+zergvs7R07Yly3fPrbhAFg6ku/Nx
         56bkZ4ZXIVz7UwNqITQhwOilInh+iB8etVqTwCduXc9Esl7/eu0vdK0QNwhSVOb3HWs5
         PtRWWsnOztgClWFhrQRJkfalE6f1FEE7rBifBH07Atj1/yvX3js0Af6qHvaGupi4vk0h
         Y7dA==
X-Gm-Message-State: AOAM53338SKuQFh+MYFeje81GgFvB5+EzfKTLDFb4uAMlcFULksxptY8
        8i0/i/pYIhqU4nLH1HeqFKP5DdpQdHLYHA==
X-Google-Smtp-Source: ABdhPJxTlkxEGent6H402e5f26v8fXWmy9JTGGbQQWmEoe+SPznDgdr7Dxy8gSb5zCCI2wOOpne+yA==
X-Received: by 2002:a17:906:b218:: with SMTP id p24mr2026988ejz.136.1603370461685;
        Thu, 22 Oct 2020 05:41:01 -0700 (PDT)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com. [209.85.221.52])
        by smtp.gmail.com with ESMTPSA id k9sm798752ejv.113.2020.10.22.05.40.59
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Oct 2020 05:41:00 -0700 (PDT)
Received: by mail-wr1-f52.google.com with SMTP id n18so2199224wrs.5
        for <ceph-devel@vger.kernel.org>; Thu, 22 Oct 2020 05:40:59 -0700 (PDT)
X-Received: by 2002:a5d:5748:: with SMTP id q8mr2478822wrw.299.1603370458980;
 Thu, 22 Oct 2020 05:40:58 -0700 (PDT)
MIME-Version: 1.0
References: <CACo-D_AU21TT6wcuUXTDquUY1UtSb265ga+0SAvU2S-RCWmzTw@mail.gmail.com>
In-Reply-To: <CACo-D_AU21TT6wcuUXTDquUY1UtSb265ga+0SAvU2S-RCWmzTw@mail.gmail.com>
From:   Dan van der Ster <dan@vanderster.com>
Date:   Thu, 22 Oct 2020 14:40:22 +0200
X-Gmail-Original-Message-ID: <CABZ+qq=n8XFYNtrJKThG3OViYa12pVMU4b5eVr58ZFHxbAod=A@mail.gmail.com>
Message-ID: <CABZ+qq=n8XFYNtrJKThG3OViYa12pVMU4b5eVr58ZFHxbAod=A@mail.gmail.com>
Subject: Re: [ceph-users] Urgent help needed please - MDS offline
To:     David C <dcsysengineer@gmail.com>
Cc:     ceph-users <ceph-users@ceph.io>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

You can disable that beacon by increasing mds_beacon_grace to 300 or
600. This will stop the mon from failing that mds over to a standby.
I don't know if that is set on the mon or mgr, so I usually set it on both.
(You might as well disable the standby too -- no sense in something
failing back and forth between two mdses).

Next -- looks like your mds is in active:replay. Is it doing anything?
Is it using lots of CPU/RAM? If you increase debug_mds do you see some
progress?

-- dan


On Thu, Oct 22, 2020 at 2:01 PM David C <dcsysengineer@gmail.com> wrote:
>
> Hi All
>
> My main CephFS data pool on a Luminous 12.2.10 cluster hit capacity
> overnight, metadata is on a separate pool which didn't hit capacity but the
> filesystem stopped working which I'd expect. I increased the osd full-ratio
> to give me some breathing room to get some data deleted once the filesystem
> is back online. When I attempt to restart the MDS service, I see the usual
> stuff I'd expect in the log but then:
>
> heartbeat_map is_healthy 'MDSRank' had timed out after 15
>
>
> Followed by:
>
> mds.beacon.hostnamecephssd01 Skipping beacon heartbeat to monitors (last
> > acked 4.00013s ago); MDS internal heartbeat is not healthy!
>
>
> Eventually I get:
>
> >
> > mds.beacon.hostnamecephssd01 is_laggy 29.372 > 15 since last acked beacon
> > mds.0.90884 skipping upkeep work because connection to Monitors appears
> > laggy
> > mds.hostnamecephssd01 Updating MDS map to version 90885 from mon.0
> > mds.beacon.hostnamecephssd01  MDS is no longer laggy
>
>
> The "MDS is no longer laggy" appears to be where the service fails
>
> Meanwhile a ceph -s is showing:
>
> >
> > cluster:
> >     id:     5c5998fd-dc9b-47ec-825e-beaba66aad11
> >     health: HEALTH_ERR
> >             1 filesystem is degraded
> >             insufficient standby MDS daemons available
> >             67 backfillfull osd(s)
> >             11 nearfull osd(s)
> >             full ratio(s) out of order
> >             2 pool(s) backfillfull
> >             2 pool(s) nearfull
> >             6 scrub errors
> >             Possible data damage: 5 pgs inconsistent
> >   services:
> >     mon: 3 daemons, quorum hostnameceph01,hostnameceph02,hostnameceph03
> >     mgr: hostnameceph03(active), standbys: hostnameceph02, hostnameceph01
> >     mds: cephfs-1/1/1 up  {0=hostnamecephssd01=up:replay}
> >     osd: 172 osds: 161 up, 161 in
> >   data:
> >     pools:   5 pools, 8384 pgs
> >     objects: 76.25M objects, 124TiB
> >     usage:   373TiB used, 125TiB / 498TiB avail
> >     pgs:     8379 active+clean
> >              5    active+clean+inconsistent
> >   io:
> >     client:   676KiB/s rd, 0op/s rd, 0op/s w
>
>
> The 5 pgs inconsistent is not a new issue, that is from past scrubs, just
> haven't gotten around to manually clearing them although I suppose they
> could be related to my issue
>
> The cluster has no clients connected
>
> I did notice in the ceph.log, some OSDs that are in the same host as the
> MDS service briefly went down when trying to restart the MDS but examining
> the logs of those particular OSDs isn't showing any glaring issues.
>
> Full MDS log at debug 5 (can go higher if needed):
>
> 2020-10-22 11:27:10.987652 7f6f696f5240  0 set uid:gid to 167:167
> (ceph:ceph)
> 2020-10-22 11:27:10.987669 7f6f696f5240  0 ceph version 12.2.10
> (177915764b752804194937482a39e95e0ca3de94) luminous (stable), process
> ceph-mds, pid 2022582
> 2020-10-22 11:27:10.990567 7f6f696f5240  0 pidfile_write: ignore empty
> --pid-file
> 2020-10-22 11:27:11.027981 7f6f62616700  1 mds.hostnamecephssd01 Updating
> MDS map to version 90882 from mon.0
> 2020-10-22 11:27:15.097957 7f6f62616700  1 mds.hostnamecephssd01 Updating
> MDS map to version 90883 from mon.0
> 2020-10-22 11:27:15.097989 7f6f62616700  1 mds.hostnamecephssd01 Map has
> assigned me to become a standby
> 2020-10-22 11:27:15.101071 7f6f62616700  1 mds.hostnamecephssd01 Updating
> MDS map to version 90884 from mon.0
> 2020-10-22 11:27:15.105310 7f6f62616700  1 mds.0.90884 handle_mds_map i am
> now mds.0.90884
> 2020-10-22 11:27:15.105316 7f6f62616700  1 mds.0.90884 handle_mds_map state
> change up:boot --> up:replay
> 2020-10-22 11:27:15.105325 7f6f62616700  1 mds.0.90884 replay_start
> 2020-10-22 11:27:15.105333 7f6f62616700  1 mds.0.90884  recovery set is
> 2020-10-22 11:27:15.105344 7f6f62616700  1 mds.0.90884  waiting for osdmap
> 73745 (which blacklists prior instance)
> 2020-10-22 11:27:15.149092 7f6f5be09700  0 mds.0.cache creating system
> inode with ino:0x100
> 2020-10-22 11:27:15.149693 7f6f5be09700  0 mds.0.cache creating system
> inode with ino:0x1
> 2020-10-22 11:27:41.021708 7f6f63618700  1 heartbeat_map is_healthy
> 'MDSRank' had timed out after 15
> 2020-10-22 11:27:43.029290 7f6f5f610700  1 heartbeat_map is_healthy
> 'MDSRank' had timed out after 15
> 2020-10-22 11:27:43.029297 7f6f5f610700  0 mds.beacon.hostnamecephssd01
> Skipping beacon heartbeat to monitors (last acked 4.00013s ago); MDS
> internal heartbeat is not healthy!
> 2020-10-22 11:27:45.866711 7f6f5fe11700  1 heartbeat_map reset_timeout
> 'MDSRank' had timed out after 15
> 2020-10-22 11:28:01.021965 7f6f63618700  1 heartbeat_map is_healthy
> 'MDSRank' had timed out after 15
> 2020-10-22 11:28:03.029862 7f6f5f610700  1 heartbeat_map is_healthy
> 'MDSRank' had timed out after 15
> 2020-10-22 11:28:03.029885 7f6f5f610700  0 mds.beacon.hostnamecephssd01
> Skipping beacon heartbeat to monitors (last acked 4.00113s ago); MDS
> internal heartbeat is not healthy!
> 2020-10-22 11:28:06.022033 7f6f63618700  1 heartbeat_map is_healthy
> 'MDSRank' had timed out after 15
> 2020-10-22 11:28:07.029955 7f6f5f610700  1 heartbeat_map is_healthy
> 'MDSRank' had timed out after 15
> 2020-10-22 11:28:07.029961 7f6f5f610700  0 mds.beacon.hostnamecephssd01
> Skipping beacon heartbeat to monitors (last acked 8.00126s ago); MDS
> internal heartbeat is not healthy!
> 2020-10-22 11:28:11.022099 7f6f63618700  1 heartbeat_map is_healthy
> 'MDSRank' had timed out after 15
> 2020-10-22 11:28:11.030024 7f6f5f610700  1 heartbeat_map is_healthy
> 'MDSRank' had timed out after 15
> 2020-10-22 11:28:11.030028 7f6f5f610700  0 mds.beacon.hostnamecephssd01
> Skipping beacon heartbeat to monitors (last acked 12.0014s ago); MDS
> internal heartbeat is not healthy!
> 2020-10-22 11:28:15.030092 7f6f5f610700  1 heartbeat_map is_healthy
> 'MDSRank' had timed out after 15
> 2020-10-22 11:28:15.030099 7f6f5f610700  0 mds.beacon.hostnamecephssd01
> Skipping beacon heartbeat to monitors (last acked 16.0015s ago); MDS
> internal heartbeat is not healthy!
> 2020-10-22 11:28:16.022165 7f6f63618700  1 heartbeat_map is_healthy
> 'MDSRank' had timed out after 15
> 2020-10-22 11:28:19.030163 7f6f5f610700  1 heartbeat_map is_healthy
> 'MDSRank' had timed out after 15
> 2020-10-22 11:28:19.030169 7f6f5f610700  0 mds.beacon.hostnamecephssd01
> Skipping beacon heartbeat to monitors (last acked 20.0016s ago); MDS
> internal heartbeat is not healthy!
> 2020-10-22 11:28:21.022231 7f6f63618700  1 heartbeat_map is_healthy
> 'MDSRank' had timed out after 15
> 2020-10-22 11:28:23.030233 7f6f5f610700  1 heartbeat_map is_healthy
> 'MDSRank' had timed out after 15
> 2020-10-22 11:28:23.030241 7f6f5f610700  0 mds.beacon.hostnamecephssd01
> Skipping beacon heartbeat to monitors (last acked 24.0008s ago); MDS
> internal heartbeat is not healthy!
> 2020-10-22 11:28:26.022295 7f6f63618700  1 heartbeat_map is_healthy
> 'MDSRank' had timed out after 15
> 2020-10-22 11:28:27.030305 7f6f5f610700  1 heartbeat_map is_healthy
> 'MDSRank' had timed out after 15
> 2020-10-22 11:28:27.030311 7f6f5f610700  0 mds.beacon.hostnamecephssd01
> Skipping beacon heartbeat to monitors (last acked 28.0009s ago); MDS
> internal heartbeat is not healthy!
> 2020-10-22 11:28:28.401161 7f6f5fe11700  1 heartbeat_map reset_timeout
> 'MDSRank' had timed out after 15
> 2020-10-22 11:28:28.401168 7f6f5fe11700  1 mds.beacon.hostnamecephssd01
> is_laggy 29.372 > 15 since last acked beacon
> 2020-10-22 11:28:28.401177 7f6f5fe11700  1 mds.0.90884 skipping upkeep work
> because connection to Monitors appears laggy
> 2020-10-22 11:28:28.401187 7f6f62616700  1 mds.hostnamecephssd01 Updating
> MDS map to version 90885 from mon.0
> 2020-10-22 11:28:31.659817 7f6f64595700  0 mds.beacon.hostnamecephssd01
>  MDS is no longer laggy
> 2020-10-22 11:36:15.880009 7f88ee4ac240  0 set uid:gid to 167:167
> (ceph:ceph)
> 2020-10-22 11:36:15.880026 7f88ee4ac240  0 ceph version 12.2.10
> (177915764b752804194937482a39e95e0ca3de94) luminous (stable), process
> ceph-mds, pid 2022663
> 2020-10-22 11:36:15.883118 7f88ee4ac240  0 pidfile_write: ignore empty
> --pid-file
> 2020-10-22 11:36:15.921200 7f88e73cd700  1 mds.hostnamecephssd01 Updating
> MDS map to version 90887 from mon.2
> 2020-10-22 11:36:20.270298 7f88e73cd700  1 mds.hostnamecephssd01 Updating
> MDS map to version 90888 from mon.2
> 2020-10-22 11:36:20.270329 7f88e73cd700  1 mds.hostnamecephssd01 Map has
> assigned me to become a standby
> 2020-10-22 11:36:20.272917 7f88e73cd700  1 mds.hostnamecephssd01 Updating
> MDS map to version 90889 from mon.2
> 2020-10-22 11:36:20.277063 7f88e73cd700  1 mds.0.90889 handle_mds_map i am
> now mds.0.90889
> 2020-10-22 11:36:20.277069 7f88e73cd700  1 mds.0.90889 handle_mds_map state
> change up:boot --> up:replay
> 2020-10-22 11:36:20.277079 7f88e73cd700  1 mds.0.90889 replay_start
> 2020-10-22 11:36:20.277086 7f88e73cd700  1 mds.0.90889  recovery set is
> 2020-10-22 11:36:20.277096 7f88e73cd700  1 mds.0.90889  waiting for osdmap
> 73746 (which blacklists prior instance)
> 2020-10-22 11:36:20.322318 7f88e0bc0700  0 mds.0.cache creating system
> inode with ino:0x100
> 2020-10-22 11:36:20.322918 7f88e0bc0700  0 mds.0.cache creating system
> inode with ino:0x1
> 2020-10-22 11:36:47.922531 7f88e43c7700  1 heartbeat_map is_healthy
> 'MDSRank' had timed out after 15
> 2020-10-22 11:36:47.922549 7f88e43c7700  0 mds.beacon.hostnamecephssd01
> Skipping beacon heartbeat to monitors (last acked 4.00013s ago); MDS
> internal heartbeat is not healthy!
> 2020-10-22 11:36:50.914516 7f88e83cf700  1 heartbeat_map is_healthy
> 'MDSRank' had timed out after 15
> 2020-10-22 11:36:51.351457 7f88e4bc8700  1 heartbeat_map reset_timeout
> 'MDSRank' had timed out after 15
> 2020-10-22 11:37:07.923089 7f88e43c7700  1 heartbeat_map is_healthy
> 'MDSRank' had timed out after 15
> 2020-10-22 11:37:07.923126 7f88e43c7700  0 mds.beacon.hostnamecephssd01
> Skipping beacon heartbeat to monitors (last acked 3.99913s ago); MDS
> internal heartbeat is not healthy!
> 2020-10-22 11:37:10.914767 7f88e83cf700  1 heartbeat_map is_healthy
> 'MDSRank' had timed out after 15
> 2020-10-22 11:37:11.923216 7f88e43c7700  1 heartbeat_map is_healthy
> 'MDSRank' had timed out after 15
> 2020-10-22 11:37:11.923223 7f88e43c7700  0 mds.beacon.hostnamecephssd01
> Skipping beacon heartbeat to monitors (last acked 7.99926s ago); MDS
> internal heartbeat is not healthy!
> 2020-10-22 11:37:15.914831 7f88e83cf700  1 heartbeat_map is_healthy
> 'MDSRank' had timed out after 15
> 2020-10-22 11:37:15.923286 7f88e43c7700  1 heartbeat_map is_healthy
> 'MDSRank' had timed out after 15
> 2020-10-22 11:37:15.923294 7f88e43c7700  0 mds.beacon.hostnamecephssd01
> Skipping beacon heartbeat to monitors (last acked 11.9994s ago); MDS
> internal heartbeat is not healthy!
> 2020-10-22 11:37:19.923359 7f88e43c7700  1 heartbeat_map is_healthy
> 'MDSRank' had timed out after 15
> 2020-10-22 11:37:19.923366 7f88e43c7700  0 mds.beacon.hostnamecephssd01
> Skipping beacon heartbeat to monitors (last acked 15.9995s ago); MDS
> internal heartbeat is not healthy!
> 2020-10-22 11:37:20.914917 7f88e83cf700  1 heartbeat_map is_healthy
> 'MDSRank' had timed out after 15
> 2020-10-22 11:37:23.923430 7f88e43c7700  1 heartbeat_map is_healthy
> 'MDSRank' had timed out after 15
> 2020-10-22 11:37:23.923437 7f88e43c7700  0 mds.beacon.hostnamecephssd01
> Skipping beacon heartbeat to monitors (last acked 19.9996s ago); MDS
> internal heartbeat is not healthy!
> 2020-10-22 11:37:25.914981 7f88e83cf700  1 heartbeat_map is_healthy
> 'MDSRank' had timed out after 15
> 2020-10-22 11:37:27.923501 7f88e43c7700  1 heartbeat_map is_healthy
> 'MDSRank' had timed out after 15
> 2020-10-22 11:37:27.923508 7f88e43c7700  0 mds.beacon.hostnamecephssd01
> Skipping beacon heartbeat to monitors (last acked 23.9998s ago); MDS
> internal heartbeat is not healthy!
> 2020-10-22 11:37:30.915046 7f88e83cf700  1 heartbeat_map is_healthy
> 'MDSRank' had timed out after 15
> 2020-10-22 11:37:31.923572 7f88e43c7700  1 heartbeat_map is_healthy
> 'MDSRank' had timed out after 15
> 2020-10-22 11:37:31.923579 7f88e43c7700  0 mds.beacon.hostnamecephssd01
> Skipping beacon heartbeat to monitors (last acked 27.9999s ago); MDS
> internal heartbeat is not healthy!
> 2020-10-22 11:37:32.412628 7f88e4bc8700  1 heartbeat_map reset_timeout
> 'MDSRank' had timed out after 15
> 2020-10-22 11:37:32.412635 7f88e4bc8700  1 mds.beacon.hostnamecephssd01
> is_laggy 28.4889 > 15 since last acked beacon
> 2020-10-22 11:37:32.412643 7f88e4bc8700  1 mds.0.90889 skipping upkeep work
> because connection to Monitors appears laggy
> 2020-10-22 11:37:32.412657 7f88e73cd700  1 mds.hostnamecephssd01 Updating
> MDS map to version 90890 from mon.2
> 2020-10-22 11:37:35.978858 7f88e934c700  0 mds.beacon.hostnamecephssd01
>  MDS is no longer laggy
>
>
> Thanks in advance for any assistance you can provide!
> David
> _______________________________________________
> ceph-users mailing list -- ceph-users@ceph.io
> To unsubscribe send an email to ceph-users-leave@ceph.io
