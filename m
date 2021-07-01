Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB8463B99B6
	for <lists+ceph-devel@lfdr.de>; Fri,  2 Jul 2021 01:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234195AbhGAXtX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 1 Jul 2021 19:49:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50171 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234095AbhGAXtW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 1 Jul 2021 19:49:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625183211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=47gM1ez3lB+fOxtZ09rPxqSKOpnfiot4+3fQU+GV4KE=;
        b=XM9gUuE5j8VvvZd3ircg2qJRy5QVVQBgtXe+o2laa/QNz5Tr9VZ0M/o3tUdE5lbL79xDWw
        I1/B8iCnQ6yhHogTjhvrftwMQTp4JO2Z7HwwBRj2UDyjYuCholX8vjSCUqcbTZaMvrofBf
        3iMJp6T+Lm6Bb+maaxwReiVda1aWErI=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-587-MZURYnXyMTKYMOpoeM8xhQ-1; Thu, 01 Jul 2021 19:46:50 -0400
X-MC-Unique: MZURYnXyMTKYMOpoeM8xhQ-1
Received: by mail-io1-f70.google.com with SMTP id r3-20020a6b8f030000b02904e159249245so5455157iod.19
        for <ceph-devel@vger.kernel.org>; Thu, 01 Jul 2021 16:46:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=47gM1ez3lB+fOxtZ09rPxqSKOpnfiot4+3fQU+GV4KE=;
        b=uYMI7A5787akMgNEuTnu9xQj4JevUP+3TRncn7djvulT0iC/xFDUtb70EjmpjxmBlN
         5/ZqZfAA226J9EnDfT6LxYsxpK/vitK/PMqAC6IT/JN+MO1aTovrYPdk6c1W9/Ae34gT
         aL/ad8Tpb+4ji3ZkgNEuJ6qaV3yZh2V/PTtzQCJBxh4bWNnUcVGuTgtGuC2dGtsKb1K2
         NRoDpGc2o8XFuTj0XVC6DeUfi2cfn+DuIqkv9GdlTiZ3e9sLczj4u24UK5IeCVLuIVIq
         9QSFWygt+z7gxHztZufSDP0EmnhcVoNv+0PWxOvV5K9W6qxxH0jzRJ84Tv99D7q+4lCA
         qIWw==
X-Gm-Message-State: AOAM530wy1ZL92f3uW8BKUIypLGtgQPm1+FbRFRvr29eXSQRg+hVqu+M
        Jus7IyrqDg7VrkcExkIKZins3gjBYQi7LTlKuNOx0kQmYcVCCNdvrqIoQx11hkyIOp8vTP5nde8
        GGHWMi/pXnnnnAXMi6+IB3SJtNtdejnDlXsrzCw==
X-Received: by 2002:a92:c52f:: with SMTP id m15mr1254412ili.293.1625183209567;
        Thu, 01 Jul 2021 16:46:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyQ5tINIqillFWN4BU/cDwyvul3QpSc5MRfmp3721MwGzgMgy3HPgbMkFG+a5YZXNJ4gyKiumtJ5QfGEUZsOvw=
X-Received: by 2002:a92:c52f:: with SMTP id m15mr1254403ili.293.1625183209399;
 Thu, 01 Jul 2021 16:46:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210629044241.30359-1-xiubli@redhat.com> <20210629044241.30359-5-xiubli@redhat.com>
 <b531585184df099e633a4b92e3be23b4b8384253.camel@kernel.org>
 <4f2f6de6-eb1f-1527-de73-2378f262228b@redhat.com> <2e8aabad80e166d7c628fde9d820fc5f403e034f.camel@kernel.org>
 <379d5257-f182-c455-9675-b199aeb8ce1b@redhat.com> <CA+2bHPZNQU9wZr2W3FjW453KKFVi4q+LwVyicTPQ7kihhoQpQg@mail.gmail.com>
 <e917a3e1-2902-604b-5154-98086c95357f@redhat.com>
In-Reply-To: <e917a3e1-2902-604b-5154-98086c95357f@redhat.com>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Thu, 1 Jul 2021 16:46:23 -0700
Message-ID: <CA+2bHPY=xyqW48RfuGX8C9Br7vRUArF66AK5yDTOKH4Ewdt8dg@mail.gmail.com>
Subject: Re: [PATCH 4/5] ceph: flush the mdlog before waiting on unsafe reqs
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jun 30, 2021 at 11:18 PM Xiubo Li <xiubli@redhat.com> wrote:
> And just now I have run by adding the time stamp:
>
> > fd = open("/path")
> > fopenat(fd, "foo")
> > renameat(fd, "foo", fd, "bar")
> > fstat(fd)
> > fsync(fd)
>
> lxb ----- before renameat ---> Current time is Thu Jul  1 13:28:52 2021
> lxb ----- after renameat ---> Current time is Thu Jul  1 13:28:52 2021
> lxb ----- before fstat ---> Current time is Thu Jul  1 13:28:52 2021
> lxb ----- after fstat ---> Current time is Thu Jul  1 13:28:52 2021
> lxb ----- before fsync ---> Current time is Thu Jul  1 13:28:52 2021
> lxb ----- after fsync ---> Current time is Thu Jul  1 13:28:56 2021
>
> We can see that even after 'fstat(fd)', the 'fsync(fd)' still will wait around 4s.
>
> Why your test worked it should be the MDS's tick thread and the 'fstat(fd)' were running almost simultaneously sometimes, I also could see the 'fsync(fd)' finished very fast sometimes:
>
> lxb ----- before renameat ---> Current time is Thu Jul  1 13:29:51 2021
> lxb ----- after renameat ---> Current time is Thu Jul  1 13:29:51 2021
> lxb ----- before fstat ---> Current time is Thu Jul  1 13:29:51 2021
> lxb ----- after fstat ---> Current time is Thu Jul  1 13:29:51 2021
> lxb ----- before fsync ---> Current time is Thu Jul  1 13:29:51 2021
> lxb ----- after fsync ---> Current time is Thu Jul  1 13:29:51 2021

Actually, I did a lot more testing on this. It's a unique behavior of
the directory is /. You will see a getattr force a flush of the
journal:

2021-07-01T23:42:18.095+0000 7fcc7741c700  7 mds.0.server
dispatch_client_request client_request(client.4257:74 getattr
pAsLsXsFs #0x1 2021-07-01T23:42:18.095884+0000 caller_uid=1147,
caller_gid=1147{1000,1147,}) v5
...
2021-07-01T23:42:18.096+0000 7fcc7741c700 10 mds.0.locker nudge_log
(ifile mix->sync w=2) on [inode 0x1 [...2,head] / auth v34 pv39 ap=6
snaprealm=0x564734479600 DIRTYPARENT f(v0
m2021-07-01T23:38:00.418466+0000 3=1+2) n(v6
rc2021-07-01T23:38:15.692076+0000 b65536 7=2+5)/n(v0
rc2021-07-01T19:31:40.924877+0000 1=0+1) (iauth sync r=1) (isnap sync
r=4) (inest mix w=3) (ipolicy sync r=2) (ifile mix->sync w=2)
(iversion lock w=3) caps={4257=pAsLsXs/-@32} | dirtyscattered=0
request=1 lock=6 dirfrag=1 caps=1 dirtyparent=1 dirty=1 waiter=1
authpin=1 0x56473913a580]

You don't see that getattr for directories other than root. That's
probably because the client has been issued more caps than what the
MDS is willing to normally hand out for root.

I'm not really sure why there is a difference. I even experimented
with redundant getattr ("forced") calls to cause a journal flush on
non-root directories but didn't get anywhere. Maybe you can
investigate further? It'd be optimal if we could nudge the log just by
doing a getattr.

-- 
Patrick Donnelly, Ph.D.
He / Him / His
Principal Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D

