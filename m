Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC7E4B06C4
	for <lists+ceph-devel@lfdr.de>; Thu, 10 Feb 2022 08:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235786AbiBJG7b (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 10 Feb 2022 01:59:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232769AbiBJG7a (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 10 Feb 2022 01:59:30 -0500
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF67AFC0
        for <ceph-devel@vger.kernel.org>; Wed,  9 Feb 2022 22:59:31 -0800 (PST)
Received: by mail-vs1-xe30.google.com with SMTP id i26so1677272vso.9
        for <ceph-devel@vger.kernel.org>; Wed, 09 Feb 2022 22:59:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DCie6w89ibgIfUkbETixj8/9wVj+4ifvYNd6UMjboYo=;
        b=AC5Uv0q/f+jSB9Ag0tlQHyYNwpMm8ESfVTvipYRbP2LXcOeDAC7MGnZDFfLtpC1Tq/
         sqx0bOeh4eNJ6uS6Gu7woRLnmHJTRWzhm1wYQX/+2cVd3j1VwrxFYAt0Wyxmjr3eDI6d
         QonhRCwYrUy+5a3j37ycWJGwx6CNlw3Y3nU+UdZM0Jea/4pls6wOFAE5VbR2trNUUBpl
         DJQkxY2JDWUdAtm9l9W/7Zls+lZCt2ntPGZVbkcKsGderW9uebX31vGGUEsuHbiRH/NC
         6B1NAHIGZ7lI0yaVsOW+rDdAyDvnD/WOlOD4FsYiT77X0671rbYhHNvY6biauJPfqt6/
         vimA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DCie6w89ibgIfUkbETixj8/9wVj+4ifvYNd6UMjboYo=;
        b=VLTCnLAXn659ylbohkfzp4AnMemfoPpoBvLvlR4nJuWzo9bqQbd9kpZRTFzJ1Jo5B2
         s+wSAIoS5ubRBEaRi3b4lJ36WkmGGO0AVy3EA4tIB2a4e7SClgJrRP47IvpzWKSxaWV1
         6p59sJ8rqnNGs8n301GMvyoH4Dm/7lo9IgIcj4tblKrxMITA1Vvn9r/QSzVcwSlgfIEA
         Cd8rHpPGTL9yGFS/4Lrh82BF0+5dJ8R6BW8TjlduHI2M3ukIJDbrvbqL8cuA2LX9YMMy
         3vVcXVlGMGgYPExquOEpoK1ZfEGqRLXl8vp69FUoADS8wbpp7/CcDl2sn/oY6aMbkd04
         4gDA==
X-Gm-Message-State: AOAM532IbQa5QfNc8xIaeu/I4xGyIGbEv2qXGOBX+yonk7ZwKPquzr2s
        xmkyReYtYb+/KIrA3wj/vSwIb8mRVGZZ/hNcxYg=
X-Google-Smtp-Source: ABdhPJxpk6VfGCfhCPqdXEp94HglzQkMQlbBThhdjCtgf5HnFEOWjORiYjIcSM5urjvkOrR65MMYtFISW60MkIuMTrk=
X-Received: by 2002:a67:1d45:: with SMTP id d66mr139346vsd.46.1644476370785;
 Wed, 09 Feb 2022 22:59:30 -0800 (PST)
MIME-Version: 1.0
References: <20220127082619.85379-1-mchangir@redhat.com> <20220127082619.85379-2-mchangir@redhat.com>
 <0b18ee3f-86c4-c1aa-ac65-f43577319c69@redhat.com>
In-Reply-To: <0b18ee3f-86c4-c1aa-ac65-f43577319c69@redhat.com>
From:   Milind Changire <milindchangire@gmail.com>
Date:   Thu, 10 Feb 2022 12:29:19 +0530
Message-ID: <CANmksPSEroB-_Hx67-zuU4kZaUz=WQWxps_f9M1MuS8Yb=zUNg@mail.gmail.com>
Subject: Re: [PATCH v6 1/1] ceph: add getvxattr op
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Milind Changire <mchangir@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Feb 7, 2022 at 2:08 PM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 1/27/22 4:26 PM, Milind Changire wrote:
> > Problem:
> > Directory vxattrs like ceph.dir.pin* and ceph.dir.layout* may not be
> > propagated to the client as frequently to keep them updated. This
> > creates vxattr availability problems.
> >
> > Solution:
> > Adds new getvxattr op to fetch ceph.dir.pin*, ceph.dir.layout* and
> > ceph.file.layout* vxattrs.
> > If the entire layout for a dir or a file is being set, then it is
> > expected that the layout be set in standard JSON format. Individual
> > field value retrieval is not wrapped in JSON. The JSON format also
> > applies while setting the vxattr if the entire layout is being set in
> > one go.
> > As a temporary measure, setting a vxattr can also be done in the old
> > format. The old format will be deprecated in the future.
> >
> > URL: https://tracker.ceph.com/issues/51062
> > Signed-off-by: Milind Changire <mchangir@redhat.com>
> > ---
> >   fs/ceph/inode.c              | 51 ++++++++++++++++++++++++++++++++++++
> >   fs/ceph/mds_client.c         | 27 ++++++++++++++++++-
> >   fs/ceph/mds_client.h         | 12 ++++++++-
> >   fs/ceph/strings.c            |  1 +
> >   fs/ceph/super.h              |  1 +
> >   fs/ceph/xattr.c              | 17 ++++++++++++
> >   include/linux/ceph/ceph_fs.h |  1 +
> >   7 files changed, 108 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> > index e3322fcb2e8d..efdce049b7f0 100644
> > --- a/fs/ceph/inode.c
> > +++ b/fs/ceph/inode.c
> > @@ -2291,6 +2291,57 @@ int __ceph_do_getattr(struct inode *inode, struct page *locked_page,
> >       return err;
> >   }
> >
> > +int ceph_do_getvxattr(struct inode *inode, const char *name, void *value,
> > +                   size_t size)
> > +{
> > +     struct ceph_fs_client *fsc = ceph_sb_to_client(inode->i_sb);
> > +     struct ceph_mds_client *mdsc = fsc->mdsc;
> > +     struct ceph_mds_request *req;
> > +     int mode = USE_AUTH_MDS;
> > +     int err;
> > +     char *xattr_value;
> > +     size_t xattr_value_len;
> > +
> > +     req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETVXATTR, mode);
> > +     if (IS_ERR(req)) {
> > +             err = -ENOMEM;
> > +             goto out;
> > +     }
> > +
> > +     req->r_path2 = kstrdup(name, GFP_NOFS);
> > +     if (!req->r_path2) {
> > +             err = -ENOMEM;
> > +             goto put;
> > +     }
> > +
> > +     ihold(inode);
> > +     req->r_inode = inode;
> > +     err = ceph_mdsc_do_request(mdsc, NULL, req);
> > +     if (err < 0)
> > +             goto put;
> > +
> > +     xattr_value = req->r_reply_info.xattr_info.xattr_value;
> > +     xattr_value_len = req->r_reply_info.xattr_info.xattr_value_len;
> > +
> > +     dout("do_getvxattr xattr_value_len:%zu, size:%zu\n", xattr_value_len, size);
> > +
> > +     err = (int)xattr_value_len;
> > +     if (size == 0)
> > +             goto put;
> > +
> > +     if (xattr_value_len > size) {
> > +             err = -ERANGE;
> > +             goto put;
> > +     }
> > +
> > +     memcpy(value, xattr_value, xattr_value_len);
> > +put:
> > +     ceph_mdsc_put_request(req);
> > +out:
> > +     dout("do_getvxattr result=%d\n", err);
> > +     return err;
> > +}
> > +
> >
> >   /*
> >    * Check inode permissions.  We verify we have a valid value for
> > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > index c30eefc0ac19..a5eafc71d976 100644
> > --- a/fs/ceph/mds_client.c
> > +++ b/fs/ceph/mds_client.c
> > @@ -555,6 +555,29 @@ static int parse_reply_info_create(void **p, void *end,
> >       return -EIO;
> >   }
> >
> > +static int parse_reply_info_getvxattr(void **p, void *end,
> > +                                   struct ceph_mds_reply_info_parsed *info,
> > +                                   u64 features)
> > +{
> > +     u8 struct_v, struct_compat;
> > +     u32 struct_len;
> > +     u32 value_len;
> > +
> > +     ceph_decode_8_safe(p, end, struct_v, bad);
> > +     ceph_decode_8_safe(p, end, struct_compat, bad);
> > +     ceph_decode_32_safe(p, end, struct_len, bad);
> > +     ceph_decode_32_safe(p, end, value_len, bad);
> > +
> > +     if (value_len == end - *p) {
> > +       info->xattr_info.xattr_value = *p;
> > +       info->xattr_info.xattr_value_len = end - *p;
>
> Maybe this could be simplified by 's/end - *p/value_len/'

done ... check v7 patch

>
>
> > +       *p = end;
> > +       return info->xattr_info.xattr_value_len;
>
> And also here just return 'value_len' instead.

done ... check v7 patch

>
>
> > +     }
> > +bad:
> > +     return -EIO;
> > +}
> > +
> >   /*
> >    * parse extra results
> >    */
> > @@ -570,6 +593,8 @@ static int parse_reply_info_extra(void **p, void *end,
> >               return parse_reply_info_readdir(p, end, info, features);
> >       else if (op == CEPH_MDS_OP_CREATE)
> >               return parse_reply_info_create(p, end, info, features, s);
> > +     else if (op == CEPH_MDS_OP_GETVXATTR)
> > +             return parse_reply_info_getvxattr(p, end, info, features);
> >       else
> >               return -EIO;
> >   }
> > @@ -615,7 +640,7 @@ static int parse_reply_info(struct ceph_mds_session *s, struct ceph_msg *msg,
> >
> >       if (p != end)
> >               goto bad;
> > -     return 0;
> > +     return err;
> >
> >   bad:
> >       err = -EIO;
> > diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> > index 97c7f7bfa55f..f2a8e5af3c2e 100644
> > --- a/fs/ceph/mds_client.h
> > +++ b/fs/ceph/mds_client.h
> > @@ -29,8 +29,10 @@ enum ceph_feature_type {
> >       CEPHFS_FEATURE_MULTI_RECONNECT,
> >       CEPHFS_FEATURE_DELEG_INO,
> >       CEPHFS_FEATURE_METRIC_COLLECT,
> > +     CEPHFS_FEATURE_ALTERNATE_NAME,
> > +     CEPHFS_FEATURE_GETVXATTR,
> >
> > -     CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_METRIC_COLLECT,
> > +     CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_GETVXATTR,
> >   };
> >
> >   /*
> > @@ -45,6 +47,8 @@ enum ceph_feature_type {
> >       CEPHFS_FEATURE_MULTI_RECONNECT,         \
> >       CEPHFS_FEATURE_DELEG_INO,               \
> >       CEPHFS_FEATURE_METRIC_COLLECT,          \
> > +     CEPHFS_FEATURE_ALTERNATE_NAME,          \
> > +     CEPHFS_FEATURE_GETVXATTR,               \
> >                                               \
> >       CEPHFS_FEATURE_MAX,                     \
> >   }
> > @@ -100,6 +104,11 @@ struct ceph_mds_reply_dir_entry {
> >       loff_t                        offset;
> >   };
> >
> > +struct ceph_mds_reply_xattr {
> > +     char *xattr_value;
> > +     size_t xattr_value_len;
> > +};
> > +
> >   /*
> >    * parsed info about an mds reply, including information about
> >    * either: 1) the target inode and/or its parent directory and dentry,
> > @@ -115,6 +124,7 @@ struct ceph_mds_reply_info_parsed {
> >       char                          *dname;
> >       u32                           dname_len;
> >       struct ceph_mds_reply_lease   *dlease;
> > +     struct ceph_mds_reply_xattr   xattr_info;
> >
> >       /* extra */
> >       union {
> > diff --git a/fs/ceph/strings.c b/fs/ceph/strings.c
> > index 573bb9556fb5..e36e8948e728 100644
> > --- a/fs/ceph/strings.c
> > +++ b/fs/ceph/strings.c
> > @@ -60,6 +60,7 @@ const char *ceph_mds_op_name(int op)
> >       case CEPH_MDS_OP_LOOKUPINO:  return "lookupino";
> >       case CEPH_MDS_OP_LOOKUPNAME:  return "lookupname";
> >       case CEPH_MDS_OP_GETATTR:  return "getattr";
> > +     case CEPH_MDS_OP_GETVXATTR:  return "getvxattr";
> >       case CEPH_MDS_OP_SETXATTR: return "setxattr";
> >       case CEPH_MDS_OP_SETATTR: return "setattr";
> >       case CEPH_MDS_OP_RMXATTR: return "rmxattr";
> > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > index ac331aa07cfa..a627fa69668e 100644
> > --- a/fs/ceph/super.h
> > +++ b/fs/ceph/super.h
> > @@ -1043,6 +1043,7 @@ static inline bool ceph_inode_is_shutdown(struct inode *inode)
> >
> >   /* xattr.c */
> >   int __ceph_setxattr(struct inode *, const char *, const void *, size_t, int);
> > +int ceph_do_getvxattr(struct inode *inode, const char *name, void *value, size_t size);
> >   ssize_t __ceph_getxattr(struct inode *, const char *, void *, size_t);
> >   extern ssize_t ceph_listxattr(struct dentry *, char *, size_t);
> >   extern struct ceph_buffer *__ceph_build_xattrs_blob(struct ceph_inode_info *ci);
> > diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> > index fcf7dfdecf96..9a4fbe48963f 100644
> > --- a/fs/ceph/xattr.c
> > +++ b/fs/ceph/xattr.c
> > @@ -924,6 +924,7 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
> >       struct ceph_inode_info *ci = ceph_inode(inode);
> >       struct ceph_inode_xattr *xattr;
> >       struct ceph_vxattr *vxattr = NULL;
> > +     struct ceph_mds_session *session = NULL;
>
> No need to init this.

done ... check v7 patch

>
>
> >       int req_mask;
> >       ssize_t err;
> >
> > @@ -945,6 +946,22 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
> >                               err = -ERANGE;
> >               }
> >               return err;
> > +     } else {
> > +             err = -ENODATA;
> > +             spin_lock(&ci->i_ceph_lock);
> > +             if (strncmp(name, XATTR_CEPH_PREFIX, XATTR_CEPH_PREFIX_LEN))
> > +                     goto out;
>
> No need to get the 'i_ceph_lock' for the 'strncmp()' here, and could
> just return '-EINVAL' directly instead of goto out ?
>
>
> > +             /* check if the auth mds supports the getvxattr feature */
> > +             session = ci->i_auth_cap->session;
> > +             if (!session)
> > +                     goto out;
>
> In which case will the session be NULL ? If the i_auth_cap exists it
> will always set the 'session'.

done ... code moved to ceph_vet_session()

>
>
> > +
> > +             if (test_bit(CEPHFS_FEATURE_GETVXATTR, &session->s_features)) {
> > +                     spin_unlock(&ci->i_ceph_lock);
> > +                     err = ceph_do_getvxattr(inode, name, value, size);
> > +                     spin_lock(&ci->i_ceph_lock);
> > +             }
> > +             goto out;
> >       }
> >
> >       req_mask = __get_request_mask(inode);
> > diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
> > index 7ad6c3d0db7d..66db21ac5f0c 100644
> > --- a/include/linux/ceph/ceph_fs.h
> > +++ b/include/linux/ceph/ceph_fs.h
> > @@ -328,6 +328,7 @@ enum {
> >       CEPH_MDS_OP_LOOKUPPARENT = 0x00103,
> >       CEPH_MDS_OP_LOOKUPINO  = 0x00104,
> >       CEPH_MDS_OP_LOOKUPNAME = 0x00105,
> > +     CEPH_MDS_OP_GETVXATTR  = 0x00106,
> >
> >       CEPH_MDS_OP_SETXATTR   = 0x01105,
> >       CEPH_MDS_OP_RMXATTR    = 0x01106,
>
