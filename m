Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7D34ED167
	for <lists+ceph-devel@lfdr.de>; Thu, 31 Mar 2022 03:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344739AbiCaBtu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 30 Mar 2022 21:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbiCaBtt (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 30 Mar 2022 21:49:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 88E45483AE
        for <ceph-devel@vger.kernel.org>; Wed, 30 Mar 2022 18:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648691282;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+5JFvosFX69ov+DEbF+/PGC5vW/Z35cU/7I8+B+oiAM=;
        b=gq+CVLP92dAFoYaIb/qFvJbymU+2Aw00c4vr8hXWdR83+en9nJNvJbJY95gM2YuyLIoew0
        sg3DAp4jk8+Z8mA9GvOan/OoFVl8cvv/n4j05ZAcnYk/SMotbGRi6b61NhI+7dzRswC13g
        eg0ckSSFvW5+JpuYAl3EaOvjzZ9F5Ns=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-137-TX51qjNZPlKzevwn1EIrYA-1; Wed, 30 Mar 2022 21:48:00 -0400
X-MC-Unique: TX51qjNZPlKzevwn1EIrYA-1
Received: by mail-pf1-f200.google.com with SMTP id w201-20020a627bd2000000b004fa92f4725bso13035300pfc.21
        for <ceph-devel@vger.kernel.org>; Wed, 30 Mar 2022 18:48:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=+5JFvosFX69ov+DEbF+/PGC5vW/Z35cU/7I8+B+oiAM=;
        b=KxIW8lOk37Ocxs9kTeH1blbNBbtvHU1ybV2LqGrW7g73wMKkCmToeMDuOxck0JQjdz
         Ruwbn8xuCOgl4asmBTgZ4xD3sTQk26OYqpmQ0y6irKZt1x3z7eo6i7hFOp0uRRRTHZLm
         XnwUJmHYEW3sB8IZg0NR8qrBTo+CReiMl52Tcy6VtK25jkeHMe4PVV7TcVQTUvFo/POg
         GzJ9mH4zqBVYOZPAfjIyi632gBb4Tj16WPXzoXjp5aNgwbq7Egu0T8wf7FpXZDzEEioM
         lTwiDEPn8HPLZxoFXeHyWKiTfGkzyVJgXErZ/G6FKAkPIuIeEG/NeYEZUfFruFB2/a4U
         msJQ==
X-Gm-Message-State: AOAM532xLkC6g9L/n85cLsVCZfSY/RZ6dk2Zv284s/e/i8Ie6K0l9Qgm
        NEim7qLFdYgc8El7GTuVkmAGlZqm830fPvzkdQSgvyHfepI7Qz1NY1Rlok+mJPCdyWddiJXOxKU
        gVqrMUCHCyeioc7IlRRaJnuFvxme2QnqZRYjgFclqo8hpRYFdqL3p2QH8w0WSiqvMp11a7a0=
X-Received: by 2002:a17:902:b488:b0:156:509c:5c42 with SMTP id y8-20020a170902b48800b00156509c5c42mr2586937plr.2.1648691279021;
        Wed, 30 Mar 2022 18:47:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyWkwqn9CrxOdzs5tqL+0Q/PI6SEYKfxJh//2rD8UzrWIh9P6U/1aoF+Zc9Piyy2BDcQ/daug==
X-Received: by 2002:a17:902:b488:b0:156:509c:5c42 with SMTP id y8-20020a170902b48800b00156509c5c42mr2586909plr.2.1648691278623;
        Wed, 30 Mar 2022 18:47:58 -0700 (PDT)
Received: from [10.72.12.110] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u204-20020a6279d5000000b004fa58625a80sm25066922pfc.53.2022.03.30.18.47.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Mar 2022 18:47:57 -0700 (PDT)
Subject: Re: [PATCH] ceph: discard r_new_inode if open O_CREAT opened existing
 inode
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com,
        =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20220330190457.73279-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <fa050107-0103-54d9-5e3c-2f29629d231d@redhat.com>
Date:   Thu, 31 Mar 2022 09:47:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220330190457.73279-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 3/31/22 3:04 AM, Jeff Layton wrote:
> When we do an unchecked create, we optimistically pre-create an inode
> and populate it, including its fscrypt context. It's possible though
> that we'll end up opening an existing inode, in which case the
> precreated inode will have a crypto context that doesn't match the
> existing data.
>
> If we're issuing an O_CREAT open and find an existing inode, just
> discard the precreated inode and create a new one to ensure the context
> is properly set.
>
> Cc: Luís Henriques <lhenriques@suse.de>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/mds_client.c | 10 ++++++++--
>   1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 840a60b812fc..b03128fdbb07 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -3504,13 +3504,19 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
>   	/* Must find target inode outside of mutexes to avoid deadlocks */
>   	rinfo = &req->r_reply_info;
>   	if ((err >= 0) && rinfo->head->is_target) {
> -		struct inode *in;
> +		struct inode *in = xchg(&req->r_new_inode, NULL);
>   		struct ceph_vino tvino = {
>   			.ino  = le64_to_cpu(rinfo->targeti.in->ino),
>   			.snap = le64_to_cpu(rinfo->targeti.in->snapid)
>   		};
>   
> -		in = ceph_get_inode(mdsc->fsc->sb, tvino, xchg(&req->r_new_inode, NULL));
> +		/* If we ended up opening an existing inode, discard r_new_inode */
> +		if (req->r_op == CEPH_MDS_OP_CREATE && !req->r_reply_info.has_create_ino) {
> +			iput(in);

If the 'in' has a delegated ino, should we give it back here ?

-- Xiubo


> +			in = NULL;
> +		}
> +
> +		in = ceph_get_inode(mdsc->fsc->sb, tvino, in);
>   		if (IS_ERR(in)) {
>   			err = PTR_ERR(in);
>   			mutex_lock(&session->s_mutex);

