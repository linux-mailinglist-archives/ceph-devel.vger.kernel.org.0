Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4772361EC67
	for <lists+ceph-devel@lfdr.de>; Mon,  7 Nov 2022 08:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbiKGHsd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 7 Nov 2022 02:48:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231235AbiKGHs2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 7 Nov 2022 02:48:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4113D2DE
        for <ceph-devel@vger.kernel.org>; Sun,  6 Nov 2022 23:47:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667807252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=52WLTkQahESKRvbE8wwCRR9ybE1ehJc40vrQX6Z9vt4=;
        b=IUZygIWt7ONI764kZAV2ivmX8672IO1JRARUH/FYGVUoYSlX5pFoNeblfuYGf1W9G/4S/d
        i6Pkl3mwf6905IWVNBzdwbZVj6mvrSMKFRk9XdIjpNK7YlH3zIcubhFCXtLeu11RRPT5GF
        2Qxzsy0Q8rBPJz8Iv6URY84scAYrkn0=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-480-7uw4q1A8PzWjJKmmU2oP2w-1; Mon, 07 Nov 2022 02:47:30 -0500
X-MC-Unique: 7uw4q1A8PzWjJKmmU2oP2w-1
Received: by mail-pg1-f199.google.com with SMTP id u63-20020a638542000000b004701a0aa835so5176658pgd.15
        for <ceph-devel@vger.kernel.org>; Sun, 06 Nov 2022 23:47:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=52WLTkQahESKRvbE8wwCRR9ybE1ehJc40vrQX6Z9vt4=;
        b=Gp8ikxt5wHf5PntpemzxyyR1ZrQk4JktQSQDZZHh+yHTf0XgwrFAI4nsY7x/bFRko4
         t6hRs77tYcTPpCbMH4Hm67+wYCJBNPdfJdalcuFsQyY0CRvuJ0daBDKDc5+iL3tNjcSB
         MezBvoLhmhTUVzPYbAxsLFyCA+2WOT0Dn1xaxl0ZtgvylA2FuOCEjhS0FvvZrzHKDKJ1
         wsdl16O/aaXRA01ww3RcIoVrIprZICryBCXcVAx90UbKMHXRNT2WqQWqolwNS9+M6jk0
         TRIWxn+7lIqmfC7SP3mogSGJmHH+/lkySwEdL3kpnYDswze6eKC6aUSFzr0Wv7YNmnl8
         qVIQ==
X-Gm-Message-State: ACrzQf00T5Wd++qiUDo6l04ym+DrNZp34NJyJKdLKHm7Z5Qogzop4ijp
        iL1vPl+oMWcqWlnmrdIrxDNS+lhzyisTIoYf5Efw+QBT/1/cH96Ufs258JomiGaA07GYTUYB4mA
        sFjZULYJZnvZLJAt2bepSmw==
X-Received: by 2002:aa7:8750:0:b0:56c:318a:f811 with SMTP id g16-20020aa78750000000b0056c318af811mr48662446pfo.14.1667807249693;
        Sun, 06 Nov 2022 23:47:29 -0800 (PST)
X-Google-Smtp-Source: AMsMyM58IgxAa4t6zhJ5Ig9aVRVRRguY43dC1mCgSfPeAWW24MmCEWrDnBo8UXHD4us991OwHxOLIg==
X-Received: by 2002:aa7:8750:0:b0:56c:318a:f811 with SMTP id g16-20020aa78750000000b0056c318af811mr48662426pfo.14.1667807249400;
        Sun, 06 Nov 2022 23:47:29 -0800 (PST)
Received: from [10.72.12.88] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id u15-20020a170903124f00b0016d72804664sm4294618plh.205.2022.11.06.23.47.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Nov 2022 23:47:29 -0800 (PST)
Subject: Re: [PATCH] ceph: fix memory leak in mount error path when using
 test_dummy_encryption
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221103153619.11068-1-lhenriques@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <700018a6-aff7-6e7a-98df-2fc8cca39acb@redhat.com>
Date:   Mon, 7 Nov 2022 15:47:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20221103153619.11068-1-lhenriques@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 03/11/2022 23:36, Luís Henriques wrote:
> Because ceph_init_fs_context() will never be invoced in case we get a
> mount error, destroy_mount_options() won't be releasing fscrypt resources
> with fscrypt_free_dummy_policy().  This will result in a memory leak.  Add
> an invocation to this function in the mount error path.
>
> Signed-off-by: Luís Henriques <lhenriques@suse.de>
> ---
>   fs/ceph/super.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 2224d44d21c0..6b9fd04b25cd 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -1362,6 +1362,7 @@ static int ceph_get_tree(struct fs_context *fc)
>   
>   	ceph_mdsc_close_sessions(fsc->mdsc);
>   	deactivate_locked_super(sb);
> +	fscrypt_free_dummy_policy(&fsc->fsc_dummy_enc_policy);

Hi Luis,

BTW, any reason the following code won't be triggered ?

deactivate_locked_super(sb);

   --> fs->kill_sb(s);

         --> ceph_kill_sb()

               --> kill_anon_super()

                     --> generic_shutdown_super()

                           --> sop->put_super()

                                 --> ceph_put_super()

                                       --> ceph_fscrypt_free_dummy_policy()

                                            --> fscrypt_free_dummy_policy(

Thanks!

- Xiubo


>   	goto out_final;
>   
>   out:
>

