Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD65958C7FC
	for <lists+ceph-devel@lfdr.de>; Mon,  8 Aug 2022 13:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242905AbiHHL46 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 8 Aug 2022 07:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236317AbiHHL45 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 8 Aug 2022 07:56:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 920B7F69
        for <ceph-devel@vger.kernel.org>; Mon,  8 Aug 2022 04:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659959813;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6TsElmCORhqXP8jgwrJUUvOp+RZV2x4q8imaLygih6I=;
        b=FK0jFaEqsb92pr+4ukqunsoA+BdfhWMJvRLkrd+b07f7/V32C+fpP+04nxDgkmMZfVyzsv
        4zCyghA0shM3w24KxKlfsEGU+mHEScdLdYnMJ/k15KElmCrGCyChBjqm4TVdWhuDXhZ1WS
        uqc4O/0PwHEHwvFXGemWokSFDoSBCN4=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-146-rD9IJpf0MwmgX39oEJgsjw-1; Mon, 08 Aug 2022 07:56:52 -0400
X-MC-Unique: rD9IJpf0MwmgX39oEJgsjw-1
Received: by mail-pf1-f198.google.com with SMTP id i23-20020aa78b57000000b0052efad0d2eeso1903342pfd.15
        for <ceph-devel@vger.kernel.org>; Mon, 08 Aug 2022 04:56:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=6TsElmCORhqXP8jgwrJUUvOp+RZV2x4q8imaLygih6I=;
        b=HDqKXPeMo3awnYJo2WplRLAhWu76wh/hhHFQ6ce8yJ9EG20sOGI0SHSCHxQYA4+X+t
         NcF0yDY0picpHqEa0434aG1Re+7K+q9zdUyTDvQxrq0JSwIicoVJ+KenLn3oHqSCsal7
         GpQZF3U8bmOvQzNRJ1TINPVIJtYi+ngdQ867GmTLdb2q/c0hFqNH1Sw+uMpU+lwZaEEM
         FxCcvDAyeOADmVgJ6+hBd+e5EV51uofysw3eBc6SwljVrtMquuNciys3vgNUNTlxjspB
         junjbdu98XHHAH0WQdN64Vz4cMg7ExGFLW5jKTWjstpHVjo/QRB7OxCHJ8ykuG9TRHaH
         aaSg==
X-Gm-Message-State: ACgBeo3BwUPVbyjHNgJMRDhfJO7MQL578v6yJQEfVRPPz0UN8+3kVcDt
        9iTor05Hx0rKCfnMUY952GqBHCqj0+yUG/p0HzJnfSbfaiAviVjCeSevJZT5F81Eo4qVTBOCsa9
        f4WoluAbpNcJeAP3kEEwymA==
X-Received: by 2002:a63:b95e:0:b0:41d:6498:2ad5 with SMTP id v30-20020a63b95e000000b0041d64982ad5mr5220522pgo.446.1659959811202;
        Mon, 08 Aug 2022 04:56:51 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4C3sNPs6TggvMZ4t7Q7yksKQiNSRb4z6RQlytFFTEdh74+vSsCOXNYe9sU2IgG9chhA2nNeQ==
X-Received: by 2002:a63:b95e:0:b0:41d:6498:2ad5 with SMTP id v30-20020a63b95e000000b0041d64982ad5mr5220501pgo.446.1659959810869;
        Mon, 08 Aug 2022 04:56:50 -0700 (PDT)
Received: from [10.72.12.61] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b7-20020a1709027e0700b0016cf195eb16sm1338072plm.185.2022.08.08.04.56.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Aug 2022 04:56:50 -0700 (PDT)
Subject: Re: [RFC PATCH 4/4] ceph: fill in the change attribute in statx
 requests
To:     Jeff Layton <jlayton@kernel.org>, linux-fsdevel@vger.kernel.org
Cc:     dhowells@redhat.com, lczerner@redhat.com, bxue@redhat.com,
        ceph-devel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <20220805183543.274352-1-jlayton@kernel.org>
 <20220805183543.274352-5-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <42ec7d51-71ee-03b2-39bc-1ea624880a3e@redhat.com>
Date:   Mon, 8 Aug 2022 19:56:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220805183543.274352-5-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 8/6/22 2:35 AM, Jeff Layton wrote:
> When statx requests the change attribute, request the full gamut of caps
> (similarly to how ctime is handled). When the change attribute seems to
> be valid, return it in the chgattr field.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/inode.c | 14 +++++++++-----
>   1 file changed, 9 insertions(+), 5 deletions(-)
>
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 56c53ab3618e..fb2ed85f9083 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -2408,10 +2408,10 @@ static int statx_to_caps(u32 want, umode_t mode)
>   {
>   	int mask = 0;
>   
> -	if (want & (STATX_MODE|STATX_UID|STATX_GID|STATX_CTIME|STATX_BTIME))
> +	if (want & (STATX_MODE|STATX_UID|STATX_GID|STATX_CTIME|STATX_BTIME|STATX_CHGATTR))
>   		mask |= CEPH_CAP_AUTH_SHARED;
>   
> -	if (want & (STATX_NLINK|STATX_CTIME)) {
> +	if (want & (STATX_NLINK|STATX_CTIME|STATX_CHGATTR)) {
>   		/*
>   		 * The link count for directories depends on inode->i_subdirs,
>   		 * and that is only updated when Fs caps are held.
> @@ -2422,11 +2422,10 @@ static int statx_to_caps(u32 want, umode_t mode)
>   			mask |= CEPH_CAP_LINK_SHARED;
>   	}
>   
> -	if (want & (STATX_ATIME|STATX_MTIME|STATX_CTIME|STATX_SIZE|
> -		    STATX_BLOCKS))
> +	if (want & (STATX_ATIME|STATX_MTIME|STATX_CTIME|STATX_SIZE| STATX_BLOCKS|STATX_CHGATTR))
>   		mask |= CEPH_CAP_FILE_SHARED;
>   
> -	if (want & (STATX_CTIME))
> +	if (want & (STATX_CTIME|STATX_CHGATTR))
>   		mask |= CEPH_CAP_XATTR_SHARED;
>   
>   	return mask;
> @@ -2468,6 +2467,11 @@ int ceph_getattr(struct user_namespace *mnt_userns, const struct path *path,
>   		valid_mask |= STATX_BTIME;
>   	}
>   
> +	if (request_mask & STATX_CHGATTR) {
> +		stat->chgattr = inode_peek_iversion_raw(inode);
> +		valid_mask |= STATX_CHGATTR;
> +	}
> +
>   	if (ceph_snap(inode) == CEPH_NOSNAP)
>   		stat->dev = inode->i_sb->s_dev;
>   	else

Reviewed-by: Xiubo Li <xiubli@redhat.com>


