Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A109B5AA55C
	for <lists+ceph-devel@lfdr.de>; Fri,  2 Sep 2022 03:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234100AbiIBB5Y (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 1 Sep 2022 21:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232199AbiIBB5X (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 1 Sep 2022 21:57:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07C0DA2D9B
        for <ceph-devel@vger.kernel.org>; Thu,  1 Sep 2022 18:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662083841;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8SOk1H2Oy3ut3CxVF1xP3lv3LfZCO4T4jxEIaoCC9xw=;
        b=Iw0/bYB/0GCeE8oTm6LW/kxfgyIY91wC25MQk/SX4Oo4lIPzl1mfnEfBri/2N3r44tP+gr
        EVu7kGJstCrml9tlowtA4MA2YbpZpt+c0dmZDV66I5hp+9lf694Dpb1adf2NunrCwGe5Mt
        zuGDALQGwDWRWBfj6nq8Dn0pxzj2EvI=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-616-IdiWOhSvNDGdOG5Ld6dBqA-1; Thu, 01 Sep 2022 21:57:20 -0400
X-MC-Unique: IdiWOhSvNDGdOG5Ld6dBqA-1
Received: by mail-pf1-f198.google.com with SMTP id x25-20020aa79199000000b005358eeebf49so272950pfa.17
        for <ceph-devel@vger.kernel.org>; Thu, 01 Sep 2022 18:57:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date;
        bh=8SOk1H2Oy3ut3CxVF1xP3lv3LfZCO4T4jxEIaoCC9xw=;
        b=yKchJGTpzsLoZ7h/sfmhRYuV0SGV3L9Dr4qHZq+egD8gXI6tQY0vyOBloOJVSDRbQI
         zB+OowHUPdClrrvP+OpDQzH6gnPzgocPTMMM1EtJNo6XxlKaWkbGTcVsu1pGKRt7E7R5
         bTxaiYqLGZ3UjKu9hbC9gOmaRPW7ApH6lsadZOI15A7CXJw96WfmNMMRv5BVuLJ3ea96
         10sTySgybjSx/EMt00i9zpvsY1XEvIjAvFef7JdjcFiV11f28OxeuyppfJtWetKRNIL/
         tskY+wJM8vgxW+SL5NHyFxIk0qm1ehgrNwkEl6KeFQy5s1AbVnfQSPV7FIfhRq2SYbia
         Ny3g==
X-Gm-Message-State: ACgBeo2p+KqFAqQMnaO2yzBk2aTPiKcGPrzLVO25/jxf/dF+5Ij31Zq9
        G7IA7lYtcX38eeGmdWHQnrwvMdq0dPe0nbN+xIj8H0ZV6jJlzCQvrAGZI3ddO/T37+eZmiNs50T
        19V883ngEB41SYXENbwOmBQ==
X-Received: by 2002:a17:902:a502:b0:172:5f2a:9e35 with SMTP id s2-20020a170902a50200b001725f2a9e35mr33780074plq.79.1662083839312;
        Thu, 01 Sep 2022 18:57:19 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6ZjOIF84L5kutg0Vcpe+Sggf0MJOCGKDZWZjtnRQvS+PO2UWNrt6KjmImYu3tPmYiIup0/Gw==
X-Received: by 2002:a17:902:a502:b0:172:5f2a:9e35 with SMTP id s2-20020a170902a50200b001725f2a9e35mr33780057plq.79.1662083839067;
        Thu, 01 Sep 2022 18:57:19 -0700 (PDT)
Received: from [10.72.12.34] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w185-20020a6262c2000000b005289a50e4c2sm303095pfb.23.2022.09.01.18.57.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Sep 2022 18:57:18 -0700 (PDT)
Subject: Re: [PATCH] ceph: force sending open request to MDS for root user
To:     ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, idryomov@gmail.com, lhenriques@suse.de,
        rraja@redhat.com, mchangir@redhat.com
References: <20220901145237.267010-1-xiubli@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <445b5aeb-f401-9f8c-0e83-5d69e5463f90@redhat.com>
Date:   Fri, 2 Sep 2022 09:57:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220901145237.267010-1-xiubli@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 9/1/22 10:52 PM, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
>
> With the root_squash MDS caps enabled and for a root user it should
> fail to write the file. But currently the kclient will just skip
> sending a open request and check the cap instead even with the root
> user. This will skip checking the MDS caps in MDS server.
>
> URL: https://tracker.ceph.com/issues/56067
> URL: https://tracker.ceph.com/issues/57154
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>   fs/ceph/file.c | 17 ++++++++++++-----
>   1 file changed, 12 insertions(+), 5 deletions(-)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 86265713a743..642c0facbdcd 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -360,6 +360,7 @@ int ceph_open(struct inode *inode, struct file *file)
>   	struct ceph_mds_client *mdsc = fsc->mdsc;
>   	struct ceph_mds_request *req;
>   	struct ceph_file_info *fi = file->private_data;
> +	uid_t uid = from_kuid(&init_user_ns, get_current_cred()->fsuid);
>   	int err;
>   	int flags, fmode, wanted;
>   
> @@ -393,13 +394,19 @@ int ceph_open(struct inode *inode, struct file *file)
>   	}
>   
>   	/*
> -	 * No need to block if we have caps on the auth MDS (for
> -	 * write) or any MDS (for read).  Update wanted set
> -	 * asynchronously.
> +	 * If the caller is root user and the Fw caps is required
> +	 * it will force sending a open request to MDS to let
> +	 * the MDS do the root_squash MDS caps check.
> +	 *
> +	 * Otherwise no need to block if we have caps on the auth
> +	 * MDS (for write) or any MDS (for read). Update wanted
> +	 * set asynchronously.
>   	 */
>   	spin_lock(&ci->i_ceph_lock);
> -	if (__ceph_is_any_real_caps(ci) &&
> -	    (((fmode & CEPH_FILE_MODE_WR) == 0) || ci->i_auth_cap)) {
> +	if (((fmode & CEPH_FILE_MODE_WR) && uid != 0) &&

This should be:

if (!((fmode & CEPH_FILE_MODE_WR) && !uid) &&

Will send the V2 to fix it.

- Xiubo


> +	    (__ceph_is_any_real_caps(ci) &&
> +	     (((fmode & CEPH_FILE_MODE_WR) == 0) || ci->i_auth_cap))) {
> +
>   		int mds_wanted = __ceph_caps_mds_wanted(ci, true);
>   		int issued = __ceph_caps_issued(ci, NULL);
>   

