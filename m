Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6882A504EF8
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Apr 2022 12:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237801AbiDRKob (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 18 Apr 2022 06:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237740AbiDRKoU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 18 Apr 2022 06:44:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EC0B815FDF
        for <ceph-devel@vger.kernel.org>; Mon, 18 Apr 2022 03:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650278495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qdyxAy4KUAkOorSsmWciKgIokGVX7y1HChDNCvudrfY=;
        b=TI5NM+npOgEwGaozd8pnnSVSEPsxR5yDG5A4U+MZML6tZGQd8EyWd+ZwBiQc793H5neiQS
        tZOmKT39j5vuJc9/qqi/U1J1pew7hzRHKcONQH+vBEHe83H3kUsVyAMtSJEqO1+JjoXwMh
        IIrC4d7mjHuqwNo7UKV/YqyZo7iz3hI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-541-_adZEpgSMyKTKWGgacZZew-1; Mon, 18 Apr 2022 06:41:34 -0400
X-MC-Unique: _adZEpgSMyKTKWGgacZZew-1
Received: by mail-wm1-f71.google.com with SMTP id t187-20020a1c46c4000000b0038ebc45dbfcso1292787wma.2
        for <ceph-devel@vger.kernel.org>; Mon, 18 Apr 2022 03:41:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qdyxAy4KUAkOorSsmWciKgIokGVX7y1HChDNCvudrfY=;
        b=ktxfeDNrIB1XPx+J1h9Wz/Dx+23+/uTq1cK+IuYQpnBGxPswMZLA+VMK6XlK9I9L1H
         uQxYjXYxcJMIA0wfN/JSXoKh3cK2bgNOJecCbRdX/pu5PKx28b4pcSEzL1jZNQaGgfwc
         SnOGBcmWiPUdtFsnnc50UZJ/jEvKgypQCiut5QRVASUwC532NtHzWcn10C2wozAIrYzD
         Nybsd/tkkAGvE5wcl5XUcx3PTCU+OPuQFjLELXWnfWTpFeCLb8K8pJpLVDruFKEXpZIQ
         S9rJvVLNzpnxCftMxBRQ8LZ1qZuQlIII0Tr7sANUaXEgbgSLiOMXRC3lUwgka7X0SM12
         NMwA==
X-Gm-Message-State: AOAM530dEHNW6MupSL6BMzmfPB7Z23vRTItJWmcmcClKbFfEHF5SzfDB
        Q1Z0wSLPZ5WF90d+Z59ROEU5k5enr3YQiSlUmfUmqw+OpGdaqSGeYqEMtDEFG+LSA2f3C/dOjkh
        /lUc4GVCu7fRxwLfLsrjm
X-Received: by 2002:a5d:6050:0:b0:207:a706:fa46 with SMTP id j16-20020a5d6050000000b00207a706fa46mr7548741wrt.369.1650278493167;
        Mon, 18 Apr 2022 03:41:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzZY8t0CILsfbkc5OJuOqfeZb2sNxU2hjSxH/3oZGazOypYOIXtjW5BmowG7oOojMppppFFOg==
X-Received: by 2002:a5d:6050:0:b0:207:a706:fa46 with SMTP id j16-20020a5d6050000000b00207a706fa46mr7548728wrt.369.1650278492994;
        Mon, 18 Apr 2022 03:41:32 -0700 (PDT)
Received: from localhost (cpc111743-lutn13-2-0-cust979.9-3.cable.virginm.net. [82.17.115.212])
        by smtp.gmail.com with ESMTPSA id bi26-20020a05600c3d9a00b0038ed39dbf00sm12587532wmb.0.2022.04.18.03.41.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 03:41:31 -0700 (PDT)
Date:   Mon, 18 Apr 2022 11:41:31 +0100
From:   Aaron Tomlin <atomlin@redhat.com>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     jlayton@kernel.org, idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org
Subject: Re: [PATCH v2] ceph: fix possible NULL pointer dereference for
 req->r_session
Message-ID: <20220418104131.4gjl73nlqgdh6n6c@ava.usersys.com>
X-PGP-Key: http://pgp.mit.edu/pks/lookup?search=atomlin%40redhat.com
X-PGP-Fingerprint: 7906 84EB FA8A 9638 8D1E  6E9B E2DE 9658 19CC 77D6
References: <20220418014440.573533-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220418014440.573533-1-xiubli@redhat.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon 2022-04-18 09:44 +0800, Xiubo Li wrote:
> The request will be inserted into the ci->i_unsafe_dirops before
> assigning the req->r_session, so it's possible that we will hit
> NULL pointer dereference bug here.
> 
> URL: https://tracker.ceph.com/issues/55327
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/caps.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 69af17df59be..c70fd747c914 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -2333,6 +2333,8 @@ static int unsafe_request_wait(struct inode *inode)
>  			list_for_each_entry(req, &ci->i_unsafe_dirops,
>  					    r_unsafe_dir_item) {
>  				s = req->r_session;
> +				if (!s)
> +					continue;
>  				if (unlikely(s->s_mds >= max_sessions)) {
>  					spin_unlock(&ci->i_unsafe_lock);
>  					for (i = 0; i < max_sessions; i++) {
> @@ -2353,6 +2355,8 @@ static int unsafe_request_wait(struct inode *inode)
>  			list_for_each_entry(req, &ci->i_unsafe_iops,
>  					    r_unsafe_target_item) {
>  				s = req->r_session;
> +				if (!s)
> +					continue;
>  				if (unlikely(s->s_mds >= max_sessions)) {
>  					spin_unlock(&ci->i_unsafe_lock);
>  					for (i = 0; i < max_sessions; i++) {
> -- 
> 2.36.0.rc1

Thanks Xiubo!

Reviewed-by: Aaron Tomlin <atomlin@redhat.com>

-- 
Aaron Tomlin

