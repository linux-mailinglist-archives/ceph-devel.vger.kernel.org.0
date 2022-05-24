Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 901CE532241
	for <lists+ceph-devel@lfdr.de>; Tue, 24 May 2022 06:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234482AbiEXEpV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 24 May 2022 00:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234480AbiEXEpT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 24 May 2022 00:45:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 01F828A324
        for <ceph-devel@vger.kernel.org>; Mon, 23 May 2022 21:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653367517;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aVpIvJUvnqhOyn4AeRtvH6vizmpDjWylYJ1wgPnXUMQ=;
        b=gN4WF1M/GS4rUwsKzxMsMm+GW3ITdH5KP2QTwLKGWiJY7fDS97gMYZUP1MIifko+egrqqh
        sj9FgVRxvsgBvAGTzG0ufzY2q/cb+K99iVLOycMQno6i94Yg91GtKLdOhheM0/6EXgBB2g
        nzmIlZQOOoC7JIKBInvsT32TbDodcNk=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-434-psuVvdmfPJGXCM2BZ0Xbcw-1; Tue, 24 May 2022 00:45:14 -0400
X-MC-Unique: psuVvdmfPJGXCM2BZ0Xbcw-1
Received: by mail-oo1-f71.google.com with SMTP id 5-20020a4a0105000000b0040e7d541ba1so3434167oor.13
        for <ceph-devel@vger.kernel.org>; Mon, 23 May 2022 21:45:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=aVpIvJUvnqhOyn4AeRtvH6vizmpDjWylYJ1wgPnXUMQ=;
        b=d1hGYyNuBZAV9hswWQ6PuWEByFLbRThsfZMO/pk4Z/EjoIPCQleRGrlzlswZMiKfg/
         iNrXXILvmxD55S6N2sibW9B1UEXIShOvBxdbbZEeVopnmir0/Vk2B0z+N8aYNJiTC245
         Belo4AVKB4zBcL6kbqM93rR3v5dI0Z5VfH9GykQHclW1TEI4g8kltZfqgshJcTvld7me
         W2QDzo+bJeyd4wE8ZJm5N7lK1iPOKkClJXNgEM5AYdDkcBEIIDaUFGswXuEAYmM+X9xX
         AninBCapMZLwSvnfLwewJ2V5N2Kt3TVa5sdElh8QQyXbSxkh57eC+vkWxBPioGC35qoi
         HVMw==
X-Gm-Message-State: AOAM5338vndCJqVj2E08hVvUYiAKVrd8TMClb/4WhKvRFBdBRvUULwf0
        RkKXhYlvE9ZUZEzZdBsVVGEy0vARV/L8mURsfP1GHHzuFkpEo51QjOVWu1V9/7kIBhkuCCN3g1R
        /qctY/cdKGl7yCrpEdKgLfQ==
X-Received: by 2002:a54:4f19:0:b0:325:338e:ff52 with SMTP id e25-20020a544f19000000b00325338eff52mr1379589oiy.98.1653367513608;
        Mon, 23 May 2022 21:45:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyqxOdFwOKtDVttxKN/N0z5Z5reMYC6DHtGqyobe+Ts98GSz6ZT+4Sd25ukE1lS7/eFVGkapg==
X-Received: by 2002:a54:4f19:0:b0:325:338e:ff52 with SMTP id e25-20020a544f19000000b00325338eff52mr1379586oiy.98.1653367513380;
        Mon, 23 May 2022 21:45:13 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u2-20020a05687004c200b000f23d04cd56sm2906251oam.44.2022.05.23.21.45.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 21:45:12 -0700 (PDT)
Date:   Tue, 24 May 2022 12:45:07 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     =?utf-8?B?THXDrXM=?= Henriques <lhenriques@suse.de>
Cc:     fstests@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: Re: [PATCH] ceph/001: skip metrics check if no copyfrom mount option
 is used
Message-ID: <20220524044507.m3drhwpn2orfp7my@zlang-mailbox>
References: <20220520105055.31520-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220520105055.31520-1-lhenriques@suse.de>
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, May 20, 2022 at 11:50:55AM +0100, Luís Henriques wrote:
> Checking the metrics is only valid if 'copyfrom' mount option is
> explicitly set, otherwise the kernel won't be doing any remote object
> copies.  Fix the logic to skip this metrics checking if 'copyfrom' isn't
> used.
> 
> Signed-off-by: Luís Henriques <lhenriques@suse.de>
> ---

The code logic looks good to me, but I'm not familiar with cephfs, so if there's
not review points or objection from ceph-fs, I'll merge this patch this week.

Reviewed-by: Zorro Lang <zlang@redhat.com>

Thanks,
Zorro

>  tests/ceph/001 | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/tests/ceph/001 b/tests/ceph/001
> index 7970ce352bab..2e6a5e6be2d6 100755
> --- a/tests/ceph/001
> +++ b/tests/ceph/001
> @@ -86,11 +86,15 @@ check_copyfrom_metrics()
>  	local copies=$4
>  	local c1=$(get_copyfrom_total_copies)
>  	local s1=$(get_copyfrom_total_size)
> +	local hascopyfrom=$(_fs_options $TEST_DEV | grep "copyfrom")
>  	local sum
>  
>  	if [ ! -d $metrics_dir ]; then
>  		return # skip metrics check if debugfs isn't mounted
>  	fi
> +	if [ -z $hascopyfrom ]; then
> +		return # ... or if we don't have copyfrom mount option
> +	fi
>  
>  	sum=$(($c0+$copies))
>  	if [ $sum -ne $c1 ]; then
> 

