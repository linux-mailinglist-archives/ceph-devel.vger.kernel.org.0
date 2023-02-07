Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6468A68CECA
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Feb 2023 06:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbjBGFSS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Feb 2023 00:18:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjBGFSQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 7 Feb 2023 00:18:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A8D12F2D
        for <ceph-devel@vger.kernel.org>; Mon,  6 Feb 2023 21:17:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675747045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GRUpcawoWrDNp+45dDmyCeBdVrdknt/dFiI8+SAxSRk=;
        b=K3y00Q3LMokqQQryXG3nH7LiJyqTCpS9y2S/rwX2Oyjjssxl+IUtLjb5K1SWdv5St/+is0
        iqNsjzc0GZ5D8yqsUUQ5+i8hAID09t/z+GvbMIlBvig8S2z7NSE186Q07KlOVB+DpzR+Lp
        Oq414NbcIj/Wb9Q8lc0wOknixyeT1Qc=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-173-Pljf0VPfOXiV-Yt5EqHAJw-1; Tue, 07 Feb 2023 00:17:24 -0500
X-MC-Unique: Pljf0VPfOXiV-Yt5EqHAJw-1
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-4c11ae6ab25so134821457b3.8
        for <ceph-devel@vger.kernel.org>; Mon, 06 Feb 2023 21:17:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GRUpcawoWrDNp+45dDmyCeBdVrdknt/dFiI8+SAxSRk=;
        b=4NtLrbwsdpPKXBP3oR7vk4JeiV4/HTaiTI6i7JOap6bVR51YeW5Afsd5h/hMpnFApZ
         XKhL7JJoYzAHnfGwJgbEmVRmaHoZTFOgjo7iPzCxspmlWbmjStmyxRjm4f0TiosAe2hv
         mPH5QqIKYnH9CJNDvMhiOfIBD6ATOLYiF/Hzyfmp/vnM5MSyzmrid4Z5xcREk3BMi46f
         Aj1wuG+Xpb3eFYh7IfxbjG5E3UnZ50sVzFzrbFbwpVTja7SNnjpP4UEr6eCrmHC/ZFQp
         XKm9/JVAVAtmkQ3SSz49V4bnliUE4p/z0Aq+HA+G7jn2gRspjeP9bVzdfjhF7fvKjwIB
         wvpA==
X-Gm-Message-State: AO0yUKXWZTOzK7u9DT8Jjzyt6yDX5qP8O0/MG8qB1c6awHmf8O28DnM5
        TklFjNH23fb5f0i2fyJACLd5fGzMeuYD11wDJBoB1W4xsTBTlSHpLCKbz7Xt3Yolg43yFmhfQU6
        wSoTbFcHPvDJjhCMCsqNwkTI+6P8r61LFoXP6glVMCgQ=
X-Received: by 2002:a0d:e646:0:b0:506:36bf:dc8a with SMTP id p67-20020a0de646000000b0050636bfdc8amr173933ywe.44.1675747043717;
        Mon, 06 Feb 2023 21:17:23 -0800 (PST)
X-Google-Smtp-Source: AK7set9Or+51kfmXqvx7BFckVwgy8Jykm/ugm9xOdM+ZQRYYEHPrc4rQc8xPTo+ltbh+GU9Pj2bsaSCTkOIHR60Xl1o=
X-Received: by 2002:a0d:e646:0:b0:506:36bf:dc8a with SMTP id
 p67-20020a0de646000000b0050636bfdc8amr173924ywe.44.1675747043384; Mon, 06 Feb
 2023 21:17:23 -0800 (PST)
MIME-Version: 1.0
References: <20230207050452.403436-1-xiubli@redhat.com>
In-Reply-To: <20230207050452.403436-1-xiubli@redhat.com>
From:   Venky Shankar <vshankar@redhat.com>
Date:   Tue, 7 Feb 2023 10:46:47 +0530
Message-ID: <CACPzV1nrtsfrxJtMxANuaSPbWo5TbQ8roqopxL+VVeUpYOh=3A@mail.gmail.com>
Subject: Re: [PATCH] ceph: flush cap release on session flush
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com, lhenriques@suse.de, stable@kernel.org,
        Patrick Donnelly <pdonnell@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Feb 7, 2023 at 10:35 AM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> MDS expects the completed cap release prior to responding to the
> session flush for cache drop.
>
> Cc: <stable@kernel.org>
> URL: http://tracker.ceph.com/issues/38009
> Cc: Patrick Donnelly <pdonnell@redhat.com>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mds_client.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 3c9d3f609e7f..51366bd053de 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4039,6 +4039,12 @@ static void handle_session(struct ceph_mds_session *session,
>                 break;
>
>         case CEPH_SESSION_FLUSHMSG:
> +               /* flush cap release */
> +               spin_lock(&session->s_cap_lock);
> +               if (session->s_num_cap_releases)
> +                       ceph_flush_cap_releases(mdsc, session);
> +               spin_unlock(&session->s_cap_lock);
> +
>                 send_flushmsg_ack(mdsc, session, seq);
>                 break;

Ugh. kclient never flushed cap releases o_O

LGTM.

Reviewed-by: Venky Shankar <vshankar@redhat.com>

>
> --
> 2.31.1
>


-- 
Cheers,
Venky

