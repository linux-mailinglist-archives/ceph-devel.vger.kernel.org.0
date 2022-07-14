Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE7B57409E
	for <lists+ceph-devel@lfdr.de>; Thu, 14 Jul 2022 02:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbiGNAlT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 13 Jul 2022 20:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiGNAlS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 13 Jul 2022 20:41:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9E44FB2A
        for <ceph-devel@vger.kernel.org>; Wed, 13 Jul 2022 17:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657759276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lwD3erQpPNSOz6q5ss5qdxr+FRZ8OhCKFE6LEfX9RG0=;
        b=HNd8VtXqFmPNFAdM6gWH3atFbTp+k164gow16wlq9mKufjvPdnB+tmDCKqYAlH0+ntirCb
        imf1R9Dzi9lDjJU8BuEfJHUb2Ekt4TmmOn6Hsnc7bpjSiE1vH2TS5ZhV5Dm6FG/D898AKd
        6uiQD4Xq9pz6zB9mOT4auOSNEBEg7yI=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-452-MhKM6hXLOmOUKHLtfFRYCg-1; Wed, 13 Jul 2022 20:41:15 -0400
X-MC-Unique: MhKM6hXLOmOUKHLtfFRYCg-1
Received: by mail-pj1-f69.google.com with SMTP id pt7-20020a17090b3d0700b001efb2800e55so277740pjb.3
        for <ceph-devel@vger.kernel.org>; Wed, 13 Jul 2022 17:41:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=lwD3erQpPNSOz6q5ss5qdxr+FRZ8OhCKFE6LEfX9RG0=;
        b=w5L2M4uBcdXSlrAe9yQr0v+xIiGG4+4EkguFtt3lbGf/jrIZu7wdrZi1nIPbdAUil/
         tzhECsl+WxZL9LO60eDw2xXmO5ECw6fxeCcZhyBxnXhFzx/yv1gthy7qgZQ/hl5GTsRx
         WdrUhtHmC5szKEkn8iiUTFCIuzQtonZB9ddW2RIhgG7ZmQlcOLmTBmbroZ4ZZiysx8dy
         /SV70YO0muwt9asciujXZSVDHs/nWRUftVKtkKb+8vpE0j2ex7iZtyyt8P4F5tRwPiF0
         6VDvVHGCjMbwDMAi5qqsDxVjkzKzkH7zX8+8KoSvHS+Qi7H5W4lpN3DNPtmXyQE/q5Sv
         XF8Q==
X-Gm-Message-State: AJIora/9pW0zh4EYM3A0QysgikNlc8o8yJqQHnzROf/fPaF/9cZMU6Qr
        qF3tFckeKB5UKkfLqn+TqovkChUMYWMPBoGVvS3YxRwM35SjQxM4HbmCIto8PyTV9SwLEAxeGA0
        xtMDi/EG9bk6JWmQuQQXFDw==
X-Received: by 2002:a65:5845:0:b0:411:9797:cb21 with SMTP id s5-20020a655845000000b004119797cb21mr4840753pgr.503.1657759274528;
        Wed, 13 Jul 2022 17:41:14 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1spgYJ4dzpDv2YUlv3SqrNnprVic78HPNsky1f245LLxVVFJn0t8f15MQBdSSSYToCZVZG5Zg==
X-Received: by 2002:a65:5845:0:b0:411:9797:cb21 with SMTP id s5-20020a655845000000b004119797cb21mr4840730pgr.503.1657759274140;
        Wed, 13 Jul 2022 17:41:14 -0700 (PDT)
Received: from [10.72.14.22] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 199-20020a6218d0000000b0052abc2438f1sm158215pfy.55.2022.07.13.17.41.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jul 2022 17:41:13 -0700 (PDT)
Subject: Re: [PATCH] ceph: fix up test_dummy_encryption handling for new mount
 API
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        idryomov@gmail.com
Cc:     vshankar@redhat.com, linux-kernel@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>
References: <20220713085641.50232-1-xiubli@redhat.com>
 <c280ce5cc43474aa17767530bf280045b128e7af.camel@kernel.org>
 <b82c4486-42ea-cdd1-8204-6dcc95836f72@redhat.com>
 <5edd2424465dc97e15d3e4635c7011e5c789cef1.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <34410c5d-6bfd-77cf-bbe3-4d9d66dc0a43@redhat.com>
Date:   Thu, 14 Jul 2022 08:41:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <5edd2424465dc97e15d3e4635c7011e5c789cef1.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 7/14/22 2:56 AM, Jeff Layton wrote:
> On Wed, 2022-07-13 at 20:55 +0800, Xiubo Li wrote:
>> Hi Jeff,
>>
>> I am rebasing the 'wip-fscrypt' branch to the 'testing', and there is
>> one commit conflicts:
>>
>> commit 81faddddbef409bcaa1aa3d89e59606cde94dab7
>> Author: Jeff Layton <jlayton@kernel.org>
>> Date:   Wed Dec 1 09:21:39 2021 -0500
>>
>>       ceph: add infrastructure for file encryption and decryption
>>
>>       ...and allow test_dummy_encryption to bypass content encryption
>>       if mounted with test_dummy_encryption=clear.
>>
>>       Reviewed-by: Xiubo Li <xiubli@redhat.com>
>>       Signed-off-by: Jeff Layton <jlayton@kernel.org>
>>
>> And the conflicts are:
>>
>> [xiubli@fedora ]$ cat fs/ceph/super.h.rej
>> --- fs/ceph/super.h
>> +++ fs/ceph/super.h
>> @@ -45,6 +45,7 @@
>>    #define CEPH_MOUNT_OPT_NOPAGECACHE     (1<<16) /* bypass pagecache
>> altogether */
>>    #define CEPH_MOUNT_OPT_SPARSEREAD      (1<<17) /* always do sparse
>> reads */
>>    #define CEPH_MOUNT_OPT_TEST_DUMMY_ENC  (1<<18) /* enable dummy
>> encryption (for testing) */
>> +#define CEPH_MOUNT_OPT_DUMMY_ENC_CLEAR (1<<19) /* don't actually
>> encrypt content */
>>
>>    #define CEPH_MOUNT_OPT_DEFAULT            \
>>        (CEPH_MOUNT_OPT_DCACHE |        \
>>
>> [xiubli@fedora ]$ cat fs/ceph/super.c.rej
>> --- fs/ceph/super.c
>> +++ fs/ceph/super.c
>> @@ -1098,6 +1098,14 @@ static int ceph_set_test_dummy_encryption(struct
>> super_block *sb, struct fs_cont
>>                return -EEXIST;
>>            }
>>
>> +        /* HACK: allow for cleartext "encryption" in files for testing */
>> +        if (fsc->mount_options->test_dummy_encryption &&
>> + !strcmp(fsc->mount_options->test_dummy_encryption, "clear")) {
>> +            fsopt->flags |= CEPH_MOUNT_OPT_DUMMY_ENC_CLEAR;
>> + kfree(fsc->mount_options->test_dummy_encryption);
>> +            fsc->mount_options->test_dummy_encryption = NULL;
>> +        }
>> +
>>            err = fscrypt_set_test_dummy_encryption(sb,
>> fsc->mount_options->test_dummy_encryption,
>>                                &fsc->dummy_enc_policy);
>>
>> And I have pushed the tmp patches to
>> https://github.com/lxbsz/ceph-client/commits/lxb-wip-fscrypt3.
>>
>> Please take a look is that okay ?
>>
>> Thanks
>>
>> -- Xiubo
>>
>>
> The result looks good to me. Thanks for fixing this up.

Cool. Thanks Jeff!


>

