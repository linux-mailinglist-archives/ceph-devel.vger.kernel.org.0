Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 071792ADC28
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Nov 2020 17:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729819AbgKJQ06 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Nov 2020 11:26:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:55672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbgKJQ06 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 10 Nov 2020 11:26:58 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA85520780;
        Tue, 10 Nov 2020 16:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605025617;
        bh=QVkj0WqF0caY1yTdKByO8jOjZpcCRqTc0wTuVsnF+D0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fcQ0HRA9imwnwDuvTT1275/cezT0hroUsYJhiM4hpY9kaejMfmeNGDxffLDm+45SF
         ez/fRrj8nzCV2O12e9HTNR0HmIKr2dhqL3YGiIEMd7Dq2ELXJVTZH3hHgZyBXSpGAY
         bye4T4sYgikczHJi1rvcrRs3Sja6OAIw73nLJ+ls=
Message-ID: <ca04bd7a8d3af6f4613a804f8b29c4c89a2562a7.camel@kernel.org>
Subject: Re: [PATCH v3 2/2] ceph: add ceph.{clusterid/clientid} vxattrs
 suppport
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>
Cc:     "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Date:   Tue, 10 Nov 2020 11:26:55 -0500
In-Reply-To: <CAOi1vP-JQbVYdAFfebKWLXPpVSgXFq=5s2_4knWbV9_J9ubxKA@mail.gmail.com>
References: <20201110141703.414211-1-xiubli@redhat.com>
         <20201110141703.414211-3-xiubli@redhat.com>
         <CAOi1vP-JQbVYdAFfebKWLXPpVSgXFq=5s2_4knWbV9_J9ubxKA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 (3.38.1-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2020-11-10 at 16:59 +0100, Ilya Dryomov wrote:
> On Tue, Nov 10, 2020 at 3:17 PM <xiubli@redhat.com> wrote:
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
> > index 0fd05d3d4399..4a41db46e191 100644
> > --- a/fs/ceph/xattr.c
> > +++ b/fs/ceph/xattr.c
> > @@ -304,6 +304,23 @@ static ssize_t ceph_vxattrcb_snap_btime(struct ceph_inode_info *ci, char *val,
> >                                 ci->i_snap_btime.tv_nsec);
> >  }
> > 
> > +static ssize_t ceph_vxattrcb_clusterid(struct ceph_inode_info *ci,
> > +                                      char *val, size_t size)
> > +{
> > +       struct ceph_fs_client *fsc = ceph_sb_to_client(ci->vfs_inode.i_sb);
> > +
> > +       return ceph_fmt_xattr(val, size, "%pU", &fsc->client->fsid);
> > +}
> > +
> > +static ssize_t ceph_vxattrcb_clientid(struct ceph_inode_info *ci,
> > +                                     char *val, size_t size)
> > +{
> > +       struct ceph_fs_client *fsc = ceph_sb_to_client(ci->vfs_inode.i_sb);
> > +
> > +       return ceph_fmt_xattr(val, size, "client%lld",
> > +                             ceph_client_gid(fsc->client));
> > +}
> > +
> >  #define CEPH_XATTR_NAME(_type, _name)  XATTR_CEPH_PREFIX #_type "." #_name
> >  #define CEPH_XATTR_NAME2(_type, _name, _name2) \
> >         XATTR_CEPH_PREFIX #_type "." #_name "." #_name2
> > @@ -407,6 +424,24 @@ static struct ceph_vxattr ceph_file_vxattrs[] = {
> >         { .name = NULL, 0 }     /* Required table terminator */
> >  };
> > 
> > +static struct ceph_vxattr ceph_vxattrs[] = {
> > +       {
> > +               .name = "ceph.clusterid",
> 
> I think this should be "ceph.cluster_fsid"
> 
> > +               .name_size = sizeof("ceph.clusterid"),
> > +               .getxattr_cb = ceph_vxattrcb_clusterid,
> > +               .exists_cb = NULL,
> > +               .flags = VXATTR_FLAG_READONLY,
> > +       },
> > +       {
> > +               .name = "ceph.clientid",
> 
> and this should be "ceph.client_id".  It's easier to read, consistent
> with "ceph fsid" command and with existing rbd attributes:
> 
>   static DEVICE_ATTR(client_id, 0444, rbd_client_id_show, NULL);
>   static DEVICE_ATTR(cluster_fsid, 0444, rbd_cluster_fsid_show, NULL);
> 

That sounds like a good idea. Xiubo, would you mind sending a v4?

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

