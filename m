Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5DEC7ACF63
	for <lists+ceph-devel@lfdr.de>; Mon, 25 Sep 2023 07:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjIYFTr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 25 Sep 2023 01:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjIYFTr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 25 Sep 2023 01:19:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F257DA
        for <ceph-devel@vger.kernel.org>; Sun, 24 Sep 2023 22:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695619134;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r/i6WgyU67cVGVuGb18YTCkwEV9jvnrS1YtYZ/55UF8=;
        b=PUFv/P72a5FBUeWy04nfvpu545RrreSKFscr0sb05sN/Jq7q/XQujt7aOq/jiywhlcn5zT
        +1k/IT1sKNZ+uZGytV7Gtf2pCPOasYTHHg6tumS8a2FWATcKV6tryyJVVkIa6Ljr4787TV
        Sw7fpCWvduh7yaKdoWzrAwQt4btJBgk=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-567-YuQaRnbFPB6FDLrx6KAP0w-1; Mon, 25 Sep 2023 01:18:52 -0400
X-MC-Unique: YuQaRnbFPB6FDLrx6KAP0w-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-27733adfb12so3004091a91.1
        for <ceph-devel@vger.kernel.org>; Sun, 24 Sep 2023 22:18:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695619131; x=1696223931;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r/i6WgyU67cVGVuGb18YTCkwEV9jvnrS1YtYZ/55UF8=;
        b=qEUIWiECK8Eg+O5kc1YKl+Fv0N/5a/FIrlA+3AJoXAd/XAxOY8nLJg5K1yc4RgPIOj
         UJL9KaPZBziII8tcLS3i/5Y2TFu1WeqRBvIIB00BMOdyQFpxbkPOXn0NigBPCHJGS6Dv
         K24I3GCc7EPVT6Oc4EVDvyY9b09zKbVtMeHUaWPw0qsfJ5upyFrN8o5MZQAs7kpEXDW8
         QL3jvg0vGR0u4Catm+jOFVTiZyoQ+jK6FgL3k7tN1OCdXvf4soSwVww3CH0BiISYqFSI
         SR+ksd73VqvfDitHhNAloSETKmjCXv333C1ZFOc0Lg622+4y7RXOneKAn9betHTJO2iJ
         R73A==
X-Gm-Message-State: AOJu0YxcUeHJCaZqxWhNrQVyocoBj1l72xmSJS27jtO9NIDAPuYXmDTT
        t8Fb0O75ashohO4PNxNuacPUsotIGgLUSsitbbIc8vJQ6HUHMWdqWIS/KyGz5IgzhsnUNO5exCo
        CO4oH5dRglh0MVp12jTiGQ9OK3YopoU2E
X-Received: by 2002:a17:90b:4a88:b0:274:9be9:7ee3 with SMTP id lp8-20020a17090b4a8800b002749be97ee3mr9105812pjb.8.1695619131243;
        Sun, 24 Sep 2023 22:18:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGGaLXQWcL0EzsDD99SelRh5aKaRr6prYyFl3V1yZtBj/fqTrmuvta2Vf2r/ggyiYAJG61rBQ==
X-Received: by 2002:a17:90b:4a88:b0:274:9be9:7ee3 with SMTP id lp8-20020a17090b4a8800b002749be97ee3mr9105801pjb.8.1695619130954;
        Sun, 24 Sep 2023 22:18:50 -0700 (PDT)
Received: from [10.72.112.123] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 30-20020a17090a005e00b00274c541ac9esm7832898pjb.48.2023.09.24.22.18.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Sep 2023 22:18:50 -0700 (PDT)
Message-ID: <fd88660f-0d23-16fb-2408-ac18ad01778e@redhat.com>
Date:   Mon, 25 Sep 2023 13:18:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 1/2] fs/ceph/debugfs: make all files world-readable
To:     Max Kellermann <max.kellermann@ionos.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230922062558.1739642-1-max.kellermann@ionos.com>
Content-Language: en-US
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20230922062558.1739642-1-max.kellermann@ionos.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 9/22/23 14:25, Max Kellermann wrote:
> I'd like to be able to run metrics collector processes without special
> privileges
>
> In the kernel, there is a mix of debugfs files being world-readable
> and not world-readable is; with a naive "git grep", I found 723
> world-readable debugfs_create_file() calls and 582 calls which were
> only accessible to privileged processe.
>
>  From the code, I cannot derive a consistent policy for that, but the
> ceph statistics seem harmless (and useful) enough.

I am not sure whether will this make sense. Because the 'debug' under 
'/sys/kernel/' is also only accessible by privileged process.

Ilya, Jeff

Any idea ?

Thanks

- Xiubo

> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> ---
>   fs/ceph/debugfs.c | 18 +++++++++---------
>   1 file changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> index 3904333fa6c3..2abee7e18144 100644
> --- a/fs/ceph/debugfs.c
> +++ b/fs/ceph/debugfs.c
> @@ -429,31 +429,31 @@ void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
>   				       name);
>   
>   	fsc->debugfs_mdsmap = debugfs_create_file("mdsmap",
> -					0400,
> +					0444,
>   					fsc->client->debugfs_dir,
>   					fsc,
>   					&mdsmap_fops);
>   
>   	fsc->debugfs_mds_sessions = debugfs_create_file("mds_sessions",
> -					0400,
> +					0444,
>   					fsc->client->debugfs_dir,
>   					fsc,
>   					&mds_sessions_fops);
>   
>   	fsc->debugfs_mdsc = debugfs_create_file("mdsc",
> -						0400,
> +						0444,
>   						fsc->client->debugfs_dir,
>   						fsc,
>   						&mdsc_fops);
>   
>   	fsc->debugfs_caps = debugfs_create_file("caps",
> -						0400,
> +						0444,
>   						fsc->client->debugfs_dir,
>   						fsc,
>   						&caps_fops);
>   
>   	fsc->debugfs_status = debugfs_create_file("status",
> -						  0400,
> +						  0444,
>   						  fsc->client->debugfs_dir,
>   						  fsc,
>   						  &status_fops);
> @@ -461,13 +461,13 @@ void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
>   	fsc->debugfs_metrics_dir = debugfs_create_dir("metrics",
>   						      fsc->client->debugfs_dir);
>   
> -	debugfs_create_file("file", 0400, fsc->debugfs_metrics_dir, fsc,
> +	debugfs_create_file("file", 0444, fsc->debugfs_metrics_dir, fsc,
>   			    &metrics_file_fops);
> -	debugfs_create_file("latency", 0400, fsc->debugfs_metrics_dir, fsc,
> +	debugfs_create_file("latency", 0444, fsc->debugfs_metrics_dir, fsc,
>   			    &metrics_latency_fops);
> -	debugfs_create_file("size", 0400, fsc->debugfs_metrics_dir, fsc,
> +	debugfs_create_file("size", 0444, fsc->debugfs_metrics_dir, fsc,
>   			    &metrics_size_fops);
> -	debugfs_create_file("caps", 0400, fsc->debugfs_metrics_dir, fsc,
> +	debugfs_create_file("caps", 0444, fsc->debugfs_metrics_dir, fsc,
>   			    &metrics_caps_fops);
>   }
>   

