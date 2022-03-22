Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 215924E39FA
	for <lists+ceph-devel@lfdr.de>; Tue, 22 Mar 2022 08:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiCVH6C (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 22 Mar 2022 03:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiCVH6B (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 22 Mar 2022 03:58:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6758B5A08E
        for <ceph-devel@vger.kernel.org>; Tue, 22 Mar 2022 00:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647935793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qkb/Adu2CA6kzFZR83yT1mHJ08q2QWQlC0t91kJO7Xs=;
        b=HCG60wa+PjUKCk9eNYoc/TgF9ceFhfBZPd6OCZdX7eWeLKs9+eFQCbnU7RulWckAVYzB+O
        rZxO4p7n2GGPwmPNQKeTb+D/mfslUYuzPn4CNir3hIMWxKzJxRw7O/ocHtCXIxhuFT1RDL
        soCRtVSDP16Jkl4n+8jr4n0YdrLZkI0=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-595-sC2nmOgxNSizJSY38TVHqw-1; Tue, 22 Mar 2022 03:56:32 -0400
X-MC-Unique: sC2nmOgxNSizJSY38TVHqw-1
Received: by mail-pf1-f200.google.com with SMTP id y27-20020aa79afb000000b004fa7883f756so6033487pfp.18
        for <ceph-devel@vger.kernel.org>; Tue, 22 Mar 2022 00:56:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Qkb/Adu2CA6kzFZR83yT1mHJ08q2QWQlC0t91kJO7Xs=;
        b=Gir1CSZWGfGvD3cQIrvkyYJ5bzWIcqIGOZG4FkWpTNWXE5nOaCeKZ8wVSWtDlHKCV+
         V3gJzY3J0uVijEKwmdyzx+HWcXO5xEtr0fJJPAN5AvpqrcfnIEAV6PSjnn/SdCIaUZg2
         v2KJYUNc0cEoxMav9ckeurk8TZ8UEmUUi1g967oSgeYr9orw31iGlAiPqa8v32ejynjO
         6+lenQXuTgCHasQENAr5Sgd9/TUrzrBGUBx86mQ1aAr9SYOV2kPurnmit0FR53LFcHBA
         e2w+0HBncR2PcWTY6M0AioKVyc9e4C/IRbwY1fc3NOCk6/VYoB8xSUq2+L5iggfSUH25
         l+1w==
X-Gm-Message-State: AOAM531AzXIJX2FY1Gq7/Fxl7yn7FghCuQA/xdOkOrIHplwnixUOs5Y2
        WhFEPoFr45dlw5BWIJXihUI+3jKQtIKgQsgh+80sxtRVR9JCHKRXv+P2v7sRKpgryn6wkskJMd6
        zCVCABYheZUWfHzyoUfVDoOp75SfGhHr63xu7DPi++nVxZTQ/W3P/9bznSz8VmNrExqnA0Qg=
X-Received: by 2002:a62:520f:0:b0:4fa:6439:1bed with SMTP id g15-20020a62520f000000b004fa64391bedmr23959883pfb.76.1647935790967;
        Tue, 22 Mar 2022 00:56:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz4GVAsmq3k/NgYylGaLR3of79BBNtdBVi8q4c9WK96U3+d5DM2A7xH8YDU2Iblsj0CFoPg8A==
X-Received: by 2002:a62:520f:0:b0:4fa:6439:1bed with SMTP id g15-20020a62520f000000b004fa64391bedmr23959860pfb.76.1647935790616;
        Tue, 22 Mar 2022 00:56:30 -0700 (PDT)
Received: from [10.72.12.110] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 3-20020a17090a0cc300b001c743a2b502sm1723127pjt.43.2022.03.22.00.56.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Mar 2022 00:56:29 -0700 (PDT)
Subject: Re: [PATCH v4 0/5] ceph/libceph: add support for sparse reads to
 msgr2 crc codepath
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org
References: <20220321182618.134202-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <03e4e7ae-4c06-f31f-7203-629631a1e6e2@redhat.com>
Date:   Tue, 22 Mar 2022 15:56:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220321182618.134202-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 3/22/22 2:26 AM, Jeff Layton wrote:
> This is a revised version of the sparse read code I posted a week or so
> ago. Sparse read support is required for fscrypt integration work, but
> may be useful on its own.
>
> The main differences from the v3 set are a couple of small bugfixes, and
> the addition of a new "sparseread" mount option to force the cephfs
> client to use sparse reads. I also renamed the sparse_ext_len field to
> be sparse_ext_cnt (as suggested by Xiubo).
>
> Ilya, at this point I'm mostly looking for feedback from you. Does this
> approach seem sound? If so, I'll plan to work on implementing the v2-secure
> and v1 codepaths next.
>
> These patches are currently available in the 'ceph-sparse-read-v4' tag
> in my kernel tree here:
>
>      https://git.kernel.org/pub/scm/linux/kernel/git/jlayton/linux.git/
>
> Jeff Layton (5):
>    libceph: add spinlock around osd->o_requests
>    libceph: define struct ceph_sparse_extent and add some helpers
>    libceph: add sparse read support to msgr2 crc state machine
>    libceph: add sparse read support to OSD client
>    ceph: add new mount option to enable sparse reads
>
>   fs/ceph/addr.c                  |  18 ++-
>   fs/ceph/file.c                  |  51 ++++++-
>   fs/ceph/super.c                 |  16 +-
>   fs/ceph/super.h                 |   8 +
>   include/linux/ceph/messenger.h  |  29 ++++
>   include/linux/ceph/osd_client.h |  71 ++++++++-
>   net/ceph/messenger.c            |   1 +
>   net/ceph/messenger_v2.c         | 170 +++++++++++++++++++--
>   net/ceph/osd_client.c           | 255 +++++++++++++++++++++++++++++++-
>   9 files changed, 593 insertions(+), 26 deletions(-)
>
This patch series looks good to me.

Reviewed-by: Xiubo Li <xiubli@redhat.com>


