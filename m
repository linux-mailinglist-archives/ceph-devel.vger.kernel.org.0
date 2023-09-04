Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 085517914C2
	for <lists+ceph-devel@lfdr.de>; Mon,  4 Sep 2023 11:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350430AbjIDJbW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 4 Sep 2023 05:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243230AbjIDJbV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 4 Sep 2023 05:31:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7979DB6
        for <ceph-devel@vger.kernel.org>; Mon,  4 Sep 2023 02:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693819831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TLFqG8+cKRieBLzgnnk5oQzVdK3d+T+/KLjIiQbhc6c=;
        b=Lxm2bYCKYLwNnKl4slKi//0QHmNflPLI7vig0LHWMhaGNJninsiTWJjNM5gOYfahyPWdKQ
        kWRK3E0nge+LXK0qfflTPIgkmZhSAyhAAJXYdbLIRYewgyk7cEnimiFkojhin4wqUfibea
        PFIHqc64oCTdw5NF/Mp0mFNm4em/geI=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-179-n-7DE6NbPHeEMsf0JHxj5A-1; Mon, 04 Sep 2023 05:30:30 -0400
X-MC-Unique: n-7DE6NbPHeEMsf0JHxj5A-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-94a348facbbso117809566b.1
        for <ceph-devel@vger.kernel.org>; Mon, 04 Sep 2023 02:30:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693819829; x=1694424629;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TLFqG8+cKRieBLzgnnk5oQzVdK3d+T+/KLjIiQbhc6c=;
        b=AB1R3yyJDPBUEtGjJkdB38N/vMUqdFLH9+x+e8AHyRW0sHmIDBcieX9R5WtB3x4+vC
         IxbNRdXfI7+thU8VadHyuONyuNz+dwri+UcoEbL2pHQCGZq8a5DqlYeh8ha9tgUCkdE0
         3Pg+XW/j+la/ac7hXTRxQgubwiuof4rXPR9pOAp70+HUWhYHRZAVY/82NYjlgNfCm6kC
         y3T66ShA8h2NWurN7O38c8c0CMR6ireGcvNcS9kqossdpLotdiKPs0HOVuCUtnZ0kDBl
         FUu+WGcuCZY1Gv59XljT+WHXpmzReTd7sJzMo8fx+3wTe7dY4tAyblmHWqzwHH6QyVPn
         nWXA==
X-Gm-Message-State: AOJu0Yx7FqSBt2vjRde3vStnJ1Yg0c73Be/5iXkoTiOR+nQG53URvGqY
        sqx7oeGgqcXpQGQR9Lzz2jg+Es7t2qU05usdCUjaTvcPRGZB5RDCNshZjgGSkYTow8/DRrz/EcP
        J0f+jFgJQZAJlW6Uk16T1C/WUsZZ2Zs7xBgCZkA==
X-Received: by 2002:a17:907:2ce7:b0:9a1:fa4e:ca83 with SMTP id hz7-20020a1709072ce700b009a1fa4eca83mr8017075ejc.65.1693819829187;
        Mon, 04 Sep 2023 02:30:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHW/GNKT7+P5SNEH06cjkKl30HOfCTVSvHYJt0Qx7uJw7YJUwcQ9p48vPt+V7e5iPkvmA8A4JEo+8vUveU5Ojw=
X-Received: by 2002:a17:907:2ce7:b0:9a1:fa4e:ca83 with SMTP id
 hz7-20020a1709072ce700b009a1fa4eca83mr8017059ejc.65.1693819828924; Mon, 04
 Sep 2023 02:30:28 -0700 (PDT)
MIME-Version: 1.0
References: <20230619071438.7000-1-xiubli@redhat.com> <20230619071438.7000-5-xiubli@redhat.com>
In-Reply-To: <20230619071438.7000-5-xiubli@redhat.com>
From:   Milind Changire <mchangir@redhat.com>
Date:   Mon, 4 Sep 2023 14:59:53 +0530
Message-ID: <CAED=hWAxvLrDoxm6b4hqSrCEDK8dXc4RzdYrMivBCKNUiK5Ndg@mail.gmail.com>
Subject: Re: [PATCH v4 4/6] ceph: move mdsmap.h to fs/ceph/
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, Patrick Donnelly <pdonnell@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Looks good to me.

Tested-by: Milind Changire <mchangir@redhat.com>
Tested-by: Venky Shankar <vshankar@redhat.com>
Reviewed-by: Milind Changire <mchangir@redhat.com>
Reviewed-by: Venky Shankar <vshankar@redhat.com>

On Mon, Jun 19, 2023 at 12:47=E2=80=AFPM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> The mdsmap.h is only used by the kcephfs and move it to fs/ceph/
>
> URL: https://tracker.ceph.com/issues/61590
> Cc: Patrick Donnelly <pdonnell@redhat.com>
> Reviewed-by: Patrick Donnelly <pdonnell@redhat.com>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mds_client.h                | 2 +-
>  fs/ceph/mdsmap.c                    | 2 +-
>  {include/linux =3D> fs}/ceph/mdsmap.h | 0
>  3 files changed, 2 insertions(+), 2 deletions(-)
>  rename {include/linux =3D> fs}/ceph/mdsmap.h (100%)
>
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 20bcf8d5322e..5d02c8c582fd 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -14,9 +14,9 @@
>
>  #include <linux/ceph/types.h>
>  #include <linux/ceph/messenger.h>
> -#include <linux/ceph/mdsmap.h>
>  #include <linux/ceph/auth.h>
>
> +#include "mdsmap.h"
>  #include "metric.h"
>  #include "super.h"
>
> diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
> index 6cbec7aed5a0..d1bc81eecc18 100644
> --- a/fs/ceph/mdsmap.c
> +++ b/fs/ceph/mdsmap.c
> @@ -7,11 +7,11 @@
>  #include <linux/slab.h>
>  #include <linux/types.h>
>
> -#include <linux/ceph/mdsmap.h>
>  #include <linux/ceph/messenger.h>
>  #include <linux/ceph/decode.h>
>
>  #include "super.h"
> +#include "mdsmap.h"
>
>  #define CEPH_MDS_IS_READY(i, ignore_laggy) \
>         (m->m_info[i].state > 0 && ignore_laggy ? true : !m->m_info[i].la=
ggy)
> diff --git a/include/linux/ceph/mdsmap.h b/fs/ceph/mdsmap.h
> similarity index 100%
> rename from include/linux/ceph/mdsmap.h
> rename to fs/ceph/mdsmap.h
> --
> 2.40.1
>


--=20
Milind

