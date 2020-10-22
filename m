Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3BA295E12
	for <lists+ceph-devel@lfdr.de>; Thu, 22 Oct 2020 14:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503333AbgJVMLQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 22 Oct 2020 08:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438263AbgJVMLQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 22 Oct 2020 08:11:16 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33E4EC0613CE
        for <ceph-devel@vger.kernel.org>; Thu, 22 Oct 2020 05:11:16 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id h11so687323qvq.7
        for <ceph-devel@vger.kernel.org>; Thu, 22 Oct 2020 05:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=duL4wNchxnNLM1IsPBFwvp8VrlVb1PzxmlR8AazOwh4=;
        b=eFIgBUM4aZVluzVFX4gIcRIdSXGVE0hYkLyspr+wkOhXBGsZ0f5j3REVurKSGP7ZHT
         eF9lfWgwVOs5SAiTtBobsDMf+mXhlfXP7ESsjxmVMll7tPIB7AZxDWLp98tnFLf4/e3U
         /rypV8sagsQ+PabsGm9ijoNQF4MftMyVRsvgHivitgdhKFEI++paZMHF00kBr3qpWZwv
         toH4E6JuJRwyLV4+nM8pvyiNcnhwYi5QUIeHZRiZf2gMvHC/IFlJhc6JubURZ86OfTp7
         R6NohwdCdaedKLoC1X1uNyowENvh9ePQAz6Zcut0QmvFHeiURThsK0PkHF4tkYR25kvJ
         oplw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=duL4wNchxnNLM1IsPBFwvp8VrlVb1PzxmlR8AazOwh4=;
        b=UIp1TnZ921f40o3YA8T3LFnEd/3zcB0XMPqtzcgOEyNsJ/x5WiHd6/NjIYALMi3laH
         UGpE1wtPEgy8Dy0nZWc10nPtN1ty3rl4NcVXITkWMgAu+Ys0sdkkj/WOX0eM1bL8cdPZ
         uuPNB6BrSWsW7T4bsXXjCIf0bcivRAc2Cvc2jsGaG7Ob58GPEilsrz+JAMa3wLBzOJnr
         kLNZycg6YXm14Fu5GjU6HJCLqd98rh1oOCad32BXOWrYads1pC8SHed8Grq25pumTXZq
         QtKHyJcTVTgbT1QnVMH5GzbCAQunl8ncrTsY67pvoHLZY/SQeCvteLE89EV4A5zm+6/x
         1zJA==
X-Gm-Message-State: AOAM533LDgQYTVqRLrnaT8tRG7gdSwIc0+gvTkp40AY/+MfuZkYsVelB
        YRMPHnETIKkoG/0cDxF4C2LqYCIeVA7o/lsvJwRHRhpWTh4=
X-Google-Smtp-Source: ABdhPJxO4GlE61DnaaJcv/2MtFbVNQzC8vaMBZPQuvacWzzsDwsC0P95oQIaZbVF8RMiDWi7gslDOcLzP12wQsOA9ho=
X-Received: by 2002:ad4:4391:: with SMTP id s17mr1857401qvr.60.1603368674488;
 Thu, 22 Oct 2020 05:11:14 -0700 (PDT)
MIME-Version: 1.0
From:   David C <dcsysengineer@gmail.com>
Date:   Thu, 22 Oct 2020 13:11:03 +0100
Message-ID: <CACo-D_Anaa+L7G4F1p6BGiaWNCVJhFOHmTxceWyi6tGq66-aew@mail.gmail.com>
Subject: Urgent help needed please - MDS offline
To:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi All

My main CephFS data pool on a Luminous 12.2.10 cluster hit capacity
overnight, metadata is on a separate pool which didn't hit capacity
but the filesystem stopped working which I'd expect. I increased the
osd full-ratio to give me some breathing room to get some data deleted
once the filesystem is back online. When I attempt to restart the MDS
service, I see the usual stuff I'd expect in the log but then:

> heartbeat_map is_healthy 'MDSRank' had timed out after 15


Followed by:

> mds.beacon.hostnamecephssd01 Skipping beacon heartbeat to monitors (last acked 4.00013s ago); MDS internal heartbeat is not healthy!


Eventually I get:
>
>
> mds.beacon.hostnamecephssd01 is_laggy 29.372 > 15 since last acked beacon
> mds.0.90884 skipping upkeep work because connection to Monitors appears laggy
> mds.hostnamecephssd01 Updating MDS map to version 90885 from mon.0
> mds.beacon.hostnamecephssd01  MDS is no longer laggy


The "MDS is no longer laggy" appears to be where the service fails

Meanwhile a ceph -s is showing:
>
>
> cluster:
>     id:     5c5998fd-dc9b-47ec-825e-beaba66aad11
>     health: HEALTH_ERR
>             1 filesystem is degraded
>             insufficient standby MDS daemons available
>             67 backfillfull osd(s)
>             11 nearfull osd(s)
>             full ratio(s) out of order
>             2 pool(s) backfillfull
>             2 pool(s) nearfull
>             6 scrub errors
>             Possible data damage: 5 pgs inconsistent
>   services:
>     mon: 3 daemons, quorum hostnameceph01,hostnameceph02,hostnameceph03
>     mgr: hostnameceph03(active), standbys: hostnameceph02, hostnameceph01
>     mds: cephfs-1/1/1 up  {0=hostnamecephssd01=up:replay}
>     osd: 172 osds: 161 up, 161 in
>   data:
>     pools:   5 pools, 8384 pgs
>     objects: 76.25M objects, 124TiB
>     usage:   373TiB used, 125TiB / 498TiB avail
>     pgs:     8379 active+clean
>              5    active+clean+inconsistent
>   io:
>     client:   676KiB/s rd, 0op/s rd, 0op/s w


The 5 pgs inconsistent is not a new issue, that is from past scrubs,
just haven't gotten around to manually clearing them although I
suppose they could be related to my issue

The cluster has no clients connected

I did notice in the ceph.log, some OSDs that are in the same host as
the MDS service briefly went down when trying to restart the MDS but
examining the logs of those particular OSDs isn't showing any glaring
issues.

Full MDS log at debug 5 (can go higher if needed):

2020-10-22 11:27:10.987652 7f6f696f5240  0 set uid:gid to 167:167 (ceph:ceph)
2020-10-22 11:27:10.987669 7f6f696f5240  0 ceph version 12.2.10
(177915764b752804194937482a39e95e0ca3de94) luminous (stable), process
ceph-mds, pid 2022582
2020-10-22 11:27:10.990567 7f6f696f5240  0 pidfile_write: ignore empty
--pid-file
2020-10-22 11:27:11.027981 7f6f62616700  1 mds.hostnamecephssd01
Updating MDS map to version 90882 from mon.0
2020-10-22 11:27:15.097957 7f6f62616700  1 mds.hostnamecephssd01
Updating MDS map to version 90883 from mon.0
2020-10-22 11:27:15.097989 7f6f62616700  1 mds.hostnamecephssd01 Map
has assigned me to become a standby
2020-10-22 11:27:15.101071 7f6f62616700  1 mds.hostnamecephssd01
Updating MDS map to version 90884 from mon.0
2020-10-22 11:27:15.105310 7f6f62616700  1 mds.0.90884 handle_mds_map
i am now mds.0.90884
2020-10-22 11:27:15.105316 7f6f62616700  1 mds.0.90884 handle_mds_map
state change up:boot --> up:replay
2020-10-22 11:27:15.105325 7f6f62616700  1 mds.0.90884 replay_start
2020-10-22 11:27:15.105333 7f6f62616700  1 mds.0.90884  recovery set is
2020-10-22 11:27:15.105344 7f6f62616700  1 mds.0.90884  waiting for
osdmap 73745 (which blacklists prior instance)
2020-10-22 11:27:15.149092 7f6f5be09700  0 mds.0.cache creating system
inode with ino:0x100
2020-10-22 11:27:15.149693 7f6f5be09700  0 mds.0.cache creating system
inode with ino:0x1
2020-10-22 11:27:41.021708 7f6f63618700  1 heartbeat_map is_healthy
'MDSRank' had timed out after 15
2020-10-22 11:27:43.029290 7f6f5f610700  1 heartbeat_map is_healthy
'MDSRank' had timed out after 15
2020-10-22 11:27:43.029297 7f6f5f610700  0
mds.beacon.hostnamecephssd01 Skipping beacon heartbeat to monitors
(last acked 4.00013s ago); MDS internal heartbeat is not healthy!
2020-10-22 11:27:45.866711 7f6f5fe11700  1 heartbeat_map reset_timeout
'MDSRank' had timed out after 15
2020-10-22 11:28:01.021965 7f6f63618700  1 heartbeat_map is_healthy
'MDSRank' had timed out after 15
2020-10-22 11:28:03.029862 7f6f5f610700  1 heartbeat_map is_healthy
'MDSRank' had timed out after 15
2020-10-22 11:28:03.029885 7f6f5f610700  0
mds.beacon.hostnamecephssd01 Skipping beacon heartbeat to monitors
(last acked 4.00113s ago); MDS internal heartbeat is not healthy!
2020-10-22 11:28:06.022033 7f6f63618700  1 heartbeat_map is_healthy
'MDSRank' had timed out after 15
2020-10-22 11:28:07.029955 7f6f5f610700  1 heartbeat_map is_healthy
'MDSRank' had timed out after 15
2020-10-22 11:28:07.029961 7f6f5f610700  0
mds.beacon.hostnamecephssd01 Skipping beacon heartbeat to monitors
(last acked 8.00126s ago); MDS internal heartbeat is not healthy!
2020-10-22 11:28:11.022099 7f6f63618700  1 heartbeat_map is_healthy
'MDSRank' had timed out after 15
2020-10-22 11:28:11.030024 7f6f5f610700  1 heartbeat_map is_healthy
'MDSRank' had timed out after 15
2020-10-22 11:28:11.030028 7f6f5f610700  0
mds.beacon.hostnamecephssd01 Skipping beacon heartbeat to monitors
(last acked 12.0014s ago); MDS internal heartbeat is not healthy!
2020-10-22 11:28:15.030092 7f6f5f610700  1 heartbeat_map is_healthy
'MDSRank' had timed out after 15
2020-10-22 11:28:15.030099 7f6f5f610700  0
mds.beacon.hostnamecephssd01 Skipping beacon heartbeat to monitors
(last acked 16.0015s ago); MDS internal heartbeat is not healthy!
2020-10-22 11:28:16.022165 7f6f63618700  1 heartbeat_map is_healthy
'MDSRank' had timed out after 15
2020-10-22 11:28:19.030163 7f6f5f610700  1 heartbeat_map is_healthy
'MDSRank' had timed out after 15
2020-10-22 11:28:19.030169 7f6f5f610700  0
mds.beacon.hostnamecephssd01 Skipping beacon heartbeat to monitors
(last acked 20.0016s ago); MDS internal heartbeat is not healthy!
2020-10-22 11:28:21.022231 7f6f63618700  1 heartbeat_map is_healthy
'MDSRank' had timed out after 15
2020-10-22 11:28:23.030233 7f6f5f610700  1 heartbeat_map is_healthy
'MDSRank' had timed out after 15
2020-10-22 11:28:23.030241 7f6f5f610700  0
mds.beacon.hostnamecephssd01 Skipping beacon heartbeat to monitors
(last acked 24.0008s ago); MDS internal heartbeat is not healthy!
2020-10-22 11:28:26.022295 7f6f63618700  1 heartbeat_map is_healthy
'MDSRank' had timed out after 15
2020-10-22 11:28:27.030305 7f6f5f610700  1 heartbeat_map is_healthy
'MDSRank' had timed out after 15
2020-10-22 11:28:27.030311 7f6f5f610700  0
mds.beacon.hostnamecephssd01 Skipping beacon heartbeat to monitors
(last acked 28.0009s ago); MDS internal heartbeat is not healthy!
2020-10-22 11:28:28.401161 7f6f5fe11700  1 heartbeat_map reset_timeout
'MDSRank' had timed out after 15
2020-10-22 11:28:28.401168 7f6f5fe11700  1
mds.beacon.hostnamecephssd01 is_laggy 29.372 > 15 since last acked
beacon
2020-10-22 11:28:28.401177 7f6f5fe11700  1 mds.0.90884 skipping upkeep
work because connection to Monitors appears laggy
2020-10-22 11:28:28.401187 7f6f62616700  1 mds.hostnamecephssd01
Updating MDS map to version 90885 from mon.0
2020-10-22 11:28:31.659817 7f6f64595700  0
mds.beacon.hostnamecephssd01  MDS is no longer laggy
2020-10-22 11:36:15.880009 7f88ee4ac240  0 set uid:gid to 167:167 (ceph:ceph)
2020-10-22 11:36:15.880026 7f88ee4ac240  0 ceph version 12.2.10
(177915764b752804194937482a39e95e0ca3de94) luminous (stable), process
ceph-mds, pid 2022663
2020-10-22 11:36:15.883118 7f88ee4ac240  0 pidfile_write: ignore empty
--pid-file
2020-10-22 11:36:15.921200 7f88e73cd700  1 mds.hostnamecephssd01
Updating MDS map to version 90887 from mon.2
2020-10-22 11:36:20.270298 7f88e73cd700  1 mds.hostnamecephssd01
Updating MDS map to version 90888 from mon.2
2020-10-22 11:36:20.270329 7f88e73cd700  1 mds.hostnamecephssd01 Map
has assigned me to become a standby
2020-10-22 11:36:20.272917 7f88e73cd700  1 mds.hostnamecephssd01
Updating MDS map to version 90889 from mon.2
2020-10-22 11:36:20.277063 7f88e73cd700  1 mds.0.90889 handle_mds_map
i am now mds.0.90889
2020-10-22 11:36:20.277069 7f88e73cd700  1 mds.0.90889 handle_mds_map
state change up:boot --> up:replay
2020-10-22 11:36:20.277079 7f88e73cd700  1 mds.0.90889 replay_start
2020-10-22 11:36:20.277086 7f88e73cd700  1 mds.0.90889  recovery set is
2020-10-22 11:36:20.277096 7f88e73cd700  1 mds.0.90889  waiting for
osdmap 73746 (which blacklists prior instance)
2020-10-22 11:36:20.322318 7f88e0bc0700  0 mds.0.cache creating system
inode with ino:0x100
2020-10-22 11:36:20.322918 7f88e0bc0700  0 mds.0.cache creating system
inode with ino:0x1
2020-10-22 11:36:47.922531 7f88e43c7700  1 heartbeat_map is_healthy
'MDSRank' had timed out after 15
2020-10-22 11:36:47.922549 7f88e43c7700  0
mds.beacon.hostnamecephssd01 Skipping beacon heartbeat to monitors
(last acked 4.00013s ago); MDS internal heartbeat is not healthy!
2020-10-22 11:36:50.914516 7f88e83cf700  1 heartbeat_map is_healthy
'MDSRank' had timed out after 15
2020-10-22 11:36:51.351457 7f88e4bc8700  1 heartbeat_map reset_timeout
'MDSRank' had timed out after 15
2020-10-22 11:37:07.923089 7f88e43c7700  1 heartbeat_map is_healthy
'MDSRank' had timed out after 15
2020-10-22 11:37:07.923126 7f88e43c7700  0
mds.beacon.hostnamecephssd01 Skipping beacon heartbeat to monitors
(last acked 3.99913s ago); MDS internal heartbeat is not healthy!
2020-10-22 11:37:10.914767 7f88e83cf700  1 heartbeat_map is_healthy
'MDSRank' had timed out after 15
2020-10-22 11:37:11.923216 7f88e43c7700  1 heartbeat_map is_healthy
'MDSRank' had timed out after 15
2020-10-22 11:37:11.923223 7f88e43c7700  0
mds.beacon.hostnamecephssd01 Skipping beacon heartbeat to monitors
(last acked 7.99926s ago); MDS internal heartbeat is not healthy!
2020-10-22 11:37:15.914831 7f88e83cf700  1 heartbeat_map is_healthy
'MDSRank' had timed out after 15
2020-10-22 11:37:15.923286 7f88e43c7700  1 heartbeat_map is_healthy
'MDSRank' had timed out after 15
2020-10-22 11:37:15.923294 7f88e43c7700  0
mds.beacon.hostnamecephssd01 Skipping beacon heartbeat to monitors
(last acked 11.9994s ago); MDS internal heartbeat is not healthy!
2020-10-22 11:37:19.923359 7f88e43c7700  1 heartbeat_map is_healthy
'MDSRank' had timed out after 15
2020-10-22 11:37:19.923366 7f88e43c7700  0
mds.beacon.hostnamecephssd01 Skipping beacon heartbeat to monitors
(last acked 15.9995s ago); MDS internal heartbeat is not healthy!
2020-10-22 11:37:20.914917 7f88e83cf700  1 heartbeat_map is_healthy
'MDSRank' had timed out after 15
2020-10-22 11:37:23.923430 7f88e43c7700  1 heartbeat_map is_healthy
'MDSRank' had timed out after 15
2020-10-22 11:37:23.923437 7f88e43c7700  0
mds.beacon.hostnamecephssd01 Skipping beacon heartbeat to monitors
(last acked 19.9996s ago); MDS internal heartbeat is not healthy!
2020-10-22 11:37:25.914981 7f88e83cf700  1 heartbeat_map is_healthy
'MDSRank' had timed out after 15
2020-10-22 11:37:27.923501 7f88e43c7700  1 heartbeat_map is_healthy
'MDSRank' had timed out after 15
2020-10-22 11:37:27.923508 7f88e43c7700  0
mds.beacon.hostnamecephssd01 Skipping beacon heartbeat to monitors
(last acked 23.9998s ago); MDS internal heartbeat is not healthy!
2020-10-22 11:37:30.915046 7f88e83cf700  1 heartbeat_map is_healthy
'MDSRank' had timed out after 15
2020-10-22 11:37:31.923572 7f88e43c7700  1 heartbeat_map is_healthy
'MDSRank' had timed out after 15
2020-10-22 11:37:31.923579 7f88e43c7700  0
mds.beacon.hostnamecephssd01 Skipping beacon heartbeat to monitors
(last acked 27.9999s ago); MDS internal heartbeat is not healthy!
2020-10-22 11:37:32.412628 7f88e4bc8700  1 heartbeat_map reset_timeout
'MDSRank' had timed out after 15
2020-10-22 11:37:32.412635 7f88e4bc8700  1
mds.beacon.hostnamecephssd01 is_laggy 28.4889 > 15 since last acked
beacon
2020-10-22 11:37:32.412643 7f88e4bc8700  1 mds.0.90889 skipping upkeep
work because connection to Monitors appears laggy
2020-10-22 11:37:32.412657 7f88e73cd700  1 mds.hostnamecephssd01
Updating MDS map to version 90890 from mon.2
2020-10-22 11:37:35.978858 7f88e934c700  0
mds.beacon.hostnamecephssd01  MDS is no longer laggy


Thanks in advance for any assistance you can provide!
David
