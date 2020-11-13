Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98A862B24D5
	for <lists+ceph-devel@lfdr.de>; Fri, 13 Nov 2020 20:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgKMTpX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 13 Nov 2020 14:45:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:33228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726087AbgKMTpV (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 13 Nov 2020 14:45:21 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39C4A22240;
        Fri, 13 Nov 2020 19:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605296720;
        bh=tqh+0mbASaAvooIbODmLklGkCNqhB5TB4KQodDOuBcs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=K3QqwAt3JTG8uLFH0Cdch0rFevzDV8xlsmYAjsFpTzmWFPdVyJV590M3tafyVbFbe
         zm5ghM9I5+lblcjg2joog4NIEylACsxXUoeffdR1sI2h5w6d0v62Oz02/e4k9GryTn
         HbDGe956OqINRG5FmY6asAvj4lFbHyRjtP/bfPAA=
Message-ID: <ce2207b20cdc5305bca62ce91bab85d3925afa38.camel@kernel.org>
Subject: Re: [PATCH v4 2/2] ceph: add ceph.{cluster_fsid/client_id} vxattrs
 suppport
From:   Jeff Layton <jlayton@kernel.org>
To:     Patrick Donnelly <pdonnell@redhat.com>,
        Xiubo Li <xiubli@redhat.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>, Zheng Yan <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Date:   Fri, 13 Nov 2020 14:45:18 -0500
In-Reply-To: <CA+2bHPZuXcVw6Mwpz0wkg-SDsUc7XZqK0_m2eVQsQOEsQkZiGw@mail.gmail.com>
References: <20201111012940.468289-1-xiubli@redhat.com>
         <20201111012940.468289-3-xiubli@redhat.com>
         <CA+2bHPZuXcVw6Mwpz0wkg-SDsUc7XZqK0_m2eVQsQOEsQkZiGw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 (3.38.1-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2020-11-13 at 11:40 -0800, Patrick Donnelly wrote:
> On Tue, Nov 10, 2020 at 5:29 PM <xiubli@redhat.com> wrote:
> > 
> > From: Xiubo Li <xiubli@redhat.com>
> > 
> > These two vxattrs will only exist in local client side, with which
> > we can easily know which mountpoint the file belongs to and also
> > they can help locate the debugfs path quickly.
> > 
> > URL: https://tracker.ceph.com/issues/48057
> > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > ---
> >  fs/ceph/xattr.c | 42 ++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 42 insertions(+)
> > 
> > diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> > index 0fd05d3d4399..e89750a1f039 100644
> > --- a/fs/ceph/xattr.c
> > +++ b/fs/ceph/xattr.c
> > @@ -304,6 +304,23 @@ static ssize_t ceph_vxattrcb_snap_btime(struct ceph_inode_info *ci, char *val,
> >                                 ci->i_snap_btime.tv_nsec);
> >  }
> > 
> > +static ssize_t ceph_vxattrcb_cluster_fsid(struct ceph_inode_info *ci,
> > +                                         char *val, size_t size)
> > +{
> > +       struct ceph_fs_client *fsc = ceph_sb_to_client(ci->vfs_inode.i_sb);
> > +
> > +       return ceph_fmt_xattr(val, size, "%pU", &fsc->client->fsid);
> > +}
> > +
> > +static ssize_t ceph_vxattrcb_client_id(struct ceph_inode_info *ci,
> > +                                      char *val, size_t size)
> > +{
> > +       struct ceph_fs_client *fsc = ceph_sb_to_client(ci->vfs_inode.i_sb);
> > +
> > +       return ceph_fmt_xattr(val, size, "client%lld",
> > +                             ceph_client_gid(fsc->client));
> > +}
> 
> Let's just have this return the id number. The caller can concatenate
> that with "client" however they require. Otherwise, parsing it out is
> needlessly troublesome.
> 

That does seem nicer, but it would be inconsistent with the existing rbd
attributes. Ilya, would you object?

> >  #define CEPH_XATTR_NAME(_type, _name)  XATTR_CEPH_PREFIX #_type "." #_name
> >  #define CEPH_XATTR_NAME2(_type, _name, _name2) \
> >         XATTR_CEPH_PREFIX #_type "." #_name "." #_name2
> > @@ -407,6 +424,24 @@ static struct ceph_vxattr ceph_file_vxattrs[] = {
> >         { .name = NULL, 0 }     /* Required table terminator */
> >  };
> > 
> > +static struct ceph_vxattr ceph_common_vxattrs[] = {
> > +       {
> > +               .name = "ceph.cluster_fsid",
> > +               .name_size = sizeof("ceph.cluster_fsid"),
> > +               .getxattr_cb = ceph_vxattrcb_cluster_fsid,
> > +               .exists_cb = NULL,
> > +               .flags = VXATTR_FLAG_READONLY,
> > +       },
> 
> I would prefer just "ceph.fsid".
> 

Ilya suggested this name to match existing rbd attributes.
 
> > +       {
> > +               .name = "ceph.client_id",
> > +               .name_size = sizeof("ceph.client_id"),
> > +               .getxattr_cb = ceph_vxattrcb_client_id,
> > +               .exists_cb = NULL,
> > +               .flags = VXATTR_FLAG_READONLY,
> > +       },
> > +       { .name = NULL, 0 }     /* Required table terminator */
> > +};
> > +
> >  static struct ceph_vxattr *ceph_inode_vxattrs(struct inode *inode)
> >  {
> >         if (S_ISDIR(inode->i_mode))
> > @@ -429,6 +464,13 @@ static struct ceph_vxattr *ceph_match_vxattr(struct inode *inode,
> >                 }
> >         }
> > 
> > +       vxattr = ceph_common_vxattrs;
> > +       while (vxattr->name) {
> > +               if (!strcmp(vxattr->name, name))
> > +                       return vxattr;
> > +               vxattr++;
> > +       }
> > +
> >         return NULL;
> >  }
> 
> Please also be sure to wire up the same vxattrs in the userspace Client.
> 
> 

-- 
Jeff Layton <jlayton@kernel.org>

