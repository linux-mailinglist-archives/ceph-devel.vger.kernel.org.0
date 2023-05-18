Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEB0707CAA
	for <lists+ceph-devel@lfdr.de>; Thu, 18 May 2023 11:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbjERJT5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 18 May 2023 05:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbjERJTy (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 18 May 2023 05:19:54 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64EF31FDC;
        Thu, 18 May 2023 02:19:53 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-965ddb2093bso283803466b.2;
        Thu, 18 May 2023 02:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684401592; x=1686993592;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r/ogxbD5+bl5v/DEfPIW7lqt5YyocC+feHk+FrEPWiA=;
        b=IHAOhEjpe+D1c8dHcvyVKHJtGm0Nwx+KJXDxwrsrn4sUBZUpL0Bf9Jp8sODEWhFGOV
         7FcLsWvz4z4Z5rdYQio6ziNR6cbxbfLbKlYxkZhveTm7HGtq2TNM3CZovuR1vVx4zDrK
         7YhV5zPAkUFU4HC+5oMIDmVfgfDjn7JhBWGtsfCkp85iLi4wOz729pgu3XwOPzjn2vpr
         BhQnHnr2yuAJ+goZwRjLsxXc6jiCKKueJamXPcwyxcExxV7PEU2YG1HIbzbqU0bvt4Oz
         q6+CYNVcqQ1bUvAJxKkY0AiQmCWhOn3zyhOInnJo8f5bXXfkw+B+QSPp/KcQ89/ev1Ff
         z7Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684401592; x=1686993592;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r/ogxbD5+bl5v/DEfPIW7lqt5YyocC+feHk+FrEPWiA=;
        b=Uq8tVlaeKoCpwaN13WA6JmbIfaYbElVLeEjEyNq9jNgnfns3bv0wN1EWi6tPxuOP08
         n1g9DibrTi8Ie+pbaNBgd8fjySgTG9RUmKh29Mdh26MOyxbznDgEL076tAUi8gpbLlhP
         ZniJxLB014KQEQx2h+QPAGUsNQkDKlZ0pyleztT0rnTv/OOkXRwEcHhdV1alcAGwsuQ9
         Oes1+6MUs530LTRji1Uo/TrRI2aosrLr/LbIff1r2GXZfcEU8RqOESbpktRTktkgpYuF
         QLoT3zSRCSBWO/89HKGufVhS1P0AkGlaHSM8RCOu39+rpD0f8HhsaWS/MBlLfV1AvASg
         1rag==
X-Gm-Message-State: AC+VfDzlbWOsyKS4NozdNm8bQ1U0wBIW7lqB/zXMbsIpYpqg4RSASAXx
        ZqYO3X8izZ9zt9kiB7OBTp9ArnZ7ONpWSkNcD6E=
X-Google-Smtp-Source: ACHHUZ5KjNxQM1w4wj0w6CBuoO01AEK2Q5cNz4PKUtAvtyiz9CKwPUF3OXBvnpUl6/cDIe9HIWo1E+G4+NYcDD7KIQQ=
X-Received: by 2002:a17:907:2d8d:b0:969:71aa:3da0 with SMTP id
 gt13-20020a1709072d8d00b0096971aa3da0mr39808213ejc.35.1684401591521; Thu, 18
 May 2023 02:19:51 -0700 (PDT)
MIME-Version: 1.0
References: <20230518014723.148327-1-xiubli@redhat.com>
In-Reply-To: <20230518014723.148327-1-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 18 May 2023 11:19:39 +0200
Message-ID: <CAOi1vP8yHgtX6YZKcOwWE_KFARtHL65SE5ykyKHQfasMnj2t4Q@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: force updating the msg pointer in non-split case
To:     xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, stable@vger.kernel.org,
        Frank Schilder <frans@dtu.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, May 18, 2023 at 3:48=E2=80=AFAM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> When the MClientSnap reqeust's op is not CEPH_SNAP_OP_SPLIT the
> request may still contain a list of 'split_realms', and we need
> to skip it anyway. Or it will be parsed as a corrupt snaptrace.
>
> Cc: stable@vger.kernel.org
> Cc: Frank Schilder <frans@dtu.dk>
> Reported-by: Frank Schilder <frans@dtu.dk>
> URL: https://tracker.ceph.com/issues/61200
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>
> V2:
> - Add a detail comment for the code.
>
>
>  fs/ceph/snap.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index 0e59e95a96d9..0f00f977c0f0 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -1114,6 +1114,19 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc=
,
>                                 continue;
>                         adjust_snap_realm_parent(mdsc, child, realm->ino)=
;
>                 }
> +       } else {
> +               /*
> +                * In non-SPLIT op case both the 'num_split_inos' and
> +                * 'num_split_realms' should always be 0 and this will
> +                * do nothing. But the MDS has one bug that in one of
> +                * the UPDATE op cases it will pass a 'split_realms'
> +                * list by mistake, and then will corrupted the snap
> +                * trace in ceph_update_snap_trace().
> +                *
> +                * So we should skip them anyway here.
> +                */
> +               p +=3D sizeof(u64) * num_split_inos;
> +               p +=3D sizeof(u64) * num_split_realms;
>         }
>
>         /*
> --
> 2.40.1
>

LGTM, staged for 6.4-rc3 with a slightly amended comment.

Thanks,

                Ilya
