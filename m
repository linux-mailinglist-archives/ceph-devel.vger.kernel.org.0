Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40D6A50CE1D
	for <lists+ceph-devel@lfdr.de>; Sun, 24 Apr 2022 02:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235018AbiDXAUL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 23 Apr 2022 20:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234377AbiDXAUK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 23 Apr 2022 20:20:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2DAAAAFB2D
        for <ceph-devel@vger.kernel.org>; Sat, 23 Apr 2022 17:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650759430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GHOyIcdYyT/xy5m3CSNZcKl7Xj4oePGriOT/oeGnn3A=;
        b=JEu+k3SxwcIlynFGDSM+ywwcg6kkHUfJWIGpoiAMVDYY2HXHIQtUfJVnNABFEhhpChK5NE
        hseSckT5UoGshar8kTZgOpIcT3am9cOtVKMLiinMITZEpiqnKdnIeM8pLp7a8r5xxivMcm
        XklVAsT69Zlkq+rwtxGCCyFXeveyIHg=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-146-CkzX6ig8NqO0o-50eT3vUg-1; Sat, 23 Apr 2022 20:17:09 -0400
X-MC-Unique: CkzX6ig8NqO0o-50eT3vUg-1
Received: by mail-pg1-f197.google.com with SMTP id n1-20020a654881000000b003a367d46721so6986913pgs.4
        for <ceph-devel@vger.kernel.org>; Sat, 23 Apr 2022 17:17:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=GHOyIcdYyT/xy5m3CSNZcKl7Xj4oePGriOT/oeGnn3A=;
        b=lllKW6zx/1vokzUX5QmGlcePk5mDKILTW81vHL/rkMD0kzWATgubaRie9L7BwltuCk
         xCYBcsDDSqhx8liwTGyMaekqBmxX1rtFkunie9kdsz1iLM0GLMWZ/oQ0MqDExz87594v
         4UaknbJoroZo1rvgYtK7UmHJu3Dwh++pidFF4v8F0xBidETVNTL7vJxxx4wKzddvBCZr
         qYWG/5uDXuKBAI9hPMAZFmfn4m42ISsrjFu4O3oEK4zhk3Nlp0Uii7jsSoJC3SHBMifS
         39p637gEo1PeRcgu/+BtGXvWbD2fsqnIaxfWlsHpc2DBCLefxnSw1xhfLtvfW9/mrMMn
         7vCw==
X-Gm-Message-State: AOAM532qbGrswcEujFwpWZRkCjzFujoWlL7JYteLEV3V8S3Jl4lCvewR
        s1QK109g3X8EHfVYIUiH1QPpKVHFjQDSCkGLRmrGqocTWodXEa+3zaXLmcS74rh60WZpPGMnnf5
        HI7Fa64zbOxv3TDjMAP8xqdgt06HRraVsvnlOhGYo1FbolJCoDmHRVFyM4lyfzM1Oyu5QC5Q=
X-Received: by 2002:a17:902:c202:b0:15a:2af6:7e06 with SMTP id 2-20020a170902c20200b0015a2af67e06mr11073186pll.76.1650759428336;
        Sat, 23 Apr 2022 17:17:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx/rcWBK9YVLbNbdBR3rLMMZXA49r6b+0WdM1m103+VN7e31v2/+Fqmavg9fR+06VLFC7p1aw==
X-Received: by 2002:a17:902:c202:b0:15a:2af6:7e06 with SMTP id 2-20020a170902c20200b0015a2af67e06mr11073167pll.76.1650759427977;
        Sat, 23 Apr 2022 17:17:07 -0700 (PDT)
Received: from [10.72.12.77] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p3-20020a056a000b4300b0050a4e73bf89sm6895035pfo.66.2022.04.23.17.17.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Apr 2022 17:17:06 -0700 (PDT)
Subject: Re: [PATCH] ceph: fix request refcount leak when session can't be
 acquired
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org
References: <20220422172911.94861-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <6eb5cb88-6a7e-dd13-843f-80eca7d3a7e6@redhat.com>
Date:   Sun, 24 Apr 2022 08:16:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220422172911.94861-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 4/23/22 1:29 AM, Jeff Layton wrote:
> ...in flush_mdlog_and_wait_mdsc_unsafe_requests.
>
> URL: https://tracker.ceph.com/issues/55411
> Fixes: 86bc9a732b7f ("ceph: flush the mdlog for filesystem sync")
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/mds_client.c | 12 +++++-------
>   1 file changed, 5 insertions(+), 7 deletions(-)
>
> Xiubo, feel free to fold this into the original patch so we can avoid
> the regression.
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 2f17ca3c10b1..1e7df3b2dffd 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4790,18 +4790,16 @@ static void flush_mdlog_and_wait_mdsc_unsafe_requests(struct ceph_mds_client *md
>   			nextreq = NULL;
>   		if (req->r_op != CEPH_MDS_OP_SETFILELOCK &&
>   		    (req->r_op & CEPH_MDS_OP_WRITE)) {
> -			struct ceph_mds_session *s;
> +			struct ceph_mds_session *s = req->r_session;
>   
> -			/* write op */
> -			ceph_mdsc_get_request(req);
> -			if (nextreq)
> -				ceph_mdsc_get_request(nextreq);
> -
> -			s = req->r_session;
>   			if (!s) {
>   				req = nextreq;
>   				continue;
>   			}
> +
> +			ceph_mdsc_get_request(req);
> +			if (nextreq)
> +				ceph_mdsc_get_request(nextreq);
>   			s = ceph_get_mds_session(s);
>   			mutex_unlock(&mdsc->mutex);
>   

Good catch!

Thanks Jeff, I will fold this into the original patch.

-- Xiubo


