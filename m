Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD9A29634F
	for <lists+ceph-devel@lfdr.de>; Thu, 22 Oct 2020 19:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898434AbgJVRDU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 22 Oct 2020 13:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2505682AbgJVRDT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 22 Oct 2020 13:03:19 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B8CBC0613CE
        for <ceph-devel@vger.kernel.org>; Thu, 22 Oct 2020 10:03:19 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id bl9so1242124qvb.10
        for <ceph-devel@vger.kernel.org>; Thu, 22 Oct 2020 10:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2Dcq1eGLEC7qVRi1GrekGz43UdffzFlvHVradxzdloo=;
        b=nJCvbhpkILj7lSuMiweh+KlgfYYtJ4KPSu2b8sKX7Qa/1x7Za2tCq0kxV7COSHDkff
         vW6uHsdbcH2mbRnMeBgSbXgWe8x1kDfWs16qsp3Qm65GrX/dnIYNMTt19o9VHrqjvhZX
         CQ4uROCEKJpRTnGr7o4bF9lYjU8nzlJzmKvWrqK110Bs0HGiGCUVwsCMnY/tnzN3Lg4n
         /TCQGNWZg30xXqBO5+WykYT7fEEPfi3YnnWAOPH8jFAbPRZco9QpZaXKtu0mifFWDjkj
         k/Tub7DyZbSwzXafXaZt0z2XjcEY+ZL2WZqz5GaPA7Tw6wsOGN3pSduADr+t4K/al1U3
         rphQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2Dcq1eGLEC7qVRi1GrekGz43UdffzFlvHVradxzdloo=;
        b=b4BXXkOWajL6FFPMQ9NrFw99Q0t2HpLSKWs+VEa8UNyFgC+s6So3RV74u9HmBkVaEO
         Rao3vRKOfZNXwBwbeHPweGPx4/p7u/l0nb6ldA0iu78SWN5bVKbNZ6VkmtJW442deOqx
         mfY1JMHdzAJby6+VhGmg868GLBVepl9AwE6A7uh/lJgqh2f/A9laJYyFaF/4a9YEUIyF
         fLXxZsEqE+bRjec0F1AlEywoTsYkuVsWEP1x7BVRR/ByKIi+o0jSj3ZhU2EKz/khv7Rd
         yZuErhEKMhZW+McOsAxvePCEXo1yThnRK1m4GaeejibeVWCXUIC0l/Dcjx3yZv+M830S
         yg7Q==
X-Gm-Message-State: AOAM531env9mdkBMVbARjF3gLyoG4HoBTJyW0oAbQlIgJeadYBXVuOCw
        NjTwXmXh71tUBBpMbGHc7liu+u/39HgBvRmJdqBJ658GY3o=
X-Google-Smtp-Source: ABdhPJy2dfIjtxycaJKsTmsQmfS4N4SUcW8udSgxtfLSd5Z+Yf3jh3w4WIrx12gg0zOYKUKfQMVZXkiVJvG+no7/bbw=
X-Received: by 2002:a0c:8064:: with SMTP id 91mr3540535qva.34.1603386198003;
 Thu, 22 Oct 2020 10:03:18 -0700 (PDT)
MIME-Version: 1.0
References: <CACo-D_AU21TT6wcuUXTDquUY1UtSb265ga+0SAvU2S-RCWmzTw@mail.gmail.com>
 <CABZ+qq=n8XFYNtrJKThG3OViYa12pVMU4b5eVr58ZFHxbAod=A@mail.gmail.com>
 <CACo-D_DhNDXAyOjJR6W9JYhZP7m9pfbh7q-G1nDMJhHskdtOXQ@mail.gmail.com>
 <CABZ+qqk1ii6sjK4izGb-ReZdUDy4U-7gRj6ywFxzHkpEGuOOHQ@mail.gmail.com>
 <CACo-D_D6abDxhwUY2ZdkFbdwTPduhKbvtK7+7GFL5VWQJbZ7xw@mail.gmail.com>
 <CABZ+qqkB_daQ+yfq+CR3Ye+8t+gv_QuavNWNRJzxP6Og5VKROg@mail.gmail.com>
 <CACo-D_BxGq2-Dq6FahNXPN6rj3BeoKmJuq6j5Nhqzcx74URqHg@mail.gmail.com>
 <CABZ+qqmvn-Yd3ZhPd3q4-RFtqjGgeHLCMwVvjMLJ4fmtxY9-gA@mail.gmail.com> <1867678ff367465eb7a6767a62b45764@dtu.dk>
In-Reply-To: <1867678ff367465eb7a6767a62b45764@dtu.dk>
From:   David C <dcsysengineer@gmail.com>
Date:   Thu, 22 Oct 2020 18:03:06 +0100
Message-ID: <CACo-D_Cjb0TF47ZwYYAXkpnYWN-9eAXtc4K3fGaC=ZLUvHzLRA@mail.gmail.com>
Subject: Re: [ceph-users] Re: Urgent help needed please - MDS offline
To:     Frank Schilder <frans@dtu.dk>
Cc:     Dan van der Ster <dan@vanderster.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        ceph-users <ceph-users@ceph.io>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Thanks, guys

I can't add more RAM right now or have access to a server that does,
I'd fear it wouldn't be enough anyway. I'll give the swap idea a go
and try and track down the thread you mentioned, Frank.

'cephfs-journal-tool journal inspect' tells me the journal is fine. I
was able to back it up cleanly, however the apparent size of the file
reported by du is 53TB, does that sound right to you? The actual size
is 3.7GB.

'cephfs-journal-tool event get list' starts listing events but
eventually gets killed as expected.

'cephfs-journal-tool event get summary'
Events by type:
  OPEN: 314260
  SUBTREEMAP: 1134
  UPDATE: 547973
Errors: 0

Those numbers seem really high to me - for reference this is an approx
128TB (usable space) cluster, 5050000 objects in metadata pool.

On Thu, Oct 22, 2020 at 5:23 PM Frank Schilder <frans@dtu.dk> wrote:
>
> If you can't add RAM, you could try provisioning SWAP on a reasonably fas=
t drive. There is a thread from this year where someone had a similar probl=
em, the MDS running out of memory during replay. He could quickly add suffi=
cient swap and the MDS managed to come up. Took a long time though, but mig=
ht be faster than getting more RAM and will not loose data.
>
> Your clients will not be able to do much, if anything during recovery tho=
ugh.
>
> Best regards,
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Frank Schilder
> AIT Ris=C3=B8 Campus
> Bygning 109, rum S14
>
> ________________________________________
> From: Dan van der Ster <dan@vanderster.com>
> Sent: 22 October 2020 18:11:57
> To: David C
> Cc: ceph-devel; ceph-users
> Subject: [ceph-users] Re: Urgent help needed please - MDS offline
>
> I assume you aren't able to quickly double the RAM on this MDS ? or
> failover to a new MDS with more ram?
>
> Failing that, you shouldn't reset the journal without recovering
> dentries, otherwise the cephfs_data objects won't be consistent with
> the metadata.
> The full procedure to be used is here:
> https://docs.ceph.com/en/latest/cephfs/disaster-recovery-experts/#disaste=
r-recovery-experts
>
>      backup the journal, recover dentires, then reset the journal.
> (the steps after might not be needed)
>
> That said -- maybe there is a more elegant procedure than using
> cephfs-journal-tool.  A cephfs dev might have better advice.
>
> -- dan
>
>
> On Thu, Oct 22, 2020 at 6:03 PM David C <dcsysengineer@gmail.com> wrote:
> >
> > I'm pretty sure it's replaying the same ops every time, the last
> > "EMetaBlob.replay updated dir" before it dies is always referring to
> > the same directory. Although interestingly that particular dir shows
> > up in the log thousands of times - the dir appears to be where a
> > desktop app is doing some analytics collecting - I don't know if
> > that's likely to be a red herring or the reason why the journal
> > appears to be so long. It's a dir I'd be quite happy to lose changes
> > to or remove from the file system altogether.
> >
> > I'm loath to update during an outage although I have seen people
> > update the MDS code independently to get out of a scrape - I suspect
> > you wouldn't recommend that.
> >
> > I feel like this leaves me with having to manipulate the journal in
> > some way, is there a nuclear option where I can choose to disregard
> > the uncommitted events? I assume that would be a journal reset with
> > the cephfs-journal-tool but I'm unclear on the impact of that, I'd
> > expect to lose any metadata changes that were made since my cluster
> > filled up but are there further implications? I also wonder what's the
> > riskier option, resetting the journal or attempting an update.
> >
> > I'm very grateful for your help so far
> >
> > Below is more of the debug 10 log with ops relating to the
> > aforementioned dir (name changed but inode is accurate):
> >
> > 2020-10-22 16:44:00.488850 7f424659e700 10 mds.0.journal
> > EMetaBlob.replay updated dir [dir 0x10009e1ec8d /path/to/desktop/app/
> > [2,head] auth v=3D911968 cv=3D0/0 state=3D1610612736 f(v0 m2020-10-14
> > 16:32:42.596652 1=3D0+1) n(v6164 rc2020-10-22 08:46:44.932805 b13333759=
2
> > 89216=3D89215+1)/n(v6164 rc2020-10-22 08:46:43.950805 b133337592
> > 89214=3D89213+1) hs=3D1+0,ss=3D0+0 dirty=3D1 | child=3D1 dirty=3D1 0x56=
54f8288300]
> > 2020-10-22 16:44:00.488864 7f424659e700 10 mds.0.journal
> > EMetaBlob.replay for [2,head] had [dentry
> > #0x1/path/to/desktop/app/Upload [2,head] auth (dversion lock) v=3D91196=
7
> > inode=3D0x5654f8288a00 state=3D1610612736 | inodepin=3D1 dirty=3D1
> > 0x5654f82794a0]
> > 2020-10-22 16:44:00.488873 7f424659e700 10 mds.0.journal
> > EMetaBlob.replay for [2,head] had [inode 0x10009e1ec8e [...2,head]
> > /path/to/desktop/app/Upload/ auth v911967 f(v0 m2020-10-22
> > 08:46:44.932805 89215=3D89215+0) n(v2 rc2020-10-22 08:46:44.932805
> > b133337592 89216=3D89215+1) (iversion lock) | dirfrag=3D1 dirty=3D1
> > 0x5654f8288a00]
> > 2020-10-22 16:44:00.488884 7f424659e700 10 mds.0.journal
> > EMetaBlob.replay dir 0x10009e1ec8e
> > 2020-10-22 16:44:00.488885 7f424659e700 10 mds.0.journal
> > EMetaBlob.replay updated dir [dir 0x10009e1ec8e
> > /path/to/desktop/app/Upload/ [2,head] auth v=3D904150 cv=3D0/0
> > state=3D1073741824 f(v0 m2020-10-22 08:46:44.932805 89215=3D89215+0) n(=
v2
> > rc2020-10-22 08:46:44.932805 b133337592 89215=3D89215+0)
> > hs=3D42926+1178,ss=3D0+0 dirty=3D2375 | child=3D1 0x5654f8289100]
> > 2020-10-22 16:44:00.488898 7f424659e700 10 mds.0.journal
> > EMetaBlob.replay added (full) [dentry
> > #0x1/path/to/desktop/app/Upload/{dc97bb9c-4600-48bb-b232-23f9e45caa6e}.=
tmp
> > [2,head] auth NULL (dversion lock) v=3D904149 inode=3D0
> > state=3D1610612800|bottomlru | dirty=3D1 0x56586df52f00]
> > 2020-10-22 16:44:00.488911 7f424659e700 10 mds.0.journal
> > EMetaBlob.replay added [inode 0x1000e4c0ff4 [2,head]
> > /path/to/desktop/app/Upload/{dc97bb9c-4600-48bb-b232-23f9e45caa6e}.tmp
> > auth v904149 s=3D0 n(v0 1=3D1+0) (iversion lock) 0x566ce168ce00]
> > 2020-10-22 16:44:00.488918 7f424659e700 10
> > mds.0.cache.ino(0x1000e4c0ff4) mark_dirty_parent
> > 2020-10-22 16:44:00.488920 7f424659e700 10 mds.0.journal
> > EMetaBlob.replay noting opened inode [inode 0x1000e4c0ff4 [2,head]
> > /path/to/desktop/app/Upload/{dc97bb9c-4600-48bb-b232-23f9e45caa6e}.tmp
> > auth v904149 dirtyparent s=3D0 n(v0 1=3D1+0) (iversion lock) |
> > dirtyparent=3D1 dirty=3D1 0x566ce168ce00]
> > 2020-10-22 16:44:00.488924 7f424659e700 10 mds.0.journal
> > EMetaBlob.replay inotable tablev 481253 <=3D table 481328
> > 2020-10-22 16:44:00.488926 7f424659e700 10 mds.0.journal
> > EMetaBlob.replay sessionmap v 240341131 <=3D table 240378576
> > 2020-10-22 16:44:00.488927 7f424659e700 10 mds.0.journal
> > EMetaBlob.replay request client.16250824:1416595263 trim_to 1416595263
> > 2020-10-22 16:44:00.491462 7f424659e700 10 mds.0.log _replay
> > 57437755528637~11764673 / 57441334490146 2020-10-22 09:08:56.198798:
> > EOpen [metablob 0x10009e1ec8e, 1881 dirs], 16748 open files
> > 2020-10-22 16:44:00.491471 7f424659e700 10 mds.0.journal EOpen.replay
> > 2020-10-22 16:44:00.491472 7f424659e700 10 mds.0.journal
> > EMetaBlob.replay 1881 dirlumps by unknown.0
> > 2020-10-22 16:44:00.491475 7f424659e700 10 mds.0.journal
> > EMetaBlob.replay dir 0x10009e1ec8e
> > 2020-10-22 16:44:00.491478 7f424659e700 10 mds.0.journal
> > EMetaBlob.replay updated dir [dir 0x10009e1ec8e
> > /path/to/desktop/app/Upload/ [2,head] auth v=3D904150 cv=3D0/0
> > state=3D1073741824 f(v0 m2020-10-22 08:46:44.932805 89215=3D89215+0) n(=
v2
> > rc2020-10-22 08:46:44.932805 b133337592 89215=3D89215+0)
> > hs=3D42927+1178,ss=3D0+0 dirty=3D2376 | child=3D1 0x5654f8289100]
> > 2020-10-22 16:44:03.783487 7f424ada7700  5
> > mds.beacon.hostnamecephssd01 Sending beacon up:replay seq 14
> > 2020-10-22 16:44:03.784082 7f424fd2c700  5
> > mds.beacon.hostnamecephssd01 received beacon reply up:replay seq 14
> > rtt 0.00100003
> > 2020-10-22 16:44:07.783586 7f424ada7700  5
> > mds.beacon.hostnamecephssd01 Sending beacon up:replay seq 15
> > 2020-10-22 16:44:07.784097 7f424fd2c700  5
> > mds.beacon.hostnamecephssd01 received beacon reply up:replay seq 15
> > rtt 0.00100003
> > 2020-10-22 16:44:11.783678 7f424ada7700  5
> > mds.beacon.hostnamecephssd01 Sending beacon up:replay seq 16
> > 2020-10-22 16:44:11.784223 7f424fd2c700  5
> > mds.beacon.hostnamecephssd01 received beacon reply up:replay seq 16
> > rtt 0.00100003
> > 2020-10-22 16:44:15.783788 7f424ada7700  1 heartbeat_map is_healthy
> > 'MDSRank' had timed out after 15
> > 2020-10-22 16:44:15.783814 7f424ada7700  0
> > mds.beacon.hostnamecephssd01 Skipping beacon heartbeat to monitors
> > (last acked 4.00013s ago); MDS internal heartbeat is not healthy!
> >
> > On Thu, Oct 22, 2020 at 3:30 PM Dan van der Ster <dan@vanderster.com> w=
rote:
> > >
> > > I wouldn't adjust it.
> > > Do you have the impression that the mds is replaying the exact same o=
ps every
> > > time the mds is restarting? or is it progressing and trimming the
> > > journal over time?
> > >
> > > The only other advice I have is that 12.2.10 is quite old, and might
> > > miss some important replay/mem fixes.
> > > I'm thinking of one particular memory bloat issue we suffered (it
> > > manifested on a multi-mds cluster, so I am not sure if it is the root
> > > cause here https://tracker.ceph.com/issues/45090 )
> > > I don't know enough about the changelog diffs to suggest upgrading
> > > right now in the middle of this outage.
> > >
> > >
> > > -- dan
> > >
> > > On Thu, Oct 22, 2020 at 4:14 PM David C <dcsysengineer@gmail.com> wro=
te:
> > > >
> > > > I've not touched the journal segments, current value of
> > > > mds_log_max_segments is 128. Would you recommend I increase (or
> > > > decrease) that value? And do you think I should change
> > > > mds_log_max_expiring to match that value?
> > > >
> > > > On Thu, Oct 22, 2020 at 3:06 PM Dan van der Ster <dan@vanderster.co=
m> wrote:
> > > > >
> > > > > You could decrease the mds_cache_memory_limit but I don't think t=
his
> > > > > will help here during replay.
> > > > >
> > > > > You can see a related tracker here: https://tracker.ceph.com/issu=
es/47582
> > > > > This is possibly caused by replaying a very large journal. Did yo=
u
> > > > > increase the journal segments?
> > > > >
> > > > > -- dan
> > > > >
> > > > >
> > > > >
> > > > >
> > > > >
> > > > >
> > > > >
> > > > > -- dan
> > > > >
> > > > > On Thu, Oct 22, 2020 at 3:35 PM David C <dcsysengineer@gmail.com>=
 wrote:
> > > > > >
> > > > > > Dan, many thanks for the response.
> > > > > >
> > > > > > I was going down the route of looking at mds_beacon_grace but I=
 now
> > > > > > realise when I start my MDS, it's swallowing up memory rapidly =
and
> > > > > > looks like the oom-killer is eventually killing the mds. With d=
ebug
> > > > > > upped to 10, I can see it's doing EMetaBlob.replays on various =
dirs in
> > > > > > the filesystem and I can't see any obvious issues.
> > > > > >
> > > > > > This server has 128GB ram with 111GB free with the MDS stopped
> > > > > >
> > > > > > The mds_cache_memory_limit is currently set to 32GB
> > > > > >
> > > > > > Could this be a case of simply reducing the mds cache until I c=
an get
> > > > > > this started again or is there another setting I should be look=
ing at?
> > > > > > Is it safe to reduce the cache memory limit at this point?
> > > > > >
> > > > > > The standby is currently down and has been deliberately down fo=
r a while now.
> > > > > >
> > > > > > Log excerpt from debug 10 just before MDS is killed (path/to/di=
r
> > > > > > refers to a real path in my FS)
> > > > > >
> > > > > > 2020-10-22 13:29:49.527372 7fc72d39f700 10
> > > > > > mds.0.cache.ino(0x1000e4c0ff4) mark_dirty_parent
> > > > > > 2020-10-22 13:29:49.527374 7fc72d39f700 10 mds.0.journal
> > > > > > EMetaBlob.replay noting opened inode [inode 0x1000e4c0ff4 [2,he=
ad]
> > > > > > /path/to/dir/{dc97bb9c-4600-48bb-b232-23f9e45caa6e}.tmp auth v9=
04149
> > > > > > dirtyparent s
> > > > > > =3D0 n(v0 1=3D1+0) (iversion lock) | dirtyparent=3D1 dirty=3D1 =
0x561c23d66e00]
> > > > > > 2020-10-22 13:29:49.527378 7fc72d39f700 10 mds.0.journal
> > > > > > EMetaBlob.replay inotable tablev 481253 <=3D table 481328
> > > > > > 2020-10-22 13:29:49.527380 7fc72d39f700 10 mds.0.journal
> > > > > > EMetaBlob.replay sessionmap v 240341131 <=3D table 240378576
> > > > > > 2020-10-22 13:29:49.527383 7fc72d39f700 10 mds.0.journal
> > > > > > EMetaBlob.replay request client.16250824:1416595263 trim_to 141=
6595263
> > > > > > 2020-10-22 13:29:49.530097 7fc72d39f700 10 mds.0.log _replay
> > > > > > 57437755528637~11764673 / 57441334490146 2020-10-22 09:08:56.19=
8798:
> > > > > > EOpen [metab
> > > > > > lob 0x10009e1ec8e, 1881 dirs], 16748 open files
> > > > > > 2020-10-22 13:29:49.530106 7fc72d39f700 10 mds.0.journal EOpen.=
replay
> > > > > > 2020-10-22 13:29:49.530107 7fc72d39f700 10 mds.0.journal
> > > > > > EMetaBlob.replay 1881 dirlumps by unknown.0
> > > > > > 2020-10-22 13:29:49.530109 7fc72d39f700 10 mds.0.journal
> > > > > > EMetaBlob.replay dir 0x10009e1ec8e
> > > > > > 2020-10-22 13:29:49.530111 7fc72d39f700 10 mds.0.journal
> > > > > > EMetaBlob.replay updated dir [dir 0x10009e1ec8e /path/to/dir/ [=
2,head]
> > > > > > auth v=3D904150 cv=3D0/0 state=3D1073741824 f(v0 m2020-10-22 08=
:46:44.932805
> > > > > > 89215=3D89215+0) n(v2 rc2020-10-22 08:46:44.932805 b133337592
> > > > > > 89215=3D89215+0) hs=3D42927+1178,ss=3D0+0 dirty=3D2376 | child=
=3D1
> > > > > > 0x56043c4bd100]
> > > > > > 2020-10-22 13:29:50.275864 7fc731ba8700  5
> > > > > > mds.beacon.hostnamecephssd01 Sending beacon up:replay seq 13
> > > > > > 2020-10-22 13:29:51.026368 7fc73732e700  5
> > > > > > mds.beacon.hostnamecephssd01 received beacon reply up:replay se=
q 13
> > > > > > rtt 0.750024
> > > > > > 2020-10-22 13:29:51.026377 7fc73732e700  0
> > > > > > mds.beacon.hostnamecephssd01  MDS is no longer laggy
> > > > > > 2020-10-22 13:29:54.275993 7fc731ba8700  5
> > > > > > mds.beacon.hostnamecephssd01 Sending beacon up:replay seq 14
> > > > > > 2020-10-22 13:29:54.277360 7fc73732e700  5
> > > > > > mds.beacon.hostnamecephssd01 received beacon reply up:replay se=
q 14
> > > > > > rtt 0.00100003
> > > > > > 2020-10-22 13:29:58.276117 7fc731ba8700  5
> > > > > > mds.beacon.hostnamecephssd01 Sending beacon up:replay seq 15
> > > > > > 2020-10-22 13:29:58.277322 7fc73732e700  5
> > > > > > mds.beacon.hostnamecephssd01 received beacon reply up:replay se=
q 15
> > > > > > rtt 0.00100003
> > > > > > 2020-10-22 13:30:02.276313 7fc731ba8700  5
> > > > > > mds.beacon.hostnamecephssd01 Sending beacon up:replay seq 16
> > > > > > 2020-10-22 13:30:02.477973 7fc73732e700  5
> > > > > > mds.beacon.hostnamecephssd01 received beacon reply up:replay se=
q 16
> > > > > > rtt 0.202007
> > > > > >
> > > > > > Thanks,
> > > > > > David
> > > > > >
> > > > > > On Thu, Oct 22, 2020 at 1:41 PM Dan van der Ster <dan@vanderste=
r.com> wrote:
> > > > > > >
> > > > > > > You can disable that beacon by increasing mds_beacon_grace to=
 300 or
> > > > > > > 600. This will stop the mon from failing that mds over to a s=
tandby.
> > > > > > > I don't know if that is set on the mon or mgr, so I usually s=
et it on both.
> > > > > > > (You might as well disable the standby too -- no sense in som=
ething
> > > > > > > failing back and forth between two mdses).
> > > > > > >
> > > > > > > Next -- looks like your mds is in active:replay. Is it doing =
anything?
> > > > > > > Is it using lots of CPU/RAM? If you increase debug_mds do you=
 see some
> > > > > > > progress?
> > > > > > >
> > > > > > > -- dan
> > > > > > >
> > > > > > >
> > > > > > > On Thu, Oct 22, 2020 at 2:01 PM David C <dcsysengineer@gmail.=
com> wrote:
> > > > > > > >
> > > > > > > > Hi All
> > > > > > > >
> > > > > > > > My main CephFS data pool on a Luminous 12.2.10 cluster hit =
capacity
> > > > > > > > overnight, metadata is on a separate pool which didn't hit =
capacity but the
> > > > > > > > filesystem stopped working which I'd expect. I increased th=
e osd full-ratio
> > > > > > > > to give me some breathing room to get some data deleted onc=
e the filesystem
> > > > > > > > is back online. When I attempt to restart the MDS service, =
I see the usual
> > > > > > > > stuff I'd expect in the log but then:
> > > > > > > >
> > > > > > > > heartbeat_map is_healthy 'MDSRank' had timed out after 15
> > > > > > > >
> > > > > > > >
> > > > > > > > Followed by:
> > > > > > > >
> > > > > > > > mds.beacon.hostnamecephssd01 Skipping beacon heartbeat to m=
onitors (last
> > > > > > > > > acked 4.00013s ago); MDS internal heartbeat is not health=
y!
> > > > > > > >
> > > > > > > >
> > > > > > > > Eventually I get:
> > > > > > > >
> > > > > > > > >
> > > > > > > > > mds.beacon.hostnamecephssd01 is_laggy 29.372 > 15 since l=
ast acked beacon
> > > > > > > > > mds.0.90884 skipping upkeep work because connection to Mo=
nitors appears
> > > > > > > > > laggy
> > > > > > > > > mds.hostnamecephssd01 Updating MDS map to version 90885 f=
rom mon.0
> > > > > > > > > mds.beacon.hostnamecephssd01  MDS is no longer laggy
> > > > > > > >
> > > > > > > >
> > > > > > > > The "MDS is no longer laggy" appears to be where the servic=
e fails
> > > > > > > >
> > > > > > > > Meanwhile a ceph -s is showing:
> > > > > > > >
> > > > > > > > >
> > > > > > > > > cluster:
> > > > > > > > >     id:     5c5998fd-dc9b-47ec-825e-beaba66aad11
> > > > > > > > >     health: HEALTH_ERR
> > > > > > > > >             1 filesystem is degraded
> > > > > > > > >             insufficient standby MDS daemons available
> > > > > > > > >             67 backfillfull osd(s)
> > > > > > > > >             11 nearfull osd(s)
> > > > > > > > >             full ratio(s) out of order
> > > > > > > > >             2 pool(s) backfillfull
> > > > > > > > >             2 pool(s) nearfull
> > > > > > > > >             6 scrub errors
> > > > > > > > >             Possible data damage: 5 pgs inconsistent
> > > > > > > > >   services:
> > > > > > > > >     mon: 3 daemons, quorum hostnameceph01,hostnameceph02,=
hostnameceph03
> > > > > > > > >     mgr: hostnameceph03(active), standbys: hostnameceph02=
, hostnameceph01
> > > > > > > > >     mds: cephfs-1/1/1 up  {0=3Dhostnamecephssd01=3Dup:rep=
lay}
> > > > > > > > >     osd: 172 osds: 161 up, 161 in
> > > > > > > > >   data:
> > > > > > > > >     pools:   5 pools, 8384 pgs
> > > > > > > > >     objects: 76.25M objects, 124TiB
> > > > > > > > >     usage:   373TiB used, 125TiB / 498TiB avail
> > > > > > > > >     pgs:     8379 active+clean
> > > > > > > > >              5    active+clean+inconsistent
> > > > > > > > >   io:
> > > > > > > > >     client:   676KiB/s rd, 0op/s rd, 0op/s w
> > > > > > > >
> > > > > > > >
> > > > > > > > The 5 pgs inconsistent is not a new issue, that is from pas=
t scrubs, just
> > > > > > > > haven't gotten around to manually clearing them although I =
suppose they
> > > > > > > > could be related to my issue
> > > > > > > >
> > > > > > > > The cluster has no clients connected
> > > > > > > >
> > > > > > > > I did notice in the ceph.log, some OSDs that are in the sam=
e host as the
> > > > > > > > MDS service briefly went down when trying to restart the MD=
S but examining
> > > > > > > > the logs of those particular OSDs isn't showing any glaring=
 issues.
> > > > > > > >
> > > > > > > > Full MDS log at debug 5 (can go higher if needed):
> > > > > > > >
> > > > > > > > 2020-10-22 11:27:10.987652 7f6f696f5240  0 set uid:gid to 1=
67:167
> > > > > > > > (ceph:ceph)
> > > > > > > > 2020-10-22 11:27:10.987669 7f6f696f5240  0 ceph version 12.=
2.10
> > > > > > > > (177915764b752804194937482a39e95e0ca3de94) luminous (stable=
), process
> > > > > > > > ceph-mds, pid 2022582
> > > > > > > > 2020-10-22 11:27:10.990567 7f6f696f5240  0 pidfile_write: i=
gnore empty
> > > > > > > > --pid-file
> > > > > > > > 2020-10-22 11:27:11.027981 7f6f62616700  1 mds.hostnameceph=
ssd01 Updating
> > > > > > > > MDS map to version 90882 from mon.0
> > > > > > > > 2020-10-22 11:27:15.097957 7f6f62616700  1 mds.hostnameceph=
ssd01 Updating
> > > > > > > > MDS map to version 90883 from mon.0
> > > > > > > > 2020-10-22 11:27:15.097989 7f6f62616700  1 mds.hostnameceph=
ssd01 Map has
> > > > > > > > assigned me to become a standby
> > > > > > > > 2020-10-22 11:27:15.101071 7f6f62616700  1 mds.hostnameceph=
ssd01 Updating
> > > > > > > > MDS map to version 90884 from mon.0
> > > > > > > > 2020-10-22 11:27:15.105310 7f6f62616700  1 mds.0.90884 hand=
le_mds_map i am
> > > > > > > > now mds.0.90884
> > > > > > > > 2020-10-22 11:27:15.105316 7f6f62616700  1 mds.0.90884 hand=
le_mds_map state
> > > > > > > > change up:boot --> up:replay
> > > > > > > > 2020-10-22 11:27:15.105325 7f6f62616700  1 mds.0.90884 repl=
ay_start
> > > > > > > > 2020-10-22 11:27:15.105333 7f6f62616700  1 mds.0.90884  rec=
overy set is
> > > > > > > > 2020-10-22 11:27:15.105344 7f6f62616700  1 mds.0.90884  wai=
ting for osdmap
> > > > > > > > 73745 (which blacklists prior instance)
> > > > > > > > 2020-10-22 11:27:15.149092 7f6f5be09700  0 mds.0.cache crea=
ting system
> > > > > > > > inode with ino:0x100
> > > > > > > > 2020-10-22 11:27:15.149693 7f6f5be09700  0 mds.0.cache crea=
ting system
> > > > > > > > inode with ino:0x1
> > > > > > > > 2020-10-22 11:27:41.021708 7f6f63618700  1 heartbeat_map is=
_healthy
> > > > > > > > 'MDSRank' had timed out after 15
> > > > > > > > 2020-10-22 11:27:43.029290 7f6f5f610700  1 heartbeat_map is=
_healthy
> > > > > > > > 'MDSRank' had timed out after 15
> > > > > > > > 2020-10-22 11:27:43.029297 7f6f5f610700  0 mds.beacon.hostn=
amecephssd01
> > > > > > > > Skipping beacon heartbeat to monitors (last acked 4.00013s =
ago); MDS
> > > > > > > > internal heartbeat is not healthy!
> > > > > > > > 2020-10-22 11:27:45.866711 7f6f5fe11700  1 heartbeat_map re=
set_timeout
> > > > > > > > 'MDSRank' had timed out after 15
> > > > > > > > 2020-10-22 11:28:01.021965 7f6f63618700  1 heartbeat_map is=
_healthy
> > > > > > > > 'MDSRank' had timed out after 15
> > > > > > > > 2020-10-22 11:28:03.029862 7f6f5f610700  1 heartbeat_map is=
_healthy
> > > > > > > > 'MDSRank' had timed out after 15
> > > > > > > > 2020-10-22 11:28:03.029885 7f6f5f610700  0 mds.beacon.hostn=
amecephssd01
> > > > > > > > Skipping beacon heartbeat to monitors (last acked 4.00113s =
ago); MDS
> > > > > > > > internal heartbeat is not healthy!
> > > > > > > > 2020-10-22 11:28:06.022033 7f6f63618700  1 heartbeat_map is=
_healthy
> > > > > > > > 'MDSRank' had timed out after 15
> > > > > > > > 2020-10-22 11:28:07.029955 7f6f5f610700  1 heartbeat_map is=
_healthy
> > > > > > > > 'MDSRank' had timed out after 15
> > > > > > > > 2020-10-22 11:28:07.029961 7f6f5f610700  0 mds.beacon.hostn=
amecephssd01
> > > > > > > > Skipping beacon heartbeat to monitors (last acked 8.00126s =
ago); MDS
> > > > > > > > internal heartbeat is not healthy!
> > > > > > > > 2020-10-22 11:28:11.022099 7f6f63618700  1 heartbeat_map is=
_healthy
> > > > > > > > 'MDSRank' had timed out after 15
> > > > > > > > 2020-10-22 11:28:11.030024 7f6f5f610700  1 heartbeat_map is=
_healthy
> > > > > > > > 'MDSRank' had timed out after 15
> > > > > > > > 2020-10-22 11:28:11.030028 7f6f5f610700  0 mds.beacon.hostn=
amecephssd01
> > > > > > > > Skipping beacon heartbeat to monitors (last acked 12.0014s =
ago); MDS
> > > > > > > > internal heartbeat is not healthy!
> > > > > > > > 2020-10-22 11:28:15.030092 7f6f5f610700  1 heartbeat_map is=
_healthy
> > > > > > > > 'MDSRank' had timed out after 15
> > > > > > > > 2020-10-22 11:28:15.030099 7f6f5f610700  0 mds.beacon.hostn=
amecephssd01
> > > > > > > > Skipping beacon heartbeat to monitors (last acked 16.0015s =
ago); MDS
> > > > > > > > internal heartbeat is not healthy!
> > > > > > > > 2020-10-22 11:28:16.022165 7f6f63618700  1 heartbeat_map is=
_healthy
> > > > > > > > 'MDSRank' had timed out after 15
> > > > > > > > 2020-10-22 11:28:19.030163 7f6f5f610700  1 heartbeat_map is=
_healthy
> > > > > > > > 'MDSRank' had timed out after 15
> > > > > > > > 2020-10-22 11:28:19.030169 7f6f5f610700  0 mds.beacon.hostn=
amecephssd01
> > > > > > > > Skipping beacon heartbeat to monitors (last acked 20.0016s =
ago); MDS
> > > > > > > > internal heartbeat is not healthy!
> > > > > > > > 2020-10-22 11:28:21.022231 7f6f63618700  1 heartbeat_map is=
_healthy
> > > > > > > > 'MDSRank' had timed out after 15
> > > > > > > > 2020-10-22 11:28:23.030233 7f6f5f610700  1 heartbeat_map is=
_healthy
> > > > > > > > 'MDSRank' had timed out after 15
> > > > > > > > 2020-10-22 11:28:23.030241 7f6f5f610700  0 mds.beacon.hostn=
amecephssd01
> > > > > > > > Skipping beacon heartbeat to monitors (last acked 24.0008s =
ago); MDS
> > > > > > > > internal heartbeat is not healthy!
> > > > > > > > 2020-10-22 11:28:26.022295 7f6f63618700  1 heartbeat_map is=
_healthy
> > > > > > > > 'MDSRank' had timed out after 15
> > > > > > > > 2020-10-22 11:28:27.030305 7f6f5f610700  1 heartbeat_map is=
_healthy
> > > > > > > > 'MDSRank' had timed out after 15
> > > > > > > > 2020-10-22 11:28:27.030311 7f6f5f610700  0 mds.beacon.hostn=
amecephssd01
> > > > > > > > Skipping beacon heartbeat to monitors (last acked 28.0009s =
ago); MDS
> > > > > > > > internal heartbeat is not healthy!
> > > > > > > > 2020-10-22 11:28:28.401161 7f6f5fe11700  1 heartbeat_map re=
set_timeout
> > > > > > > > 'MDSRank' had timed out after 15
> > > > > > > > 2020-10-22 11:28:28.401168 7f6f5fe11700  1 mds.beacon.hostn=
amecephssd01
> > > > > > > > is_laggy 29.372 > 15 since last acked beacon
> > > > > > > > 2020-10-22 11:28:28.401177 7f6f5fe11700  1 mds.0.90884 skip=
ping upkeep work
> > > > > > > > because connection to Monitors appears laggy
> > > > > > > > 2020-10-22 11:28:28.401187 7f6f62616700  1 mds.hostnameceph=
ssd01 Updating
> > > > > > > > MDS map to version 90885 from mon.0
> > > > > > > > 2020-10-22 11:28:31.659817 7f6f64595700  0 mds.beacon.hostn=
amecephssd01
> > > > > > > >  MDS is no longer laggy
> > > > > > > > 2020-10-22 11:36:15.880009 7f88ee4ac240  0 set uid:gid to 1=
67:167
> > > > > > > > (ceph:ceph)
> > > > > > > > 2020-10-22 11:36:15.880026 7f88ee4ac240  0 ceph version 12.=
2.10
> > > > > > > > (177915764b752804194937482a39e95e0ca3de94) luminous (stable=
), process
> > > > > > > > ceph-mds, pid 2022663
> > > > > > > > 2020-10-22 11:36:15.883118 7f88ee4ac240  0 pidfile_write: i=
gnore empty
> > > > > > > > --pid-file
> > > > > > > > 2020-10-22 11:36:15.921200 7f88e73cd700  1 mds.hostnameceph=
ssd01 Updating
> > > > > > > > MDS map to version 90887 from mon.2
> > > > > > > > 2020-10-22 11:36:20.270298 7f88e73cd700  1 mds.hostnameceph=
ssd01 Updating
> > > > > > > > MDS map to version 90888 from mon.2
> > > > > > > > 2020-10-22 11:36:20.270329 7f88e73cd700  1 mds.hostnameceph=
ssd01 Map has
> > > > > > > > assigned me to become a standby
> > > > > > > > 2020-10-22 11:36:20.272917 7f88e73cd700  1 mds.hostnameceph=
ssd01 Updating
> > > > > > > > MDS map to version 90889 from mon.2
> > > > > > > > 2020-10-22 11:36:20.277063 7f88e73cd700  1 mds.0.90889 hand=
le_mds_map i am
> > > > > > > > now mds.0.90889
> > > > > > > > 2020-10-22 11:36:20.277069 7f88e73cd700  1 mds.0.90889 hand=
le_mds_map state
> > > > > > > > change up:boot --> up:replay
> > > > > > > > 2020-10-22 11:36:20.277079 7f88e73cd700  1 mds.0.90889 repl=
ay_start
> > > > > > > > 2020-10-22 11:36:20.277086 7f88e73cd700  1 mds.0.90889  rec=
overy set is
> > > > > > > > 2020-10-22 11:36:20.277096 7f88e73cd700  1 mds.0.90889  wai=
ting for osdmap
> > > > > > > > 73746 (which blacklists prior instance)
> > > > > > > > 2020-10-22 11:36:20.322318 7f88e0bc0700  0 mds.0.cache crea=
ting system
> > > > > > > > inode with ino:0x100
> > > > > > > > 2020-10-22 11:36:20.322918 7f88e0bc0700  0 mds.0.cache crea=
ting system
> > > > > > > > inode with ino:0x1
> > > > > > > > 2020-10-22 11:36:47.922531 7f88e43c7700  1 heartbeat_map is=
_healthy
> > > > > > > > 'MDSRank' had timed out after 15
> > > > > > > > 2020-10-22 11:36:47.922549 7f88e43c7700  0 mds.beacon.hostn=
amecephssd01
> > > > > > > > Skipping beacon heartbeat to monitors (last acked 4.00013s =
ago); MDS
> > > > > > > > internal heartbeat is not healthy!
> > > > > > > > 2020-10-22 11:36:50.914516 7f88e83cf700  1 heartbeat_map is=
_healthy
> > > > > > > > 'MDSRank' had timed out after 15
> > > > > > > > 2020-10-22 11:36:51.351457 7f88e4bc8700  1 heartbeat_map re=
set_timeout
> > > > > > > > 'MDSRank' had timed out after 15
> > > > > > > > 2020-10-22 11:37:07.923089 7f88e43c7700  1 heartbeat_map is=
_healthy
> > > > > > > > 'MDSRank' had timed out after 15
> > > > > > > > 2020-10-22 11:37:07.923126 7f88e43c7700  0 mds.beacon.hostn=
amecephssd01
> > > > > > > > Skipping beacon heartbeat to monitors (last acked 3.99913s =
ago); MDS
> > > > > > > > internal heartbeat is not healthy!
> > > > > > > > 2020-10-22 11:37:10.914767 7f88e83cf700  1 heartbeat_map is=
_healthy
> > > > > > > > 'MDSRank' had timed out after 15
> > > > > > > > 2020-10-22 11:37:11.923216 7f88e43c7700  1 heartbeat_map is=
_healthy
> > > > > > > > 'MDSRank' had timed out after 15
> > > > > > > > 2020-10-22 11:37:11.923223 7f88e43c7700  0 mds.beacon.hostn=
amecephssd01
> > > > > > > > Skipping beacon heartbeat to monitors (last acked 7.99926s =
ago); MDS
> > > > > > > > internal heartbeat is not healthy!
> > > > > > > > 2020-10-22 11:37:15.914831 7f88e83cf700  1 heartbeat_map is=
_healthy
> > > > > > > > 'MDSRank' had timed out after 15
> > > > > > > > 2020-10-22 11:37:15.923286 7f88e43c7700  1 heartbeat_map is=
_healthy
> > > > > > > > 'MDSRank' had timed out after 15
> > > > > > > > 2020-10-22 11:37:15.923294 7f88e43c7700  0 mds.beacon.hostn=
amecephssd01
> > > > > > > > Skipping beacon heartbeat to monitors (last acked 11.9994s =
ago); MDS
> > > > > > > > internal heartbeat is not healthy!
> > > > > > > > 2020-10-22 11:37:19.923359 7f88e43c7700  1 heartbeat_map is=
_healthy
> > > > > > > > 'MDSRank' had timed out after 15
> > > > > > > > 2020-10-22 11:37:19.923366 7f88e43c7700  0 mds.beacon.hostn=
amecephssd01
> > > > > > > > Skipping beacon heartbeat to monitors (last acked 15.9995s =
ago); MDS
> > > > > > > > internal heartbeat is not healthy!
> > > > > > > > 2020-10-22 11:37:20.914917 7f88e83cf700  1 heartbeat_map is=
_healthy
> > > > > > > > 'MDSRank' had timed out after 15
> > > > > > > > 2020-10-22 11:37:23.923430 7f88e43c7700  1 heartbeat_map is=
_healthy
> > > > > > > > 'MDSRank' had timed out after 15
> > > > > > > > 2020-10-22 11:37:23.923437 7f88e43c7700  0 mds.beacon.hostn=
amecephssd01
> > > > > > > > Skipping beacon heartbeat to monitors (last acked 19.9996s =
ago); MDS
> > > > > > > > internal heartbeat is not healthy!
> > > > > > > > 2020-10-22 11:37:25.914981 7f88e83cf700  1 heartbeat_map is=
_healthy
> > > > > > > > 'MDSRank' had timed out after 15
> > > > > > > > 2020-10-22 11:37:27.923501 7f88e43c7700  1 heartbeat_map is=
_healthy
> > > > > > > > 'MDSRank' had timed out after 15
> > > > > > > > 2020-10-22 11:37:27.923508 7f88e43c7700  0 mds.beacon.hostn=
amecephssd01
> > > > > > > > Skipping beacon heartbeat to monitors (last acked 23.9998s =
ago); MDS
> > > > > > > > internal heartbeat is not healthy!
> > > > > > > > 2020-10-22 11:37:30.915046 7f88e83cf700  1 heartbeat_map is=
_healthy
> > > > > > > > 'MDSRank' had timed out after 15
> > > > > > > > 2020-10-22 11:37:31.923572 7f88e43c7700  1 heartbeat_map is=
_healthy
> > > > > > > > 'MDSRank' had timed out after 15
> > > > > > > > 2020-10-22 11:37:31.923579 7f88e43c7700  0 mds.beacon.hostn=
amecephssd01
> > > > > > > > Skipping beacon heartbeat to monitors (last acked 27.9999s =
ago); MDS
> > > > > > > > internal heartbeat is not healthy!
> > > > > > > > 2020-10-22 11:37:32.412628 7f88e4bc8700  1 heartbeat_map re=
set_timeout
> > > > > > > > 'MDSRank' had timed out after 15
> > > > > > > > 2020-10-22 11:37:32.412635 7f88e4bc8700  1 mds.beacon.hostn=
amecephssd01
> > > > > > > > is_laggy 28.4889 > 15 since last acked beacon
> > > > > > > > 2020-10-22 11:37:32.412643 7f88e4bc8700  1 mds.0.90889 skip=
ping upkeep work
> > > > > > > > because connection to Monitors appears laggy
> > > > > > > > 2020-10-22 11:37:32.412657 7f88e73cd700  1 mds.hostnameceph=
ssd01 Updating
> > > > > > > > MDS map to version 90890 from mon.2
> > > > > > > > 2020-10-22 11:37:35.978858 7f88e934c700  0 mds.beacon.hostn=
amecephssd01
> > > > > > > >  MDS is no longer laggy
> > > > > > > >
> > > > > > > >
> > > > > > > > Thanks in advance for any assistance you can provide!
> > > > > > > > David
> > > > > > > > _______________________________________________
> > > > > > > > ceph-users mailing list -- ceph-users@ceph.io
> > > > > > > > To unsubscribe send an email to ceph-users-leave@ceph.io
> _______________________________________________
> ceph-users mailing list -- ceph-users@ceph.io
> To unsubscribe send an email to ceph-users-leave@ceph.io
