Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D20F56AF65
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Jul 2022 02:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236998AbiGHA1v (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 7 Jul 2022 20:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236799AbiGHA1u (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 7 Jul 2022 20:27:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 82DB470E48
        for <ceph-devel@vger.kernel.org>; Thu,  7 Jul 2022 17:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657240068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cs7MDHvmj0/t5J4+Z18yhBzgBRius1xGpFQzgyhBcss=;
        b=hAXXzJJvf8KVzk7kx6ePj1930p9Hb5s/+y3Ul0GRkQ+sdQQ6njUHFqVTF9WzPhNP+gFacG
        gVszdgUMPECD8oqff5dAA7Wk6ziYNHuWflExhV8Z/bRQOtiAZFfZ7i4v5uk58PQ6rCiHiO
        5szOHdsP0uJrOblMrkmHKeDCykaHKUE=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-483-MkdFozqaOkSAz7-9gE7YMw-1; Thu, 07 Jul 2022 20:27:44 -0400
X-MC-Unique: MkdFozqaOkSAz7-9gE7YMw-1
Received: by mail-pf1-f200.google.com with SMTP id by4-20020a056a00400400b005251029fd97so6296841pfb.9
        for <ceph-devel@vger.kernel.org>; Thu, 07 Jul 2022 17:27:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=cs7MDHvmj0/t5J4+Z18yhBzgBRius1xGpFQzgyhBcss=;
        b=ipXlLhqTq6oo5eQ2iGFz2wPAIDHr+e/z+t7/h03ekfI7plzHWF0aag0opHDNSM3kPV
         bZkSVc7V0q/Y+d5PuWYnml7wbOjwS6uPof1raFpjS9hNgaDA6efxsyA86yBMpi3CV+6w
         Fy67tbz9lt7n/vVEUHWa0sqjinEj9AriXCPRE6s9ifTT9JcgFGt1dQpArpBgBckgymEP
         VKVmGSzELazcgaEWvn4BKgbbSNrtn78ow59II0qPGJ4voYiwPPdkWxck5m8DluvvkIqm
         7QsXqghkceo8ZSS3goC6BtsIbWem2f/MAf0HphbUw3Fv4EAiiNf145rS5WeGRmjHFBqE
         f7Dw==
X-Gm-Message-State: AJIora+jlM6u7k0OHfmrq+9qrcutUE6b53q/uKaAOcDYEna9Tr1nIsYA
        nZGogUhwvN7A/gEeX8pO02TKuFJUJbvgi36uHSrPs2xs7E6/X4eQ/GY5+dBxA910OacUOVztGsJ
        4310w6faRm0tGdPfFPvbuhQ==
X-Received: by 2002:a17:90b:e95:b0:1ef:825f:cb40 with SMTP id fv21-20020a17090b0e9500b001ef825fcb40mr8333794pjb.29.1657240063730;
        Thu, 07 Jul 2022 17:27:43 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tgRDYPNWcFcCsRVDN1/RK1hq5OuCzbP6yM1Z6fAxtxgAQChjpsWmwkkNWW0/A4n3ypppIZfw==
X-Received: by 2002:a17:90b:e95:b0:1ef:825f:cb40 with SMTP id fv21-20020a17090b0e9500b001ef825fcb40mr8333778pjb.29.1657240063425;
        Thu, 07 Jul 2022 17:27:43 -0700 (PDT)
Received: from [10.72.12.227] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e6-20020a17090301c600b00163daef3dc2sm10473781plh.84.2022.07.07.17.27.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jul 2022 17:27:42 -0700 (PDT)
Subject: Re: [PATCH wip-fscrypt] ceph: reset "err = 0" after
 iov_get_pages_alloc in ceph_netfs_issue_read
To:     Jeff Layton <jlayton@kernel.org>
Cc:     dhowells@redhat.com, ceph-devel@vger.kernel.org, idryomov@gmail.com
References: <20220707140811.35155-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <d5e9d800-750f-2422-8ff6-fe4eb2cd10bc@redhat.com>
Date:   Fri, 8 Jul 2022 08:27:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220707140811.35155-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 7/7/22 10:08 PM, Jeff Layton wrote:
> Currently, when we call ceph_netfs_issue_read for an encrypted inode,
> we'll call iov_iter_get_pages_alloc and assign its result to "err".
> Later we'll end up inappropriately calling netfs_subreq_terminated with
> that value after submitting the request. Ensure we reset "err = 0;"
> after calling iov_iter_get_pages_alloc.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/addr.c | 1 +
>   1 file changed, 1 insertion(+)
>
> Probably this should get squashed into the patch that adds fscrypt
> support to buffered reads.
>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index c713b5491012..64facef79883 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -376,6 +376,7 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
>   		/* should always give us a page-aligned read */
>   		WARN_ON_ONCE(page_off);
>   		len = err;
> +		err = 0;
>   
>   		osd_req_op_extent_osd_data_pages(req, 0, pages, len, 0, false, false);
>   	} else {
Looks good. Thanks Jeff!

Show we fold it into the previous patch ?

-- Xiubo


