Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7DFE27CBC8
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Sep 2020 14:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732939AbgI2Man (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Sep 2020 08:30:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:43654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732807AbgI2MaY (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 29 Sep 2020 08:30:24 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 784E6208B8;
        Tue, 29 Sep 2020 12:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601382624;
        bh=QJRidVy9dSk4TYwH+Ryb+0eZgSXzN934rTM79uyIp20=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pSjraPhkfe01aCQlhoMISnEqzu03X5C8MAxR/yIhwNrWKYgPTWISDujdx2+fr5dzm
         iDkenWtzd4Ab2KPzXY0a0WQLVJfdtAy4HJCAJnRn9lS574FFioxcU325X3uWtAiiET
         EfibzlhwORm21Ho7alGvoKWIdwM1KGhHhB/i9Ecg=
Message-ID: <2246f010fe5a697f0694fe769fd1fe131b46ba35.camel@kernel.org>
Subject: Re: [RFC PATCH 2/4] ceph: don't mark mount as SHUTDOWN when
 recovering session
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Patrick Donnelly <pdonnell@redhat.com>
Date:   Tue, 29 Sep 2020 08:30:22 -0400
In-Reply-To: <CAAM7YAm834Kbf1YYcNa0XGR7EYMnAH4eYs0uBbCr3KNaHccCcQ@mail.gmail.com>
References: <20200925140851.320673-1-jlayton@kernel.org>
         <20200925140851.320673-3-jlayton@kernel.org>
         <CAAM7YAm834Kbf1YYcNa0XGR7EYMnAH4eYs0uBbCr3KNaHccCcQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2020-09-29 at 16:20 +0800, Yan, Zheng wrote:
> On Fri, Sep 25, 2020 at 10:08 PM Jeff Layton <jlayton@kernel.org> wrote:
> > When recovering a session (a'la recover_session=clean), we want to do
> > all of the operations that we do on a forced umount, but changing the
> > mount state to SHUTDOWN is wrong and can cause queued MDS requests to
> > fail when the session comes back.
> > 
> 
> code that cleanup page cache check the SHUTDOWN state.
> 

Ok, so we do need to do something else there if we don't mark the thing
SHUTDOWN. Maybe we ought to declare a new mount_state for
this...CEPH_MOUNT_RECOVERING ?

> > Only mark it as SHUTDOWN when umount_begin is called.
> > 
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/super.c | 13 +++++++++----
> >  1 file changed, 9 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > index 2516304379d3..46a0e4e1b177 100644
> > --- a/fs/ceph/super.c
> > +++ b/fs/ceph/super.c
> > @@ -832,6 +832,13 @@ static void destroy_caches(void)
> >         ceph_fscache_unregister();
> >  }
> > 
> > +static void __ceph_umount_begin(struct ceph_fs_client *fsc)
> > +{
> > +       ceph_osdc_abort_requests(&fsc->client->osdc, -EIO);
> > +       ceph_mdsc_force_umount(fsc->mdsc);
> > +       fsc->filp_gen++; // invalidate open files
> > +}
> > +
> >  /*
> >   * ceph_umount_begin - initiate forced umount.  Tear down the
> >   * mount, skipping steps that may hang while waiting for server(s).
> > @@ -844,9 +851,7 @@ static void ceph_umount_begin(struct super_block *sb)
> >         if (!fsc)
> >                 return;
> >         fsc->mount_state = CEPH_MOUNT_SHUTDOWN;
> > -       ceph_osdc_abort_requests(&fsc->client->osdc, -EIO);
> > -       ceph_mdsc_force_umount(fsc->mdsc);
> > -       fsc->filp_gen++; // invalidate open files
> > +       __ceph_umount_begin(fsc);
> >  }
> > 
> >  static const struct super_operations ceph_super_ops = {
> > @@ -1235,7 +1240,7 @@ int ceph_force_reconnect(struct super_block *sb)
> >         struct ceph_fs_client *fsc = ceph_sb_to_client(sb);
> >         int err = 0;
> > 
> > -       ceph_umount_begin(sb);
> > +       __ceph_umount_begin(fsc);
> > 
> >         /* Make sure all page caches get invalidated.
> >          * see remove_session_caps_cb() */
> > --
> > 2.26.2
> > 

-- 
Jeff Layton <jlayton@kernel.org>

