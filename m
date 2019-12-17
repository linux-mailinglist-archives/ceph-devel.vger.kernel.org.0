Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19491122AEE
	for <lists+ceph-devel@lfdr.de>; Tue, 17 Dec 2019 13:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbfLQMGs (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 17 Dec 2019 07:06:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:36666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726747AbfLQMGr (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 17 Dec 2019 07:06:47 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B165207FF;
        Tue, 17 Dec 2019 12:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576584406;
        bh=KkrzYcGNMXleMrUh7LMx++2+XebCTzknXsgOVEe42ZI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Kd21o6r5CeMZkU9uRIad7SDvayI2GHwD+j8hthXsy/LrlzmizVurCybE02ApWN71/
         DCFUKJabYZOq62EW7nCvn1A62Fdoh/ZHl5JUK83srFtuwVT6iCbwlGkpQ7LqD8zbwA
         eDRxBWQWWjUhSEIe5A1/mRjjK6W97yUpv+8RF9yM=
Message-ID: <1a9367f923b2e5fc9df6c5826e06bc9867df1835.camel@kernel.org>
Subject: Re: [PATCH] ceph: don't clear I_NEW until inode metadata is fully
 populated
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>,
        Zheng Yan <zyan@redhat.com>
Date:   Tue, 17 Dec 2019 07:06:45 -0500
In-Reply-To: <CAAM7YA=Csi3+0AsR2Sa7cUVQQ0ME7VPcAugcPC=LesUBFV9zuw@mail.gmail.com>
References: <20191212142717.23656-1-jlayton@kernel.org>
         <CAAM7YA=Csi3+0AsR2Sa7cUVQQ0ME7VPcAugcPC=LesUBFV9zuw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2019-12-17 at 19:59 +0800, Yan, Zheng wrote:
> On Thu, Dec 12, 2019 at 10:28 PM Jeff Layton <jlayton@kernel.org> wrote:
> > Currently, we could have an open-by-handle (or NFS server) call
> > into the filesystem and start working with an inode before it's
> > properly filled out.
> > 
> > Don't clear I_NEW until we have filled out the inode, and discard it
> > properly if that fails. Note that we occasionally take an extra
> > reference to the inode to ensure that we don't put the last reference in
> > discard_new_inode, but rather leave it for ceph_async_iput.
> > 
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/inode.c | 25 +++++++++++++++++++++----
> >  1 file changed, 21 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> > index 5bdc1afc2bee..11672f8192b9 100644
> > --- a/fs/ceph/inode.c
> > +++ b/fs/ceph/inode.c
> > @@ -55,11 +55,9 @@ struct inode *ceph_get_inode(struct super_block *sb, struct ceph_vino vino)
> >         inode = iget5_locked(sb, t, ceph_ino_compare, ceph_set_ino_cb, &vino);
> >         if (!inode)
> >                 return ERR_PTR(-ENOMEM);
> > -       if (inode->i_state & I_NEW) {
> > +       if (inode->i_state & I_NEW)
> >                 dout("get_inode created new inode %p %llx.%llx ino %llx\n",
> >                      inode, ceph_vinop(inode), (u64)inode->i_ino);
> > -               unlock_new_inode(inode);
> > -       }
> > 
> >         dout("get_inode on %lu=%llx.%llx got %p\n", inode->i_ino, vino.ino,
> >              vino.snap, inode);
> > @@ -88,6 +86,10 @@ struct inode *ceph_get_snapdir(struct inode *parent)
> >         inode->i_fop = &ceph_snapdir_fops;
> >         ci->i_snap_caps = CEPH_CAP_PIN; /* so we can open */
> >         ci->i_rbytes = 0;
> > +
> > +       if (inode->i_state & I_NEW)
> > +               unlock_new_inode(inode);
> > +
> >         return inode;
> >  }
> > 
> > @@ -1301,7 +1303,6 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
> >                         err = PTR_ERR(in);
> >                         goto done;
> >                 }
> > -               req->r_target_inode = in;
> > 
> >                 err = fill_inode(in, req->r_locked_page, &rinfo->targeti, NULL,
> >                                 session,
> > @@ -1311,8 +1312,13 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
> >                 if (err < 0) {
> >                         pr_err("fill_inode badness %p %llx.%llx\n",
> >                                 in, ceph_vinop(in));
> > +                       if (in->i_state & I_NEW)
> > +                               discard_new_inode(in);
> >                         goto done;
> >                 }
> > +               req->r_target_inode = in;
> > +               if (in->i_state & I_NEW)
> > +                       unlock_new_inode(in);
> >         }
> > 
> >         /*
> > @@ -1496,7 +1502,12 @@ static int readdir_prepopulate_inodes_only(struct ceph_mds_request *req,
> >                 if (rc < 0) {
> >                         pr_err("fill_inode badness on %p got %d\n", in, rc);
> >                         err = rc;
> > +                       ihold(in);
> > +                       discard_new_inode(in);
> no check for I_NEW?
> 

Good catch. Those two lines should be inside a check for I_NEW.

> > +               } else if (in->i_state & I_NEW) {
> > +                       unlock_new_inode(in);
> >                 }
> > +
> >                 /* avoid calling iput_final() in mds dispatch threads */
> >                 ceph_async_iput(in);
> >         }
> > @@ -1698,12 +1709,18 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
> >                         if (d_really_is_negative(dn)) {
> >                                 /* avoid calling iput_final() in mds
> >                                  * dispatch threads */
> > +                               if (in->i_state & I_NEW) {
> > +                                       ihold(in);
> > +                                       discard_new_inode(in);
> > +                               }
> >                                 ceph_async_iput(in);
> >                         }
> >                         d_drop(dn);
> >                         err = ret;
> >                         goto next_item;
> >                 }
> > +               if (in->i_state & I_NEW)
> > +                       unlock_new_inode(in);
> > 
> >                 if (d_really_is_negative(dn)) {
> >                         if (ceph_security_xattr_deadlock(in)) {
> > --
> > 2.23.0
> > 

-- 
Jeff Layton <jlayton@kernel.org>

