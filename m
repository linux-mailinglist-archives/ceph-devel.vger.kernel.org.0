Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCFB4B6B43
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Feb 2022 12:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234546AbiBOLhP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Feb 2022 06:37:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbiBOLhN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Feb 2022 06:37:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B39DDBF54
        for <ceph-devel@vger.kernel.org>; Tue, 15 Feb 2022 03:37:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644925022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8bFKGgJX2HYBrm4eSNZUg0QjJpLcEPtgIhSyKMcDeVY=;
        b=Z8oHuLDNF9pcSKfjDFT1DpkV1FbAy+HtxvsuP5kjDOVRwTaJHiePSPyv/ZjaKiZkM3yAXV
        eErj4E/oOMFM8bD0ab9xmv6z4tr0GyJXcqOED7oo/JLRERBZ/O94M7J3U6BHcusXd5LvSZ
        7B7V+N7vofWiPMJgAAASl9NtgqO6B9Q=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-135-3LieRJAVPqCkrY2a8qaM_A-1; Tue, 15 Feb 2022 06:37:01 -0500
X-MC-Unique: 3LieRJAVPqCkrY2a8qaM_A-1
Received: by mail-qt1-f199.google.com with SMTP id l15-20020ac84ccf000000b002cf9424cfa5so14662070qtv.7
        for <ceph-devel@vger.kernel.org>; Tue, 15 Feb 2022 03:37:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=8bFKGgJX2HYBrm4eSNZUg0QjJpLcEPtgIhSyKMcDeVY=;
        b=kUZI3kI9dmhFG2XH4ldNTWc2r4wmoAJbcKvpiwvgzIVjjQ51RD4Q9UEgOb+ZKJ4ih+
         TE7+Ey3VckQLDcpHys0dBTAymme4Jx0kggrgiaHTQ24oQBms2bcJUF/nyoAELdPSJBk0
         ZUpM/ZHNgmhtXR4CjJOhr89DFJTJ50cSallXxB/38fRlXjBBS65Knd0B1GYNA04eeywL
         aNevigwXweAZB4D4ZU68ALjkoNDORCxnJ1egmbwEYFQ6xNIvTp3S6+j7pEsK8uC7YAqb
         9fEsmE6Lz30gnHh2R+U4FlDp1f0wr0vn63PTCQayL0sqBCo0jync/ZDWopTrCizbDnUw
         /U5Q==
X-Gm-Message-State: AOAM530dvRJ3sQI23Gpfjf8tUjCTmickUdXtQHGTiMi7EOZ2U8nm4aKC
        /hWT9VNkLiyEDCPSyFBTQfARuB3AoUmySx95bg5C/ZkfWI6v2UdfPN9UVhnoR1KQRji1Py9wGH8
        tjhglFKUTMClhyu2nISsGMQ==
X-Received: by 2002:a37:ad06:: with SMTP id f6mr1688865qkm.668.1644925021029;
        Tue, 15 Feb 2022 03:37:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz9uOCsuFk2iPE9qdCBBUq/Bm5qoyYjwpK9bqAwgKcuaTXwaeRiUoI+r9SYhUZ/6zpLQ/wMCA==
X-Received: by 2002:a37:ad06:: with SMTP id f6mr1688860qkm.668.1644925020797;
        Tue, 15 Feb 2022 03:37:00 -0800 (PST)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id i18sm1569480qka.80.2022.02.15.03.37.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 03:37:00 -0800 (PST)
Message-ID: <a95f3800460d968865642a3c6d9a68ba56823946.camel@redhat.com>
Subject: Re: [PATCH 3/3] ceph: use tracked average r/w/m latencies to
 display metrics in debugfs
From:   Jeff Layton <jlayton@redhat.com>
To:     Venky Shankar <vshankar@redhat.com>, xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org
Date:   Tue, 15 Feb 2022 06:36:59 -0500
In-Reply-To: <20220215091657.104079-4-vshankar@redhat.com>
References: <20220215091657.104079-1-vshankar@redhat.com>
         <20220215091657.104079-4-vshankar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2022-02-15 at 14:46 +0530, Venky Shankar wrote:
> Signed-off-by: Venky Shankar <vshankar@redhat.com>
> ---
>  fs/ceph/debugfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> index 3cf7c9c1085b..acc5cb3ad0ef 100644
> --- a/fs/ceph/debugfs.c
> +++ b/fs/ceph/debugfs.c
> @@ -186,7 +186,7 @@ static int metrics_latency_show(struct seq_file *s, void *p)
>  		spin_lock(&m->lock);
>  		total = m->total;
>  		sum = m->latency_sum;
> -		avg = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
> +		avg = m->latency_avg;
>  		min = m->latency_min;
>  		max = m->latency_max;
>  		sq = m->latency_sq_sum;

I see this warning with this patch:

fs/ceph/debugfs.c: In function ‘metrics_latency_show’:
fs/ceph/debugfs.c:178:20: warning: variable ‘sum’ set but not used [-Wunused-but-set-variable]
  178 |         s64 total, sum, avg, min, max, sq;
      |                    ^~~

I think the "sum" var can be eliminated from this function now? I'll go
ahead and make that change in there. You don't need resend.
-- 
Jeff Layton <jlayton@redhat.com>

