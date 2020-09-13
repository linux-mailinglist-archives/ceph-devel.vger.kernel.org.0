Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF7A9267F86
	for <lists+ceph-devel@lfdr.de>; Sun, 13 Sep 2020 14:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725932AbgIMMmC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 13 Sep 2020 08:42:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:40070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725919AbgIMMmB (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Sun, 13 Sep 2020 08:42:01 -0400
Received: from vulkan (047-135-012-206.res.spectrum.com [47.135.12.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A5BB2158C;
        Sun, 13 Sep 2020 12:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600000920;
        bh=AY3flTtG0nRo/JjZaeRk2Oi/Fvrcc/CA67DP33OueLE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=faOTUo4lr48BPKDLoDQG0aeT18GO8s7gRuJYpqDTmUXUIYfGU3oUhLnz3SVW3tJ8W
         L2SSoXudxCOqoqnFd1kqLDtl9I6TAPReA8OhQChdUbZdRQM4/+LFP+wpk71wcNm7cF
         XDpgUYrJP+EwfBXCOZvi6LMAb9/TQOUVmJG2yoP4=
Message-ID: <39f1aab64cc6c4fdc8f0cc32b74220c8aae71bd8.camel@kernel.org>
Subject: Re: [PATCH] ceph: use kill_anon_super helper
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Date:   Sun, 13 Sep 2020 08:41:58 -0400
In-Reply-To: <CAOi1vP9=wJNo0vywfBUnGz7qhJegTS=-bRWyqnJ=z7_54A+0vQ@mail.gmail.com>
References: <20200912101424.5659-1-jlayton@kernel.org>
         <CAOi1vP9=wJNo0vywfBUnGz7qhJegTS=-bRWyqnJ=z7_54A+0vQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sun, 2020-09-13 at 14:00 +0200, Ilya Dryomov wrote:
> On Sat, Sep 12, 2020 at 12:14 PM Jeff Layton <jlayton@kernel.org> wrote:
> > ceph open-codes this around some other activity and the rationale
> > for it isn't clear. There is no need to delay free_anon_bdev until
> > the end of kill_sb.
> > 
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/super.c | 4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> > 
> > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > index 7ec0e6d03d10..b3fc9bb61afc 100644
> > --- a/fs/ceph/super.c
> > +++ b/fs/ceph/super.c
> > @@ -1205,14 +1205,13 @@ static int ceph_init_fs_context(struct fs_context *fc)
> >  static void ceph_kill_sb(struct super_block *s)
> >  {
> >         struct ceph_fs_client *fsc = ceph_sb_to_client(s);
> > -       dev_t dev = s->s_dev;
> > 
> >         dout("kill_sb %p\n", s);
> > 
> >         ceph_mdsc_pre_umount(fsc->mdsc);
> >         flush_fs_workqueues(fsc);
> > 
> > -       generic_shutdown_super(s);
> > +       kill_anon_super(s);
> > 
> >         fsc->client->extra_mon_dispatch = NULL;
> >         ceph_fs_debugfs_cleanup(fsc);
> > @@ -1220,7 +1219,6 @@ static void ceph_kill_sb(struct super_block *s)
> >         ceph_fscache_unregister_fs(fsc);
> > 
> >         destroy_fs_client(fsc);
> > -       free_anon_bdev(dev);
> >  }
> > 
> >  static struct file_system_type ceph_fs_type = {
> > --
> > 2.26.2
> > 
> 
> Hi Jeff,
> 
> Just curious, did you attempt to figure out why it used to be
> necessary?  Looks like it goes back to a very old commit 5dfc589a8467
> ("ceph: unregister bdi before kill_anon_super releases device name"),
> but it's not obvious to me at first sight...
> 
> A lot has changed in the bdi area since then, so if not, it probably
> doesn't matter much -- AFAICT bdi would still get unregistered before
> the minor number is released with this patch.
> 

I did see that commit, but the rationale for it wasn't terribly clear,
and like you said the bdi handling has had a lot of changes since then.

I mainly just looked to see whether the activities between
generic_shutdown_super and free_anon_bdev had any bearing on the minor
number and bdi, but it didn't seem to be.
-- 
Jeff Layton <jlayton@kernel.org>

