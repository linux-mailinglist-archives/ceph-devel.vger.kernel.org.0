Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9E1422332
	for <lists+ceph-devel@lfdr.de>; Tue,  5 Oct 2021 12:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233783AbhJEKQh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 5 Oct 2021 06:16:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232658AbhJEKQg (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 5 Oct 2021 06:16:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CAE66113A;
        Tue,  5 Oct 2021 10:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633428885;
        bh=QxoT0VDAnR/pFzXaS8ecqIG4iei0w4QyP4WpU+vYvgc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XpzHaeAnCQKJythpYNrmvwD02Hn+lsYA2VjT/ug6oGE2gF9FbdTtj8kvOzi3bWCaD
         WHBz1e5AFvovla5pEzkLZJCPl2ENcfJLyefUaDoZvgvgJcNqHKw8UiySYi/9Jtr1D+
         yjgtjYAjRev7O4llyWFWNGrHBZpmRx4RzVtDf4PxIO6npnPcOTAQUp198vvyxsQDoi
         UKvJkeQA2s+naqXbu1fejA6f2y43P2ZHeBh3jcOCfJBZxmgWONPo/tXqI2SVc2diZk
         oBtjiJdYbjnhdZu3cWVhuGfnKnXsZuXsvJ7AmAXqU176pwsKaOgt9ZXLClTr8sowWR
         0S5lhwTTv9KKg==
Message-ID: <cb422013534ef465e906b45a085e5c79dcd1b201.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: skip existing superblocks that are blocklisted
 when mounting
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Niels de Vos <ndevos@redhat.com>
Date:   Tue, 05 Oct 2021 06:14:44 -0400
In-Reply-To: <CAOi1vP9YBcxMAMe1yE4v-E6gmK0GbYMKX5yODAYQOXvRd39FFg@mail.gmail.com>
References: <20210930170302.74924-1-jlayton@kernel.org>
         <CAOi1vP9YBcxMAMe1yE4v-E6gmK0GbYMKX5yODAYQOXvRd39FFg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2021-10-05 at 10:00 +0200, Ilya Dryomov wrote:
> On Thu, Sep 30, 2021 at 7:03 PM Jeff Layton <jlayton@kernel.org> wrote:
> > 
> > Currently when mounting, we may end up finding an existing superblock
> > that corresponds to a blocklisted MDS client. This means that the new
> > mount ends up being unusable.
> > 
> > If we've found an existing superblock with a client that is already
> > blocklisted, and the client is not configured to recover on its own,
> > fail the match.
> > 
> > While we're in here, also rename "other" to the more conventional "fsc".
> > 
> > Cc: Patrick Donnelly <pdonnell@redhat.com>
> > Cc: Niels de Vos <ndevos@redhat.com>
> > URL: https://bugzilla.redhat.com/show_bug.cgi?id=1901499
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/super.c | 11 ++++++++---
> >  1 file changed, 8 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > index f517ad9eeb26..a7f1b66a91a7 100644
> > --- a/fs/ceph/super.c
> > +++ b/fs/ceph/super.c
> > @@ -1123,16 +1123,16 @@ static int ceph_compare_super(struct super_block *sb, struct fs_context *fc)
> >         struct ceph_fs_client *new = fc->s_fs_info;
> >         struct ceph_mount_options *fsopt = new->mount_options;
> >         struct ceph_options *opt = new->client->options;
> > -       struct ceph_fs_client *other = ceph_sb_to_client(sb);
> > +       struct ceph_fs_client *fsc = ceph_sb_to_client(sb);
> > 
> >         dout("ceph_compare_super %p\n", sb);
> > 
> > -       if (compare_mount_options(fsopt, opt, other)) {
> > +       if (compare_mount_options(fsopt, opt, fsc)) {
> >                 dout("monitor(s)/mount options don't match\n");
> >                 return 0;
> >         }
> >         if ((opt->flags & CEPH_OPT_FSID) &&
> > -           ceph_fsid_compare(&opt->fsid, &other->client->fsid)) {
> > +           ceph_fsid_compare(&opt->fsid, &fsc->client->fsid)) {
> >                 dout("fsid doesn't match\n");
> >                 return 0;
> >         }
> > @@ -1140,6 +1140,11 @@ static int ceph_compare_super(struct super_block *sb, struct fs_context *fc)
> >                 dout("flags differ\n");
> >                 return 0;
> >         }
> > +       /* Exclude any blocklisted superblocks */
> > +       if (fsc->blocklisted && !(fsopt->flags & CEPH_MOUNT_OPT_CLEANRECOVER)) {
> 
> Hi Jeff,
> 
> Nit: This looks a bit weird because fsc is the existing client while
> fsopt is the new set of mount options.  They are guaranteed to match at
> that point because of compare_mount_options() but it feels better to
> stick to probing the existing client, e.g.
> 
>    if (fsc->blocklisted && !ceph_test_mount_opt(fsc, CLEANRECOVER))
> 

Yeah, that does look cleaner. I went ahead and made that change in the
testing branch patch, but I'll skip re-posting it.

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

