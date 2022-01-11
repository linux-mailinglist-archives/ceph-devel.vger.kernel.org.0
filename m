Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 742D348AED1
	for <lists+ceph-devel@lfdr.de>; Tue, 11 Jan 2022 14:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241072AbiAKNsT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 11 Jan 2022 08:48:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241007AbiAKNsT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 11 Jan 2022 08:48:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0696EC06173F
        for <ceph-devel@vger.kernel.org>; Tue, 11 Jan 2022 05:48:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A6DC6163D
        for <ceph-devel@vger.kernel.org>; Tue, 11 Jan 2022 13:48:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05E42C36AEB;
        Tue, 11 Jan 2022 13:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641908897;
        bh=AmTmwgnaLWEM4MggydeIvfReGwUUapzV5GI2KBQRDJA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Hy9Q1bVrkFwWjRCV3sAMte1JISTzsv7ubW7O2Lks/8ZVOyzG1efwMjtOHUg1BZa85
         +7pILh30mhNN9eSsWvnlfe4RNvh/N6PmIXtuNf+afp9xttmzwNJYjo/RuB4hu0C82+
         D0EWe8YyTOWHB4E7pjXvwJlHyN7iZlMjk7LPeugW7vEdi7lzZaDjiAM5RNptnlpl+/
         hEg4Ay1xx0WWkh7krWbQUigS35fwggLhoeQKYRjsUKrXuQJZAo8S7dDcTw7cxii3gV
         ksWYabgN/QJP1lszQ1u2qSHW5ozWWPje1Kam2P3WGmvQh6Q86UIxtXY6l53MhwKX2R
         XxkeyIJuVtAvw==
Message-ID: <fa963a296a9f90b395a6439f92e830d174a30784.camel@kernel.org>
Subject: Re: [PATCH 1/1] ceph: add getvxattr op
From:   Jeff Layton <jlayton@kernel.org>
To:     Milind Changire <milindchangire@gmail.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Milind Changire <mchangir@redhat.com>
Date:   Tue, 11 Jan 2022 08:48:15 -0500
In-Reply-To: <CANmksPRpzAEB70xGVmwKCgwv55bXYwuAruDcdu7ovc4suQqUZA@mail.gmail.com>
References: <20220111122431.93683-1-mchangir@redhat.com>
         <20220111122431.93683-2-mchangir@redhat.com>
         <01533250694f13e7c07263b9b4904446003f0655.camel@kernel.org>
         <CANmksPRpzAEB70xGVmwKCgwv55bXYwuAruDcdu7ovc4suQqUZA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2022-01-11 at 18:53 +0530, Milind Changire wrote:
> responses below ...
> 
> On Tue, Jan 11, 2022 at 6:19 PM Jeff Layton <jlayton@kernel.org>
> wrote:
> > On Tue, 2022-01-11 at 17:54 +0530, Milind Changire wrote:
> > > Problem:
> > > Directory vxattrs like ceph.dir.pin* and ceph.dir.layout* may not
> > > be
> > > propagated to the client as frequently to keep them updated. This
> > > creates vxattr availability problems.
> > > 
> > > Solution:
> > > Adds new getvxattr op to fetch ceph.dir.pin*, ceph.dir.layout* and
> > > ceph.file.layout* vxattrs.
> > > If the entire layout for a dir or a file is being set, then it is
> > > expected that the layout be set in standard JSON format.
> > > Individual
> > > field value retrieval is not wrapped in JSON. The JSON format also
> > > applies while setting the vxattr if the entire layout is being set
> > > in
> > > one go.
> > > As a temporary measure, setting a vxattr can also be done in the
> > > old
> > > format. The old format will be deprecated in the future.
> > > 
> > > URL: https://tracker.ceph.com/issues/51062
> > > Signed-off-by: Milind Changire <mchangir@redhat.com>
> > > ---
> > >   fs/ceph/inode.c              | 51 ++++++++++++++++++++++++++++
> > >   fs/ceph/mds_client.c         | 27 ++++++++++++++-
> > >   fs/ceph/mds_client.h         | 12 ++++++-
> > >   fs/ceph/strings.c            |  1 +
> > >   fs/ceph/super.h              |  1 +
> > >   fs/ceph/xattr.c              | 65
> > > ++++++++++++++++++++++++++++++++++++
> > >   include/linux/ceph/ceph_fs.h |  1 +
> > >   7 files changed, 156 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> > > index e3322fcb2e8d..f29d59b63c52 100644
> > > --- a/fs/ceph/inode.c
> > > +++ b/fs/ceph/inode.c
> > > @@ -2291,6 +2291,57 @@ int __ceph_do_getattr(struct inode *inode,
> > > struct page *locked_page,
> > >        return err;
> > >   }
> > >   
> > > +int ceph_do_getvxattr(struct inode *inode, const char *name, void
> > > *value,
> > > +                   size_t size)
> > > +{
> > > +     struct ceph_fs_client *fsc = ceph_sb_to_client(inode->i_sb);
> > > +     struct ceph_mds_client *mdsc = fsc->mdsc;
> > > +     struct ceph_mds_request *req;
> > > +     int mode = USE_AUTH_MDS;
> > > +     int err;
> > > +     char *xattr_value;
> > > +     size_t xattr_value_len;
> > > +
> > > +     req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETVXATTR,
> > > mode);
> > > +     if (IS_ERR(req)) {
> > > +             err = -ENOMEM;
> > > +             goto out;
> > > +     }
> > > +
> > > +     req->r_path2 = kstrdup(name, GFP_NOFS);
> > > +     if (!req->r_path2) {
> > > +             err = -ENOMEM;
> > > +             goto put;
> > > +     }
> > > +
> > > +     ihold(inode);
> > > +     req->r_inode = inode;
> > > +     err = ceph_mdsc_do_request(mdsc, NULL, req);
> > > +     if (err < 0)
> > > +             goto put;
> > > +
> > > +     xattr_value = req->r_reply_info.xattr_info.xattr_value;
> > > +     xattr_value_len = req-
> > > >r_reply_info.xattr_info.xattr_value_len;
> > > +
> > > +     dout("do_getvxattr xattr_value_len:%lu, size:%lu\n",
> > > xattr_value_len, size);
> > > +
> > > +     err = xattr_value_len;
> > > +     if (size == 0)
> > > +             goto put;
> > > +
> > > +     if (xattr_value_len > size) {
> > > +             err = -ERANGE;
> > > +             goto put;
> > > +     }
> > > +
> > > +     memcpy(value, xattr_value, xattr_value_len);
> > > +put:
> > > +     ceph_mdsc_put_request(req);
> > > +out:
> > > +     dout("do_getvxattr result=%d\n", err);
> > > +     return err;
> > > +}
> > > +
> > >   
> > >   /*
> > >    * Check inode permissions.  We verify we have a valid value for
> > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > index c30eefc0ac19..a5eafc71d976 100644
> > > --- a/fs/ceph/mds_client.c
> > > +++ b/fs/ceph/mds_client.c
> > > @@ -555,6 +555,29 @@ static int parse_reply_info_create(void **p,
> > > void *end,
> > >        return -EIO;
> > >   }
> > >   
> > > +static int parse_reply_info_getvxattr(void **p, void *end,
> > > +                                   struct
> > > ceph_mds_reply_info_parsed *info,
> > > +                                   u64 features)
> > > +{
> > > +     u8 struct_v, struct_compat;
> > > +     u32 struct_len;
> > > +     u32 value_len;
> > > +
> > > +     ceph_decode_8_safe(p, end, struct_v, bad);
> > > +     ceph_decode_8_safe(p, end, struct_compat, bad);
> > > +     ceph_decode_32_safe(p, end, struct_len, bad);
> > > +     ceph_decode_32_safe(p, end, value_len, bad);
> > > +
> > > +     if (value_len == end - *p) {
> > > +       info->xattr_info.xattr_value = *p;
> > > +       info->xattr_info.xattr_value_len = end - *p;
> > > +       *p = end;
> > > +       return info->xattr_info.xattr_value_len;
> > > +     }
> > 
> > The kernel uses tab indent almost exclusively. Can you fix the
> > indention
> > above (and anywhere else I missed)?
> > 
> 
> 
> I'll fix this. newbie issues :P
>  
> > 
> > > +bad:
> > > +     return -EIO;
> > > +}
> > > +
> > >   /*
> > >    * parse extra results
> > >    */
> > > @@ -570,6 +593,8 @@ static int parse_reply_info_extra(void **p,
> > > void *end,
> > >                return parse_reply_info_readdir(p, end, info,
> > > features);
> > >        else if (op == CEPH_MDS_OP_CREATE)
> > >                return parse_reply_info_create(p, end, info,
> > > features, s);
> > > +     else if (op == CEPH_MDS_OP_GETVXATTR)
> > > +             return parse_reply_info_getvxattr(p, end, info,
> > > features);
> > >        else
> > >                return -EIO;
> > >   }
> > > @@ -615,7 +640,7 @@ static int parse_reply_info(struct
> > > ceph_mds_session *s, struct ceph_msg *msg,
> > >   
> > >        if (p != end)
> > >                goto bad;
> > > -     return 0;
> > > +     return err;
> > >   
> > >   bad:
> > >        err = -EIO;
> > > diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> > > index 97c7f7bfa55f..f2a8e5af3c2e 100644
> > > --- a/fs/ceph/mds_client.h
> > > +++ b/fs/ceph/mds_client.h
> > > @@ -29,8 +29,10 @@ enum ceph_feature_type {
> > >        CEPHFS_FEATURE_MULTI_RECONNECT,
> > >        CEPHFS_FEATURE_DELEG_INO,
> > >        CEPHFS_FEATURE_METRIC_COLLECT,
> > > +     CEPHFS_FEATURE_ALTERNATE_NAME,
> > > +     CEPHFS_FEATURE_GETVXATTR,
> > >   
> > > -     CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_METRIC_COLLECT,
> > > +     CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_GETVXATTR,
> > >   };
> > >   
> > >   /*
> > > @@ -45,6 +47,8 @@ enum ceph_feature_type {
> > >        CEPHFS_FEATURE_MULTI_RECONNECT,         \
> > >        CEPHFS_FEATURE_DELEG_INO,               \
> > >        CEPHFS_FEATURE_METRIC_COLLECT,          \
> > > +     CEPHFS_FEATURE_ALTERNATE_NAME,          \
> > > +     CEPHFS_FEATURE_GETVXATTR,               \
> > >                                                \
> > >        CEPHFS_FEATURE_MAX,                     \
> > >   }
> > > @@ -100,6 +104,11 @@ struct ceph_mds_reply_dir_entry {
> > >        loff_t                        offset;
> > >   };
> > >   
> > > +struct ceph_mds_reply_xattr {
> > > +     char *xattr_value;
> > > +     size_t xattr_value_len;
> > > +};
> > > +
> > >   /*
> > >    * parsed info about an mds reply, including information about
> > >    * either: 1) the target inode and/or its parent directory and
> > > dentry,
> > > @@ -115,6 +124,7 @@ struct ceph_mds_reply_info_parsed {
> > >        char                          *dname;
> > >        u32                           dname_len;
> > >        struct ceph_mds_reply_lease   *dlease;
> > > +     struct ceph_mds_reply_xattr   xattr_info;
> > >   
> > >        /* extra */
> > >        union {
> > > diff --git a/fs/ceph/strings.c b/fs/ceph/strings.c
> > > index 573bb9556fb5..e36e8948e728 100644
> > > --- a/fs/ceph/strings.c
> > > +++ b/fs/ceph/strings.c
> > > @@ -60,6 +60,7 @@ const char *ceph_mds_op_name(int op)
> > >        case CEPH_MDS_OP_LOOKUPINO:  return "lookupino";
> > >        case CEPH_MDS_OP_LOOKUPNAME:  return "lookupname";
> > >        case CEPH_MDS_OP_GETATTR:  return "getattr";
> > > +     case CEPH_MDS_OP_GETVXATTR:  return "getvxattr";
> > >        case CEPH_MDS_OP_SETXATTR: return "setxattr";
> > >        case CEPH_MDS_OP_SETATTR: return "setattr";
> > >        case CEPH_MDS_OP_RMXATTR: return "rmxattr";
> > > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > > index ac331aa07cfa..a627fa69668e 100644
> > > --- a/fs/ceph/super.h
> > > +++ b/fs/ceph/super.h
> > > @@ -1043,6 +1043,7 @@ static inline bool
> > > ceph_inode_is_shutdown(struct inode *inode)
> > >   
> > >   /* xattr.c */
> > >   int __ceph_setxattr(struct inode *, const char *, const void *,
> > > size_t, int);
> > > +int ceph_do_getvxattr(struct inode *inode, const char *name, void
> > > *value, size_t size);
> > >   ssize_t __ceph_getxattr(struct inode *, const char *, void *,
> > > size_t);
> > >   extern ssize_t ceph_listxattr(struct dentry *, char *, size_t);
> > >   extern struct ceph_buffer *__ceph_build_xattrs_blob(struct
> > > ceph_inode_info *ci);
> > > diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> > > index fcf7dfdecf96..fdde8ffa71bb 100644
> > > --- a/fs/ceph/xattr.c
> > > +++ b/fs/ceph/xattr.c
> > > @@ -918,6 +918,64 @@ static inline int __get_request_mask(struct
> > > inode *in) {
> > >        return mask;
> > >   }
> > >   
> > > +static inline bool ceph_is_passthrough_vxattr(const char *name)
> > > +{
> > > +     const char *vxattr_list[] = {
> > > +             "ceph.dir.pin",
> > > +             "ceph.dir.pin.random",
> > > +             "ceph.dir.pin.distributed",
> > > +             "ceph.dir.layout",
> > > +             "ceph.dir.layout.object_size",
> > > +             "ceph.dir.layout.stripe_count",
> > > +             "ceph.dir.layout.stripe_unit",
> > > +             "ceph.dir.layout.pool",
> > > +             "ceph.dir.layout.pool_name",
> > > +             "ceph.dir.layout.pool_id",
> > > +             "ceph.dir.layout.pool_namespace",
> > > +             "ceph.file.layout",
> > > +             "ceph.file.layout.object_size",
> > > +             "ceph.file.layout.stripe_count",
> > > +             "ceph.file.layout.stripe_unit",
> > > +             "ceph.file.layout.pool",
> > > +             "ceph.file.layout.pool_name",
> > > +             "ceph.file.layout.pool_id",
> > > +             "ceph.file.layout.pool_namespace",
> > > +     };
> > > +     int i = 0;
> > > +     int n = sizeof(vxattr_list)/sizeof(vxattr_list[0]);
> > > +
> > > +     while (i < n) {
> > > +             if (!strcmp(name, vxattr_list[i]))
> > > +                     return true;
> > > +             i++;
> > > +     }
> > > +     return false;
> > > +}
> > 
> > This part, I'm not so crazy about. This list will be hard to keep in
> > sync with the userland code and you're almost guaranteed to have a
> > mismatch between what the kernel and userland supports since they're
> > on
> > different release schedules.
> > 
> > I think what we probably ought to do is run the ceph_match_vxattr
> > call
> > first, and if it doesn't match the name and the name starts with
> > "ceph.", then we'll send a GETVXATTR call to the MDS.
> > 
> > Sound ok?
> > 
> 
> 
> I was trying to preempt a getvxattr call if the full xattr name was
> invalid.

Huh, why? That seems like the point of the whole bug. We need a way to
hand vxattrs that the client doesn't recognize off to the MDS so it can
satisfy the request.

> I could just test for the prefixes: ceph.dir.pin, ceph.dir.layout and
> ceph.file.layout and send them over. Eventually, we'll get an ENODATA
> if xattr name validation fails on the MDS side.
> 
> The problem with doing a ceph_match_vxattr() first is that it will
> succeed
> for any of these vxattrs, but we'll land in the same place as the one
> you've
> described in the tracker.
> The very idea of implementing getvxattr is to bypass the existing
> "cached"
> service mechanism for special vxattrs.
> 

I don't get it. What's the benefit of calling out to the MDS to ask for
ceph.file.layout.pool instead of just satisfying it from the info we
have?

I'd prefer we just add a fallback for "ceph.*" vxattrs that for which we
don't have a local handler.


> > 
> > > +
> > > +/* check if the entire cluster supports the given feature */
> > > +static inline bool ceph_cluster_has_feature(struct inode *inode,
> > > int feature_bit)
> > > +{
> > > +     int64_t i;
> > > +     struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
> > > +     struct ceph_mds_session **sessions = fsc->mdsc->sessions;
> > > +     int64_t num_sessions = atomic_read(&fsc->mdsc-
> > > >num_sessions);
> > > +
> > > +     if (fsc->mdsc->stopping)
> > > +             return false;
> > > +
> > > +     if (!sessions)
> > > +             return false;
> > > +
> > > +     for (i = 0; i < num_sessions; i++) {
> > > +             struct ceph_mds_session *session = sessions[i];
> > > +             if (!session)
> > > +                     return false;
> > > +             if (!test_bit(feature_bit, &session->s_features))
> > > +                     return false;
> > > +     }
> > > +     return true;
> > > +}
> > > +
> > >   ssize_t __ceph_getxattr(struct inode *inode, const char *name,
> > > void *value,
> > >                      size_t size)
> > >   {
> > > @@ -927,6 +985,13 @@ ssize_t __ceph_getxattr(struct inode *inode,
> > > const char *name, void *value,
> > >        int req_mask;
> > >        ssize_t err;
> > >   
> > > +     if (ceph_is_passthrough_vxattr(name) &&
> > > +         ceph_cluster_has_feature(inode,
> > > CEPHFS_FEATURE_GETVXATTR)) {
> > > +             err = ceph_do_getvxattr(inode, name, value, size);
> > > +             return err;
> > > +     }
> > > +     dout("vxattr is not passthrough or kclient doesn't support
> > > GETVXATTR\n");
> > > +
> > >        /* let's see if a virtual xattr was requested */
> > >        vxattr = ceph_match_vxattr(inode, name);
> > >        if (vxattr) {
> > > diff --git a/include/linux/ceph/ceph_fs.h
> > > b/include/linux/ceph/ceph_fs.h
> > > index 7ad6c3d0db7d..66db21ac5f0c 100644
> > > --- a/include/linux/ceph/ceph_fs.h
> > > +++ b/include/linux/ceph/ceph_fs.h
> > > @@ -328,6 +328,7 @@ enum {
> > >        CEPH_MDS_OP_LOOKUPPARENT = 0x00103,
> > >        CEPH_MDS_OP_LOOKUPINO  = 0x00104,
> > >        CEPH_MDS_OP_LOOKUPNAME = 0x00105,
> > > +     CEPH_MDS_OP_GETVXATTR  = 0x00106,
> > >   
> > >        CEPH_MDS_OP_SETXATTR   = 0x01105,
> > >        CEPH_MDS_OP_RMXATTR    = 0x01106,
> > 

-- 
Jeff Layton <jlayton@kernel.org>
