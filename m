Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65398562989
	for <lists+ceph-devel@lfdr.de>; Fri,  1 Jul 2022 05:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232646AbiGADVW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 30 Jun 2022 23:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231532AbiGADVU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 30 Jun 2022 23:21:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8878464D7A
        for <ceph-devel@vger.kernel.org>; Thu, 30 Jun 2022 20:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656645676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pCoEUOA9LZIYZe3tvjEL1x105MeisyE7v4qvAobeywQ=;
        b=f40NW0nu36EKpSq8XttoQ3drVVVem95mSS28W/AHLnf2q8gexErBNs4J2DLK8nnFSZSkrQ
        vNLWKw8/C46fKDZYqCiCaC7NTAFQdYiETn7bkdy9fPJZcWA5pnGiuKtxZW4pYOn6HzynbE
        /9Rsa3ZftekovYByOl5jrPtZKH2k31U=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-177-piKXrTw2ONa6dPFkK97xkg-1; Thu, 30 Jun 2022 23:21:14 -0400
X-MC-Unique: piKXrTw2ONa6dPFkK97xkg-1
Received: by mail-pg1-f200.google.com with SMTP id o22-20020a637316000000b0040d238478aeso635501pgc.2
        for <ceph-devel@vger.kernel.org>; Thu, 30 Jun 2022 20:21:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=pCoEUOA9LZIYZe3tvjEL1x105MeisyE7v4qvAobeywQ=;
        b=j97Q1mAd3nP7WDPw8RnCAJahPPOHlqeczDTHWEnCpEtqGsQdzI8Yjgd6FcJ0Zrx8jT
         fpwU0FX8Aho5+MMJemI05h6dihtQrpMGeBn37w61NVgeDHFfuq5qDuVHZ1rUrIQ12YZ6
         DMQ+ogt6a9DBr68lsJOb3P7CNaD197xg76YFFjjZWgO23j+1pspTpcyMYzaP72AhyOIv
         vbYwkSnjvWom69U4pRk4rtCD/+9aV/Esm7oWCDNIfwQFEqRTHrikw6At+fmjfDNNdMmT
         Rom1OBb3acX4e92Xi0jFXbfZasrj34Tktt2wd1sUZlGw3S6zJJIpQpdT11rfp+vKKMHb
         3mzA==
X-Gm-Message-State: AJIora9/8kIoByk/OKQNysxhbbXtJxLpCJF6hK9HFgBw4Bq08xJc8jew
        +l7RnFKHZ0RYDoBJekuLKlD8kLqqDUO3PHU71UefV1EPcyYZ3n687J3xsD/wsMI///kMeh86L6G
        Zn9ZZyoKtoNBdT4ejltlsaGVEtsuKq/QtbZNlFucRppaQKxSt+xnOXmRDm366a5buVrjcTQI=
X-Received: by 2002:a17:903:1c7:b0:16a:2762:88d1 with SMTP id e7-20020a17090301c700b0016a276288d1mr18913010plh.76.1656645672922;
        Thu, 30 Jun 2022 20:21:12 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sYiCSb7XvTYm142AOrKCiUtpwoF+DU801w6livIs/smcN6X7pT6sQNEcA5CyCBs8BY4VCX0w==
X-Received: by 2002:a17:903:1c7:b0:16a:2762:88d1 with SMTP id e7-20020a17090301c700b0016a276288d1mr18912986plh.76.1656645672584;
        Thu, 30 Jun 2022 20:21:12 -0700 (PDT)
Received: from [10.72.12.186] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l3-20020a17090a408300b001eab99a42efsm5334273pjg.31.2022.06.30.20.21.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 20:21:12 -0700 (PDT)
Subject: Re: [RESEND PATCH] ceph: don't truncate file in atomic_open
To:     Hu Weiwen <sehuww@mail.scut.edu.cn>, ceph-devel@vger.kernel.org
References: <59d7c10f-7419-971b-c13c-71865f897953@redhat.com>
 <20220701025227.21636-1-sehuww@mail.scut.edu.cn>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <7552c891-fd6e-de29-e914-fd238091900c@redhat.com>
Date:   Fri, 1 Jul 2022 11:21:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220701025227.21636-1-sehuww@mail.scut.edu.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 7/1/22 10:52 AM, Hu Weiwen wrote:
> Clear O_TRUNC from the flags sent in the MDS create request.
>
> `atomic_open' is called before permission check. We should not do any
> modification to the file here. The caller will do the truncation
> afterward.
>
> Fixes: 124e68e74099 ("ceph: file operations")
> Signed-off-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
> ---
> rebased onto ceph_client repo testing branch
>
>   fs/ceph/file.c | 9 ++++++---
>   1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 296fd1c7ece8..289e66e9cbb0 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -745,6 +745,11 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>   	err = ceph_wait_on_conflict_unlink(dentry);
>   	if (err)
>   		return err;
> +	/*
> +	 * Do not truncate the file, since atomic_open is called before the
> +	 * permission check. The caller will do the truncation afterward.
> +	 */
> +	flags &= ~O_TRUNC;
>   
>   retry:
>   	if (flags & O_CREAT) {
> @@ -836,9 +841,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>   	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
>   	req->r_new_inode = new_inode;
>   	new_inode = NULL;
> -	err = ceph_mdsc_do_request(mdsc,
> -				   (flags & (O_CREAT|O_TRUNC)) ? dir : NULL,
> -				   req);
> +	err = ceph_mdsc_do_request(mdsc, (flags & O_CREAT) ? dir : NULL, req);
>   	if (err == -ENOENT) {
>   		dentry = ceph_handle_snapdir(req, dentry);
>   		if (IS_ERR(dentry)) {

Merged it and thanks!

-- Xiubo


