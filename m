Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0B3B491023
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Jan 2022 19:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238202AbiAQSPr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Jan 2022 13:15:47 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59146 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbiAQSPq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 17 Jan 2022 13:15:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42B06B81151
        for <ceph-devel@vger.kernel.org>; Mon, 17 Jan 2022 18:15:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 512DEC36AE7;
        Mon, 17 Jan 2022 18:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642443344;
        bh=GODX28F95ngG8eHF2XUencSDyltoh+6rp44UjK7rpcY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZoPKkK/cCk4uNS9Ar2+BCryDlGh0QwsZwgbwBcBEhNpkhNIQaEpyMpkzEDGeA0mqc
         x7KFNwhqv05NenKrwHEYC+J1v32RlmG5wPytWDm/6DoHI2ELeeKV1zRPlTUH/vcvbq
         ulrYw8BFsIL9l5TG37hN1yf1G6TnYubwaYtlWCOO2rpRJX0YJZDFgzHxxTBT6024LD
         SHEHmaVHTO/FK+LOHVNq5ejmMRchRghsya4VSiKByR9db+LyL5ey4TfpRd9SWzaEYl
         t1E4hgm66hTeWysSA9YGP4pqYuiJb02Ksx5OkFMGIuqyq0TT+ooVr8VIG2bvO3XLif
         xyxIYpER24zEw==
Message-ID: <c6f32054c69eb00717d63f63c351dad58ae5e91b.camel@kernel.org>
Subject: Re: [PATCH v4 1/1] ceph: add getvxattr op
From:   Jeff Layton <jlayton@kernel.org>
To:     Patrick Donnelly <pdonnell@redhat.com>,
        Gregory Farnum <gfarnum@redhat.com>
Cc:     Venky Shankar <vshankar@redhat.com>, Xiubo Li <xiubli@redhat.com>,
        Milind Changire <milindchangire@gmail.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Milind Changire <mchangir@redhat.com>
Date:   Mon, 17 Jan 2022 13:15:41 -0500
In-Reply-To: <CA+2bHPZ22CdDJap9JHsdBNTFXET_vumdRdAFd2Cd4r11mr2Ljg@mail.gmail.com>
References: <20220117085142.23638-1-mchangir@redhat.com>
         <20220117085142.23638-2-mchangir@redhat.com>
         <e1a40f8003fb861facbbf0c915b6631141c282ad.camel@kernel.org>
         <CANmksPT=vM653QZthXb7tgwekNBAeaLV67pZ0TiOmgusj8bhmQ@mail.gmail.com>
         <76e405bf-b7b4-62c2-eac8-1c3f7cbaf860@redhat.com>
         <CANmksPR5c5GHYnfx7QRf1501Q5KttUv_kzpdqK1FfZzOmaX_MQ@mail.gmail.com>
         <742b88f2-063d-d30a-9b5c-ab0e39a8a079@redhat.com>
         <7f7398c8b9842eee079a4fcc67f39224fe4eb92d.camel@kernel.org>
         <CAJ4mKGbixsBKGRJh=9r0KN54FkWPhB27XBSBWzrMc-gdZNwpjw@mail.gmail.com>
         <CA+2bHPZ22CdDJap9JHsdBNTFXET_vumdRdAFd2Cd4r11mr2Ljg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2022-01-17 at 13:09 -0500, Patrick Donnelly wrote:
> On Mon, Jan 17, 2022 at 9:50 AM Gregory Farnum <gfarnum@redhat.com> wrote:
> > 
> > On Mon, Jan 17, 2022 at 5:28 AM Jeff Layton <jlayton@kernel.org> wrote:
> > > 
> > > On Mon, 2022-01-17 at 21:09 +0800, Xiubo Li wrote:
> > > > On 1/17/22 8:58 PM, Milind Changire wrote:
> > > > > On Mon, Jan 17, 2022 at 6:20 PM Xiubo Li <xiubli@redhat.com> wrote:
> > > > > > 
> > > > > > On 1/17/22 7:07 PM, Milind Changire wrote:
> > > > > > > On Mon, Jan 17, 2022 at 4:23 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > > > > > > On Mon, 2022-01-17 at 08:51 +0000, Milind Changire wrote:
> > > > > > > > > Problem:
> > > > > > > > > Directory vxattrs like ceph.dir.pin* and ceph.dir.layout* may not be
> > > > > > > > > propagated to the client as frequently to keep them updated. This
> > > > > > > > > creates vxattr availability problems.
> > > > > > > > > 
> > > > > > > > > Solution:
> > > > > > > > > Adds new getvxattr op to fetch ceph.dir.pin*, ceph.dir.layout* and
> > > > > > > > > ceph.file.layout* vxattrs.
> > > > > > > > > If the entire layout for a dir or a file is being set, then it is
> > > > > > > > > expected that the layout be set in standard JSON format. Individual
> > > > > > > > > field value retrieval is not wrapped in JSON. The JSON format also
> > > > > > > > > applies while setting the vxattr if the entire layout is being set in
> > > > > > > > > one go.
> > > > > > > > > As a temporary measure, setting a vxattr can also be done in the old
> > > > > > > > > format. The old format will be deprecated in the future.
> > > > > > > > > 
> > > > > > > > > URL: https://tracker.ceph.com/issues/51062
> > > > > > > > > Signed-off-by: Milind Changire <mchangir@redhat.com>
> > > > > > > > > ---
> > > > > > > > >    fs/ceph/inode.c              | 51 ++++++++++++++++++++++++++++++++++++
> > > > > > > > >    fs/ceph/mds_client.c         | 27 ++++++++++++++++++-
> > > > > > > > >    fs/ceph/mds_client.h         | 12 ++++++++-
> > > > > > > > >    fs/ceph/strings.c            |  1 +
> > > > > > > > >    fs/ceph/super.h              |  1 +
> > > > > > > > >    fs/ceph/xattr.c              | 34 ++++++++++++++++++++++++
> > > > > > > > >    include/linux/ceph/ceph_fs.h |  1 +
> > > > > > > > >    7 files changed, 125 insertions(+), 2 deletions(-)
> > > > > > > > > 
> > > > > > > > > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> > > > > > > > > index e3322fcb2e8d..efdce049b7f0 100644
> > > > > > > > > --- a/fs/ceph/inode.c
> > > > > > > > > +++ b/fs/ceph/inode.c
> > > > > > > > > @@ -2291,6 +2291,57 @@ int __ceph_do_getattr(struct inode *inode, struct page *locked_page,
> > > > > > > > >         return err;
> > > > > > > > >    }
> > > > > > > > > 
> > > > > > > > > +int ceph_do_getvxattr(struct inode *inode, const char *name, void *value,
> > > > > > > > > +                   size_t size)
> > > > > > > > > +{
> > > > > > > > > +     struct ceph_fs_client *fsc = ceph_sb_to_client(inode->i_sb);
> > > > > > > > > +     struct ceph_mds_client *mdsc = fsc->mdsc;
> > > > > > > > > +     struct ceph_mds_request *req;
> > > > > > > > > +     int mode = USE_AUTH_MDS;
> > > > > > > > > +     int err;
> > > > > > > > > +     char *xattr_value;
> > > > > > > > > +     size_t xattr_value_len;
> > > > > > > > > +
> > > > > > > > > +     req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETVXATTR, mode);
> > > > > > > > > +     if (IS_ERR(req)) {
> > > > > > > > > +             err = -ENOMEM;
> > > > > > > > > +             goto out;
> > > > > > > > > +     }
> > > > > > > > > +
> > > > > > > > > +     req->r_path2 = kstrdup(name, GFP_NOFS);
> > > > > > > > > +     if (!req->r_path2) {
> > > > > > > > > +             err = -ENOMEM;
> > > > > > > > > +             goto put;
> > > > > > > > > +     }
> > > > > > > > > +
> > > > > > > > > +     ihold(inode);
> > > > > > > > > +     req->r_inode = inode;
> > > > > > > > > +     err = ceph_mdsc_do_request(mdsc, NULL, req);
> > > > > > > > > +     if (err < 0)
> > > > > > > > > +             goto put;
> > > > > > > > > +
> > > > > > > > > +     xattr_value = req->r_reply_info.xattr_info.xattr_value;
> > > > > > > > > +     xattr_value_len = req->r_reply_info.xattr_info.xattr_value_len;
> > > > > > > > > +
> > > > > > > > > +     dout("do_getvxattr xattr_value_len:%zu, size:%zu\n", xattr_value_len, size);
> > > > > > > > > +
> > > > > > > > > +     err = (int)xattr_value_len;
> > > > > > > > > +     if (size == 0)
> > > > > > > > > +             goto put;
> > > > > > > > > +
> > > > > > > > > +     if (xattr_value_len > size) {
> > > > > > > > > +             err = -ERANGE;
> > > > > > > > > +             goto put;
> > > > > > > > > +     }
> > > > > > > > > +
> > > > > > > > > +     memcpy(value, xattr_value, xattr_value_len);
> > > > > > > > > +put:
> > > > > > > > > +     ceph_mdsc_put_request(req);
> > > > > > > > > +out:
> > > > > > > > > +     dout("do_getvxattr result=%d\n", err);
> > > > > > > > > +     return err;
> > > > > > > > > +}
> > > > > > > > > +
> > > > > > > > > 
> > > > > > > > >    /*
> > > > > > > > >     * Check inode permissions.  We verify we have a valid value for
> > > > > > > > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > > > > > > > index c30eefc0ac19..a5eafc71d976 100644
> > > > > > > > > --- a/fs/ceph/mds_client.c
> > > > > > > > > +++ b/fs/ceph/mds_client.c
> > > > > > > > > @@ -555,6 +555,29 @@ static int parse_reply_info_create(void **p, void *end,
> > > > > > > > >         return -EIO;
> > > > > > > > >    }
> > > > > > > > > 
> > > > > > > > > +static int parse_reply_info_getvxattr(void **p, void *end,
> > > > > > > > > +                                   struct ceph_mds_reply_info_parsed *info,
> > > > > > > > > +                                   u64 features)
> > > > > > > > > +{
> > > > > > > > > +     u8 struct_v, struct_compat;
> > > > > > > > > +     u32 struct_len;
> > > > > > > > > +     u32 value_len;
> > > > > > > > > +
> > > > > > > > > +     ceph_decode_8_safe(p, end, struct_v, bad);
> > > > > > > > > +     ceph_decode_8_safe(p, end, struct_compat, bad);
> > > > > > > > > +     ceph_decode_32_safe(p, end, struct_len, bad);
> > > > > > > > > +     ceph_decode_32_safe(p, end, value_len, bad);
> > > > > > > > > +
> > > > > > > > > +     if (value_len == end - *p) {
> > > > > > > > > +       info->xattr_info.xattr_value = *p;
> > > > > > > > > +       info->xattr_info.xattr_value_len = end - *p;
> > > > > > > > > +       *p = end;
> > > > > > > > > +       return info->xattr_info.xattr_value_len;
> > > > > > > > > +     }
> > > > > > > > > +bad:
> > > > > > > > > +     return -EIO;
> > > > > > > > > +}
> > > > > > > > > +
> > > > > > > > >    /*
> > > > > > > > >     * parse extra results
> > > > > > > > >     */
> > > > > > > > > @@ -570,6 +593,8 @@ static int parse_reply_info_extra(void **p, void *end,
> > > > > > > > >                 return parse_reply_info_readdir(p, end, info, features);
> > > > > > > > >         else if (op == CEPH_MDS_OP_CREATE)
> > > > > > > > >                 return parse_reply_info_create(p, end, info, features, s);
> > > > > > > > > +     else if (op == CEPH_MDS_OP_GETVXATTR)
> > > > > > > > > +             return parse_reply_info_getvxattr(p, end, info, features);
> > > > > > > > >         else
> > > > > > > > >                 return -EIO;
> > > > > > > > >    }
> > > > > > > > > @@ -615,7 +640,7 @@ static int parse_reply_info(struct ceph_mds_session *s, struct ceph_msg *msg,
> > > > > > > > > 
> > > > > > > > >         if (p != end)
> > > > > > > > >                 goto bad;
> > > > > > > > > -     return 0;
> > > > > > > > > +     return err;
> > > > > > > > > 
> > > > > > > > >    bad:
> > > > > > > > >         err = -EIO;
> > > > > > > > > diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> > > > > > > > > index 97c7f7bfa55f..f2a8e5af3c2e 100644
> > > > > > > > > --- a/fs/ceph/mds_client.h
> > > > > > > > > +++ b/fs/ceph/mds_client.h
> > > > > > > > > @@ -29,8 +29,10 @@ enum ceph_feature_type {
> > > > > > > > >         CEPHFS_FEATURE_MULTI_RECONNECT,
> > > > > > > > >         CEPHFS_FEATURE_DELEG_INO,
> > > > > > > > >         CEPHFS_FEATURE_METRIC_COLLECT,
> > > > > > > > > +     CEPHFS_FEATURE_ALTERNATE_NAME,
> > > > > > > > > +     CEPHFS_FEATURE_GETVXATTR,
> > > > > > > > > 
> > > > > > > > > -     CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_METRIC_COLLECT,
> > > > > > > > > +     CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_GETVXATTR,
> > > > > > > > >    };
> > > > > > > > > 
> > > > > > > > >    /*
> > > > > > > > > @@ -45,6 +47,8 @@ enum ceph_feature_type {
> > > > > > > > >         CEPHFS_FEATURE_MULTI_RECONNECT,         \
> > > > > > > > >         CEPHFS_FEATURE_DELEG_INO,               \
> > > > > > > > >         CEPHFS_FEATURE_METRIC_COLLECT,          \
> > > > > > > > > +     CEPHFS_FEATURE_ALTERNATE_NAME,          \
> > > > > > > > > +     CEPHFS_FEATURE_GETVXATTR,               \
> > > > > > > > >                                                 \
> > > > > > > > >         CEPHFS_FEATURE_MAX,                     \
> > > > > > > > >    }
> > > > > > > > > @@ -100,6 +104,11 @@ struct ceph_mds_reply_dir_entry {
> > > > > > > > >         loff_t                        offset;
> > > > > > > > >    };
> > > > > > > > > 
> > > > > > > > > +struct ceph_mds_reply_xattr {
> > > > > > > > > +     char *xattr_value;
> > > > > > > > > +     size_t xattr_value_len;
> > > > > > > > > +};
> > > > > > > > > +
> > > > > > > > >    /*
> > > > > > > > >     * parsed info about an mds reply, including information about
> > > > > > > > >     * either: 1) the target inode and/or its parent directory and dentry,
> > > > > > > > > @@ -115,6 +124,7 @@ struct ceph_mds_reply_info_parsed {
> > > > > > > > >         char                          *dname;
> > > > > > > > >         u32                           dname_len;
> > > > > > > > >         struct ceph_mds_reply_lease   *dlease;
> > > > > > > > > +     struct ceph_mds_reply_xattr   xattr_info;
> > > > > > > > > 
> > > > > > > > >         /* extra */
> > > > > > > > >         union {
> > > > > > > > > diff --git a/fs/ceph/strings.c b/fs/ceph/strings.c
> > > > > > > > > index 573bb9556fb5..e36e8948e728 100644
> > > > > > > > > --- a/fs/ceph/strings.c
> > > > > > > > > +++ b/fs/ceph/strings.c
> > > > > > > > > @@ -60,6 +60,7 @@ const char *ceph_mds_op_name(int op)
> > > > > > > > >         case CEPH_MDS_OP_LOOKUPINO:  return "lookupino";
> > > > > > > > >         case CEPH_MDS_OP_LOOKUPNAME:  return "lookupname";
> > > > > > > > >         case CEPH_MDS_OP_GETATTR:  return "getattr";
> > > > > > > > > +     case CEPH_MDS_OP_GETVXATTR:  return "getvxattr";
> > > > > > > > >         case CEPH_MDS_OP_SETXATTR: return "setxattr";
> > > > > > > > >         case CEPH_MDS_OP_SETATTR: return "setattr";
> > > > > > > > >         case CEPH_MDS_OP_RMXATTR: return "rmxattr";
> > > > > > > > > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > > > > > > > > index ac331aa07cfa..a627fa69668e 100644
> > > > > > > > > --- a/fs/ceph/super.h
> > > > > > > > > +++ b/fs/ceph/super.h
> > > > > > > > > @@ -1043,6 +1043,7 @@ static inline bool ceph_inode_is_shutdown(struct inode *inode)
> > > > > > > > > 
> > > > > > > > >    /* xattr.c */
> > > > > > > > >    int __ceph_setxattr(struct inode *, const char *, const void *, size_t, int);
> > > > > > > > > +int ceph_do_getvxattr(struct inode *inode, const char *name, void *value, size_t size);
> > > > > > > > >    ssize_t __ceph_getxattr(struct inode *, const char *, void *, size_t);
> > > > > > > > >    extern ssize_t ceph_listxattr(struct dentry *, char *, size_t);
> > > > > > > > >    extern struct ceph_buffer *__ceph_build_xattrs_blob(struct ceph_inode_info *ci);
> > > > > > > > > diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> > > > > > > > > index fcf7dfdecf96..dc32876a541a 100644
> > > > > > > > > --- a/fs/ceph/xattr.c
> > > > > > > > > +++ b/fs/ceph/xattr.c
> > > > > > > > > @@ -918,6 +918,30 @@ static inline int __get_request_mask(struct inode *in) {
> > > > > > > > >         return mask;
> > > > > > > > >    }
> > > > > > > > > 
> > > > > > > > > +/* check if the entire cluster supports the given feature */
> > > > > > > > > +static inline bool ceph_cluster_has_feature(struct inode *inode, int feature_bit)
> > > > > > > > > +{
> > > > > > > > > +     int64_t i;
> > > > > > > > > +     struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
> > > > > > > > > +     struct ceph_mds_session **sessions = fsc->mdsc->sessions;
> > > > > > > > > +     int64_t num_sessions = atomic_read(&fsc->mdsc->num_sessions);
> > > > > > > > > +
> > > > > > > > > +     if (fsc->mdsc->stopping)
> > > > > > > > > +             return false;
> > > > > > > > > +
> > > > > > > > > +     if (!sessions)
> > > > > > > > > +             return false;
> > > > > > > > > +
> > > > > > > > > +     for (i = 0; i < num_sessions; i++) {
> > > > > > > > > +             struct ceph_mds_session *session = sessions[i];
> > > > > > > > > +             if (!session)
> > > > > > > > > +                     return false;
> > > > > > > > > +             if (!test_bit(feature_bit, &session->s_features))
> > > > > > > > > +                     return false;
> > > > > > > > What guarantee do you have that "session" will still be a valid pointer
> > > > > > > > by the time you get to dereferencing it here?
> > > > > > > > 
> > > > > > > > I think this loop needs some locking (as Xiubo pointed out in his
> > > > > > > > earlier review).
> > > > > > > yeah, thanks for pointing that out
> > > > > > > I'm trying to wrap the entire processing of this function inside a
> > > > > > > mutex_unlock(&mdsc->mutex) ... but the mount command fails
> > > > > > > to mount if done so. If code is not wrapped in mutex lock...unlock
> > > > > > > then the mount is successful.
> > > > > > > It's a surprise that the code doesn't deadlock under the mutex
> > > > > > > lock...unlock and gracefully fails with a message.
> > > > > > > Any hints on what I could be missing.
> > > > > > > 
> > > > > > > > > +     }
> > > > > > > > > +     return true;
> > > > > > > > > +}
> > > > > > > > > +
> > > > > > > > >    ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
> > > > > > > > >                       size_t size)
> > > > > > > > >    {
> > > > > > > > > @@ -927,6 +951,16 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
> > > > > > > > >         int req_mask;
> > > > > > > > >         ssize_t err;
> > > > > > > > > 
> > > > > > > > > +     if (!strncmp(name, XATTR_CEPH_PREFIX, XATTR_CEPH_PREFIX_LEN) &&
> > > > > > > > > +         ceph_cluster_has_feature(inode, CEPHFS_FEATURE_GETVXATTR)) {
> > > > > > > > > +             err = ceph_do_getvxattr(inode, name, value, size);
> > > > > > > > > +             /* if cluster doesn't support xattr, we try to service it
> > > > > > > > > +              * locally
> > > > > > > > > +              */
> > > > > > > > > +             if (err >= 0)
> > > > > > > > > +                     return err;
> > > > > > > > > +     }
> > > > > > > > > +
> > > > > > > > What is this? Why not always service this locally?
> > > > > > > vxattr handling is planned to be moved to the MDS side.
> > > > > > > As I've pointed out to Xiubo, there's a few new things that have been done for
> > > > > > > layout vxattr management. Also, as per your original tracker, ceph.dir.pin*
> > > > > > > can't be handled locally.
> > > > > > > getvxattr() currently handles:
> > > > > > > 1. ceph.dir.layout*
> > > > > > > 2. ceph.file.layout*
> > > > > > > 3. ceph.dir.pin*
> > > > > > The above seems will include the 'ceph.dir.layout', 'ceph.file.layout'
> > > > > > and 'ceph.dir.pin' ? All these have been handled in 'ceph_file_vxattrs'
> > > > > > and 'ceph_dir_vxattrs'...
> > > > > > 
> > > > > > And the code above will always force kclient to get all the 'ceph.XXX'
> > > > > > xattrs from MDS ?
> > > > > yes, the kclient will always get vxattr values from MDS
> > > > > for old cluster, op will be handled locally
> > > > > 
> > > > > Jeff has a proposal to expose the JSON output variety of layout
> > > > > vxattr vlaue via new vxattr altogether
> > > > > eg. ceph.dir.layout_json and ceph.file.layout_json
> > > > > 
> > > > Yeah, sounds good. Or maybe just adding the '.json' instead of '_json'.
> > > > 
> > > 
> > > +1 -- that looks cleaner than mixing up delimiters
> > > 
> > > To be clear, I think this should wholly be a fallback mechanism for when
> > > the client doesn't recognize a vxattr name. IOW, we should only call the
> > > MDS after ceph_match_vxattr doesn't match an xattr name.
> > 
> > I'm with you, but this set of changes (and its Client.cc equivalent)
> > is by request from Patrick and Venky (added), so there may be some
> > subtleties we're missing. And we should follow the same pattern for
> > who gets to resolve vxattrs in both clients.
> > -Greg
> 
> I had incorrectly recalled that the client did return json for the
> layout xattrs. So, yes, we can't just switch to json for these
> existing vxattrs. I agree adding a "json" extension cleanly avoids the
> issue. We can continue handling the existing layout vxattrs without
> the suffix in the client (for now).
> 
> Although, I do think ".json" is a little weird. I had privately
> expressed to Jeff/Milind that "!json" or similar as a suffix could be
> more appropriate. It emphasizes it's not a derivative xattr.
> 

The mixed delimiters are also weird, and I don't think it's really
outside the scope of the existing ceph.file.layout.* xattrs.

Also, I have to wonder -- why json? Isn't yaml more en vogue these days?
-- 
Jeff Layton <jlayton@kernel.org>
