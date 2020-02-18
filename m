Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4DC16276C
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Feb 2020 14:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbgBRNvz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 18 Feb 2020 08:51:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:46964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726620AbgBRNvz (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 18 Feb 2020 08:51:55 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2FB320801;
        Tue, 18 Feb 2020 13:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582033914;
        bh=ZRyqwwZO6/f+fBV4H7w/2yqjJOfNbFUM+1PKRnL6LhI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XIYDBUT9RtrwiJd4ljuVC40uJJ8ta2zUjo7hZJzkw/9tWTJWtODOC5CyRyzlnVRa6
         5OHjHf8QzgrmMQRPrHdEjdn2bBLZB7hnk52u21L0gXyfRzuX04NMOQUgB5c9ajEXzH
         hsqbzCTE9DgZdyRTfbidtRnpanQcTl+JZIJA2qJE=
Message-ID: <53b7ad01ba884004209e86bb028dc628ae0d12db.camel@kernel.org>
Subject: Re: [PATCH] ceph: fix dout logs for null pointers
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>
Cc:     Sage Weil <sage@redhat.com>, "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Date:   Tue, 18 Feb 2020 08:51:52 -0500
In-Reply-To: <0637b6ba-b411-6ddd-2703-d0f96a65a796@redhat.com>
References: <20200217112806.30738-1-xiubli@redhat.com>
         <CAOi1vP_bCGoni+tmvVri6Gcv7QRN4+qvHUrrweHLpnTyAzQw=A@mail.gmail.com>
         <cf786dd6-cb6e-1a3a-a57e-04d9525bb4a4@redhat.com>
         <CAOi1vP9sLLUhuBAP7UZ1Mbjjx4uh0Rt0PwgAuD_qBevQoSOeHA@mail.gmail.com>
         <0637b6ba-b411-6ddd-2703-d0f96a65a796@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2020-02-17 at 23:42 +0800, Xiubo Li wrote:
> On 2020/2/17 23:27, Ilya Dryomov wrote:
> > On Mon, Feb 17, 2020 at 4:02 PM Xiubo Li <xiubli@redhat.com> wrote:
> > > On 2020/2/17 22:52, Ilya Dryomov wrote:
> > > > On Mon, Feb 17, 2020 at 12:28 PM <xiubli@redhat.com> wrote:
> > > > > From: Xiubo Li <xiubli@redhat.com>
> > > > > 
> > > > > For example, if dentry and inode is NULL, the log will be:
> > > > > ceph:  lookup result=000000007a1ca695
> > > > > ceph:  submit_request on 0000000041d5070e for inode 000000007a1ca695
> > > > > 
> > > > > The will be confusing without checking the corresponding code carefully.
> > > > > 
> > > > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > > > ---
> > > > >    fs/ceph/dir.c        | 2 +-
> > > > >    fs/ceph/mds_client.c | 6 +++++-
> > > > >    2 files changed, 6 insertions(+), 2 deletions(-)
> > > > > 
> > > > > diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> > > > > index ffeaff5bf211..245a262ec198 100644
> > > > > --- a/fs/ceph/dir.c
> > > > > +++ b/fs/ceph/dir.c
> > > > > @@ -798,7 +798,7 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
> > > > >           err = ceph_handle_snapdir(req, dentry, err);
> > > > >           dentry = ceph_finish_lookup(req, dentry, err);
> > > > >           ceph_mdsc_put_request(req);  /* will dput(dentry) */
> > > > > -       dout("lookup result=%p\n", dentry);
> > > > > +       dout("lookup result=%d\n", err);
> > > > >           return dentry;
> > > > >    }
> > > > > 
> > > > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > > > index b6aa357f7c61..e34f159d262b 100644
> > > > > --- a/fs/ceph/mds_client.c
> > > > > +++ b/fs/ceph/mds_client.c
> > > > > @@ -2772,7 +2772,11 @@ int ceph_mdsc_submit_request(struct ceph_mds_client *mdsc, struct inode *dir,
> > > > >                   ceph_get_cap_refs(ceph_inode(req->r_old_dentry_dir),
> > > > >                                     CEPH_CAP_PIN);
> > > > > 
> > > > > -       dout("submit_request on %p for inode %p\n", req, dir);
> > > > > +       if (dir)
> > > > > +               dout("submit_request on %p for inode %p\n", req, dir);
> > > > > +       else
> > > > > +               dout("submit_request on %p\n", req);
> > > > Hi Xiubo,
> > > > 
> > > > It's been this way for a couple of years now.  There are a lot more
> > > > douts in libceph, ceph and rbd that are sometimes fed NULL pointers.
> > > > I don't think replacing them with conditionals is the way forward.
> > > > 
> > > > I honestly don't know what security concern is addressed by hashing
> > > > NULL pointers, but that is what we have...  Ultimately, douts are just
> > > > for developers, and when you find yourself having to chase individual
> > > > pointers, you usually have a large enough piece of log to figure out
> > > > what the NULL hash is.
> > > Hi Ilya
> > > 
> > > For the ceph_lookup(). The dentry will be NULL(when the directory exists
> > > or -ENOENT) or ERR_PTR(-errno) in most cases here, it seems for the
> > > rename case it will be the old dentry returned.
> > > 
> > > So today I was trying to debug and get some logs from it, the
> > > 000000007a1ca695 really confused me for a long time before I dig into
> > > the source code.
> > I was reacting to ceph_mdsc_submit_request() hunk.  Feel free to tweak
> > ceph_lookup() or refactor it so that err is not threaded through three
> > different functions as Jeff suggested.
> 
> Hi Ilya
> 
> Oh okay. You are right we can figure out what we need via many other 
> dout logs.
> 
> I just saw some very confusing logs that the "dentry" in cpeh_lookup() 
> and the "inode" in _submit_ are all 000000007a1ca695, so I addressed 
> them both here.
> 

Since Ilya objected to this patch, I'll drop it from testing for now.
Please send a v2 that addresses his concerns if you still want this in.

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

