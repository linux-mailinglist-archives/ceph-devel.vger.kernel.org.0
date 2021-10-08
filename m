Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 863CF426607
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Oct 2021 10:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbhJHIjf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 8 Oct 2021 04:39:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48905 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229868AbhJHIjf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 8 Oct 2021 04:39:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633682259;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=68/vA4lkUENr8iJ/eur5boJexHsk2jq9PCTyate5Vas=;
        b=gBouB8+e3TkzR+ueo1K5oQX37HNkAXRf8sr+BeUhh2tRD6EKkae+wKvtn2yQ/noSE3FyRQ
        3Y/1nkNkq8vI4KifY+GuRypDhdECvROp5p1RvywTucwcAPVa9l9TcyifghzpZNMOezPBIK
        MNyPHzOmSiyTQiH8tx6yEe4Qa0DDNrA=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-ooZBvamaMIeafBWVs6rSyw-1; Fri, 08 Oct 2021 04:37:38 -0400
X-MC-Unique: ooZBvamaMIeafBWVs6rSyw-1
Received: by mail-pf1-f199.google.com with SMTP id 3-20020a620603000000b0042aea40c2ddso4308941pfg.9
        for <ceph-devel@vger.kernel.org>; Fri, 08 Oct 2021 01:37:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=68/vA4lkUENr8iJ/eur5boJexHsk2jq9PCTyate5Vas=;
        b=Bzn1+boxJJ/83obcts2l4hxpfp7q+XYj2EDyhhkBvYwlD7h9mIVW+6ZQch1kCrMqxS
         Q41oNYOSWfCjxGT0rSsoM0TKVZlBG3/p9EMUMubMoIjKCYun8GwteyKrnFLYTnQlJFC2
         w7Yul+PMtCiY57tGvr0AUlt53DVmd1gm1wR3hc1x5lzB/a65TVus9RpmjlXKyumtze4h
         nY1JoWG/A2zZy6UsaAuN+7si2a+p+76q8Z53GghGWofmvtJUd6sSL+6yUoJowXWHFhrU
         EarKpBV0ZGIWVPKKodK4et75qKSHXGqcRPinDYz2FwgRHvMOO4Il+5W9fsQdS0yGXqen
         2w5w==
X-Gm-Message-State: AOAM530KdofB81pdL0tRwVmEjPFhHJSkIUHX7q71AahnTxWbwGXnrtGc
        jB2OQcSNJeYDQv7UY/SgAfQHUFHgpC5xs8wIew1A6li5D+ZdNTYgrx6W+u7L7yrzKweq7jsBUvJ
        6otmHIOhqPnskPy4xhm7rxw==
X-Received: by 2002:a63:1e0e:: with SMTP id e14mr3576850pge.5.1633682257358;
        Fri, 08 Oct 2021 01:37:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxT05XIyQTMRUOjUAFZhpdMti1Q8hE1BA2Jpt182U6evLGFNRaKGKOpFhL9xJhZzXAcvAD9HQ==
X-Received: by 2002:a63:1e0e:: with SMTP id e14mr3576836pge.5.1633682257090;
        Fri, 08 Oct 2021 01:37:37 -0700 (PDT)
Received: from [10.72.12.176] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a67sm1805864pfa.128.2021.10.08.01.37.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Oct 2021 01:37:36 -0700 (PDT)
Subject: Re: [PATCH v2] ceph: skip existing superblocks that are blocklisted
 when mounting
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, Patrick Donnelly <pdonnell@redhat.com>,
        Niels de Vos <ndevos@redhat.com>
References: <20210930170302.74924-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <48806320-292e-0f04-74ce-fe79e23d57d7@redhat.com>
Date:   Fri, 8 Oct 2021 16:37:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210930170302.74924-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 10/1/21 1:03 AM, Jeff Layton wrote:
> Currently when mounting, we may end up finding an existing superblock
> that corresponds to a blocklisted MDS client. This means that the new
> mount ends up being unusable.
>
> If we've found an existing superblock with a client that is already
> blocklisted, and the client is not configured to recover on its own,
> fail the match.
>
> While we're in here, also rename "other" to the more conventional "fsc".
>
> Cc: Patrick Donnelly <pdonnell@redhat.com>
> Cc: Niels de Vos <ndevos@redhat.com>
> URL: https://bugzilla.redhat.com/show_bug.cgi?id=1901499
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/super.c | 11 ++++++++---
>   1 file changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index f517ad9eeb26..a7f1b66a91a7 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -1123,16 +1123,16 @@ static int ceph_compare_super(struct super_block *sb, struct fs_context *fc)
>   	struct ceph_fs_client *new = fc->s_fs_info;
>   	struct ceph_mount_options *fsopt = new->mount_options;
>   	struct ceph_options *opt = new->client->options;
> -	struct ceph_fs_client *other = ceph_sb_to_client(sb);
> +	struct ceph_fs_client *fsc = ceph_sb_to_client(sb);
>   
>   	dout("ceph_compare_super %p\n", sb);
>   
> -	if (compare_mount_options(fsopt, opt, other)) {
> +	if (compare_mount_options(fsopt, opt, fsc)) {
>   		dout("monitor(s)/mount options don't match\n");
>   		return 0;
>   	}
>   	if ((opt->flags & CEPH_OPT_FSID) &&
> -	    ceph_fsid_compare(&opt->fsid, &other->client->fsid)) {
> +	    ceph_fsid_compare(&opt->fsid, &fsc->client->fsid)) {
>   		dout("fsid doesn't match\n");
>   		return 0;
>   	}
> @@ -1140,6 +1140,11 @@ static int ceph_compare_super(struct super_block *sb, struct fs_context *fc)
>   		dout("flags differ\n");
>   		return 0;
>   	}
> +	/* Exclude any blocklisted superblocks */
> +	if (fsc->blocklisted && !(fsopt->flags & CEPH_MOUNT_OPT_CLEANRECOVER)) {
> +		dout("mds client is blocklisted (and CLEANRECOVER is not set)\n");
> +		return 0;
> +	}
>   	return 1;
>   }
>   

LGTM.

Reviewed-by: Xiubo Li <xiubli@redhat.com>


