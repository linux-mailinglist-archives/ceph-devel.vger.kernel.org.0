Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A60D16F8DA2
	for <lists+ceph-devel@lfdr.de>; Sat,  6 May 2023 03:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbjEFBeR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 5 May 2023 21:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbjEFBeN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 5 May 2023 21:34:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C8377A9A
        for <ceph-devel@vger.kernel.org>; Fri,  5 May 2023 18:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683336759;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+dEBRkuDeq/xK66jQ8NRngTNuRov4Ha3XyLQN3Dm0ak=;
        b=brtgchE/AXwObKGGKmVGix5rH4TDI/8IivWz8YruX69eqnJPFeWuuvVgDQjn+h+kOmvERf
        cC/IJepEUcvUg/oW3o8MlybnYRYNPP8W7kCVh/l+Bv6eKVR5AyZ3beMEYViguuiOm+7u+Q
        JYSbYF9hih/hB2L3etKCD8rXiK0tapM=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-518-KNlFsERYMzKtT7ufmHMYPw-1; Fri, 05 May 2023 21:32:38 -0400
X-MC-Unique: KNlFsERYMzKtT7ufmHMYPw-1
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-6438c8a0cb5so1273581b3a.3
        for <ceph-devel@vger.kernel.org>; Fri, 05 May 2023 18:32:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683336757; x=1685928757;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+dEBRkuDeq/xK66jQ8NRngTNuRov4Ha3XyLQN3Dm0ak=;
        b=hVWPjTV0LX0br7k+hhl+Ua+VXkXPZPBQy9Tl/3fv6rfA9vnww4OklKIRbzVoZSBmH9
         VUA0NhuVso5o4pbOBYi0frui/dOFl+VrXfb6gr1HY+rMwL5viB/Xq2oQCCrASvjunNC0
         PiWyWRFLZKgubQXMweVFK6bFLFDAvwolAWYvGjv5lPZI0MlsWGPZPxHK78oGApc/LHsK
         yhGidlx9lCpaBfs4QQerGJfCUxAyd8roGMCjHs7pCcVg/TX1dL4wxpKcIqox8OFnY6Dl
         ukQy5sGTxYPI5PFA3hVrx+Y7N5RnNBhrr1YMpkSVOSgtEK+QJYAHN5WeyxWcOEpO9djp
         rljA==
X-Gm-Message-State: AC+VfDxPyBaLukSBEhpRH7VxCa4ptPNGkjpR37cNoV83uTdWJkcd/bWn
        LLt+4M3MZS6aCAI2P+S4phtoiMjEfljmVG4aVY+Jk38hY8tGCGFNNEbz0HugfriYPxfFUF6BpkY
        eiMaZ0yeRgZA7lMoqw2KAeMSlFXRHSmSnqzo=
X-Received: by 2002:a05:6a20:a10c:b0:f4:d4a8:9c84 with SMTP id q12-20020a056a20a10c00b000f4d4a89c84mr3367051pzk.32.1683336756951;
        Fri, 05 May 2023 18:32:36 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4NhtOUuOJuiHF0S/nTmJLto+mGew4OwUramNk4NJOm3HDKSXDQY6hMmVyOBUnOYDgCqTarsw==
X-Received: by 2002:a05:6a20:a10c:b0:f4:d4a8:9c84 with SMTP id q12-20020a056a20a10c00b000f4d4a89c84mr3367036pzk.32.1683336756603;
        Fri, 05 May 2023 18:32:36 -0700 (PDT)
Received: from [10.72.12.156] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id w1-20020a655341000000b0051815eae23esm2091120pgr.27.2023.05.05.18.32.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 May 2023 18:32:36 -0700 (PDT)
Message-ID: <937dc7c7-1907-5511-d691-7f531e72bd8f@redhat.com>
Date:   Sat, 6 May 2023 09:32:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [bug report] ceph: fix potential use-after-free bug when trimming
 caps
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     ceph-devel@vger.kernel.org
References: <9e074e4b-9519-42e2-819a-7089564d6158@kili.mountain>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <9e074e4b-9519-42e2-819a-7089564d6158@kili.mountain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Dan,

On 5/5/23 17:21, Dan Carpenter wrote:
> Hello Xiubo Li,
>
> The patch aaf67de78807: "ceph: fix potential use-after-free bug when
> trimming caps" from Apr 19, 2023, leads to the following Smatch
> static checker warning:
>
> 	fs/ceph/mds_client.c:3968 reconnect_caps_cb()
> 	warn: missing error code here? '__get_cap_for_mds()' failed. 'err' = '0'
>
> fs/ceph/mds_client.c
>      3933 static int reconnect_caps_cb(struct inode *inode, int mds, void *arg)
>      3934 {
>      3935         union {
>      3936                 struct ceph_mds_cap_reconnect v2;
>      3937                 struct ceph_mds_cap_reconnect_v1 v1;
>      3938         } rec;
>      3939         struct ceph_inode_info *ci = ceph_inode(inode);
>      3940         struct ceph_reconnect_state *recon_state = arg;
>      3941         struct ceph_pagelist *pagelist = recon_state->pagelist;
>      3942         struct dentry *dentry;
>      3943         struct ceph_cap *cap;
>      3944         char *path;
>      3945         int pathlen = 0, err = 0;
>      3946         u64 pathbase;
>      3947         u64 snap_follows;
>      3948
>      3949         dentry = d_find_primary(inode);
>      3950         if (dentry) {
>      3951                 /* set pathbase to parent dir when msg_version >= 2 */
>      3952                 path = ceph_mdsc_build_path(dentry, &pathlen, &pathbase,
>      3953                                             recon_state->msg_version >= 2);
>      3954                 dput(dentry);
>      3955                 if (IS_ERR(path)) {
>      3956                         err = PTR_ERR(path);
>      3957                         goto out_err;
>      3958                 }
>      3959         } else {
>      3960                 path = NULL;
>      3961                 pathbase = 0;
>      3962         }
>      3963
>      3964         spin_lock(&ci->i_ceph_lock);
>      3965         cap = __get_cap_for_mds(ci, mds);
>      3966         if (!cap) {
>      3967                 spin_unlock(&ci->i_ceph_lock);
> --> 3968                 goto out_err;
>
> Set an error code?

This was intended, the 'err' was initialized as '0' in line 3945.

It's no harm to skip this _cb() for current cap, so just succeeds it.

Thanks

- Xiubo


>
>      3969         }
>      3970         dout(" adding %p ino %llx.%llx cap %p %lld %s\n",
>      3971              inode, ceph_vinop(inode), cap, cap->cap_id,
>      3972              ceph_cap_string(cap->issued));
>      3973
>      3974         cap->seq = 0;        /* reset cap seq */
>      3975         cap->issue_seq = 0;  /* and issue_seq */
>      3976         cap->mseq = 0;       /* and migrate_seq */
>      3977         cap->cap_gen = atomic_read(&cap->session->s_cap_gen);
>      3978
>      3979         /* These are lost when the session goes away */
>      3980         if (S_ISDIR(inode->i_mode)) {
>      3981                 if (cap->issued & CEPH_CAP_DIR_CREATE) {
>      3982                         ceph_put_string(rcu_dereference_raw(ci->i_cached_layout.pool_ns));
>      3983                         memset(&ci->i_cached_layout, 0, sizeof(ci->i_cached_layout));
>      3984                 }
>      3985                 cap->issued &= ~CEPH_CAP_ANY_DIR_OPS;
>      3986         }
>      3987
>      3988         if (recon_state->msg_version >= 2) {
>      3989                 rec.v2.cap_id = cpu_to_le64(cap->cap_id);
>      3990                 rec.v2.wanted = cpu_to_le32(__ceph_caps_wanted(ci));
>      3991                 rec.v2.issued = cpu_to_le32(cap->issued);
>      3992                 rec.v2.snaprealm = cpu_to_le64(ci->i_snap_realm->ino);
>      3993                 rec.v2.pathbase = cpu_to_le64(pathbase);
>      3994                 rec.v2.flock_len = (__force __le32)
>      3995                         ((ci->i_ceph_flags & CEPH_I_ERROR_FILELOCK) ? 0 : 1);
>      3996         } else {
>      3997                 rec.v1.cap_id = cpu_to_le64(cap->cap_id);
>      3998                 rec.v1.wanted = cpu_to_le32(__ceph_caps_wanted(ci));
>      3999                 rec.v1.issued = cpu_to_le32(cap->issued);
>      4000                 rec.v1.size = cpu_to_le64(i_size_read(inode));
>      4001                 ceph_encode_timespec64(&rec.v1.mtime, &inode->i_mtime);
>      4002                 ceph_encode_timespec64(&rec.v1.atime, &inode->i_atime);
>      4003                 rec.v1.snaprealm = cpu_to_le64(ci->i_snap_realm->ino);
>      4004                 rec.v1.pathbase = cpu_to_le64(pathbase);
>      4005         }
>      4006
>      4007         if (list_empty(&ci->i_cap_snaps)) {
>      4008                 snap_follows = ci->i_head_snapc ? ci->i_head_snapc->seq : 0;
>      4009         } else {
>      4010                 struct ceph_cap_snap *capsnap =
>      4011                         list_first_entry(&ci->i_cap_snaps,
>      4012                                          struct ceph_cap_snap, ci_item);
>      4013                 snap_follows = capsnap->follows;
>      4014         }
>      4015         spin_unlock(&ci->i_ceph_lock);
>      4016
>      4017         if (recon_state->msg_version >= 2) {
>      4018                 int num_fcntl_locks, num_flock_locks;
>      4019                 struct ceph_filelock *flocks = NULL;
>      4020                 size_t struct_len, total_len = sizeof(u64);
>      4021                 u8 struct_v = 0;
>      4022
>      4023 encode_again:
>      4024                 if (rec.v2.flock_len) {
>      4025                         ceph_count_locks(inode, &num_fcntl_locks, &num_flock_locks);
>      4026                 } else {
>      4027                         num_fcntl_locks = 0;
>      4028                         num_flock_locks = 0;
>      4029                 }
>      4030                 if (num_fcntl_locks + num_flock_locks > 0) {
>      4031                         flocks = kmalloc_array(num_fcntl_locks + num_flock_locks,
>      4032                                                sizeof(struct ceph_filelock),
>      4033                                                GFP_NOFS);
>      4034                         if (!flocks) {
>      4035                                 err = -ENOMEM;
>      4036                                 goto out_err;
>      4037                         }
>      4038                         err = ceph_encode_locks_to_buffer(inode, flocks,
>      4039                                                           num_fcntl_locks,
>      4040                                                           num_flock_locks);
>      4041                         if (err) {
>      4042                                 kfree(flocks);
>      4043                                 flocks = NULL;
>      4044                                 if (err == -ENOSPC)
>      4045                                         goto encode_again;
>      4046                                 goto out_err;
>      4047                         }
>      4048                 } else {
>      4049                         kfree(flocks);
>      4050                         flocks = NULL;
>      4051                 }
>      4052
>      4053                 if (recon_state->msg_version >= 3) {
>      4054                         /* version, compat_version and struct_len */
>      4055                         total_len += 2 * sizeof(u8) + sizeof(u32);
>      4056                         struct_v = 2;
>      4057                 }
>      4058                 /*
>      4059                  * number of encoded locks is stable, so copy to pagelist
>      4060                  */
>      4061                 struct_len = 2 * sizeof(u32) +
>      4062                             (num_fcntl_locks + num_flock_locks) *
>      4063                             sizeof(struct ceph_filelock);
>      4064                 rec.v2.flock_len = cpu_to_le32(struct_len);
>      4065
>      4066                 struct_len += sizeof(u32) + pathlen + sizeof(rec.v2);
>      4067
>      4068                 if (struct_v >= 2)
>      4069                         struct_len += sizeof(u64); /* snap_follows */
>      4070
>      4071                 total_len += struct_len;
>      4072
>      4073                 if (pagelist->length + total_len > RECONNECT_MAX_SIZE) {
>      4074                         err = send_reconnect_partial(recon_state);
>      4075                         if (err)
>      4076                                 goto out_freeflocks;
>      4077                         pagelist = recon_state->pagelist;
>      4078                 }
>      4079
>      4080                 err = ceph_pagelist_reserve(pagelist, total_len);
>      4081                 if (err)
>      4082                         goto out_freeflocks;
>      4083
>      4084                 ceph_pagelist_encode_64(pagelist, ceph_ino(inode));
>      4085                 if (recon_state->msg_version >= 3) {
>      4086                         ceph_pagelist_encode_8(pagelist, struct_v);
>      4087                         ceph_pagelist_encode_8(pagelist, 1);
>      4088                         ceph_pagelist_encode_32(pagelist, struct_len);
>      4089                 }
>      4090                 ceph_pagelist_encode_string(pagelist, path, pathlen);
>      4091                 ceph_pagelist_append(pagelist, &rec, sizeof(rec.v2));
>      4092                 ceph_locks_to_pagelist(flocks, pagelist,
>      4093                                        num_fcntl_locks, num_flock_locks);
>      4094                 if (struct_v >= 2)
>      4095                         ceph_pagelist_encode_64(pagelist, snap_follows);
>      4096 out_freeflocks:
>      4097                 kfree(flocks);
>      4098         } else {
>      4099                 err = ceph_pagelist_reserve(pagelist,
>      4100                                             sizeof(u64) + sizeof(u32) +
>      4101                                             pathlen + sizeof(rec.v1));
>      4102                 if (err)
>      4103                         goto out_err;
>      4104
>      4105                 ceph_pagelist_encode_64(pagelist, ceph_ino(inode));
>      4106                 ceph_pagelist_encode_string(pagelist, path, pathlen);
>      4107                 ceph_pagelist_append(pagelist, &rec, sizeof(rec.v1));
>      4108         }
>      4109
>      4110 out_err:
>      4111         ceph_mdsc_free_path(path, pathlen);
>      4112         if (!err)
>      4113                 recon_state->nr_caps++;
>      4114         return err;
>      4115 }
>
> regards,
> dan carpenter
>

