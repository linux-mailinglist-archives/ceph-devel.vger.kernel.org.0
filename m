Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D530741D73
	for <lists+ceph-devel@lfdr.de>; Thu, 29 Jun 2023 03:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbjF2BC1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 28 Jun 2023 21:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjF2BCY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 28 Jun 2023 21:02:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 654222689
        for <ceph-devel@vger.kernel.org>; Wed, 28 Jun 2023 18:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688000493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+ivoSdvKCt3LdjQXqmvX5y6tmG/NdQSCZIYJOrRfupE=;
        b=iKXEk1CF3x6N3IPVUunYupPVh7JlRRuhZd+O70malVWnhBig1hS1Z0R+qOlRS+Ag11d851
        rR04dSi6Nnuk5ExmRrt0WC3AXe4Z5FyMQ4WTkNVvbR4EzT4w39JPjAi5qE44mr5EeAUxPl
        OUYBTRxROwXFDmme7Rmw+HbqhhoVTRU=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-604-zOE73IL0PwmTKZuKheadyw-1; Wed, 28 Jun 2023 21:01:32 -0400
X-MC-Unique: zOE73IL0PwmTKZuKheadyw-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7624c3355baso17258985a.2
        for <ceph-devel@vger.kernel.org>; Wed, 28 Jun 2023 18:01:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688000492; x=1690592492;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+ivoSdvKCt3LdjQXqmvX5y6tmG/NdQSCZIYJOrRfupE=;
        b=COlhMa0OZoCulL24D7O9pI/WMuKUYEM7KscJr6e0W/p622wMAVpZE6yMQxV4O5lLJL
         XMgqkeErKXmHZayYZ6mhL+xn/9wTkM2n4wBocesYZT29gs2z2ghdFIlOCJsyIyLuDoZj
         ZaUwkKwMWHdSUkVZQSu8YUAm3uPnwN+3mzR327MotFKdL6VixeiV7FdYIhGkg3tb8ts/
         iWsBCtHKodEz52uQ9pVyw1QnxMp8ZpqJNAmBvFbGl0cnEbnhzFiPyNF5+LF7j14waEmN
         moa7alueJzy6llEMWVE9wAfW/G06ry4I7hgIEhpYP3Km/oaS83G/toxsod0Kd6wbmEju
         7WZg==
X-Gm-Message-State: AC+VfDx2YvKTMCgVdk2HOgSJq1UvAusasORKRg1HH39SUCwU1XKFckhF
        XKWhxscHyDJ/rbVnIhxiyi7ORwXyTYThqDC0uAjZfnrkViW1vjCoWyvEYjnxmm3htvn0NdEazhA
        6uZDgB5plbw6Fa5qFHDWmyieK++79DJ+JJhffIg==
X-Received: by 2002:a05:620a:192a:b0:765:50f5:2e2a with SMTP id bj42-20020a05620a192a00b0076550f52e2amr20895130qkb.36.1688000491755;
        Wed, 28 Jun 2023 18:01:31 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7EWN4hBamTp9RfwTr5VdICq+AwZX8OEp/94SHKEW56MtZzpNt4/FYUvKSY90PUZvlF3DstX+oiXUnYQzG+z28=
X-Received: by 2002:a05:620a:192a:b0:765:50f5:2e2a with SMTP id
 bj42-20020a05620a192a00b0076550f52e2amr20895113qkb.36.1688000491527; Wed, 28
 Jun 2023 18:01:31 -0700 (PDT)
MIME-Version: 1.0
References: <20230627235709.201132-1-xiubli@redhat.com>
In-Reply-To: <20230627235709.201132-1-xiubli@redhat.com>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Wed, 28 Jun 2023 21:01:05 -0400
Message-ID: <CA+2bHPYSRSoYqT4RV6KNUS2X6kNVC7f0JdQzyknh6i75PonJYA@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: don't let check_caps skip sending responses for
 revoke msgs
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, mchangir@redhat.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Patch looks good to me. Sorry I must nitpick the commit message wording:

If a client sends out a cap update dropping caps with the prior 'seq' just
before an incoming cap revoke request, then the client may drop the revoke
because it believes it's already released the requested capabilities.
This causes
the MDS to wait indefinitely for the client to respond to the revoke.
It's therefore always a good idea to ack the cap revoke request with
the bumped up 'seq'.

On Tue, Jun 27, 2023 at 7:59=E2=80=AFPM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> If a client sends out a cap-update request with the old 'seq' just
> before a pending cap revoke request, then the MDS might miscalculate
> the 'seqs' and caps. It's therefore always a good idea to ack the
> cap revoke request with the bumped up 'seq'.
>
> Cc: stable@vger.kernel.org
> Cc: Patrick Donnelly <pdonnell@redhat.com>
> URL: https://tracker.ceph.com/issues/61782
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>
> V2:
> - Rephrased the commit comment for better understanding from Milind
>
>
>  fs/ceph/caps.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 1052885025b3..eee2fbca3430 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -3737,6 +3737,15 @@ static void handle_cap_grant(struct inode *inode,
>         }
>         BUG_ON(cap->issued & ~cap->implemented);
>
> +       /* don't let check_caps skip sending a response to MDS for revoke=
 msgs */
> +       if (le32_to_cpu(grant->op) =3D=3D CEPH_CAP_OP_REVOKE) {
> +               cap->mds_wanted =3D 0;
> +               if (cap =3D=3D ci->i_auth_cap)
> +                       check_caps =3D 1; /* check auth cap only */
> +               else
> +                       check_caps =3D 2; /* check all caps */
> +       }
> +
>         if (extra_info->inline_version > 0 &&
>             extra_info->inline_version >=3D ci->i_inline_version) {
>                 ci->i_inline_version =3D extra_info->inline_version;
> --
> 2.40.1
>


--=20
Patrick Donnelly, Ph.D.
He / Him / His
Red Hat Partner Engineer
IBM, Inc.
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D

