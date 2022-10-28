Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE8261075A
	for <lists+ceph-devel@lfdr.de>; Fri, 28 Oct 2022 03:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235033AbiJ1Blj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 27 Oct 2022 21:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbiJ1Blh (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 27 Oct 2022 21:41:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 391767DF77
        for <ceph-devel@vger.kernel.org>; Thu, 27 Oct 2022 18:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666921252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H6M9aZTCM9vZLMk834ZoOy59D6XIaZNXZ0cEk+GrpHM=;
        b=jVMUwYb9ESNrMeBvuL0NS91Hh86Y+GtgivWd012D/2E3ZxQAPGB3woii0RSH6MpwW5JpD1
        Sjk95OorbYgn3xQ/JMr07i+ZsE1AHH68Mqkty/2Npoc3yEnhOojalOjjbwjKGRc0xCGIWv
        GAbxoMIblNv+avC8Nmy5U76Yr8P8UIE=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-571-E8k39TsgPemiziMd7PC1gg-1; Thu, 27 Oct 2022 21:40:50 -0400
X-MC-Unique: E8k39TsgPemiziMd7PC1gg-1
Received: by mail-pf1-f200.google.com with SMTP id k131-20020a628489000000b0056b3e1a9629so1764015pfd.8
        for <ceph-devel@vger.kernel.org>; Thu, 27 Oct 2022 18:40:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H6M9aZTCM9vZLMk834ZoOy59D6XIaZNXZ0cEk+GrpHM=;
        b=Jo23/mFbPaEzRqlIdY9eLZM4KZeDlGU4rSFwJtNgARfcQsFjDBnj0WXQOa39F/guUh
         plcSR4/C9pxOlqw6ZhUI2Y/7T5X3HWNGh3vrkxGA+T1O6/g3Gf8A/JIyWd5lsp0xCigw
         n/xH+rLiFqGUL78kaGif19+FAgeXD/hrDHsrCx9KYCnbv/KVj157wNM453o+rZPEO7rZ
         jPOPm0SRABiSa76pCDO6KtHg0Fsxytu7YvoHosde1ryU/+ZdC63B6sUSKu/oo9lVqg2P
         0pX+TD2wXnQz9IStI/J1uuEFJU+Tut+vV+fX2O1b6JyaDivMW0N4pj4oyEn+hUvYo0Yj
         QJ6A==
X-Gm-Message-State: ACrzQf0PC+nVxjvW5DNbrsIx9LzO/A13jxEl0AJ8Q4JVwrhUiwvz8TOk
        cEWPeVsYf01JZjkl+jH0YKQ8Rlvf/dd/rfngzML8cR2qKCEzlTjPKSJZ7nAcSzfHXvaccK4LC/U
        MJ36EDr6mfVBnlKbCKf7v8g==
X-Received: by 2002:a17:902:ea06:b0:185:4c1f:7460 with SMTP id s6-20020a170902ea0600b001854c1f7460mr52707941plg.99.1666921249540;
        Thu, 27 Oct 2022 18:40:49 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5vt0LfBiVkNNdEb0a8e8EGLreSRg4MQVdu+ngx6lv9b5RcZkfrM6CBNm2xsfDUmh3pelM9xQ==
X-Received: by 2002:a17:902:ea06:b0:185:4c1f:7460 with SMTP id s6-20020a170902ea0600b001854c1f7460mr52707927plg.99.1666921249297;
        Thu, 27 Oct 2022 18:40:49 -0700 (PDT)
Received: from [10.72.13.65] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id y68-20020a636447000000b004582e25a595sm1652163pgb.41.2022.10.27.18.40.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Oct 2022 18:40:48 -0700 (PDT)
Subject: Re: [PATCH v2] encrypt: add ceph support
To:     fstests@vger.kernel.org
Cc:     zlang@redhat.com, david@fromorbit.com, djwong@kernel.org,
        lhenriques@suse.de, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com
References: <20221027030021.296548-1-xiubli@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <9ba067d1-d62c-6894-c5b0-2d054130d453@redhat.com>
Date:   Fri, 28 Oct 2022 09:40:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20221027030021.296548-1-xiubli@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The test result for ceph:

[root@lxbceph1 xfstests-dev]# ./check -g encrypt
FSTYP         -- ceph
PLATFORM      -- Linux/x86_64 lxbceph1 6.1.0-rc1+ #164 SMP 
PREEMPT_DYNAMIC Mon Oct 24 10:18:33 CST 2022
MKFS_OPTIONS  -- 10.72.47.117:40267:/testB
MOUNT_OPTIONS -- -o name=admin,nowsync,copyfrom,rasize=4096 -o 
context=system_u:object_r:root_t:s0 10.72.47.117:40267:/testB /mnt/kcephfs.B

generic/395 187s ...  224s
generic/396 164s ...  219s
generic/397 177s ...  226s
generic/398       [not run] kernel doesn't support renameat2 syscall
generic/399       [not run] Filesystem ceph not supported in 
_scratch_mkfs_sized_encrypted
generic/419       [not run] kernel doesn't support renameat2 syscall
generic/421 170s ...  219s
generic/429 179s ...  237s
generic/435         3874s
generic/440 176s ...  216s
generic/548       [not run] xfs_io fiemap  failed (old kernel/wrong fs?)
generic/549       [not run] xfs_io fiemap  failed (old kernel/wrong fs?)
generic/550       [not run] encryption policy '-c 9 -n 9 -f 0' is 
unusable; probably missing kernel crypto API support
generic/576       [not run] fsverity utility required, skipped this test
generic/580        218s
generic/581 209s ...  244s
generic/582       [not run] xfs_io fiemap  failed (old kernel/wrong fs?)
generic/583       [not run] xfs_io fiemap  failed (old kernel/wrong fs?)
generic/584       [not run] encryption policy '-c 9 -n 9 -v 2 -f 0' is 
unusable; probably missing kernel crypto API support
generic/592       [not run] kernel does not support encryption policy: 
'-c 1 -n 4 -v 2 -f 8'
generic/593 155s ...  223s
generic/595 161s ...  194s
generic/602       [not run] kernel does not support encryption policy: 
'-c 1 -n 4 -v 2 -f 16'
generic/613       [not run] _get_encryption_nonce() isn't implemented on 
ceph
generic/621       [not run] kernel doesn't support renameat2 syscall
generic/693       [not run] encryption policy '-c 1 -n 10 -v 2 -f 0' is 
unusable; probably missing kernel crypto API support
Ran: generic/395 generic/396 generic/397 generic/398 generic/399 
generic/419 generic/421 generic/429 generic/435 generic/440 generic/548 
generic/549 generic/550 generic/576 generic/580 generic/581 generic/582 
generic/583 generic/584 generic/592 generic/593 generic/595 generic/602 
generic/613 generic/621 generic/693
Not run: generic/398 generic/399 generic/419 generic/548 generic/549 
generic/550 generic/576 generic/582 generic/583 generic/584 generic/592 
generic/602 generic/613 generic/621 generic/693
Passed all 26 tests

On 27/10/2022 11:00, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>   common/encrypt | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/common/encrypt b/common/encrypt
> index 45ce0954..1a77e23b 100644
> --- a/common/encrypt
> +++ b/common/encrypt
> @@ -153,6 +153,9 @@ _scratch_mkfs_encrypted()
>   		# erase the UBI volume; reformated automatically on next mount
>   		$UBIUPDATEVOL_PROG ${SCRATCH_DEV} -t
>   		;;
> +	ceph)
> +		_scratch_cleanup_files
> +		;;
>   	*)
>   		_notrun "No encryption support for $FSTYP"
>   		;;

