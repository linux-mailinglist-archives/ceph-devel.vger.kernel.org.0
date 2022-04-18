Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E89AD504ACD
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Apr 2022 04:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbiDRCLP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 17 Apr 2022 22:11:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235784AbiDRCLN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 17 Apr 2022 22:11:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 777DA186C5
        for <ceph-devel@vger.kernel.org>; Sun, 17 Apr 2022 19:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650247715;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JOPGXvpowPHsDs6IqP4T6GFB4HlrHcpgJRJi9H2uTNQ=;
        b=eWu3XbLHEOeeBWKo7la/+ps29KAlgjtwbwJ9iSVEp1AsIkvVjAFihf9vD+NFb14CVoXqjj
        gSTFp2sKIeKQyDeb/6utnzhrG2KOu7ds30rGfo/j9GnUv8URGk1SIO1GcupEr1qyGJFP/k
        JRU0mHbJkBxzIBeiwB0sJYv6n9YV2mU=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-498-aa5Ou0HGOUe2Yw8T3R3WUw-1; Sun, 17 Apr 2022 22:08:33 -0400
X-MC-Unique: aa5Ou0HGOUe2Yw8T3R3WUw-1
Received: by mail-pg1-f200.google.com with SMTP id r30-20020a63a55e000000b003a89ac6d583so2504946pgu.0
        for <ceph-devel@vger.kernel.org>; Sun, 17 Apr 2022 19:08:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=JOPGXvpowPHsDs6IqP4T6GFB4HlrHcpgJRJi9H2uTNQ=;
        b=vLoZmYOkCR37yZVtCJgxZCtHrMm5Me4oCGtsuog55ozoNk4jtTB10Vdcur5XcFwyuw
         CjPwQDC0O/eOK0UZb5HMFmwUzixV2vwjaUYaImu800egmB5JH0e6QBsP8W0hRhsvbO82
         knnjVZb1pFVKZt2Bnn6m2TvsqvLwl4b4TMbPs5YihAZWb9K4lwb2IZIHTGRJVl8pS9ua
         Bn2jtRMyOkSffAXD8xXen4jPMU71NrUV8p3VO8TIvdgLTOVNgaALDTClhQwmYtBCiDRl
         NBZBTjO8ZlQeo8FmtLQO6wVxf+DhvTV6Hu4QHY2g5CNbjEL+Vh07oKPeJRrcBgoO7wEF
         ovIQ==
X-Gm-Message-State: AOAM532AhqyDphJpqWUgcddHhErNtkr+HDtKdbZ8Vkl2c+mTig+5GCTH
        sq1jT4LhvNSqrdnOBtzSJOqPiuNrInva+zVzrvLPawLbln8MpFm+SkPKE/2jlCS1N4OwgFAYunJ
        9BmLyvpbHP/wLff6my7E7hg==
X-Received: by 2002:a17:902:b612:b0:158:8455:479e with SMTP id b18-20020a170902b61200b001588455479emr9052095pls.59.1650247712730;
        Sun, 17 Apr 2022 19:08:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxvSoOrhpfQp36iBxr6C6ijpEk+7NhBb3ea5QT1aEYX5kTc2c2qXnjr+e7YDV2gzBHzcDaUIg==
X-Received: by 2002:a17:902:b612:b0:158:8455:479e with SMTP id b18-20020a170902b61200b001588455479emr9052079pls.59.1650247712484;
        Sun, 17 Apr 2022 19:08:32 -0700 (PDT)
Received: from [10.72.12.77] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d16-20020a056a00245000b004f7728a4346sm10527480pfj.79.2022.04.17.19.08.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Apr 2022 19:08:31 -0700 (PDT)
Subject: Re: [PATCH v4 0/4] ceph: add support for snapshot names encryption
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220414135122.26821-1-lhenriques@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <6be0fac6-b5f5-86fe-cea9-110daf7220af@redhat.com>
Date:   Mon, 18 Apr 2022 10:08:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220414135122.26821-1-lhenriques@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 4/14/22 9:51 PM, Luís Henriques wrote:
> Hi!
>
> Time for another iteration on the encrypted snapshots names, which is
> mostly a rebase to the wip-fscrypt branch.  To test this, I've used ceph
> with the following PRs:
>
>    mds: add protection from clients without fscrypt support #45073
>    mds: use the whole string as the snapshot long name #45192
>    mds: support alternate names for snapshots #45224
>    mds: limit the snapshot names to 240 characters #45312
>
> Changes since v3:
>
> - Fixed WARN_ON() in ceph_encode_encrypted_dname()
>
> - Updated documentation and copyright notice for the base64
>    encoding/decoding implementaiton which was taken from the fscrypt base.
>
> Changes since v2:
>
> - Use ceph_find_inode() instead of ceph_get_inode() for finding a snapshot
>    parent in function parse_longname().  I've also added a fallback to
>    ceph_get_inode() in case we fail to find the inode.  This may happen if,
>    for example, the mount root doesn't include that inode.  The iput() was
>    also complemented by a discard_new_inode() if the inode is in the I_NEW
>    state. (patch 0002)
>
> - Move the check for '_' snapshots further up in the ceph_fname_to_usr()
>    and ceph_encode_encrypted_dname().  This fixes the case pointed out by
>    Xiubo in v2. (patch 0002)
>
> - Use NAME_MAX for tmp arrays (patch 0002)
>
> - Added an extra patch for replacing the base64url encoding by a different
>    encoding standard, the one used for IMAP mailboxes (which uses '+' and
>    ',' instead of '-' and '_').  This should fix the issue with snapshot
>    names starting with '_'. (patch 0003)
>
> Changes since v1:
>
> - Dropped the dentry->d_flags change in ceph_mkdir().  Thanks to Xiubo
>    suggestion, patch 0001 now skips calling ceph_fscrypt_prepare_context()
>    if we're handling a snapshot.
>
> - Added error handling to ceph_get_snapdir() in patch 0001 (Jeff had
>    already pointed that out but I forgot to include that change in previous
>    revision).
>
> - Rebased patch 0002 to the latest wip-fscrypt branch.
>
> - Added some documentation regarding snapshots naming restrictions.
>
>
> Luís Henriques (4):
>    ceph: add support for encrypted snapshot names
>    ceph: add support for handling encrypted snapshot names
>    ceph: update documentation regarding snapshot naming limitations
>    ceph: replace base64url by the encoding used for mailbox names
>
>   Documentation/filesystems/ceph.rst |  10 ++
>   fs/ceph/crypto.c                   | 252 +++++++++++++++++++++++++----
>   fs/ceph/crypto.h                   |  14 +-
>   fs/ceph/dir.c                      |   2 +-
>   fs/ceph/inode.c                    |  33 +++-
>   5 files changed, 273 insertions(+), 38 deletions(-)
>
This patch series LGTM.  Thanks Luis !

Reviewed-by: Xiubo Li <xiubli@redhat.com>


