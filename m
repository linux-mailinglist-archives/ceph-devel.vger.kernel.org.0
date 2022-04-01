Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B67174EE583
	for <lists+ceph-devel@lfdr.de>; Fri,  1 Apr 2022 02:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241520AbiDAAxd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 31 Mar 2022 20:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbiDAAxc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 31 Mar 2022 20:53:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B6D27249C72
        for <ceph-devel@vger.kernel.org>; Thu, 31 Mar 2022 17:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648774303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3zm3IqxCgUI92IA0dg8vg8QruFvWAfp9U6+c73wTcLA=;
        b=e2jSt8eWY2Ww1Thwk/JjgmezUYQEtgyb6xWb8oV+m0949BMrltwQbjXfj0M/CfYyvrUzEg
        DuTphzLTcgIo6eT0x6ZZaqx1/1os9eGXs8RYOfaifDr86Sfs9adeJcOVAOrn1Biuc1eq4X
        DK1hprZNhvXF8UIPD3iyXtnGd9zQtI0=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-533-oJAPczpqOhK9abYPdZfaag-1; Thu, 31 Mar 2022 20:51:40 -0400
X-MC-Unique: oJAPczpqOhK9abYPdZfaag-1
Received: by mail-pj1-f70.google.com with SMTP id oj16-20020a17090b4d9000b001c7552b7546so2737730pjb.8
        for <ceph-devel@vger.kernel.org>; Thu, 31 Mar 2022 17:51:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=3zm3IqxCgUI92IA0dg8vg8QruFvWAfp9U6+c73wTcLA=;
        b=6H5xPzV0p6b6p+V4SPbZwqvp6/utxu5Rsofpn8ZosDlosQXv6Lw/uEut5v+oFx14Fu
         Wp1zuhoVdgG93ctTpEtin8A1tm+6uM2RkK0k+YqJ4hEDP05D58wgBHc0erYvDxzeSaUz
         cqTkIqzz4ttYazQmpTV9i7Bl0LWawOtIxf1umtJgp/YztRpN3MRTfCQH4M0iRhacxBJf
         vISzzc195rxgIAHjMmlA0ef7aSHkd+bZkTOKBxqr5Yjq8n6l3PklwtUDrdS+ycqfauKc
         A2wm/TV9XDTDFxHkXDXnd+NPzotd/1zrAe1124HMRms6qRXO5lcjRZfYtfG67LtFYGhk
         M7pw==
X-Gm-Message-State: AOAM530Pzwvu+sNusbbeai+bgiOUegkY4MF3YtbbIgLS1Z1IrflxNex7
        G/mXR1xWAIccQiB5P0qycFE1lANyzrDmdt+biWck+vHlXZF8WqFP1XrPJEgxMuiaUDsEQCCF7a8
        hchyvjQGwmwpUjHYyToR0MA==
X-Received: by 2002:a17:903:230c:b0:156:e47:387e with SMTP id d12-20020a170903230c00b001560e47387emr7917495plh.119.1648774298852;
        Thu, 31 Mar 2022 17:51:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz9ErqG+g64cCcnAzTNmtyiIUQkOC3kFZPtYufakhR3f/vlQ0QrfkedQ5OBcxt4BBxCz3MTIg==
X-Received: by 2002:a17:903:230c:b0:156:e47:387e with SMTP id d12-20020a170903230c00b001560e47387emr7917477plh.119.1648774298564;
        Thu, 31 Mar 2022 17:51:38 -0700 (PDT)
Received: from [10.72.12.110] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k22-20020aa788d6000000b004faaf897064sm653555pff.106.2022.03.31.17.51.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Mar 2022 17:51:38 -0700 (PDT)
Subject: Re: [PATCH v2] ceph: discard r_new_inode if open O_CREAT opened
 existing inode
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com,
        =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
References: <20220331095931.6261-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <4af1e9ad-7870-f6fa-6600-1633c9871a91@redhat.com>
Date:   Fri, 1 Apr 2022 08:51:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220331095931.6261-1-jlayton@kernel.org>
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


On 3/31/22 5:59 PM, Jeff Layton wrote:
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
> Also, we should never end up opening an existing file on an async
> create, since we should know that the dentry doesn't exist. Throw a
> warning if that ever does occur.
>
> Cc: Luís Henriques <lhenriques@suse.de>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/mds_client.c | 12 ++++++++++--
>   1 file changed, 10 insertions(+), 2 deletions(-)
>
> v2: WARN if this ever happens on an async create
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 840a60b812fc..b3cf3a22fa2a 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -3504,13 +3504,21 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
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
> +			/* This should never happen on an async create */
> +			WARN_ON_ONCE(req->r_deleg_ino);
> +			iput(in);
> +			in = NULL;
> +		}
> +
> +		in = ceph_get_inode(mdsc->fsc->sb, tvino, in);
>   		if (IS_ERR(in)) {
>   			err = PTR_ERR(in);
>   			mutex_lock(&session->s_mutex);

LGTM.

Reviewed-by: Xiubo Li <xiubli@redhat.com>


