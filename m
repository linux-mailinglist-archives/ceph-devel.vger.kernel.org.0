Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 723BD3BA3E0
	for <lists+ceph-devel@lfdr.de>; Fri,  2 Jul 2021 20:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbhGBSRZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 2 Jul 2021 14:17:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56903 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229455AbhGBSRY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 2 Jul 2021 14:17:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625249691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vPtW0bOi9eZkD17Qm8Z4RTn/WgP+kKDL874V1joM7aw=;
        b=OJeyNpZAW79HL70yIjkIWab++UDiNPEngA9CK6k1wnqHIhY0s2GJoOW0yuurQSzfDNA4m8
        DMTYSoUJ0ETI6Vw335XW/UJBpAub9xe5Fm86bBrj78GfgA16dpJZG3yzaTAaQHYVCcIQpi
        ADeENz4uKFuYknksUP1z6iqevOPGWHU=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-255-VmdVWZdmPSeoTwsLrhp7ig-1; Fri, 02 Jul 2021 14:14:50 -0400
X-MC-Unique: VmdVWZdmPSeoTwsLrhp7ig-1
Received: by mail-il1-f198.google.com with SMTP id g14-20020a926b0e0000b02901bb2deb9d71so6445939ilc.6
        for <ceph-devel@vger.kernel.org>; Fri, 02 Jul 2021 11:14:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vPtW0bOi9eZkD17Qm8Z4RTn/WgP+kKDL874V1joM7aw=;
        b=ThcNoLX+W6T6cIgWceyqHetuUl3yO0vysmUE2AYWylQFcrjmvGp21uAY7XlWxHPYhM
         RnbfnInQTayePFhmeFp+xGlUHKG+gf6HovVjHVw6uDZfyhtU2E+OvtC9tS5ppIDumTZf
         PBiXkxln3shrv6N0bbO3d6f9/7sIHI/ol+xg9VBVzXKZZsbc7TDVRri2po4gWMDPgXEG
         chnsV+2/lrWn0f4H2PKJxt/7QxT0fKxUO5HBi+hHoyb20vDyd+qzMWj3HnEThMoJhNUn
         KVlsRWDg24DGGw0Sfzufgdy0yr+YdI81qsuWGUUS/ZSCC4g4zFIhCb5hOuXeVdrqZHTY
         ZZxg==
X-Gm-Message-State: AOAM533QdDQI/mnwUiqqYfgI/5rrdi6pIFmUK8/LDK4q6v7WtdZimZw/
        GLAMmtkjCIx+s82WEqe9io69qxvOuJmm9bAssp1XPzC7p0X5gXK7SVBZUp9L8gk9ArAFt2z/AVy
        TEBXnAgMpSxa1jpbtm/cpmEtwC7jAZCVCxPlEbQ==
X-Received: by 2002:a05:6e02:4b2:: with SMTP id e18mr773776ils.293.1625249690302;
        Fri, 02 Jul 2021 11:14:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJynnSv1+S9yuni9eh+2c3rXC/64Zg8VYW7D2JUnYzXYcKoA8fyLNyOfnTGDKHKR4Q7u4t2QwPfAFrS2M/sQfDk=
X-Received: by 2002:a05:6e02:4b2:: with SMTP id e18mr773767ils.293.1625249690112;
 Fri, 02 Jul 2021 11:14:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210629044241.30359-1-xiubli@redhat.com> <20210629044241.30359-5-xiubli@redhat.com>
 <b531585184df099e633a4b92e3be23b4b8384253.camel@kernel.org>
 <4f2f6de6-eb1f-1527-de73-2378f262228b@redhat.com> <2e8aabad80e166d7c628fde9d820fc5f403e034f.camel@kernel.org>
 <379d5257-f182-c455-9675-b199aeb8ce1b@redhat.com> <CA+2bHPZNQU9wZr2W3FjW453KKFVi4q+LwVyicTPQ7kihhoQpQg@mail.gmail.com>
 <e917a3e1-2902-604b-5154-98086c95357f@redhat.com> <CA+2bHPY=xyqW48RfuGX8C9Br7vRUArF66AK5yDTOKH4Ewdt8dg@mail.gmail.com>
 <838be760-4d61-9fc7-be8c-59deea9d0e98@redhat.com>
In-Reply-To: <838be760-4d61-9fc7-be8c-59deea9d0e98@redhat.com>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Fri, 2 Jul 2021 11:14:24 -0700
Message-ID: <CA+2bHPbtUchykAeDcH1rh5YXzJHRMLPtOaHy7f332scX+9wmHw@mail.gmail.com>
Subject: Re: [PATCH 4/5] ceph: flush the mdlog before waiting on unsafe reqs
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Jul 2, 2021 at 6:17 AM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 7/2/21 7:46 AM, Patrick Donnelly wrote:
> > On Wed, Jun 30, 2021 at 11:18 PM Xiubo Li <xiubli@redhat.com> wrote:
> >> And just now I have run by adding the time stamp:
> >>
> >>> fd = open("/path")
> >>> fopenat(fd, "foo")
> >>> renameat(fd, "foo", fd, "bar")
> >>> fstat(fd)
> >>> fsync(fd)
> >> lxb ----- before renameat ---> Current time is Thu Jul  1 13:28:52 2021
> >> lxb ----- after renameat ---> Current time is Thu Jul  1 13:28:52 2021
> >> lxb ----- before fstat ---> Current time is Thu Jul  1 13:28:52 2021
> >> lxb ----- after fstat ---> Current time is Thu Jul  1 13:28:52 2021
> >> lxb ----- before fsync ---> Current time is Thu Jul  1 13:28:52 2021
> >> lxb ----- after fsync ---> Current time is Thu Jul  1 13:28:56 2021
> >>
> >> We can see that even after 'fstat(fd)', the 'fsync(fd)' still will wait around 4s.
> >>
> >> Why your test worked it should be the MDS's tick thread and the 'fstat(fd)' were running almost simultaneously sometimes, I also could see the 'fsync(fd)' finished very fast sometimes:
> >>
> >> lxb ----- before renameat ---> Current time is Thu Jul  1 13:29:51 2021
> >> lxb ----- after renameat ---> Current time is Thu Jul  1 13:29:51 2021
> >> lxb ----- before fstat ---> Current time is Thu Jul  1 13:29:51 2021
> >> lxb ----- after fstat ---> Current time is Thu Jul  1 13:29:51 2021
> >> lxb ----- before fsync ---> Current time is Thu Jul  1 13:29:51 2021
> >> lxb ----- after fsync ---> Current time is Thu Jul  1 13:29:51 2021
> > Actually, I did a lot more testing on this. It's a unique behavior of
> > the directory is /. You will see a getattr force a flush of the
> > journal:
> >
> > 2021-07-01T23:42:18.095+0000 7fcc7741c700  7 mds.0.server
> > dispatch_client_request client_request(client.4257:74 getattr
> > pAsLsXsFs #0x1 2021-07-01T23:42:18.095884+0000 caller_uid=1147,
> > caller_gid=1147{1000,1147,}) v5
> > ...
> > 2021-07-01T23:42:18.096+0000 7fcc7741c700 10 mds.0.locker nudge_log
> > (ifile mix->sync w=2) on [inode 0x1 [...2,head] / auth v34 pv39 ap=6
> > snaprealm=0x564734479600 DIRTYPARENT f(v0
> > m2021-07-01T23:38:00.418466+0000 3=1+2) n(v6
> > rc2021-07-01T23:38:15.692076+0000 b65536 7=2+5)/n(v0
> > rc2021-07-01T19:31:40.924877+0000 1=0+1) (iauth sync r=1) (isnap sync
> > r=4) (inest mix w=3) (ipolicy sync r=2) (ifile mix->sync w=2)
> > (iversion lock w=3) caps={4257=pAsLsXs/-@32} | dirtyscattered=0
> > request=1 lock=6 dirfrag=1 caps=1 dirtyparent=1 dirty=1 waiter=1
> > authpin=1 0x56473913a580]
> >
> > You don't see that getattr for directories other than root. That's
> > probably because the client has been issued more caps than what the
> > MDS is willing to normally hand out for root.
>
> For the root dir, when doing the 'rename' the wrlock_start('ifile lock')
> will change the lock state 'SYNC' --> 'MIX'. Then the inode 0x1 will
> issue 'pAsLsXs' to clients. So when the client sends a 'getattr' request
> with caps 'AsXsFs' wanted, the mds will try to switch the 'ifile lock'
> state back to 'SYNC' to get the 'Fs' cap. Since the rdlock_start('ifile
> lock') needs to do the lock state transition, it will wait and trigger
> the 'nudge_log'.
>
> The reason why will wrlock_start('ifile lock') change the lock state
> 'SYNC' --> 'MIX' above is that the inode '0x1' has subtree, if my
> understanding is correct so for the root dir it should be very probably
> shared by multiple MDSes and it chooses to switch to MIX.
>
> This is why the root dir will work when we send a 'getattr' request.
>
>
> For the none root directories, it will bump to loner and then the
> 'ifile/iauth/ixattr locks' state switched to EXCL instead, for this lock
> state it will issue 'pAsxLsXsxFsx' cap. So when doing the
> 'getattr(AsXsFs)' in client, it will do nothing since it's already
> issued the caps needed. This is why we couldn't see the getattr request
> was sent out.
>
> Even we 'forced' to call the getattr, it can get the rdlock immediately
> and no need to gather or do lock state transition, so no 'nudge_log' was
> called. Since in case if the none directories are in loner mode and the
> locks will be in 'EXCL' state, so it will allow 'pAsxLsXsxFsxrwb' as
> default, then even we 'forced' call the getattr('pAsxLsXsxFsxrwb') in
> fsync, in the MDS side it still won't do the lock states transition.
>
>
> >
> > I'm not really sure why there is a difference. I even experimented
> > with redundant getattr ("forced") calls to cause a journal flush on
> > non-root directories but didn't get anywhere. Maybe you can
> > investigate further? It'd be optimal if we could nudge the log just by
> > doing a getattr.
>
> So in the above case, from my tests and reading the Locker code, I
> didn't figure out how can the getattr could work for this issue yet.
>
> Patrick,
>
> Did I miss something about the Lockers ?

No, your analysis looks right. Thanks.

I suppose this flush_mdlog message is the best tool we have to fix this.

-- 
Patrick Donnelly, Ph.D.
He / Him / His
Principal Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D

