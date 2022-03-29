Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 956A24EA45C
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Mar 2022 03:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbiC2A7E (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 28 Mar 2022 20:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiC2A7D (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 28 Mar 2022 20:59:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 45E2CDE098
        for <ceph-devel@vger.kernel.org>; Mon, 28 Mar 2022 17:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648515440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6dez9gWvcoysmMe5n4AzLh4dnpw25uEaC2kmuCk0rjg=;
        b=CJtR11XRHY718MwQ66sdEnVy2laH5jycAqgNOOc58tKKvxItb10eLodcDJf6lhzu0tSNhm
        2u5/amtlVSXttc6fScmiD5qwGxY13XNfHCXYJut8E2lDCQMRPr7VmWB30BiHJy2MQaC1A9
        1c8kvPLZ9RyCOpXvUzG6PlSOj1KzcXk=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-446-lWUYoZrrPEmcnnRP4e199Q-1; Mon, 28 Mar 2022 20:57:18 -0400
X-MC-Unique: lWUYoZrrPEmcnnRP4e199Q-1
Received: by mail-pl1-f197.google.com with SMTP id i4-20020a170902eb4400b001561d3be0f3so865513pli.15
        for <ceph-devel@vger.kernel.org>; Mon, 28 Mar 2022 17:57:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=6dez9gWvcoysmMe5n4AzLh4dnpw25uEaC2kmuCk0rjg=;
        b=qEEGyODXw097BoeXRWpMzQ1F0dI31rjzjg+mU1fjK1yhU1dN5I676lW8x0rE8/KI0l
         J7ikbQDSOQWJwzGYGLE6vdN63RfbBLe/h7tkrFjQhwtyZBFCZzZGR72jBcxS3DmWaFzE
         obpLW6fbDXzEXwyQEuCZcu7+dXk2Iq2gQDH5DxXT8ePC7PqpEOF4TRKccCoTSIgH34kI
         5BG24QjJrKLtdFd7AaOlTdrP436j2ijg2y3XrZlsCcL9z6pnDxkGq/GD65E5Bb1gIj8M
         cYvkUnzpRHUr4ZNdjSuFaTL/Z4GUNyCfm1hHqGM+cv7nW27iw4LQ56u+oA/M6kM4Zj56
         Lr2A==
X-Gm-Message-State: AOAM530NVeRRCgl3ConBn/pv51V1AYUvAHiPoC3akcMGfU1ulLyywKCH
        XhimbWAnEQazGnLHJdyR1Na/EOvuTSDKwBXbcuUEeMUNNKOzlDD6DOp03HNC4qkz0uXoeZlSHAt
        BFIqdncrhY9B6EVIUdfw2HA==
X-Received: by 2002:a05:6a00:846:b0:4fb:3b79:fc94 with SMTP id q6-20020a056a00084600b004fb3b79fc94mr11596647pfk.76.1648515437449;
        Mon, 28 Mar 2022 17:57:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxYAOQezY9OpvpmEtlAKJM4EXvSR/rscom6wYjOMWZBHkiU47XuyWHbEOR/d33XfaUjTLAj4A==
X-Received: by 2002:a05:6a00:846:b0:4fb:3b79:fc94 with SMTP id q6-20020a056a00084600b004fb3b79fc94mr11596626pfk.76.1648515437200;
        Mon, 28 Mar 2022 17:57:17 -0700 (PDT)
Received: from [10.72.12.110] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h2-20020a056a00170200b004fae65cf154sm17193577pfc.219.2022.03.28.17.57.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Mar 2022 17:57:16 -0700 (PDT)
Subject: Re: [PATCH] ceph: set DCACHE_NOKEY_NAME in atomic open
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, lhenriques@suse.de
References: <20220328203351.79603-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <c33e12d4-8deb-987b-55fd-e4e370012a14@redhat.com>
Date:   Tue, 29 Mar 2022 08:57:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220328203351.79603-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 3/29/22 4:33 AM, Jeff Layton wrote:
> Atomic open can act as a lookup if handed a dentry that is negative on
> the MDS. Ensure that we set DCACHE_NOKEY_NAME on the dentry in
> atomic_open, if we don't have the key for the parent. Otherwise, we can
> end up validating the dentry inappropriately if someone later adds a
> key.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/file.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
>
> Another patch for the fscrypt series.
>
> A much less heavy-handed fix for generic/580 and generic/593. I'll
> probably fold this into an earlier patch in the series since it appears
> to be a straightforward bug.
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index eb04dc8f1f93..5072570c2203 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -765,8 +765,14 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>   	req->r_args.open.mask = cpu_to_le32(mask);
>   	req->r_parent = dir;
>   	ihold(dir);
> -	if (IS_ENCRYPTED(dir))
> +	if (IS_ENCRYPTED(dir)) {
>   		set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
> +		if (!fscrypt_has_encryption_key(dir)) {
> +			spin_lock(&dentry->d_lock);
> +			dentry->d_flags |= DCACHE_NOKEY_NAME;
> +			spin_unlock(&dentry->d_lock);
> +		}
> +	}
>   
>   	if (flags & O_CREAT) {
>   		struct ceph_file_layout lo;
Reviewed-by: Xiubo Li <xiubli@redhat.com>

