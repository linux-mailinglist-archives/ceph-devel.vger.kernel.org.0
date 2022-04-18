Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3D3504EFD
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Apr 2022 12:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbiDRKqD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 18 Apr 2022 06:46:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbiDRKqB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 18 Apr 2022 06:46:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 81F8215FD7
        for <ceph-devel@vger.kernel.org>; Mon, 18 Apr 2022 03:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650278602;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Xng4G/S5G/R+w7vcyMVbTb8ulNXfcRaBLSYAVHPK0e4=;
        b=V8XH6KCapbP8n32mQXxJKf3a0Rx8BCcAJWAZ5qXW1xiAbpae6NtZ4QCGFiIqEd950MllTn
        XIucalKe715lWjXY4/HZL5MBfkN/fe+EU8wk5fQHUu3AhSAGzPCnikzX0etgF2qw0/5x1n
        vQXHZ9dnU4e0BJ/TX7HXg1ANhTwiPcA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-41-a3XlYTaLMMe5jT6KZPR2iQ-1; Mon, 18 Apr 2022 06:43:21 -0400
X-MC-Unique: a3XlYTaLMMe5jT6KZPR2iQ-1
Received: by mail-wm1-f72.google.com with SMTP id p21-20020a1c5455000000b0038ff4f1014fso4674304wmi.7
        for <ceph-devel@vger.kernel.org>; Mon, 18 Apr 2022 03:43:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Xng4G/S5G/R+w7vcyMVbTb8ulNXfcRaBLSYAVHPK0e4=;
        b=AdOT2iwDnv6NUf150KTcHmAba9wvC/LIV29saGbqvEBwPD31dleNX6jFlw8QwwAaIS
         DqplYgIlguSfI1dNHOODuUtRLGcNqV2gFijWAyFSAHCiYBdzRYT2VVsNwediEtwUaeKB
         Pl7/rnRFDzhygxg9xtbfzbQUeVXiewhhuml5Se4ras4KiNKzLrQLrDMBUWbbzBuZXFip
         6iyw5qtDpWPdlqcWP33aUx3V3HyqAiqFl1nkZYHpeAacHRJC4jL//Pc/k/x+MqGACIV3
         LHmN+AdNFCW4Y+DtLwrE9PUMuBVS4r0wsLVZOdNen08HOgVrpHauIYPZzbdTvwpbRAN5
         6vGg==
X-Gm-Message-State: AOAM532e5FqhkZPC3D+g1/Zf2/s5vtGU1E6x987xj3Lg7nO/FjBye0qe
        MvYaIp2GAol3zmGZ3Y8iK3K7LiV4g8FXvkLAZr7uXNEVv7esjgrTxo7qt/h5+1PvtElPL2/dmvE
        TvhfqO98/rLuPR8XWPeZf
X-Received: by 2002:a7b:c155:0:b0:38e:b840:c99e with SMTP id z21-20020a7bc155000000b0038eb840c99emr14388890wmi.201.1650278600487;
        Mon, 18 Apr 2022 03:43:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyZ4pD0ulKy6SZk5oxXjHfAKpNhIjzcbpeexrz7l3SR3l6gmm6qeXGPMV5fLzGGpWm+FKuOPQ==
X-Received: by 2002:a7b:c155:0:b0:38e:b840:c99e with SMTP id z21-20020a7bc155000000b0038eb840c99emr14388869wmi.201.1650278600218;
        Mon, 18 Apr 2022 03:43:20 -0700 (PDT)
Received: from localhost (cpc111743-lutn13-2-0-cust979.9-3.cable.virginm.net. [82.17.115.212])
        by smtp.gmail.com with ESMTPSA id u7-20020a05600c19c700b003928959f92dsm7454622wmq.2.2022.04.18.03.43.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 03:43:19 -0700 (PDT)
Date:   Mon, 18 Apr 2022 11:43:18 +0100
From:   Aaron Tomlin <atomlin@redhat.com>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     jlayton@kernel.org, idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org
Subject: Re: [PATCH v2] ceph: fix possible NULL pointer dereference for
 req->r_session
Message-ID: <20220418104318.4fb3jpdgnhje4b5d@ava.usersys.com>
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

Tested-by: Aaron Tomlin <atomlin@redhat.com>

-- 
Aaron Tomlin

