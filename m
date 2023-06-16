Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7596B732644
	for <lists+ceph-devel@lfdr.de>; Fri, 16 Jun 2023 06:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjFPEla (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 16 Jun 2023 00:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjFPEl2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 16 Jun 2023 00:41:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98E822D58
        for <ceph-devel@vger.kernel.org>; Thu, 15 Jun 2023 21:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686890440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rJd1ZBdSVh8HRr2gKCjn+mEwbm0cRR58O73TJwuYFl0=;
        b=hpc+o5mhA8rnt1CYFi2G2rCOXmhDB/P4f01LBgeCpKO6koz+FcXNIJk0e4uCG6Sb6WoSIs
        RS69yORpFPjs+/m41KtebMLhj6bRRDivF+WuyoKeXIO4kDub9LORDvz1JAOZE/2fLvc1tZ
        e1MRsYD/o+TEWbCezuWysp+1DYN+46g=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-150-piiMjIpSO7eE1AQS8dY9yg-1; Fri, 16 Jun 2023 00:40:39 -0400
X-MC-Unique: piiMjIpSO7eE1AQS8dY9yg-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-982a57942c1so24522466b.1
        for <ceph-devel@vger.kernel.org>; Thu, 15 Jun 2023 21:40:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686890438; x=1689482438;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rJd1ZBdSVh8HRr2gKCjn+mEwbm0cRR58O73TJwuYFl0=;
        b=g6CM3SwbdF91RWiiXNdhmW4X0wDMWxOadaevRpkX5UzQyus4W8XMTWIPdFNdHXgdJU
         LLlESPMMxejKkfhQctDCIzRsBsYQHlgU5Lcw0/Ouurl6cnfHaoO0oW7l3Z93oVByc3rx
         7FVvXCPBf5Ma+9mF0jWgvpocseHEJ1Ka7+NY9+vhL4uZneGbF6KTpbXF5O57cBMVKTNG
         crHTI4RE2RVqdRQHEQ2ar/cQtIiOvvjXu6civx5zqaZTO12q5jxDbSqeahsImuSIMOzK
         HuR30e7ZD9Tae8+ep5tQ5IAfoHlkYxboBn70n9+fT7ZQA8RUn3okLj7ZTmZbL+V1Cc9f
         QDhQ==
X-Gm-Message-State: AC+VfDyVvTp1/4/kNFsEoakrMwU3eJalYUHPfvCwh1axLI3OAKnlafk7
        2K1dQCqj4XJLC2tSpfytc78622EV8e/UxK93VB0CvJtEkL0wzdjOAyHlK68X2dmHMaaDPrIsFyR
        5+cWy92+6MXC+22yVJLYVFqtB0jzQiUksjUhl+g==
X-Received: by 2002:a17:907:748:b0:982:b920:daad with SMTP id xc8-20020a170907074800b00982b920daadmr863597ejb.71.1686890438111;
        Thu, 15 Jun 2023 21:40:38 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6fjE8Q9E2JoejCipw7/IZ9nYnrKi1XQUujMWvS9raTB9AKg/wu59igz0MHi7Zudl154JFU4GOP8oeCm0MvhAE=
X-Received: by 2002:a17:907:748:b0:982:b920:daad with SMTP id
 xc8-20020a170907074800b00982b920daadmr863590ejb.71.1686890437855; Thu, 15 Jun
 2023 21:40:37 -0700 (PDT)
MIME-Version: 1.0
References: <20230606005732.1056361-1-xiubli@redhat.com>
In-Reply-To: <20230606005732.1056361-1-xiubli@redhat.com>
From:   Venky Shankar <vshankar@redhat.com>
Date:   Fri, 16 Jun 2023 10:10:01 +0530
Message-ID: <CACPzV1miqfsoAHbjqnw=1wo5CKEcQR0G-J1Zi0ia2Ara=3x-ZA@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: only send metrics when the MDS rank is ready
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Xiubo,

On Tue, Jun 6, 2023 at 6:30=E2=80=AFAM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> When the MDS rank is in clientreplay state, the metrics requests
> will be discarded directly. Also, when there are a lot of known
> client requests to recover from, the metrics requests will slow
> down the MDS rank from getting to the active state sooner.
>
> With this patch, we will send the metrics requests only when the
> MDS rank is in active state.

Although the changes look fine. I have a question though - the metrics
are sent by the client each second (on tick()) - how many clients were
connected for the MDS to experience further slowness due to metric
update messages?

>
> URL: https://tracker.ceph.com/issues/61524
> Reviewed-by: Milind Changire <mchangir@redhat.com>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>
> V2:
> - rephrase the commit comment from Milind's comments.
>
>
>  fs/ceph/metric.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
> index c47347d2e84e..cce78d769f55 100644
> --- a/fs/ceph/metric.c
> +++ b/fs/ceph/metric.c
> @@ -36,6 +36,14 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_cli=
ent *mdsc,
>         s32 items =3D 0;
>         s32 len;
>
> +       /* Do not send the metrics until the MDS rank is ready */
> +       mutex_lock(&mdsc->mutex);
> +       if (ceph_mdsmap_get_state(mdsc->mdsmap, s->s_mds) !=3D CEPH_MDS_S=
TATE_ACTIVE) {
> +               mutex_unlock(&mdsc->mutex);
> +               return false;
> +       }
> +       mutex_unlock(&mdsc->mutex);
> +
>         len =3D sizeof(*head) + sizeof(*cap) + sizeof(*read) + sizeof(*wr=
ite)
>               + sizeof(*meta) + sizeof(*dlease) + sizeof(*files)
>               + sizeof(*icaps) + sizeof(*inodes) + sizeof(*rsize)
> --
> 2.40.1
>


--=20
Cheers,
Venky

