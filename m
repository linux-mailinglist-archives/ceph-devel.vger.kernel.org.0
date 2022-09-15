Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D67085B92AE
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Sep 2022 04:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiIOCbk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 14 Sep 2022 22:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiIOCbj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 14 Sep 2022 22:31:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D8B901A3
        for <ceph-devel@vger.kernel.org>; Wed, 14 Sep 2022 19:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663209097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LLJx39fYO4u/RW6RN4O7d+e5bgwKGnTliRl8UuC17Iw=;
        b=eOm5g5VfwTelzvQvKwlh5wMF6XQFE56m2h7G9HA5CUO1+qsEmN7BsuQsWuGGkAz9Ka0rvb
        rzDd2apqMpG++jqr4wTdx9XOw6LmP08bhT5deqDv+35FuwbtsBbKevXVuoiha3dHa1/yPe
        bAQPI5/oxgJyuo2glM1kkJSfjFdctb8=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-14-RQEHR-sENAKQ0wjEF4W_vw-1; Wed, 14 Sep 2022 22:31:36 -0400
X-MC-Unique: RQEHR-sENAKQ0wjEF4W_vw-1
Received: by mail-pl1-f200.google.com with SMTP id d7-20020a170903230700b00177f6dd8472so11534140plh.6
        for <ceph-devel@vger.kernel.org>; Wed, 14 Sep 2022 19:31:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date;
        bh=LLJx39fYO4u/RW6RN4O7d+e5bgwKGnTliRl8UuC17Iw=;
        b=ODy30xL68j9Lb6S7CiKiK46F6iAKdUcXRA4cnVuvdEqAZZmLGeXChnBmFZxjiVSHmj
         znJpKOqMDgAIT2g8uCDdHwtyDnZS8aYEKjznic30TXGQVqyjIqJQsi/v/HtKLipazkT5
         u8yRAHJ6f9aUMQ9kNYkjCXRZ7a/SnKrzzjc3swWyFkwUIz2b6otVLaiMmB8ZqNJH1lS+
         JQlAkdq5tv4Kt9PXxPhRcUlQbkvYaDyG/f/OospPMWE/1DRcacPUNSp5Ipb+8XUHO3vF
         oluvPqijYR/e2l2irWRA367dZ94UZKi+Vqptw4wdC91w3lTys509nQ9NBclheCeWUmnI
         tbSA==
X-Gm-Message-State: ACrzQf1DQMGoFSA03zwncF10cWnobmoIOT/tUbsB542xxcS+obLUgy+/
        Ko6J0B5p7ejaqi5I8mdyMITveKZJ5zeNnlEx77sD0GvkODM6BWclymdqni9UqDn0UGFT1zGHFGC
        q6EE6w4zF8oLkwbldXOfQlw==
X-Received: by 2002:a63:1f02:0:b0:439:8ff9:236e with SMTP id f2-20020a631f02000000b004398ff9236emr670213pgf.63.1663209094508;
        Wed, 14 Sep 2022 19:31:34 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM73mqSyJMALhlkJsUVgrtOrya7m1ro0M+fzPFU84WVmfnD54cf9+SrAFVWTM+WIMiwXb2wy4w==
X-Received: by 2002:a63:1f02:0:b0:439:8ff9:236e with SMTP id f2-20020a631f02000000b004398ff9236emr670202pgf.63.1663209094289;
        Wed, 14 Sep 2022 19:31:34 -0700 (PDT)
Received: from [10.72.12.203] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q17-20020a170902f35100b00172b87d9770sm11373860ple.81.2022.09.14.19.31.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Sep 2022 19:31:33 -0700 (PDT)
Subject: Re: [PATCH v2] ceph: force sending open requests to MDS for root user
 for root_squash
To:     ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, idryomov@gmail.com, lhenriques@suse.de,
        rraja@redhat.com, mchangir@redhat.com
References: <20220902015535.305294-1-xiubli@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <9201b074-8521-d591-cea5-b922c4874b11@redhat.com>
Date:   Thu, 15 Sep 2022 10:31:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220902015535.305294-1-xiubli@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Will discard this patch.

We are planing to make the clients to check the mds auth caps before 
buffering the changes instead of this workaround and will blocklist or 
forbid old clients to mount if root_squash enabled, because it's hard to 
fix this bug for the old clients properly.

Thanks!

Xiubo


On 02/09/2022 09:55, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
>
> With the root_squash MDS caps enabled and for a root user it should
> fail to write the file. But currently the kclient will just skip
> sending a open request and check_caps() instead even with the root
> user. This will skip checking the MDS caps in MDS server.
>
> We should force sending a open request to MDS for root user if the
> cephx is enabled.
>
> URL: https://tracker.ceph.com/issues/56067
> URL: https://tracker.ceph.com/issues/57154
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>   fs/ceph/file.c | 17 ++++++++++++-----
>   1 file changed, 12 insertions(+), 5 deletions(-)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 86265713a743..d51c98412a30 100644
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
> +	if (!((fmode & CEPH_FILE_MODE_WR) && !uid) &&
> +	    (__ceph_is_any_real_caps(ci) &&
> +	     (((fmode & CEPH_FILE_MODE_WR) == 0) || ci->i_auth_cap))) {
> +
>   		int mds_wanted = __ceph_caps_mds_wanted(ci, true);
>   		int issued = __ceph_caps_issued(ci, NULL);
>   

