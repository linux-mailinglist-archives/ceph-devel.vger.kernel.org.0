Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43554490915
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Jan 2022 13:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234255AbiAQM6X (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Jan 2022 07:58:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231817AbiAQM6W (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 17 Jan 2022 07:58:22 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1012CC061574
        for <ceph-devel@vger.kernel.org>; Mon, 17 Jan 2022 04:58:22 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id 30so65272787edv.3
        for <ceph-devel@vger.kernel.org>; Mon, 17 Jan 2022 04:58:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yChQh9X4nAi4CWK8vrcOoyT5EFJmiDtPdwHl3sIW7Cg=;
        b=L0n083fx25TkS1Xalp72xUZ3WLdxKdWUhzEuO/YVjD3yKN/Nx7wADqTW59PtsxXcDO
         ljgHsvZ7JRaIcy/2mEaJeyBPcJE/GBredzrxwgiM68fgDuiLwOhrw3G5TYMIMq36TUsu
         82pby6oBzpcv0B1cktaD3K+V81v1WeTu/FhrBmUq6Nu/QYzcSHmXYjI2Lh4zFGKH9IyF
         e+x/+CJmtYg6/jWhjzQSe1l45F7Xj0RaLWldnt6TqkTBxirhrp7k81FlioVReX56iNJ8
         p6RXzS6rhjdBNcSTHAFI4kkFf2Rgb01I2t7wlcOT3IcV1j9WRTy4r/AbcocAuvym2KkR
         Buog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yChQh9X4nAi4CWK8vrcOoyT5EFJmiDtPdwHl3sIW7Cg=;
        b=5/2QYfOXotJnbnO+EP1m1WtGGVcTArPV5KpdBezY1VPJQdFEVS10ptjV+IwhNamQln
         VUKqDMScB84SwatSVjjemgZEkIBAs4Zuy3gRJYcczyZMOQmP5HDaAY4yXewl5J7wa52q
         c2OJgFIHogoTuPMuqyT9KKNlCKCq0EnxTw0vYB46M4Z5hbwApRHVyGy8Hebib6GiZ5/n
         NX2/seN/eX8jxu1+izHLr0foTGWniwa74TNruu+3Lqt0ZGGafj4U+BH0zQr/y7qYp6yx
         w3ruHdgW5snttMOIW14g92B8ESgYmCqam7eD58GCpc1mp7zN4PiwQ6BnOKE/5Fi9MV8Z
         K8yQ==
X-Gm-Message-State: AOAM531p2bSOEsUCA4xY7mlCkdAmvDFbWMfngvh41b6PDHJIEYKNPEHY
        nKVLsmZJ65oyneJD+rfIaDag0yukKj6Ws1PQqNI=
X-Google-Smtp-Source: ABdhPJwJh4zevx0pMrj1JGwoafPIIQZtGM4Dm6EKPdTNqBmLrbcUPpRYdLieGqlIEDAOLwH8i4ODiHMH63S5xZlLzdY=
X-Received: by 2002:a17:906:3e8a:: with SMTP id a10mr16357046ejj.612.1642424300460;
 Mon, 17 Jan 2022 04:58:20 -0800 (PST)
MIME-Version: 1.0
References: <20220117085142.23638-1-mchangir@redhat.com> <20220117085142.23638-2-mchangir@redhat.com>
 <e1a40f8003fb861facbbf0c915b6631141c282ad.camel@kernel.org>
 <CANmksPT=vM653QZthXb7tgwekNBAeaLV67pZ0TiOmgusj8bhmQ@mail.gmail.com> <76e405bf-b7b4-62c2-eac8-1c3f7cbaf860@redhat.com>
In-Reply-To: <76e405bf-b7b4-62c2-eac8-1c3f7cbaf860@redhat.com>
From:   Milind Changire <milindchangire@gmail.com>
Date:   Mon, 17 Jan 2022 18:28:08 +0530
Message-ID: <CANmksPR5c5GHYnfx7QRf1501Q5KttUv_kzpdqK1FfZzOmaX_MQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/1] ceph: add getvxattr op
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Milind Changire <mchangir@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jan 17, 2022 at 6:20 PM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 1/17/22 7:07 PM, Milind Changire wrote:
> > On Mon, Jan 17, 2022 at 4:23 PM Jeff Layton <jlayton@kernel.org> wrote:
> >> On Mon, 2022-01-17 at 08:51 +0000, Milind Changire wrote:
> >>> Problem:
> >>> Directory vxattrs like ceph.dir.pin* and ceph.dir.layout* may not be
> >>> propagated to the client as frequently to keep them updated. This
> >>> creates vxattr availability problems.
> >>>
> >>> Solution:
> >>> Adds new getvxattr op to fetch ceph.dir.pin*, ceph.dir.layout* and
> >>> ceph.file.layout* vxattrs.
> >>> If the entire layout for a dir or a file is being set, then it is
> >>> expected that the layout be set in standard JSON format. Individual
> >>> field value retrieval is not wrapped in JSON. The JSON format also
> >>> applies while setting the vxattr if the entire layout is being set in
> >>> one go.
> >>> As a temporary measure, setting a vxattr can also be done in the old
> >>> format. The old format will be deprecated in the future.
> >>>
> >>> URL: https://tracker.ceph.com/issues/51062
> >>> Signed-off-by: Milind Changire <mchangir@redhat.com>
> >>> ---
> >>>   fs/ceph/inode.c              | 51 ++++++++++++++++++++++++++++++++++++
> >>>   fs/ceph/mds_client.c         | 27 ++++++++++++++++++-
> >>>   fs/ceph/mds_client.h         | 12 ++++++++-
> >>>   fs/ceph/strings.c            |  1 +
> >>>   fs/ceph/super.h              |  1 +
> >>>   fs/ceph/xattr.c              | 34 ++++++++++++++++++++++++
> >>>   include/linux/ceph/ceph_fs.h |  1 +
> >>>   7 files changed, 125 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> >>> index e3322fcb2e8d..efdce049b7f0 100644
> >>> --- a/fs/ceph/inode.c
> >>> +++ b/fs/ceph/inode.c
> >>> @@ -2291,6 +2291,57 @@ int __ceph_do_getattr(struct inode *inode, struct page *locked_page,
> >>>        return err;
> >>>   }
> >>>
> >>> +int ceph_do_getvxattr(struct inode *inode, const char *name, void *value,
> >>> +                   size_t size)
> >>> +{
> >>> +     struct ceph_fs_client *fsc = ceph_sb_to_client(inode->i_sb);
> >>> +     struct ceph_mds_client *mdsc = fsc->mdsc;
> >>> +     struct ceph_mds_request *req;
> >>> +     int mode = USE_AUTH_MDS;
> >>> +     int err;
> >>> +     char *xattr_value;
> >>> +     size_t xattr_value_len;
> >>> +
> >>> +     req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETVXATTR, mode);
> >>> +     if (IS_ERR(req)) {
> >>> +             err = -ENOMEM;
> >>> +             goto out;
> >>> +     }
> >>> +
> >>> +     req->r_path2 = kstrdup(name, GFP_NOFS);
> >>> +     if (!req->r_path2) {
> >>> +             err = -ENOMEM;
> >>> +             goto put;
> >>> +     }
> >>> +
> >>> +     ihold(inode);
> >>> +     req->r_inode = inode;
> >>> +     err = ceph_mdsc_do_request(mdsc, NULL, req);
> >>> +     if (err < 0)
> >>> +             goto put;
> >>> +
> >>> +     xattr_value = req->r_reply_info.xattr_info.xattr_value;
> >>> +     xattr_value_len = req->r_reply_info.xattr_info.xattr_value_len;
> >>> +
> >>> +     dout("do_getvxattr xattr_value_len:%zu, size:%zu\n", xattr_value_len, size);
> >>> +
> >>> +     err = (int)xattr_value_len;
> >>> +     if (size == 0)
> >>> +             goto put;
> >>> +
> >>> +     if (xattr_value_len > size) {
> >>> +             err = -ERANGE;
> >>> +             goto put;
> >>> +     }
> >>> +
> >>> +     memcpy(value, xattr_value, xattr_value_len);
> >>> +put:
> >>> +     ceph_mdsc_put_request(req);
> >>> +out:
> >>> +     dout("do_getvxattr result=%d\n", err);
> >>> +     return err;
> >>> +}
> >>> +
> >>>
> >>>   /*
> >>>    * Check inode permissions.  We verify we have a valid value for
> >>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> >>> index c30eefc0ac19..a5eafc71d976 100644
> >>> --- a/fs/ceph/mds_client.c
> >>> +++ b/fs/ceph/mds_client.c
> >>> @@ -555,6 +555,29 @@ static int parse_reply_info_create(void **p, void *end,
> >>>        return -EIO;
> >>>   }
> >>>
> >>> +static int parse_reply_info_getvxattr(void **p, void *end,
> >>> +                                   struct ceph_mds_reply_info_parsed *info,
> >>> +                                   u64 features)
> >>> +{
> >>> +     u8 struct_v, struct_compat;
> >>> +     u32 struct_len;
> >>> +     u32 value_len;
> >>> +
> >>> +     ceph_decode_8_safe(p, end, struct_v, bad);
> >>> +     ceph_decode_8_safe(p, end, struct_compat, bad);
> >>> +     ceph_decode_32_safe(p, end, struct_len, bad);
> >>> +     ceph_decode_32_safe(p, end, value_len, bad);
> >>> +
> >>> +     if (value_len == end - *p) {
> >>> +       info->xattr_info.xattr_value = *p;
> >>> +       info->xattr_info.xattr_value_len = end - *p;
> >>> +       *p = end;
> >>> +       return info->xattr_info.xattr_value_len;
> >>> +     }
> >>> +bad:
> >>> +     return -EIO;
> >>> +}
> >>> +
> >>>   /*
> >>>    * parse extra results
> >>>    */
> >>> @@ -570,6 +593,8 @@ static int parse_reply_info_extra(void **p, void *end,
> >>>                return parse_reply_info_readdir(p, end, info, features);
> >>>        else if (op == CEPH_MDS_OP_CREATE)
> >>>                return parse_reply_info_create(p, end, info, features, s);
> >>> +     else if (op == CEPH_MDS_OP_GETVXATTR)
> >>> +             return parse_reply_info_getvxattr(p, end, info, features);
> >>>        else
> >>>                return -EIO;
> >>>   }
> >>> @@ -615,7 +640,7 @@ static int parse_reply_info(struct ceph_mds_session *s, struct ceph_msg *msg,
> >>>
> >>>        if (p != end)
> >>>                goto bad;
> >>> -     return 0;
> >>> +     return err;
> >>>
> >>>   bad:
> >>>        err = -EIO;
> >>> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> >>> index 97c7f7bfa55f..f2a8e5af3c2e 100644
> >>> --- a/fs/ceph/mds_client.h
> >>> +++ b/fs/ceph/mds_client.h
> >>> @@ -29,8 +29,10 @@ enum ceph_feature_type {
> >>>        CEPHFS_FEATURE_MULTI_RECONNECT,
> >>>        CEPHFS_FEATURE_DELEG_INO,
> >>>        CEPHFS_FEATURE_METRIC_COLLECT,
> >>> +     CEPHFS_FEATURE_ALTERNATE_NAME,
> >>> +     CEPHFS_FEATURE_GETVXATTR,
> >>>
> >>> -     CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_METRIC_COLLECT,
> >>> +     CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_GETVXATTR,
> >>>   };
> >>>
> >>>   /*
> >>> @@ -45,6 +47,8 @@ enum ceph_feature_type {
> >>>        CEPHFS_FEATURE_MULTI_RECONNECT,         \
> >>>        CEPHFS_FEATURE_DELEG_INO,               \
> >>>        CEPHFS_FEATURE_METRIC_COLLECT,          \
> >>> +     CEPHFS_FEATURE_ALTERNATE_NAME,          \
> >>> +     CEPHFS_FEATURE_GETVXATTR,               \
> >>>                                                \
> >>>        CEPHFS_FEATURE_MAX,                     \
> >>>   }
> >>> @@ -100,6 +104,11 @@ struct ceph_mds_reply_dir_entry {
> >>>        loff_t                        offset;
> >>>   };
> >>>
> >>> +struct ceph_mds_reply_xattr {
> >>> +     char *xattr_value;
> >>> +     size_t xattr_value_len;
> >>> +};
> >>> +
> >>>   /*
> >>>    * parsed info about an mds reply, including information about
> >>>    * either: 1) the target inode and/or its parent directory and dentry,
> >>> @@ -115,6 +124,7 @@ struct ceph_mds_reply_info_parsed {
> >>>        char                          *dname;
> >>>        u32                           dname_len;
> >>>        struct ceph_mds_reply_lease   *dlease;
> >>> +     struct ceph_mds_reply_xattr   xattr_info;
> >>>
> >>>        /* extra */
> >>>        union {
> >>> diff --git a/fs/ceph/strings.c b/fs/ceph/strings.c
> >>> index 573bb9556fb5..e36e8948e728 100644
> >>> --- a/fs/ceph/strings.c
> >>> +++ b/fs/ceph/strings.c
> >>> @@ -60,6 +60,7 @@ const char *ceph_mds_op_name(int op)
> >>>        case CEPH_MDS_OP_LOOKUPINO:  return "lookupino";
> >>>        case CEPH_MDS_OP_LOOKUPNAME:  return "lookupname";
> >>>        case CEPH_MDS_OP_GETATTR:  return "getattr";
> >>> +     case CEPH_MDS_OP_GETVXATTR:  return "getvxattr";
> >>>        case CEPH_MDS_OP_SETXATTR: return "setxattr";
> >>>        case CEPH_MDS_OP_SETATTR: return "setattr";
> >>>        case CEPH_MDS_OP_RMXATTR: return "rmxattr";
> >>> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> >>> index ac331aa07cfa..a627fa69668e 100644
> >>> --- a/fs/ceph/super.h
> >>> +++ b/fs/ceph/super.h
> >>> @@ -1043,6 +1043,7 @@ static inline bool ceph_inode_is_shutdown(struct inode *inode)
> >>>
> >>>   /* xattr.c */
> >>>   int __ceph_setxattr(struct inode *, const char *, const void *, size_t, int);
> >>> +int ceph_do_getvxattr(struct inode *inode, const char *name, void *value, size_t size);
> >>>   ssize_t __ceph_getxattr(struct inode *, const char *, void *, size_t);
> >>>   extern ssize_t ceph_listxattr(struct dentry *, char *, size_t);
> >>>   extern struct ceph_buffer *__ceph_build_xattrs_blob(struct ceph_inode_info *ci);
> >>> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> >>> index fcf7dfdecf96..dc32876a541a 100644
> >>> --- a/fs/ceph/xattr.c
> >>> +++ b/fs/ceph/xattr.c
> >>> @@ -918,6 +918,30 @@ static inline int __get_request_mask(struct inode *in) {
> >>>        return mask;
> >>>   }
> >>>
> >>> +/* check if the entire cluster supports the given feature */
> >>> +static inline bool ceph_cluster_has_feature(struct inode *inode, int feature_bit)
> >>> +{
> >>> +     int64_t i;
> >>> +     struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
> >>> +     struct ceph_mds_session **sessions = fsc->mdsc->sessions;
> >>> +     int64_t num_sessions = atomic_read(&fsc->mdsc->num_sessions);
> >>> +
> >>> +     if (fsc->mdsc->stopping)
> >>> +             return false;
> >>> +
> >>> +     if (!sessions)
> >>> +             return false;
> >>> +
> >>> +     for (i = 0; i < num_sessions; i++) {
> >>> +             struct ceph_mds_session *session = sessions[i];
> >>> +             if (!session)
> >>> +                     return false;
> >>> +             if (!test_bit(feature_bit, &session->s_features))
> >>> +                     return false;
> >> What guarantee do you have that "session" will still be a valid pointer
> >> by the time you get to dereferencing it here?
> >>
> >> I think this loop needs some locking (as Xiubo pointed out in his
> >> earlier review).
> > yeah, thanks for pointing that out
> > I'm trying to wrap the entire processing of this function inside a
> > mutex_unlock(&mdsc->mutex) ... but the mount command fails
> > to mount if done so. If code is not wrapped in mutex lock...unlock
> > then the mount is successful.
> > It's a surprise that the code doesn't deadlock under the mutex
> > lock...unlock and gracefully fails with a message.
> > Any hints on what I could be missing.
> >
> >>> +     }
> >>> +     return true;
> >>> +}
> >>> +
> >>>   ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
> >>>                      size_t size)
> >>>   {
> >>> @@ -927,6 +951,16 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
> >>>        int req_mask;
> >>>        ssize_t err;
> >>>
> >>> +     if (!strncmp(name, XATTR_CEPH_PREFIX, XATTR_CEPH_PREFIX_LEN) &&
> >>> +         ceph_cluster_has_feature(inode, CEPHFS_FEATURE_GETVXATTR)) {
> >>> +             err = ceph_do_getvxattr(inode, name, value, size);
> >>> +             /* if cluster doesn't support xattr, we try to service it
> >>> +              * locally
> >>> +              */
> >>> +             if (err >= 0)
> >>> +                     return err;
> >>> +     }
> >>> +
> >> What is this? Why not always service this locally?
> > vxattr handling is planned to be moved to the MDS side.
> > As I've pointed out to Xiubo, there's a few new things that have been done for
> > layout vxattr management. Also, as per your original tracker, ceph.dir.pin*
> > can't be handled locally.
> > getvxattr() currently handles:
> > 1. ceph.dir.layout*
> > 2. ceph.file.layout*
> > 3. ceph.dir.pin*
>
> The above seems will include the 'ceph.dir.layout', 'ceph.file.layout'
> and 'ceph.dir.pin' ? All these have been handled in 'ceph_file_vxattrs'
> and 'ceph_dir_vxattrs'...
>
> And the code above will always force kclient to get all the 'ceph.XXX'
> xattrs from MDS ?

yes, the kclient will always get vxattr values from MDS
for old cluster, op will be handled locally

Jeff has a proposal to expose the JSON output variety of layout
vxattr vlaue via new vxattr altogether
eg. ceph.dir.layout_json and ceph.file.layout_json

>
>
>
> > If kclient is new and the cluster is old, then layout vxattr will be
> > handled the old
> > way, i.e. locally. ceph.dir.pin* will remain inaccessible.
> >
> >>>        /* let's see if a virtual xattr was requested */
> >>>        vxattr = ceph_match_vxattr(inode, name);
> >>>        if (vxattr) {
> >>> diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
> >>> index 7ad6c3d0db7d..66db21ac5f0c 100644
> >>> --- a/include/linux/ceph/ceph_fs.h
> >>> +++ b/include/linux/ceph/ceph_fs.h
> >>> @@ -328,6 +328,7 @@ enum {
> >>>        CEPH_MDS_OP_LOOKUPPARENT = 0x00103,
> >>>        CEPH_MDS_OP_LOOKUPINO  = 0x00104,
> >>>        CEPH_MDS_OP_LOOKUPNAME = 0x00105,
> >>> +     CEPH_MDS_OP_GETVXATTR  = 0x00106,
> >>>
> >>>        CEPH_MDS_OP_SETXATTR   = 0x01105,
> >>>        CEPH_MDS_OP_RMXATTR    = 0x01106,
> >> --
> >> Jeff Layton <jlayton@kernel.org>
>
