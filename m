Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5B74909DB
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Jan 2022 14:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236294AbiAQN4U (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Jan 2022 08:56:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52187 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233038AbiAQN4T (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 17 Jan 2022 08:56:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642427778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AdehWyJ37RfD776hPJ7e2CI9LJSy1LcZU0FqFkpgsnk=;
        b=DxGRkI298S3PU1kgbzTlxzmeJVqg5HmPNKtGMdXbVekrTFsfmHCydtXO7ZYCX6IWlB3SpL
        7rDtZRTqOmOSeifJSKA2Htzcrm3zUKu4dIW5J+6AbgWd99NUkXGlEgyxNfKD9yuBLDKz/O
        fjr6AuS98eHzPUHw/4cVHwnBUbsp9MM=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-346--Z0JUvNSNKiK_u0Ge8jmYg-1; Mon, 17 Jan 2022 08:56:17 -0500
X-MC-Unique: -Z0JUvNSNKiK_u0Ge8jmYg-1
Received: by mail-pg1-f197.google.com with SMTP id g12-20020a63200c000000b00342cd03227aso7689885pgg.19
        for <ceph-devel@vger.kernel.org>; Mon, 17 Jan 2022 05:56:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=AdehWyJ37RfD776hPJ7e2CI9LJSy1LcZU0FqFkpgsnk=;
        b=xXDRkIGwjBo+gDkmK9dnh4BSaBUIuNAQOY+E1Xx57R0GPxgSizr767ECq1RNiNYq+c
         zto/FaH2lFn9XDNdTODfEI9nqYYCj4iGjGh1sChNL/cM8FJrBBOXIyVk/pIEejhhZzAT
         FMULf75vGykRvTtk9/AILJfbMgtoPpCS/fGfmNSeq/rXtiZWxO6FtjooiNfE//WkkYZr
         TtYEwUYjgOQz0Dq2RSsHcmxQuQFjBjpm7gVRLPCQ8d0fhQxKbT2F+HON8FbJDpPIFzjz
         +SLvbxD9//YAauTq+FRBWJWq8ptPNMyNgbIOHl7AF5IAsbebIS4dBRxyDcvPvNAyDxRF
         Zs3A==
X-Gm-Message-State: AOAM530UR2MhbKXEvHcVpmNdlPyUkK/709pKRrty117he2J6JcOoGXlP
        pTY1y7nudRL3MBbOGkyiOya7JX94dQtL9SLfAuz4bnN//rnky+4LUJh6OHm67KT+8HImb/qgHIW
        bpa6hEeJ6bRn6OzhzfiVzGg==
X-Received: by 2002:a63:45:: with SMTP id 66mr3995570pga.607.1642427775560;
        Mon, 17 Jan 2022 05:56:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwd51r9XOpyTrB6xl48EEMUGnYeWpZRIlkJY9fpot0oyzfStHxt5Yv8A7lyAFSr0ucOK5xURA==
X-Received: by 2002:a63:45:: with SMTP id 66mr3995545pga.607.1642427775128;
        Mon, 17 Jan 2022 05:56:15 -0800 (PST)
Received: from [10.72.12.81] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 14sm5893520pgg.55.2022.01.17.05.56.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jan 2022 05:56:14 -0800 (PST)
Subject: Re: [PATCH v4 1/1] ceph: add getvxattr op
To:     Jeff Layton <jlayton@kernel.org>,
        Milind Changire <milindchangire@gmail.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Milind Changire <mchangir@redhat.com>
References: <20220117085142.23638-1-mchangir@redhat.com>
 <20220117085142.23638-2-mchangir@redhat.com>
 <e1a40f8003fb861facbbf0c915b6631141c282ad.camel@kernel.org>
 <CANmksPT=vM653QZthXb7tgwekNBAeaLV67pZ0TiOmgusj8bhmQ@mail.gmail.com>
 <76e405bf-b7b4-62c2-eac8-1c3f7cbaf860@redhat.com>
 <CANmksPR5c5GHYnfx7QRf1501Q5KttUv_kzpdqK1FfZzOmaX_MQ@mail.gmail.com>
 <742b88f2-063d-d30a-9b5c-ab0e39a8a079@redhat.com>
 <7f7398c8b9842eee079a4fcc67f39224fe4eb92d.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <a1b241a2-fe59-a25c-4201-c4fe2242f35a@redhat.com>
Date:   Mon, 17 Jan 2022 21:56:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <7f7398c8b9842eee079a4fcc67f39224fe4eb92d.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 1/17/22 9:27 PM, Jeff Layton wrote:
> On Mon, 2022-01-17 at 21:09 +0800, Xiubo Li wrote:
>> On 1/17/22 8:58 PM, Milind Changire wrote:
>>> On Mon, Jan 17, 2022 at 6:20 PM Xiubo Li <xiubli@redhat.com> wrote:
>>>> On 1/17/22 7:07 PM, Milind Changire wrote:
>>>>> On Mon, Jan 17, 2022 at 4:23 PM Jeff Layton <jlayton@kernel.org> wrote:
>>>>>> On Mon, 2022-01-17 at 08:51 +0000, Milind Changire wrote:
>>>>>>> Problem:
>>>>>>> Directory vxattrs like ceph.dir.pin* and ceph.dir.layout* may not be
>>>>>>> propagated to the client as frequently to keep them updated. This
>>>>>>> creates vxattr availability problems.
>>>>>>>
>>>>>>> Solution:
>>>>>>> Adds new getvxattr op to fetch ceph.dir.pin*, ceph.dir.layout* and
>>>>>>> ceph.file.layout* vxattrs.
>>>>>>> If the entire layout for a dir or a file is being set, then it is
>>>>>>> expected that the layout be set in standard JSON format. Individual
>>>>>>> field value retrieval is not wrapped in JSON. The JSON format also
>>>>>>> applies while setting the vxattr if the entire layout is being set in
>>>>>>> one go.
>>>>>>> As a temporary measure, setting a vxattr can also be done in the old
>>>>>>> format. The old format will be deprecated in the future.
>>>>>>>
>>>>>>> URL: https://tracker.ceph.com/issues/51062
>>>>>>> Signed-off-by: Milind Changire <mchangir@redhat.com>
>>>>>>> ---
>>>>>>>     fs/ceph/inode.c              | 51 ++++++++++++++++++++++++++++++++++++
>>>>>>>     fs/ceph/mds_client.c         | 27 ++++++++++++++++++-
>>>>>>>     fs/ceph/mds_client.h         | 12 ++++++++-
>>>>>>>     fs/ceph/strings.c            |  1 +
>>>>>>>     fs/ceph/super.h              |  1 +
>>>>>>>     fs/ceph/xattr.c              | 34 ++++++++++++++++++++++++
>>>>>>>     include/linux/ceph/ceph_fs.h |  1 +
>>>>>>>     7 files changed, 125 insertions(+), 2 deletions(-)
>>>>>>>
>>>>>>> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
>>>>>>> index e3322fcb2e8d..efdce049b7f0 100644
>>>>>>> --- a/fs/ceph/inode.c
>>>>>>> +++ b/fs/ceph/inode.c
>>>>>>> @@ -2291,6 +2291,57 @@ int __ceph_do_getattr(struct inode *inode, struct page *locked_page,
>>>>>>>          return err;
>>>>>>>     }
>>>>>>>
>>>>>>> +int ceph_do_getvxattr(struct inode *inode, const char *name, void *value,
>>>>>>> +                   size_t size)
>>>>>>> +{
>>>>>>> +     struct ceph_fs_client *fsc = ceph_sb_to_client(inode->i_sb);
>>>>>>> +     struct ceph_mds_client *mdsc = fsc->mdsc;
>>>>>>> +     struct ceph_mds_request *req;
>>>>>>> +     int mode = USE_AUTH_MDS;
>>>>>>> +     int err;
>>>>>>> +     char *xattr_value;
>>>>>>> +     size_t xattr_value_len;
>>>>>>> +
>>>>>>> +     req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETVXATTR, mode);
>>>>>>> +     if (IS_ERR(req)) {
>>>>>>> +             err = -ENOMEM;
>>>>>>> +             goto out;
>>>>>>> +     }
>>>>>>> +
>>>>>>> +     req->r_path2 = kstrdup(name, GFP_NOFS);
>>>>>>> +     if (!req->r_path2) {
>>>>>>> +             err = -ENOMEM;
>>>>>>> +             goto put;
>>>>>>> +     }
>>>>>>> +
>>>>>>> +     ihold(inode);
>>>>>>> +     req->r_inode = inode;
>>>>>>> +     err = ceph_mdsc_do_request(mdsc, NULL, req);
>>>>>>> +     if (err < 0)
>>>>>>> +             goto put;
>>>>>>> +
>>>>>>> +     xattr_value = req->r_reply_info.xattr_info.xattr_value;
>>>>>>> +     xattr_value_len = req->r_reply_info.xattr_info.xattr_value_len;
>>>>>>> +
>>>>>>> +     dout("do_getvxattr xattr_value_len:%zu, size:%zu\n", xattr_value_len, size);
>>>>>>> +
>>>>>>> +     err = (int)xattr_value_len;
>>>>>>> +     if (size == 0)
>>>>>>> +             goto put;
>>>>>>> +
>>>>>>> +     if (xattr_value_len > size) {
>>>>>>> +             err = -ERANGE;
>>>>>>> +             goto put;
>>>>>>> +     }
>>>>>>> +
>>>>>>> +     memcpy(value, xattr_value, xattr_value_len);
>>>>>>> +put:
>>>>>>> +     ceph_mdsc_put_request(req);
>>>>>>> +out:
>>>>>>> +     dout("do_getvxattr result=%d\n", err);
>>>>>>> +     return err;
>>>>>>> +}
>>>>>>> +
>>>>>>>
>>>>>>>     /*
>>>>>>>      * Check inode permissions.  We verify we have a valid value for
>>>>>>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>>>>>>> index c30eefc0ac19..a5eafc71d976 100644
>>>>>>> --- a/fs/ceph/mds_client.c
>>>>>>> +++ b/fs/ceph/mds_client.c
>>>>>>> @@ -555,6 +555,29 @@ static int parse_reply_info_create(void **p, void *end,
>>>>>>>          return -EIO;
>>>>>>>     }
>>>>>>>
>>>>>>> +static int parse_reply_info_getvxattr(void **p, void *end,
>>>>>>> +                                   struct ceph_mds_reply_info_parsed *info,
>>>>>>> +                                   u64 features)
>>>>>>> +{
>>>>>>> +     u8 struct_v, struct_compat;
>>>>>>> +     u32 struct_len;
>>>>>>> +     u32 value_len;
>>>>>>> +
>>>>>>> +     ceph_decode_8_safe(p, end, struct_v, bad);
>>>>>>> +     ceph_decode_8_safe(p, end, struct_compat, bad);
>>>>>>> +     ceph_decode_32_safe(p, end, struct_len, bad);
>>>>>>> +     ceph_decode_32_safe(p, end, value_len, bad);
>>>>>>> +
>>>>>>> +     if (value_len == end - *p) {
>>>>>>> +       info->xattr_info.xattr_value = *p;
>>>>>>> +       info->xattr_info.xattr_value_len = end - *p;
>>>>>>> +       *p = end;
>>>>>>> +       return info->xattr_info.xattr_value_len;
>>>>>>> +     }
>>>>>>> +bad:
>>>>>>> +     return -EIO;
>>>>>>> +}
>>>>>>> +
>>>>>>>     /*
>>>>>>>      * parse extra results
>>>>>>>      */
>>>>>>> @@ -570,6 +593,8 @@ static int parse_reply_info_extra(void **p, void *end,
>>>>>>>                  return parse_reply_info_readdir(p, end, info, features);
>>>>>>>          else if (op == CEPH_MDS_OP_CREATE)
>>>>>>>                  return parse_reply_info_create(p, end, info, features, s);
>>>>>>> +     else if (op == CEPH_MDS_OP_GETVXATTR)
>>>>>>> +             return parse_reply_info_getvxattr(p, end, info, features);
>>>>>>>          else
>>>>>>>                  return -EIO;
>>>>>>>     }
>>>>>>> @@ -615,7 +640,7 @@ static int parse_reply_info(struct ceph_mds_session *s, struct ceph_msg *msg,
>>>>>>>
>>>>>>>          if (p != end)
>>>>>>>                  goto bad;
>>>>>>> -     return 0;
>>>>>>> +     return err;
>>>>>>>
>>>>>>>     bad:
>>>>>>>          err = -EIO;
>>>>>>> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
>>>>>>> index 97c7f7bfa55f..f2a8e5af3c2e 100644
>>>>>>> --- a/fs/ceph/mds_client.h
>>>>>>> +++ b/fs/ceph/mds_client.h
>>>>>>> @@ -29,8 +29,10 @@ enum ceph_feature_type {
>>>>>>>          CEPHFS_FEATURE_MULTI_RECONNECT,
>>>>>>>          CEPHFS_FEATURE_DELEG_INO,
>>>>>>>          CEPHFS_FEATURE_METRIC_COLLECT,
>>>>>>> +     CEPHFS_FEATURE_ALTERNATE_NAME,
>>>>>>> +     CEPHFS_FEATURE_GETVXATTR,
>>>>>>>
>>>>>>> -     CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_METRIC_COLLECT,
>>>>>>> +     CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_GETVXATTR,
>>>>>>>     };
>>>>>>>
>>>>>>>     /*
>>>>>>> @@ -45,6 +47,8 @@ enum ceph_feature_type {
>>>>>>>          CEPHFS_FEATURE_MULTI_RECONNECT,         \
>>>>>>>          CEPHFS_FEATURE_DELEG_INO,               \
>>>>>>>          CEPHFS_FEATURE_METRIC_COLLECT,          \
>>>>>>> +     CEPHFS_FEATURE_ALTERNATE_NAME,          \
>>>>>>> +     CEPHFS_FEATURE_GETVXATTR,               \
>>>>>>>                                                  \
>>>>>>>          CEPHFS_FEATURE_MAX,                     \
>>>>>>>     }
>>>>>>> @@ -100,6 +104,11 @@ struct ceph_mds_reply_dir_entry {
>>>>>>>          loff_t                        offset;
>>>>>>>     };
>>>>>>>
>>>>>>> +struct ceph_mds_reply_xattr {
>>>>>>> +     char *xattr_value;
>>>>>>> +     size_t xattr_value_len;
>>>>>>> +};
>>>>>>> +
>>>>>>>     /*
>>>>>>>      * parsed info about an mds reply, including information about
>>>>>>>      * either: 1) the target inode and/or its parent directory and dentry,
>>>>>>> @@ -115,6 +124,7 @@ struct ceph_mds_reply_info_parsed {
>>>>>>>          char                          *dname;
>>>>>>>          u32                           dname_len;
>>>>>>>          struct ceph_mds_reply_lease   *dlease;
>>>>>>> +     struct ceph_mds_reply_xattr   xattr_info;
>>>>>>>
>>>>>>>          /* extra */
>>>>>>>          union {
>>>>>>> diff --git a/fs/ceph/strings.c b/fs/ceph/strings.c
>>>>>>> index 573bb9556fb5..e36e8948e728 100644
>>>>>>> --- a/fs/ceph/strings.c
>>>>>>> +++ b/fs/ceph/strings.c
>>>>>>> @@ -60,6 +60,7 @@ const char *ceph_mds_op_name(int op)
>>>>>>>          case CEPH_MDS_OP_LOOKUPINO:  return "lookupino";
>>>>>>>          case CEPH_MDS_OP_LOOKUPNAME:  return "lookupname";
>>>>>>>          case CEPH_MDS_OP_GETATTR:  return "getattr";
>>>>>>> +     case CEPH_MDS_OP_GETVXATTR:  return "getvxattr";
>>>>>>>          case CEPH_MDS_OP_SETXATTR: return "setxattr";
>>>>>>>          case CEPH_MDS_OP_SETATTR: return "setattr";
>>>>>>>          case CEPH_MDS_OP_RMXATTR: return "rmxattr";
>>>>>>> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
>>>>>>> index ac331aa07cfa..a627fa69668e 100644
>>>>>>> --- a/fs/ceph/super.h
>>>>>>> +++ b/fs/ceph/super.h
>>>>>>> @@ -1043,6 +1043,7 @@ static inline bool ceph_inode_is_shutdown(struct inode *inode)
>>>>>>>
>>>>>>>     /* xattr.c */
>>>>>>>     int __ceph_setxattr(struct inode *, const char *, const void *, size_t, int);
>>>>>>> +int ceph_do_getvxattr(struct inode *inode, const char *name, void *value, size_t size);
>>>>>>>     ssize_t __ceph_getxattr(struct inode *, const char *, void *, size_t);
>>>>>>>     extern ssize_t ceph_listxattr(struct dentry *, char *, size_t);
>>>>>>>     extern struct ceph_buffer *__ceph_build_xattrs_blob(struct ceph_inode_info *ci);
>>>>>>> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
>>>>>>> index fcf7dfdecf96..dc32876a541a 100644
>>>>>>> --- a/fs/ceph/xattr.c
>>>>>>> +++ b/fs/ceph/xattr.c
>>>>>>> @@ -918,6 +918,30 @@ static inline int __get_request_mask(struct inode *in) {
>>>>>>>          return mask;
>>>>>>>     }
>>>>>>>
>>>>>>> +/* check if the entire cluster supports the given feature */
>>>>>>> +static inline bool ceph_cluster_has_feature(struct inode *inode, int feature_bit)
>>>>>>> +{
>>>>>>> +     int64_t i;
>>>>>>> +     struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
>>>>>>> +     struct ceph_mds_session **sessions = fsc->mdsc->sessions;
>>>>>>> +     int64_t num_sessions = atomic_read(&fsc->mdsc->num_sessions);
>>>>>>> +
>>>>>>> +     if (fsc->mdsc->stopping)
>>>>>>> +             return false;
>>>>>>> +
>>>>>>> +     if (!sessions)
>>>>>>> +             return false;
>>>>>>> +
>>>>>>> +     for (i = 0; i < num_sessions; i++) {
>>>>>>> +             struct ceph_mds_session *session = sessions[i];
>>>>>>> +             if (!session)
>>>>>>> +                     return false;
>>>>>>> +             if (!test_bit(feature_bit, &session->s_features))
>>>>>>> +                     return false;
>>>>>> What guarantee do you have that "session" will still be a valid pointer
>>>>>> by the time you get to dereferencing it here?
>>>>>>
>>>>>> I think this loop needs some locking (as Xiubo pointed out in his
>>>>>> earlier review).
>>>>> yeah, thanks for pointing that out
>>>>> I'm trying to wrap the entire processing of this function inside a
>>>>> mutex_unlock(&mdsc->mutex) ... but the mount command fails
>>>>> to mount if done so. If code is not wrapped in mutex lock...unlock
>>>>> then the mount is successful.
>>>>> It's a surprise that the code doesn't deadlock under the mutex
>>>>> lock...unlock and gracefully fails with a message.
>>>>> Any hints on what I could be missing.
>>>>>
>>>>>>> +     }
>>>>>>> +     return true;
>>>>>>> +}
>>>>>>> +
>>>>>>>     ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
>>>>>>>                        size_t size)
>>>>>>>     {
>>>>>>> @@ -927,6 +951,16 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
>>>>>>>          int req_mask;
>>>>>>>          ssize_t err;
>>>>>>>
>>>>>>> +     if (!strncmp(name, XATTR_CEPH_PREFIX, XATTR_CEPH_PREFIX_LEN) &&
>>>>>>> +         ceph_cluster_has_feature(inode, CEPHFS_FEATURE_GETVXATTR)) {
>>>>>>> +             err = ceph_do_getvxattr(inode, name, value, size);
>>>>>>> +             /* if cluster doesn't support xattr, we try to service it
>>>>>>> +              * locally
>>>>>>> +              */
>>>>>>> +             if (err >= 0)
>>>>>>> +                     return err;
>>>>>>> +     }
>>>>>>> +
>>>>>> What is this? Why not always service this locally?
>>>>> vxattr handling is planned to be moved to the MDS side.
>>>>> As I've pointed out to Xiubo, there's a few new things that have been done for
>>>>> layout vxattr management. Also, as per your original tracker, ceph.dir.pin*
>>>>> can't be handled locally.
>>>>> getvxattr() currently handles:
>>>>> 1. ceph.dir.layout*
>>>>> 2. ceph.file.layout*
>>>>> 3. ceph.dir.pin*
>>>> The above seems will include the 'ceph.dir.layout', 'ceph.file.layout'
>>>> and 'ceph.dir.pin' ? All these have been handled in 'ceph_file_vxattrs'
>>>> and 'ceph_dir_vxattrs'...
>>>>
>>>> And the code above will always force kclient to get all the 'ceph.XXX'
>>>> xattrs from MDS ?
>>> yes, the kclient will always get vxattr values from MDS
>>> for old cluster, op will be handled locally
>>>
>>> Jeff has a proposal to expose the JSON output variety of layout
>>> vxattr vlaue via new vxattr altogether
>>> eg. ceph.dir.layout_json and ceph.file.layout_json
>>>
>> Yeah, sounds good. Or maybe just adding the '.json' instead of '_json'.
>>
> +1 -- that looks cleaner than mixing up delimiters
>
> To be clear, I think this should wholly be a fallback mechanism for when
> the client doesn't recognize a vxattr name. IOW, we should only call the
> MDS after ceph_match_vxattr doesn't match an xattr name.

Sounds good.


>>>>
>>>>> If kclient is new and the cluster is old, then layout vxattr will be
>>>>> handled the old
>>>>> way, i.e. locally. ceph.dir.pin* will remain inaccessible.
>>>>>
>>>>>>>          /* let's see if a virtual xattr was requested */
>>>>>>>          vxattr = ceph_match_vxattr(inode, name);
>>>>>>>          if (vxattr) {
>>>>>>> diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
>>>>>>> index 7ad6c3d0db7d..66db21ac5f0c 100644
>>>>>>> --- a/include/linux/ceph/ceph_fs.h
>>>>>>> +++ b/include/linux/ceph/ceph_fs.h
>>>>>>> @@ -328,6 +328,7 @@ enum {
>>>>>>>          CEPH_MDS_OP_LOOKUPPARENT = 0x00103,
>>>>>>>          CEPH_MDS_OP_LOOKUPINO  = 0x00104,
>>>>>>>          CEPH_MDS_OP_LOOKUPNAME = 0x00105,
>>>>>>> +     CEPH_MDS_OP_GETVXATTR  = 0x00106,
>>>>>>>
>>>>>>>          CEPH_MDS_OP_SETXATTR   = 0x01105,
>>>>>>>          CEPH_MDS_OP_RMXATTR    = 0x01106,
>>>>>> --
>>>>>> Jeff Layton <jlayton@kernel.org>

