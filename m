Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2C7A734C4B
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Jun 2023 09:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbjFSHU7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 19 Jun 2023 03:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjFSHU6 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 19 Jun 2023 03:20:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256571A4
        for <ceph-devel@vger.kernel.org>; Mon, 19 Jun 2023 00:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687159212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G2Jq21Zx5kusMx4gvyFYG1dEjhzALtQ1El/tc1Kl1K0=;
        b=ZzWCCH+zezUF6SmaiGXrYM4w+GFq5RDmq28OsqVOFW62OXvzFcQG7UXc43JpbqW0FmTZWr
        /vzJ5MHbl0bQJSOrqBvH8FjuG3SilkutWUcLCQu/D6xfK+A5mquOCwmnlCME6+6be8XZWM
        2QVLB+rB/MiiJQnME5ou6RBnogOyFek=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-493-_v0qKKFtN82uwhEt9Pgz5A-1; Mon, 19 Jun 2023 03:20:10 -0400
X-MC-Unique: _v0qKKFtN82uwhEt9Pgz5A-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1b511b1b660so13147915ad.1
        for <ceph-devel@vger.kernel.org>; Mon, 19 Jun 2023 00:20:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687159209; x=1689751209;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G2Jq21Zx5kusMx4gvyFYG1dEjhzALtQ1El/tc1Kl1K0=;
        b=gbbb018r23l+yTyNUng7lpPEWM0Dgd6Vod4jrzqA+gOeZ0m25QPWtbgySuRYkDiGS+
         G6pUYEN/j1Il1jAQzxrExVP8diNImhIkBdI1QUVTASXTosOKNVds1fR2e01pcgqM4OZS
         4mDVJv9X2LG3vz79bN0rgNM1IQskJuRvvcQGn7hqZpPKrQE698iH0cSOn7EDv3/HO2WZ
         QJBFYJD/o6+FN7NtmZmVc6Q2S7tsjWLWl56fEXyidAPO2Jo/dK9Gv9zXtUFFPS+Y/5X5
         ZZ8g02+h1pSoUvXmo3L6BSKan/UszUZbJbueQVlAL4k64rw7dxQgIbbl4ErsYykCfXGw
         2yfA==
X-Gm-Message-State: AC+VfDyMM7HKoDnUunjUYod3uzB7IfS8YbdxWjPpatv6NEKwzbimJtqM
        PoCChhfuf4FJmDPl9wDSq5Pdnb8+BoFVIAw+2EV4UxogJnfS4ZNYu6f4Fa1f/CU0HDZ4jai2VbU
        Ib3RBx8BDJoP4ijzBaWn8sA==
X-Received: by 2002:a17:903:2284:b0:1b6:6a5c:2c76 with SMTP id b4-20020a170903228400b001b66a5c2c76mr442367plh.15.1687159209222;
        Mon, 19 Jun 2023 00:20:09 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5V138LjLWBKDa6G6oS5mj4lyYOasBcYhEzyNWFt1t85VYyW2On/aPKf61WrmOSN/RrtTzcmg==
X-Received: by 2002:a17:903:2284:b0:1b6:6a5c:2c76 with SMTP id b4-20020a170903228400b001b66a5c2c76mr442358plh.15.1687159208892;
        Mon, 19 Jun 2023 00:20:08 -0700 (PDT)
Received: from [10.72.13.217] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n10-20020a170902d2ca00b001b03c225c0asm19763760plc.221.2023.06.19.00.20.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 00:20:08 -0700 (PDT)
Message-ID: <59e8e45a-b73a-1f3a-9310-ba5dab5af3d2@redhat.com>
Date:   Mon, 19 Jun 2023 15:20:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v4 0/6] ceph: print the client global id for debug logs
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com
References: <20230619071438.7000-1-xiubli@redhat.com>
Content-Language: en-US
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20230619071438.7000-1-xiubli@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/19/23 15:14, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
>
> V4:
> - s/dout_client()/doutc()/
> - Fixed the building errors reported by ceph: print the client global id
> for debug logs. Thanks.

Sorry, it's reported by "kernel test robot <lkp@intel.com>".

- Xiubo

>
> Xiubo Li (6):
>    ceph: add the *_client debug macros support
>    ceph: pass the mdsc to several helpers
>    ceph: rename _to_client() to _to_fs_client()
>    ceph: move mdsmap.h to fs/ceph/
>    ceph: add ceph_inode_to_client() helper support
>    ceph: print the client global_id in all the debug logs
>
>   fs/ceph/acl.c                       |   6 +-
>   fs/ceph/addr.c                      | 298 ++++++-----
>   fs/ceph/cache.c                     |   2 +-
>   fs/ceph/caps.c                      | 774 ++++++++++++++++------------
>   fs/ceph/crypto.c                    |  41 +-
>   fs/ceph/debugfs.c                   |  10 +-
>   fs/ceph/dir.c                       | 237 +++++----
>   fs/ceph/export.c                    |  49 +-
>   fs/ceph/file.c                      | 270 +++++-----
>   fs/ceph/inode.c                     | 521 ++++++++++---------
>   fs/ceph/ioctl.c                     |  21 +-
>   fs/ceph/locks.c                     |  57 +-
>   fs/ceph/mds_client.c                | 624 ++++++++++++----------
>   fs/ceph/mds_client.h                |   5 +-
>   fs/ceph/mdsmap.c                    |  29 +-
>   {include/linux => fs}/ceph/mdsmap.h |   5 +-
>   fs/ceph/metric.c                    |   5 +-
>   fs/ceph/quota.c                     |  29 +-
>   fs/ceph/snap.c                      | 192 +++----
>   fs/ceph/super.c                     |  92 ++--
>   fs/ceph/super.h                     |  19 +-
>   fs/ceph/xattr.c                     | 108 ++--
>   include/linux/ceph/ceph_debug.h     |  48 +-
>   23 files changed, 1976 insertions(+), 1466 deletions(-)
>   rename {include/linux => fs}/ceph/mdsmap.h (92%)
>

