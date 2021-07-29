Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C08F63D9BF5
	for <lists+ceph-devel@lfdr.de>; Thu, 29 Jul 2021 04:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233513AbhG2C5T (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 28 Jul 2021 22:57:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34706 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233507AbhG2C5R (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 22:57:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627527434;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sdWqcm2hTlWIjp2F33DCe6CouyBLxIxMPOxN3lEmDdw=;
        b=HU6GGnZUzdGSRqsMzo58bXLk9MFDmTy6MqhoT/pRdOGCv9Brely2o+FmfmdkWOa1my3LgK
        9XGaMEU/713nxSlLZtb+xaNsVKNvbkE/m8Zh4WKgXLIQSeXTSiPK3FFnMmq0uxfc81GnzP
        XHNbk3Dhrvkb90nYUE7sThEFvMAAEdY=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-hEci1EiPOEmnD63bmCx80A-1; Wed, 28 Jul 2021 22:57:13 -0400
X-MC-Unique: hEci1EiPOEmnD63bmCx80A-1
Received: by mail-pj1-f71.google.com with SMTP id j22-20020a17090a7e96b0290175fc969950so8787035pjl.4
        for <ceph-devel@vger.kernel.org>; Wed, 28 Jul 2021 19:57:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=sdWqcm2hTlWIjp2F33DCe6CouyBLxIxMPOxN3lEmDdw=;
        b=dxpbHFS1DiL0/Xvf4Lu5OjuG4xaVMp2g+4GON4r+9duOChgTVTB17+vSiwBxya5srE
         5vW3AcTCg45JPZFuLjcMKLb6pw76eUyGMi2xqxk0yp7X3pqYnxWLioqQ1yH6NXdIqTqU
         s8GYmQMFHSPSnXnMFlwcBqIrBD2UhEy3LHIA+yceIsGIXwQ/HWpk09fDU8V/3z+O/UXW
         n9m+x+fT0x1E0Ydhfnsmb3K2jQP71xkcZaWvs02+V9ZaaWLUEeZbQzjhw0GdEs4k/ZrI
         ATY0pHmH0PM1tyGaFoWQN7ZxE7YQ6+szI5hone9EbcIxoTP/3RR/DvJK9eSyPhhE0Fd2
         6SrA==
X-Gm-Message-State: AOAM531TDn83Qq2ssx+3qB6DzRV0yDd3QaBm/ENnXIyZsxvBkCa2/+I0
        ZhoqkwwglaWD9lSkpMtuv4Dcnj+eYANZhJiSPo644n8iIjD5nIAci93HQA1mEo2+6hLTAG4zb1r
        ymbC8bQMmklZft+ytMzCXIA==
X-Received: by 2002:a05:6a00:b83:b029:352:9507:f3b9 with SMTP id g3-20020a056a000b83b02903529507f3b9mr2758661pfj.13.1627527432098;
        Wed, 28 Jul 2021 19:57:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyFUhBfbEpIGgCt4bDAgwE1hRKyn+HRrrACWsCorJUjIHGukrjd78t1FTBp64fPpIfkG0Fr4g==
X-Received: by 2002:a05:6a00:b83:b029:352:9507:f3b9 with SMTP id g3-20020a056a000b83b02903529507f3b9mr2758653pfj.13.1627527431896;
        Wed, 28 Jul 2021 19:57:11 -0700 (PDT)
Received: from [10.72.13.192] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v23sm7603715pje.33.2021.07.28.19.57.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jul 2021 19:57:11 -0700 (PDT)
Subject: Re: [PATCH] ceph: cancel delayed work instead of flushing on mdsc
 teardown
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com
References: <20210727201230.178286-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <0c57b1e2-90a6-3580-3ca4-aa95cd1c7126@redhat.com>
Date:   Thu, 29 Jul 2021 10:56:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210727201230.178286-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 7/28/21 4:12 AM, Jeff Layton wrote:
> The first thing metric_delayed_work does is check mdsc->stopping,
> and then return immediately if it's set...which is good since we would
> have already torn down the metric structures at this point, otherwise.
>
> Worse yet, it's possible that the ceph_metric_destroy call could race
> with the delayed_work, in which case we could end up a end up accessing
> destroyed percpu variables.
>
> At this point in the mdsc teardown, the "stopping" flag has already been
> set, so there's no benefit to flushing the work. Just cancel it instead,
> and do so before we tear down the metrics structures.
>
> Cc: Xiubo Li <xiubli@redhat.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/mds_client.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index c43091a30ba8..d3f2baf3c352 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4977,9 +4977,9 @@ void ceph_mdsc_destroy(struct ceph_fs_client *fsc)
>   
>   	ceph_mdsc_stop(mdsc);
>   
> +	cancel_delayed_work_sync(&mdsc->metric.delayed_work);
>   	ceph_metric_destroy(&mdsc->metric);
>   

In the "ceph_metric_destroy()" it will also do 
"cancel_delayed_work_sync(&mdsc->metric.delayed_work)".

We can just move the it to the front of the _destory().



> -	flush_delayed_work(&mdsc->metric.delayed_work);
>   	fsc->mdsc = NULL;
>   	kfree(mdsc);
>   	dout("mdsc_destroy %p done\n", mdsc);

