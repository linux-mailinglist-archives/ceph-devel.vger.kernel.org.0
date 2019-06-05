Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A47DD367B2
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Jun 2019 01:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfFEXI7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 5 Jun 2019 19:08:59 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:33212 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbfFEXI7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 5 Jun 2019 19:08:59 -0400
Received: by mail-qt1-f193.google.com with SMTP id 14so598829qtf.0
        for <ceph-devel@vger.kernel.org>; Wed, 05 Jun 2019 16:08:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5ftboMtGZiMUdvVv+uKNETq+NXgUqra7wENJVX/RHpI=;
        b=EQj9XupzAHuHlC/Km3+hsQ5iYlFovU8IRmFopcC2YL9sJcafpKKU8Zlds1HUZjZsXJ
         fHkFQqniHV2ehS+fd2ZiNnVWi/L4dw//yPa+Me7Tp2sHOvbXSY2JK9trTcCa5hDd6pcx
         qgqhfEZe7Wfvma6u/zO2NjChUuANPOwkZijyLRne1DrKbC4cw1BNDSMGNIGY9UxQvQ5t
         F4/GjcAj5keZno756FaVxunksrTwk0drW0MjVbhTha4x/hX4y2pLWf9siiQdxz8qX+Ux
         bj9elaS1P9DwCYc+zP+4h3PGBedfj/RZ/MDkIe6Bsb4e+C0J+9g8IetyV/1naUdGw0Ow
         6WgA==
X-Gm-Message-State: APjAAAX/yVdDY5yWd2A8Hfno6EFoHcsY0/KgbiVpT0c1n+asJ6ox8LZj
        7N4iTRW4ALWlIZsXB1qnMUTfp+uNWsy5p/I9USmpnQ==
X-Google-Smtp-Source: APXvYqxo4lyPFYvCBzcbz340eS0baC+GnU9ZQAN4r6NpU4AnGHnVG8S3YHVCeQ8PbqCVn+6QSZr0k3Dd/f9uQtkYrsU=
X-Received: by 2002:ac8:4252:: with SMTP id r18mr36525827qtm.357.1559776138120;
 Wed, 05 Jun 2019 16:08:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190604093908.30491-1-zyan@redhat.com> <b8e91fb1b19c36bd8493e316b60a2313b044ee8a.camel@redhat.com>
 <CAAM7YA=bDmbOvwYRghT30R=-Rgw2vTt0Wctxo6=xH137tgqiBg@mail.gmail.com>
 <271c6b6b44fcc4f8d84a6d4035179b94bc6986ba.camel@redhat.com>
 <CAAM7YAmkP98WgfnHSHNS9Gc-isdeoxQwz_SG0F4rNfd+-zRroQ@mail.gmail.com> <cf72762eac9ddcb158915c24c7a458829e18e521.camel@redhat.com>
In-Reply-To: <cf72762eac9ddcb158915c24c7a458829e18e521.camel@redhat.com>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Wed, 5 Jun 2019 16:08:31 -0700
Message-ID: <CA+2bHPau+J8JXwdcYLuGUOw6_mo8ZcmbW244DsFXPOA+DDPzsg@mail.gmail.com>
Subject: Re: [PATCH 1/4] libceph: add function that reset client's entity addr
To:     Jeff Layton <jlayton@redhat.com>
Cc:     "Yan, Zheng" <ukernel@gmail.com>, "Yan, Zheng" <zyan@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jun 5, 2019 at 4:13 AM Jeff Layton <jlayton@redhat.com> wrote:
> > > > > I'd like to better understand what happens to file descriptors that were
> > > > > opened before the blacklisting occurred.
> > > > >
> > > > > Suppose I hold a POSIX lock on a O_RDWR fd, and then get blacklisted.
> > > > > The admin then remounts the mount. What happens to my fd? Can I carry on
> > > > > using it, or will it be shut down in some fashion? What about the lock?
> > > > > I've definitely lost it during the blacklisting -- how do we make the
> > > > > application aware of that fact?
> > > >
> > > > After 'mount -f',  cephfs return -EIO for any operation on open files.
> > > > After remount, operations except fsync and close work as normal. fsync
> > > > and close return error if any dirty data got dropped.
> > > >
> > > > Current cephfs code already handle file lock. after session get
> > > > evicted, cephfs return -EIO for any lock operation until all local
> > > > locks are released. (see commit b3f8d68f38a87)
> > > >
> > >
> > > I think that's not sufficient. After a blacklisting event, we need to
> > > shut down all file descriptors that were open before the event.
> > >
> > > Consider:
> > >
> > > Suppose I have an application (maybe a distributed database) that opens
> > > a file O_RDWR and takes out a lock on the file. The client gets
> > > blacklisted and loses its lock, and then the admin remounts the thing
> > > leaving the fd intact.
> > >
> > > After the blacklisting, the application then performs some writes to the
> > > file and fsyncs and that all succeeds. Those writes are now being done
> > > without holding the file lock, even though the application thinks it has
> > > the lock. That seems like potential silent data corruption.
> > >
> >
> > Is it possible that application uses one file descriptor to do file
> > locking, and use different file descriptors to do read/write.  If it
> > is, allowing read/write from new file descriptor is not safe either.
> >
>
> Sure, applications do all sorts of crazy things. PostgreSQL (for
> instance) has a process separate from the writers to handle fsyncs. That
> could also be problematic in this scenario.
>
> The main point here is that a file description is (partly) a
> representation of state granted by the MDS, and that state can no longer
> be considered valid after the client has been blacklisted.
>
> In practice, applications would need to have special handling to detect
> and deal with this situation, and >99% of them won't have it. Most
> applications will need to be restarted altogether after an event like
> this, which makes me question whether this is something we should do at
> all.

As I said in the other thread, I think one way we can address file
locks is through SIGLOST (with this scenario similar to its intended
use) which would be terminal for most applications.

-- 
Patrick Donnelly, Ph.D.
He / Him / His
Senior Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D
