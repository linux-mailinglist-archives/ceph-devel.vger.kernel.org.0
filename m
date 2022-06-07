Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 509FA53FF2D
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Jun 2022 14:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244074AbiFGMn3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Jun 2022 08:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235690AbiFGMn2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 7 Jun 2022 08:43:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 86D571C91F
        for <ceph-devel@vger.kernel.org>; Tue,  7 Jun 2022 05:43:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654605806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c00Ksb7eMAPjHP90uTIC7eq8xGmVJDrpEBh2hYRXSas=;
        b=Ar1LyJF8RBaTwHJ67c+p7yJeVgWWMq69RJESAs5vd98rTW9uESPL+I52E3+7CwyM39ROxm
        L2+tl5Z6X8pr9GCApwbAEk6MVTnhWG/SBF+l+5SkHSPhCGThZnv7F8sE8haoibFHgGW1Q/
        kSLshjmIwzdffOm7vshxsq8v58PeuXo=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-615-eis4lO01Ocylhs9V65tQkQ-1; Tue, 07 Jun 2022 08:43:25 -0400
X-MC-Unique: eis4lO01Ocylhs9V65tQkQ-1
Received: by mail-pj1-f69.google.com with SMTP id q9-20020a17090a1b0900b001e87ad1beadso4052430pjq.1
        for <ceph-devel@vger.kernel.org>; Tue, 07 Jun 2022 05:43:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=c00Ksb7eMAPjHP90uTIC7eq8xGmVJDrpEBh2hYRXSas=;
        b=BhxdZpgqEkFuKJb5pqMQAW+rWQYdICXq30slSdCtTGzs5mNfYzyHGviI9lpiawaPZQ
         lxn+X6nRQ49uO+iYh77eDU//zhxc7vipNhu7MOL44J9wzHUqDs0dpETql1WJHpeML6Zs
         ThvOE1M7axNS0ZyFiYE8DryBDz7oKObaI55oiUB9tkOQ8MzE9rekqpA1CQs34nKfDP/6
         FnUAIqI0OQz2aqY7BzmPOJ39lrxLybCz3bovP+tXpfifaZvf/x233k/zucv6T3Q41KCZ
         1kIGXWAZgpHw7m6hL9/dle2TGjo0Y8vunLLjPXr/mHBwHVf9FLGV8TXkImDZkl0uqnKQ
         mEdg==
X-Gm-Message-State: AOAM531SFLGKYHttsajnmCOW9qA8I4ZtzIAZ3mLEGne8GEWSQuOH6Jdl
        eCQuRUS7kpLO4mZI2MPDEbJrEFoorCWkQRLXzusuuZ3KdVV71goTGngenbBjCoMd+eE6/GM98vz
        zYxVx8+EjK7RgCHTwVA8KVWcI9h6Oqqxq9xKDJ8omy6FtzwlxnUxjdeFjtv9ScxyZOD95DpU=
X-Received: by 2002:a17:90a:1b61:b0:1e2:c247:bf5e with SMTP id q88-20020a17090a1b6100b001e2c247bf5emr32236508pjq.68.1654605803981;
        Tue, 07 Jun 2022 05:43:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzgy9a9QpGP4ap0CUT2L2rv7HmjzwIRwYSI3zsQRlQFnYEkqR+6lMfLE+TwWuhE1Hv178hddg==
X-Received: by 2002:a17:90a:1b61:b0:1e2:c247:bf5e with SMTP id q88-20020a17090a1b6100b001e2c247bf5emr32236489pjq.68.1654605803647;
        Tue, 07 Jun 2022 05:43:23 -0700 (PDT)
Received: from [10.72.12.54] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u18-20020a62ed12000000b0050dc7628191sm12765868pfh.107.2022.06.07.05.43.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jun 2022 05:43:22 -0700 (PDT)
Subject: Re: [PATCH] ceph: don't implement writepage
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org
References: <20220607112703.17997-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <de924b6d-fc2f-175f-fc23-6ad04071a5b0@redhat.com>
Date:   Tue, 7 Jun 2022 20:43:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220607112703.17997-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/7/22 7:27 PM, Jeff Layton wrote:
> Remove ceph_writepage as it's not strictly required these days.
>
> To quote from commit 21b4ee7029c9 (xfs: drop ->writepage completely):
>
>      ->writepage is only used in one place - single page writeback from
>      memory reclaim. We only allow such writeback from kswapd, not from
>      direct memory reclaim, and so it is rarely used. When it comes from
>      kswapd, it is effectively random dirty page shoot-down, which is
>      horrible for IO patterns. We will already have background writeback
>      trying to clean all the dirty pages in memory as efficiently as
>      possible, so having kswapd interrupt our well formed IO stream only
>      slows things down. So get rid of xfs_vm_writepage() completely.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/addr.c | 25 -------------------------
>   1 file changed, 25 deletions(-)
>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 40830cb9b599..3489444c55b9 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -680,30 +680,6 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
>   	return err;
>   }
>   
> -static int ceph_writepage(struct page *page, struct writeback_control *wbc)
> -{
> -	int err;
> -	struct inode *inode = page->mapping->host;
> -	BUG_ON(!inode);
> -	ihold(inode);
> -
> -	if (wbc->sync_mode == WB_SYNC_NONE &&
> -	    ceph_inode_to_client(inode)->write_congested)
> -		return AOP_WRITEPAGE_ACTIVATE;
> -
> -	wait_on_page_fscache(page);
> -
> -	err = writepage_nounlock(page, wbc);
> -	if (err == -ERESTARTSYS) {
> -		/* direct memory reclaimer was killed by SIGKILL. return 0
> -		 * to prevent caller from setting mapping/page error */
> -		err = 0;
> -	}
> -	unlock_page(page);
> -	iput(inode);
> -	return err;
> -}
> -
>   /*
>    * async writeback completion handler.
>    *
> @@ -1394,7 +1370,6 @@ static int ceph_write_end(struct file *file, struct address_space *mapping,
>   const struct address_space_operations ceph_aops = {
>   	.readpage = netfs_readpage,
>   	.readahead = netfs_readahead,
> -	.writepage = ceph_writepage,
>   	.writepages = ceph_writepages_start,
>   	.write_begin = ceph_write_begin,
>   	.write_end = ceph_write_end,

Sounds reasonable.

Will merge it into the testing branch.

Thanks Jeff!

-- Xiubo


