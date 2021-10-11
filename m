Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1312A428B06
	for <lists+ceph-devel@lfdr.de>; Mon, 11 Oct 2021 12:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235981AbhJKKuJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 11 Oct 2021 06:50:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:43594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235970AbhJKKuI (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 11 Oct 2021 06:50:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD4D960E53;
        Mon, 11 Oct 2021 10:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633949288;
        bh=HsJHmola6Ex8Jyfgo6yBjZspiuXkoKWk7C24cpJt0Sw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WjgqL2P0BLcvvq3eglqXjH99FXc8iQnBWmZy50EP7zk5cPkUuRWDQwPKl43ZguuaU
         EZG7uBnQXRwXpB0hWqcVNj/wuuV/8MQ1J3LKIBU07Zey4Tn56d1TGRpUG1J69KN19T
         yyOGEE1NYAP+Othx93pMKEgh3Oimj8oFuDrrk4DfawolQPhbjjQ7h4TlILeBuGmsvZ
         8YIlOwr/gXq1GucNPL9RlKl8gsDEhXxQLtY94pwgq1t2onijqjKBa/kj6Qj3R8lf17
         WcgMHy2L1fJ2U9vI4oPWXtmDHJU+5P8UHrIvHcCOGmraXc+BBA9AreVAUmjaIWp4MX
         w5hokQ0P1/LSg==
Message-ID: <24064c5d0298580ba7dbaab78a168d442246bb28.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: skip existing superblocks that are blocklisted
 when mounting
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Niels de Vos <ndevos@redhat.com>
Date:   Mon, 11 Oct 2021 06:48:06 -0400
In-Reply-To: <CAAM7YA=eFt5HVc5r=5o6A_0iuzKxNf=M3k_7Ctx0eg-DsO6CxA@mail.gmail.com>
References: <20210930170302.74924-1-jlayton@kernel.org>
         <CAOi1vP9YBcxMAMe1yE4v-E6gmK0GbYMKX5yODAYQOXvRd39FFg@mail.gmail.com>
         <cb422013534ef465e906b45a085e5c79dcd1b201.camel@kernel.org>
         <CAAM7YA=eFt5HVc5r=5o6A_0iuzKxNf=M3k_7Ctx0eg-DsO6CxA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2021-10-11 at 11:37 +0800, Yan, Zheng wrote:
> 
> 
> On Tue, Oct 5, 2021 at 6:17 PM Jeff Layton <jlayton@kernel.org> wrote:
> > On Tue, 2021-10-05 at 10:00 +0200, Ilya Dryomov wrote:
> > > On Thu, Sep 30, 2021 at 7:03 PM Jeff Layton <jlayton@kernel.org>
> > wrote:
> > > > 
> > > > Currently when mounting, we may end up finding an existing
> > superblock
> > > > that corresponds to a blocklisted MDS client. This means that
> > > > the
> > new
> > > > mount ends up being unusable.
> > > > 
> > > > If we've found an existing superblock with a client that is
> > already
> > > > blocklisted, and the client is not configured to recover on its
> > own,
> > > > fail the match.
> > > > 
> > > > While we're in here, also rename "other" to the more
> > > > conventional
> > "fsc".
> > > > 
> > 
> 
> 
> Note: we have similar issue for forced umounted superblock 
>  

True...

There is a small window of time between when ->umount_begin runs and
generic_shutdown_super happens. Between that period, you could match a
superblock that's been forcibly umounted and is on the way to being
detached from the tree.

I'm a little less concerned about that because the time window should be
pretty short, and someone would need to try to make a new mount while
"umount -f" is still running. I don't think we can fully prevent that
anyway, as there is some raciness involved (your mount might match the
thing just before umount_begin runs).

I'm inclined not to worry about that case, unless we have some reports
of people hitting that problem.

Thoughts?


> >  
> > > > Cc: Patrick Donnelly <pdonnell@redhat.com>
> > > > Cc: Niels de Vos <ndevos@redhat.com>
> > > > URL: https://bugzilla.redhat.com/show_bug.cgi?id=1901499
> > > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > > ---
> > > >   fs/ceph/super.c | 11 ++++++++---
> > > >   1 file changed, 8 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > > > index f517ad9eeb26..a7f1b66a91a7 100644
> > > > --- a/fs/ceph/super.c
> > > > +++ b/fs/ceph/super.c
> > > > @@ -1123,16 +1123,16 @@ static int ceph_compare_super(struct
> > super_block *sb, struct fs_context *fc)
> > > >          struct ceph_fs_client *new = fc->s_fs_info;
> > > >          struct ceph_mount_options *fsopt = new->mount_options;
> > > >          struct ceph_options *opt = new->client->options;
> > > > -       struct ceph_fs_client *other = ceph_sb_to_client(sb);
> > > > +       struct ceph_fs_client *fsc = ceph_sb_to_client(sb);
> > > > 
> > > >          dout("ceph_compare_super %p\n", sb);
> > > > 
> > > > -       if (compare_mount_options(fsopt, opt, other)) {
> > > > +       if (compare_mount_options(fsopt, opt, fsc)) {
> > > >                  dout("monitor(s)/mount options don't match\n");
> > > >                  return 0;
> > > >          }
> > > >          if ((opt->flags & CEPH_OPT_FSID) &&
> > > > -           ceph_fsid_compare(&opt->fsid, &other->client->fsid))
> > > > {
> > > > +           ceph_fsid_compare(&opt->fsid, &fsc->client->fsid)) {
> > > >                  dout("fsid doesn't match\n");
> > > >                  return 0;
> > > >          }
> > > > @@ -1140,6 +1140,11 @@ static int ceph_compare_super(struct
> > super_block *sb, struct fs_context *fc)
> > > >                  dout("flags differ\n");
> > > >                  return 0;
> > > >          }
> > > > +       /* Exclude any blocklisted superblocks */
> > > > +       if (fsc->blocklisted && !(fsopt->flags &
> > CEPH_MOUNT_OPT_CLEANRECOVER)) {
> > > 
> > > Hi Jeff,
> > > 
> > > Nit: This looks a bit weird because fsc is the existing client
> > > while
> > > fsopt is the new set of mount options.  They are guaranteed to
> > > match
> > at
> > > that point because of compare_mount_options() but it feels better
> > > to
> > > stick to probing the existing client, e.g.
> > > 
> > >     if (fsc->blocklisted && !ceph_test_mount_opt(fsc,
> > > CLEANRECOVER))
> > > 
> > 
> > Yeah, that does look cleaner. I went ahead and made that change in
> > the
> > testing branch patch, but I'll skip re-posting it.
> > 
> > Thanks,

-- 
Jeff Layton <jlayton@kernel.org>

