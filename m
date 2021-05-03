Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDEE371649
	for <lists+ceph-devel@lfdr.de>; Mon,  3 May 2021 15:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233815AbhECNzj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Mon, 3 May 2021 09:55:39 -0400
Received: from smobe-rbx-k8s190.smobe.fr ([51.210.113.172]:20300 "EHLO
        zimbra.smobe.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231771AbhECNzc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 3 May 2021 09:55:32 -0400
X-Greylist: delayed 356 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 May 2021 09:55:32 EDT
Received: from localhost (localhost [127.0.0.1])
        by zimbra.smobe.fr (Postfix) with ESMTP id 2FA07318A57;
        Mon,  3 May 2021 13:48:38 +0000 (UTC)
Received: from zimbra.smobe.fr ([127.0.0.1])
        by localhost (zimbra.smobe.fr [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id Xa3bx1YLQ8IB; Mon,  3 May 2021 13:48:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
        by zimbra.smobe.fr (Postfix) with ESMTP id DB3C7318A55;
        Mon,  3 May 2021 13:48:37 +0000 (UTC)
X-Virus-Scanned: amavisd-new at smobe.fr
Received: from zimbra.smobe.fr ([127.0.0.1])
        by localhost (zimbra.smobe.fr [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id HQ87mUjs5U0v; Mon,  3 May 2021 13:48:37 +0000 (UTC)
Received: from gimli (unknown [10.244.3.0])
        by zimbra.smobe.fr (Postfix) with ESMTPSA id 7F0BC318A31;
        Mon,  3 May 2021 13:48:37 +0000 (UTC)
Message-ID: <d81929d41edfc41c645e49220e8644ed924d6fb0.camel@predical.fr>
Subject: Re: [ceph-users] [ Ceph MDS MON Config Variables ] Failover Delay
 issue
From:   Olivier AUDRY <oaudry@predical.fr>
To:     Lokendra Rathour <lokendrarathour@gmail.com>,
        ceph-devel@vger.kernel.org, dev@ceph.io, ceph-users@ceph.io
Date:   Mon, 03 May 2021 15:48:36 +0200
In-Reply-To: <CAJm6b-741TRptPWOqoqEJG6m00auekTkcWUD+z3sxH1-34THgA@mail.gmail.com>
References: <CAJm6b-741TRptPWOqoqEJG6m00auekTkcWUD+z3sxH1-34THgA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

hello

perhaps you should have more than one MDS active.

mds: cephfs:3 {0=cephfs-d=up:active,1=cephfs-e=up:active,2=cephfs-
a=up:active} 1 up:standby-replay

I got 3 active mds and one standby.

I'm using rook in kubernetes for this setup.

oau

Le lundi 03 mai 2021 à 19:06 +0530, Lokendra Rathour a écrit :
> Hi Team,
> I was setting up the ceph cluster with
> 
>    - Node Details:3 Mon,2 MDS, 2 Mgr, 2 RGW
>    - Deployment Type: Active Standby
>    - Testing Mode: Failover of MDS Node
>    - Setup : Octopus (15.2.7)
>    - OS: centos 8.3
>    - hardware: HP
>    - Ram:  128 GB on each Node
>    - OSD: 2 ( 1 tb each)
>    - Operation: Normal I/O with mkdir on every 1 second.
> 
> T*est Case: Power-off any active MDS Node for failover to happen*
> 
> *Observation:*
> We have observed that whenever an active MDS Node is down it takes
> around*
> 40 seconds* to activate the standby MDS Node.
> on further checking the logs for the new-handover MDS Node we have
> seen
> delay on the basis of following inputs:
> 
>    1. 10 second delay after which Mon calls for new Monitor election
>       1.  [log]  0 log_channel(cluster) log [INF] : mon.cephnode1
> calling
>       monitor election
>    2. 5 second delay in which newly elected Monitor is elected
>       1. [log] 0 log_channel(cluster) log [INF] : mon.cephnode1 is
> new
>       leader, mons cephnode1,cephnode3 in quorum (ranks 0,2)
>       3. the addition beacon grace time for which the system waits
> before
>    which it enables standby MDS node activation. (approx delay of 19
> seconds)
>       1. defaults :  sudo ceph config get mon mds_beacon_grace
>       15.000000
>       2. sudo ceph config get mon mds_beacon_interval
>       5.000000
>       3. [log] - 2021-04-30T18:23:10.136+0530 7f4e3925c700  1
>       mon.cephnode2@1(leader).mds e776 no beacon from mds.0.771 (gid:
>       639443 addr: [v2:
>       10.0.4.10:6800/2172152716,v1:10.0.4.10:6801/2172152716] state:
>       up:active)* since 18.7951*
>    4. *in Total it takes around 40 seconds to handover and activate
> passive
>    standby node. *
> 
> *Query:*
> 
>    1. Can these variables be configured ?  which we have tried,but
> are not
>    aware of the overall impact on the ceph cluster because of these
> changes
>       1. By tuning these values we could reach the minimum time of 12
>       seconds in which the active node comes up.
>       2. Values taken to get the said time :
>          1. *mon_election_timeout* (default 5) - configured as 1
>          2. *mon_lease*(default 5)  - configured as 2
>          3.  *mds_beacon_grace* (default 15) - configured as 5
>          4.  *mds_beacon_interval* (default 5) - configured as 1
> 
> We need to tune this setup to get the failover duration as low as 5-7
> seconds.
> 
> Please suggest/support and share your inputs, my setup is ready and
> already
> we are testing with multiple scenarios so that we are able to achive
> min
> failover duration.
> 

